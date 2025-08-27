#!/bin/bash

source "$(dirname "$0")/../__syncdb.sh"

docker_image="postgres:$db_version-alpine"
internal_ip="$(get_user_param '--internal-ip')"
console_debug_line "Internal IP        : $internal_ip"
console_debug_line "Docker Image       : $docker_image"
common_suffix_args=$(unit_test_common_suffix_args)
console_debug_line "Common Suffix Args : $common_suffix_args"

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
console_debug_line "SyncDB Args        : $common_suffix_args"

checkpoint_init_container() {
    checkpoint_staring "Init Docker Container"

    container_id=$(eval """
    sudo docker run --name $container_name \
    --platform linux/amd64 \
    -p $from_port:5432 \
    -e 'POSTGRES_DB=$from_root_database' \
    -e 'POSTGRES_USER=$from_username' \
    -e 'POSTGRES_PASSWORD=$from_password' \
    -d '$docker_image'
    """)

    if [ $? -eq 0 ]; then
        checkpoint_content "Container" "$container_id"
        checkpoint_complete
    else
        checkpoint_error
        console_error_line "Failed to init Docker Container: $docker_image"
        exit 1
    fi
}

checkpoint_wait_for_postgres() {
    local max_attempts=20
    local attempt=1
    console_debug_line "Waiting for PostgreSQL to be ready..."

    while [ $attempt -le $max_attempts ]; do
        sudo docker exec "$container_name" \
            pg_isready -h 127.0.0.1 -p 5432 -U "$from_username" >/dev/null 2>&1
        if [ $? -eq 0 ]; then
            console_debug_line "PostgreSQL is ready after $attempt attempts."
            return 0
        fi
        sleep 1
        attempt=$((attempt + 1))
    done
    console_error_line "PostgreSQL did not become ready in time."
    return 1
}

