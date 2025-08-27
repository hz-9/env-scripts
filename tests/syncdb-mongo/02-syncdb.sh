#!/bin/bash

# Test script - for verifying actual installation functionality of syncdb-mongo.sh script

# Import test utility functions
source "$(dirname "$0")/../__base.sh"
source "$(dirname "$0")/../__syncdb.sh"
source "$(dirname "$0")/../__install.sh"

# Test constants
SCRIPT_PATH="$(dirname "$0")/../../dist/syncdb-mongo.sh"
 
unit_test_initing "$@" "--name=syncdb-mongo"
checkpoint_check_current_os_is_supported

container_name="hz_9_env_scripts_syncdb_mongodb_02_syncdb"

db_version="4.0.28"

source "$(dirname "$0")/__base.sh"

# trap 'remove_docker_container && cleanup_test_env' EXIT

checkpoint_init_data() {
    checkpoint_staring "Init Data"

    MONGO_SCRIPT="""
    use $from_database;
    
    db.createCollection('test_users');
    
    db.test_users.insertMany([
      { username: 'alice', email: 'alice@example.com', created_at: new Date() },
      { username: 'bob', email: 'bob@example.com', created_at: new Date() },
      { username: 'carol', email: 'carol@example.com', created_at: new Date() }
    ]);
    """

    init_command=$(cat <<EOF
$shell_cmd --host $from_hostname --port $from_port --username $from_username --password $from_password --authenticationDatabase admin <<MONGO
$MONGO_SCRIPT
MONGO
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
      $shell_cmd --host 127.0.0.1 --port 27017 --username $from_username --password $from_password --authenticationDatabase admin --quiet --eval \
      "db.getSiblingDB('$from_database').getCollectionNames().includes('test_users_nonexistent')" | tr -d '\r'
    )

    if [ "$exists" == "false" ]; then
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

checkpoint_wait_for_mongodb

checkpoint_init_data

checkpoint_with_run_syncdb_script "$SCRIPT_PATH" "$final_args"

checkpoint_check_data

remove_docker_container

# Display test results
unit_test_console_summary
exit $?
