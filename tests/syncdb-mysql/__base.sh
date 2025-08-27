#!/bin/bash

source "$(dirname "$0")/../__syncdb.sh"

docker_image="mysql:$db_version"
internal_ip="$(get_user_param '--internal-ip')"
log_debug "Internal IP        : $internal_ip"
log_debug "Docker Image       : $docker_image"
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

checkpoint_init_container() {
    checkpoint_staring "Init Docker Container"

    container_id=$(eval """
    sudo docker run --name $container_name \
    --platform linux/amd64 \
    -p $from_port:3306 \
    -e 'MYSQL_ROOT_PASSWORD=$from_password' \
    -e 'MYSQL_DATABASE=$from_database' \
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

checkpoint_wait_for_mysql() {
    local max_attempts=20
    local attempt=1
    log_debug "Waiting for MySQL to be ready..."

    while [ $attempt -le $max_attempts ]; do
        sudo docker exec "$container_name" \
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