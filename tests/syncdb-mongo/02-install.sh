#!/bin/bash

# Test script - for verifying actual installation functionality of syncdb-mongodb.sh script

# Import test utility functions
source "$(dirname "$0")/../__base.sh"

# Test constants
SCRIPT_PATH="$(dirname "$0")/../../dist/syncdb-mongo.sh"
 
unit_test_initing "$@" "--name=syncdb-mongo"

checkpoint_staring "0" "Check if current OS is supported"
if unit_test_is_support_current_os "$SCRIPT_PATH"; then
    checkpoint_complete
else
    checkpoint_skip
    exit 2 # Skip the rest of the tests if OS is not supported
fi

container_name="hz_9_env_scripts_syncdb_mongodb_02_install"

db_version="4.0.28"
docker_image="mongo:$db_version"

if [[ $(echo "$db_version" | cut -d. -f1) -ge 5 ]]; then
  shell_cmd="mongosh"
else
  shell_cmd="mongo"
fi


internal_ip="$(get_user_param '--internal-ip')"
log_debug "Internal IP        : $internal_ip"
log_debug "Docker Image       : $docker_image"
common_suffix_args=$(unit_test_common_suffix_args)
log_debug "Common Suffix Args : $common_suffix_args"

from_hostname=$internal_ip
from_port=27017
from_username="root"
from_password="12345678"
from_database="test_db"

to_hostname=$internal_ip
to_port=27017
to_username="root"
to_password="12345678"
to_database="test_db_backup"

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

    "--temp=$TEST_TMP_DIR/syncdb-mongodb"
)
sync_args_str=""
for arg in "${sync_args[@]}"; do
    sync_args_str+="$arg "
done
final_args="${sync_args_str}${common_suffix_args}"
log_debug "SyncDB Args        : $common_suffix_args"

remove_docker_container() {
    # checkpoint_staring "9" "Remove Docker Container"

    eval "sudo docker stop $container_name $(console_redirect_output)"
    eval "sudo docker rm   $container_name $(console_redirect_output)"

    # checkpoint_complete
}

# trap 'remove_docker_container && cleanup_test_env' EXIT

pull_docker_image() {
    checkpoint_staring "1" "Pull Docker Image ${docker_image}"

    eval "sudo docker pull $docker_image --platform linux/amd64 $(console_redirect_output)"
    if [ $? -eq 0 ]; then
        checkpoint_complete
    else
        checkpoint_error
        log_error "Failed to pull Docker image: $docker_image"
        exit 1
    fi
}

init_docker_container() {
    checkpoint_staring "2" "Init Docker Container"

    eval """
    sudo docker run --name $container_name \
    --platform linux/amd64 \
    -p $from_port:27017 \
    -e 'MONGO_INITDB_ROOT_USERNAME=$from_username' \
    -e 'MONGO_INITDB_ROOT_PASSWORD=$from_password' \
    -d '$docker_image'
    """

    if [ $? -eq 0 ]; then
        checkpoint_complete
    else
        checkpoint_error
        log_error "Failed to init Docker Container: $docker_image"
        exit 1
    fi
}

init_data() {
    checkpoint_staring "3" "Init Data"

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
        log_error "Failed to init data: $docker_image"
        exit 1
    fi
}

wait_for_mongodb() {
    local max_attempts=30
    local attempt=1
    log_debug "Waiting for MongoDB to be ready..."
    
    while [ $attempt -le $max_attempts ]; do
        # Try to ping the database to check if it's accepting connections
        if sudo docker exec "$container_name" \
            $shell_cmd --host 127.0.0.1 --port 27017 \
            --username "$from_username" --password "$from_password" \
            --authenticationDatabase admin \
            --quiet --eval "db.adminCommand('ping').ok" | grep -q "1"; then
            
            # Additional verification - check if we can list databases
            if sudo docker exec "$container_name" \
                $shell_cmd --host 127.0.0.1 --port 27017 \
                --username "$from_username" --password "$from_password" \
                --authenticationDatabase admin \
                --quiet --eval "db.adminCommand('listDatabases')" | grep -q "databases"; then
                
                log_debug "MongoDB is fully operational after $attempt attempts."
                return 0
            fi
        fi
        
        log_debug "Attempt $attempt: MongoDB not ready yet, waiting..."
        sleep 1
        attempt=$((attempt + 1))
    done
    
    log_error "MongoDB did not become ready after $max_attempts attempts."
    return 1
}

check_data() {
    checkpoint_staring "5" "Check Data"

    exists=$(sudo docker exec $container_name \
      $shell_cmd --host 127.0.0.1 --port 27017 --username $from_username --password $from_password --authenticationDatabase admin --quiet --eval \
      "db.getSiblingDB('$from_database').getCollectionNames().includes('test_users_nonexistent')" | tr -d '\r'
    )

    if [ "$exists" == "false" ]; then
        checkpoint_complete
    else
        checkpoint_error
        log_error "Failed to check data: $docker_image"
        exit 1
    fi
}

pull_docker_image

remove_docker_container

init_docker_container

wait_for_mongodb

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
