#!/bin/bash

# Test script - for verifying actual installation functionality of syncdb-mysql.sh script

# Import test utility functions
source "$(dirname "$0")/../__base.sh"
source "$(dirname "$0")/../__syncdb.sh"
source "$(dirname "$0")/../__install.sh"

# Test constants
SCRIPT_PATH="$(dirname "$0")/../../dist/syncdb-mysql.sh"
 
unit_test_initing "$@" "--name=syncdb-mysql"
checkpoint_check_current_os_is_supported

container_name="hz_9_env_scripts_syncdb_mysql_02_syncdb"

db_version="8.0"

source "$(dirname "$0")/__base.sh"

# trap 'remove_docker_container && cleanup_test_env' EXIT

checkpoint_init_data() {
    checkpoint_staring "Init Data"

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
    sudo docker exec $container_name \
    bash -c \"$init_command\" $(console_redirect_output)
    """

    if [ $? -eq 0 ]; then
        checkpoint_complete
    else
        checkpoint_error
        console_error_line "Failed to init data: $docker_image"
        exit 1
    fi
}

checkpoint_check_data() {
    checkpoint_staring "Check Data"

    exists=$(sudo docker exec $container_name \
      mysql -h 127.0.0.1 -P 3306 -u $from_username -p$from_password -N -e \
      "SELECT COUNT(*) FROM information_schema.tables WHERE table_schema = '$from_database' AND table_name = 'test_user2';"
    )

    if [ "$exists" == "0" ]; then
        checkpoint_complete
    else
        checkpoint_error
        console_error_line "Failed to check data: $docker_image"
        exit 1
    fi
}

checkpoint_pull_image

remove_docker_container

checkpoint_init_container

checkpoint_wait_for_mysql

checkpoint_init_data

checkpoint_with_run_syncdb_script "$SCRIPT_PATH" "$final_args"

checkpoint_check_data

remove_docker_container

# Display test results
unit_test_console_summary
exit $?
