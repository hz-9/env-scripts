#!/bin/bash

# Test script - for verifying actual installation functionality of syncdb-postgresql.sh script

# Import test utility functions
source "$(dirname "$0")/../__base.sh"

# Test constants
SCRIPT_PATH="$(dirname "$0")/../../dist/syncdb-postgresql.sh"
 
unit_test_initing "$@" "--name=syncdb-postgresql"

checkpoint_staring "0" "Check if current OS is supported"
if unit_test_is_support_current_os "$SCRIPT_PATH"; then
    checkpoint_complete
else
    checkpoint_skip
    exit 2 # Skip the rest of the tests if OS is not supported
fi

containerName="hz_9_env_scripts_syncdb_postgresql_02_install"

db_version="9.6"
dockerImage="postgres:$db_version-alpine"

internal_ip="$(get_user_param '--internal-ip')"
log_debug "Internal IP        : $internal_ip"
log_debug "Docker Image       : $dockerImage"
common_suffix_args=$(unit_test_common_suffix_args)
log_debug "Common Suffix Args : $common_suffix_args"

from_hostname=$internal_ip
from_port=15432
from_username="hz_9"
from_password="12345678"
from_root_database="hz_9"
from_database="db_1"

to_hostname=$internal_ip
to_port=15432
to_username="hz_9"
to_password="12345678"
to_root_database="hz_9"
to_database="db_2"

sync_args=(
    "--db-version=$db_version"

    "--from-hostname=$internal_ip"
    "--from-port=$from_port"
    "--from-username=$from_username"
    "--from-password=$from_password"
    "--from-database=$from_database"

    "--to-hostname=$internal_ip"
    "--to-port=$to_port"
    "--to-username=$to_username"
    "--to-password=$to_password"
    "--to-database=$to_database"

    "--temp=$TEST_TMP_DIR/syncdb-postgresql"
)
sync_args_str=""
for arg in "${sync_args[@]}"; do
    sync_args_str+="$arg "
done
final_args="${sync_args_str}${common_suffix_args}"
log_debug "SyncDB Args        : $common_suffix_args"

remove_docker_container() {
    # checkpoint_staring "9" "Remove Docker Container"

    eval "sudo docker stop $containerName $(console_redirect_output)"
    eval "sudo docker rm   $containerName $(console_redirect_output)"

    # checkpoint_complete
}

# trap 'remove_docker_container && cleanup_test_env' EXIT

pull_docker_image() {
    checkpoint_staring "1" "Pull Docker Image ${dockerImage}"

    eval "sudo docker pull $dockerImage --platform linux/amd64 $(console_redirect_output)"
    if [ $? -eq 0 ]; then
        checkpoint_complete
    else
        checkpoint_error
        log_error "Failed to pull Docker image: $dockerImage"
        exit 1
    fi
}

init_docker_container() {
    checkpoint_staring "2" "Init Docker Container"

    eval """
    sudo docker run --name $containerName \
    --platform linux/amd64 \
    -p $from_port:5432 \
    -e 'POSTGRES_DB=$from_root_database' \
    -e 'POSTGRES_USER=$from_username' \
    -e 'POSTGRES_PASSWORD=$from_password' \
    -d '$dockerImage'
    """

    if [ $? -eq 0 ]; then
        checkpoint_complete
    else
        checkpoint_error
        log_error "Failed to init Docker Container: $dockerImage"
        exit 1
    fi
}

init_data() {
    checkpoint_staring "3" "Init Data"

    SQL_1="
    CREATE DATABASE $from_database;
    "

    SQL_2="
    CREATE TABLE test_user ( id SERIAL PRIMARY KEY,
        username VARCHAR(32) NOT NULL,
        email VARCHAR(64) NOT NULL,
        created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
    );

    INSERT INTO
        test_user(username, email)
    VALUES
        ('alice', 'alice@example.com'),
        ('bob', 'bob@example.com'),
        ('carol', 'carol@example.com');
    "

    init_command_1=$(cat <<EOF
export PGPASSWORD=$from_password
psql -h 127.0.0.1 -p 5432 -U $from_username -d $from_root_database <<SQL
$SQL_1
SQL
EOF
)

    init_command_2=$(cat <<EOF
export PGPASSWORD=$from_password
psql -h 127.0.0.1 -p 5432 -U $from_username -d $from_database <<SQL
$SQL_2
SQL
EOF
)

    eval """
    sudo docker exec $containerName \
    bash -c \"$init_command_1\" $(console_redirect_output)
    """

    eval """
    sudo docker exec $containerName \
    bash -c \"$init_command_2\" $(console_redirect_output)
    """

    if [ $? -eq 0 ]; then
        checkpoint_complete
    else
        checkpoint_error
        log_error "Failed to init data: $dockerImage"
        exit 1
    fi
}

wait_for_postgres() {
    local max_attempts=20
    local attempt=1
    while [ $attempt -le $max_attempts ]; do
        sudo docker exec "$containerName" \
            pg_isready -h 127.0.0.1 -p 5432 -U "$from_username" >/dev/null 2>&1
        if [ $? -eq 0 ]; then
            log_debug "PostgreSQL is ready after $attempt attempts."
            return 0
        fi
        sleep 1
        attempt=$((attempt + 1))
    done
    log_error "PostgreSQL did not become ready in time."
    return 1
}

check_data() {
    checkpoint_staring "5" "Check Data"

    exists=$(sudo docker exec $containerName \
      psql -h 127.0.0.1 -p 5432 -U $from_username -d $from_database \
      -tAc "SELECT count(1) FROM information_schema.tables WHERE table_name = 'test_user2';"
    )

    if [ "$exists" != "1" ]; then
        checkpoint_complete
    else
        checkpoint_error
        log_error "Failed to check data: $dockerImage"
        exit 1
    fi
}

pull_docker_image

remove_docker_container

init_docker_container

wait_for_postgres

init_data

bash "$SCRIPT_PATH" $final_args
INSTALL_EXIT_CODE=$?

checkpoint_staring "4" "Install script execution result"
if [ $INSTALL_EXIT_CODE -eq 0 ]; then
    checkpoint_complete
elif [ $INSTALL_EXIT_CODE -eq 2 ]; then
    checkpoint_skip
    exit 2 # Skip the rest of the tests if OS is not supported
else
    checkpoint_error
fi

check_data

remove_docker_container

# Display test results
unit_test_console_summary
exit $?
