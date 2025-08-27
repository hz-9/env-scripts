#!/bin/bash

source "$(dirname "$0")/../__syncdb.sh"

docker_image="mongo:$db_version"

if [[ $(echo "$db_version" | cut -d. -f1) -ge 5 ]]; then
  shell_cmd="mongosh"
else
  shell_cmd="mongo"
fi

internal_ip="$(get_user_param '--internal-ip')"
log_debug "Internal IP        : $internal_ip"
log_debug "Docker Image       : $docker_image"
log_debug "Shell Command      : $shell_cmd"
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

checkpoint_init_container() {
    checkpoint_staring "Init Docker Container"

    container_id=$(eval """
    sudo docker run --name $container_name \
    --platform linux/amd64 \
    -p $from_port:27017 \
    -e 'MONGO_INITDB_ROOT_USERNAME=$from_username' \
    -e 'MONGO_INITDB_ROOT_PASSWORD=$from_password' \
    -d '$docker_image'
    """)

    if [ $? -eq 0 ]; then
        checkpoint_content "Container" "$container_id"
        checkpoint_complete
    else
        checkpoint_error
        log_error "Failed to init Docker Container: $docker_image"
        exit 1
    fi
}

checkpoint_wait_for_mongodb() {
    local max_attempts=30
    local attempt=1
    log_debug "Waiting for MongoDB to be ready..."
    
    while [ $attempt -le $max_attempts ]; do
        # Try to ping the database to check if it's accepting connections
        if sudo docker exec "$container_name" \
            $shell_cmd --host 127.0.0.1 --port 27017 \
            --username "$from_username" --password "$from_password" \
            --authenticationDatabase admin \
            --quiet --eval "db.adminCommand('ping').ok" 2>/dev/null | grep -q "1"; then
            
            # Additional verification - check if we can list databases
            if sudo docker exec "$container_name" \
                $shell_cmd --host 127.0.0.1 --port 27017 \
                --username "$from_username" --password "$from_password" \
                --authenticationDatabase admin \
                --quiet --eval "db.adminCommand('listDatabases')" 2>/dev/null | grep -q "databases"; then
                
                log_debug "MongoDB is ready after $attempt attempts."
                return 0
            fi
        fi

        sleep 1
        attempt=$((attempt + 1))
    done
    
    log_error "MongoDB did not become ready in time."
    return 1
}