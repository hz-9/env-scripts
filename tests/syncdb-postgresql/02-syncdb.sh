#!/bin/bash

# Test script - for verifying actual installation functionality of syncdb-postgresql.sh script

# Import test utility functions
source "$(dirname "$0")/../__base.sh"
source "$(dirname "$0")/../__syncdb.sh"
source "$(dirname "$0")/../__install.sh"

# Test constants
SCRIPT_PATH="$(dirname "$0")/../../dist/syncdb-postgresql.sh"
 
unit_test_initing "$@" "--name=syncdb-postgresql"
checkpoint_check_current_os_is_supported

container_name="hz_9_env_scripts_syncdb_postgresql_02_syncdb"

db_version="9.6"

source "$(dirname "$0")/__base.sh"

# trap 'remove_docker_container && cleanup_test_env' EXIT

checkpoint_init_data() {
    checkpoint_staring "Init Data"

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
    sudo docker exec $container_name \
    bash -c \"$init_command_1\" $(console_redirect_output)
    """

    eval """
    sudo docker exec $container_name \
    bash -c \"$init_command_2\" $(console_redirect_output)
    """

    if [ $? -eq 0 ]; then
        checkpoint_complete
    else
        checkpoint_error
        log_error "Failed to init data: $docker_image"
        exit 1
    fi
}

checkpoint_check_data() {
    checkpoint_staring "Check Data"

    exists=$(sudo docker exec $container_name \
      psql -h 127.0.0.1 -p 5432 -U $from_username -d $from_database \
      -tAc "SELECT count(1) FROM information_schema.tables WHERE table_name = 'test_user2';"
    )

    if [ "$exists" != "1" ]; then
        checkpoint_complete
    else
        checkpoint_error
        log_error "Failed to check data: $docker_image"
        exit 1
    fi
}

checkpoint_pull_image

remove_docker_container

checkpoint_init_container

checkpoint_wait_for_postgres

checkpoint_init_data

checkpoint_with_run_syncdb_script "$SCRIPT_PATH" "$final_args"

checkpoint_check_data

remove_docker_container

# Display test results
unit_test_console_summary
exit $?
