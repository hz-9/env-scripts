#!/bin/bash

# Test script - for verifying actual installation functionality of syncdb-mysql.sh script

# Import test utility functions
source "$(dirname "$0")/../__base.sh"

# Test constants
SCRIPT_PATH="$(dirname "$0")/../../dist/syncdb-mysql.sh"
 
unit_test_initing "$@" "--name=syncdb-mysql"

checkpoint_staring "0" "Check if current OS is supported"
if unit_test_is_support_current_os "$SCRIPT_PATH"; then
    checkpoint_complete
else
    checkpoint_skip
    exit 2 # Skip the rest of the tests if OS is not supported
fi

containerName="hz_9_env_scripts_syncdb_mysql_02_install"

db_version="8.0"
dockerImage="mysql:$db_version"

internal_ip="$(get_user_param '--internal-ip')"
log_debug "Internal IP        : $internal_ip"
log_debug "Docker Image       : $dockerImage"
common_suffix_args=$(unit_test_common_suffix_args)
log_debug "Common Suffix Args : $common_suffix_args"

from_hostname=$internal_ip
from_port=13306
from_username="root"
from_password="12345678"
from_database="db_1"

to_hostname=$internal_ip
to_port=13306
to_username="root"
to_password="12345678"
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

    "--temp=$TEST_TMP_DIR/syncdb-mysql"
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
    -p $from_port:3306 \
    -e 'MYSQL_ROOT_PASSWORD=$from_password' \
    -e 'MYSQL_DATABASE=$from_database' \
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

    SQL="
    USE $from_database;
    
    CREATE TABLE test_user (
        id INT AUTO_INCREMENT PRIMARY KEY,
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

    init_command=$(cat <<EOF
mysql -h 127.0.0.1 -P 3306 -u $from_username -p$from_password <<SQL
$SQL
SQL
EOF
)

    eval """
    sudo docker exec $containerName \
    bash -c \"$init_command\" $(console_redirect_output)
    """

    if [ $? -eq 0 ]; then
        checkpoint_complete
    else
        checkpoint_error
        log_error "Failed to init data: $dockerImage"
        exit 1
    fi
}

wait_for_mysql() {
    local max_attempts=20
    local attempt=1
    while [ $attempt -le $max_attempts ]; do
        sudo docker exec "$containerName" \
            mysqladmin -h 127.0.0.1 -P 3306 -u "$from_username" -p"$from_password" ping >/dev/null 2>&1
        if [ $? -eq 0 ]; then
            log_debug "MySQL is ready after $attempt attempts."
            return 0
        fi
        sleep 1
        attempt=$((attempt + 1))
    done
    log_error "MySQL did not become ready in time."
    return 1
}

check_data() {
    checkpoint_staring "5" "Check Data"

    exists=$(sudo docker exec $containerName \
      mysql -h 127.0.0.1 -P 3306 -u $from_username -p$from_password -N -e \
      "SELECT COUNT(*) FROM information_schema.tables WHERE table_schema = '$from_database' AND table_name = 'test_user2';"
    )

    if [ "$exists" == "0" ]; then
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

wait_for_mysql

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
