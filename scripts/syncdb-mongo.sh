#!/bin/bash
_m_='♥'

SHELL_NAME="MongoDB Syncer"
SHELL_DESC="Sync MongoDB database."
SHELL_NAME="MongoDB Database Synchronizer"
SHELL_DESC="Efficiently synchronize MongoDB databases between remote and local environments, supporting backup and restore operations."

PARAMTERS=(
  "--help${_m_}-h${_m_}Print help message.${_m_}false"
  "--debug${_m_}${_m_}Print debug message.${_m_}false"

  "--network${_m_}${_m_}Specify network environment (e.g., 'in-china').${_m_}default"

  "--db-version${_m_}${_m_}The version of the database.${_m_}6.0"
  "--docker-image-quick-check${_m_}${_m_}Is there a local quick detection of the docker image.${_m_}false"

  "--from-hostname${_m_}${_m_}The hostname of the source database.${_m_}127.0.0.1"
  "--from-port${_m_}${_m_}The port of the source database.${_m_}27017"
  "--from-username${_m_}${_m_}The username of the source database.${_m_}root"
  "--from-password${_m_}${_m_}The password of the source database.${_m_}12345678"
  "--from-database${_m_}${_m_}The database name of the source database.${_m_}admin"

  "--to-hostname${_m_}${_m_}The hostname of the target database.${_m_}127.0.0.1"
  "--to-port${_m_}${_m_}The port of the target database.${_m_}27017"
  "--to-username${_m_}${_m_}The username of the target database.${_m_}root"
  "--to-password${_m_}${_m_}The password of the target database.${_m_}12345678"
  "--to-database${_m_}${_m_}The database name of the target database.${_m_}admin_backup"
  "--temp${_m_}${_m_}The temporary directory.${_m_}/tmp/hz-9/env-prepare/sync-db-mongo"
)

SUPPORT_OS_LIST=(
  "Ubuntu 20.04 AMD64"
  "Ubuntu 22.04 AMD64"
  "Ubuntu 24.04 AMD64"

  "Debian 11.9 AMD64"
  "Debian 12.2 AMD64"

  "Fedora 41 AMD64"

  "RedHat 8.10 AMD64"
  "RedHat 9.6 AMD64"
)

source ./__base.sh

print_help_or_param "$@"

network=$(get_param '--network')

db_version=$(get_param '--db-version')

from_hostname=$(get_param '--from-hostname')
from_port=$(get_param '--from-port')
from_username=$(get_param '--from-username')
from_password=$(get_param '--from-password')
from_database=$(get_param '--from-database')

to_hostname=$(get_param '--to-hostname')
to_port=$(get_param '--to-port')
to_username=$(get_param '--to-username')
to_password=$(get_param '--to-password')
to_database=$(get_param '--to-database')

# ------------------------------------------------------------

console_module_title "Temp Directory"

temp=$(get_param '--temp')
sync_dir="dump.mongodb.$(date +"%Y-%m-%dT%H:%M:%S")"

console_key_value "Temp Dir" "$temp"
console_key_value "Sync Dir" "$sync_dir"

if [[ ! -d "$temp" ]]; then
  console_content "Create temp directory."
  mkdir -p "$temp"
fi

console_empty_line

# ------------------------------------------------------------

console_module_title "Check Docker is Installed"

if docker --version &>/dev/null; then
  console_content "Docker is already installed."
else
  console_content "Docker is not installed. Please install docker first."
  exit 1
fi

console_empty_line

console_key_value "Docker CE" "$(docker --version | awk '{print $3}' | sed 's/,//')"
console_key_value "Docker compose" "$(docker compose version | awk '{print $4}')"
console_empty_line

# ------------------------------------------------------------

console_module_title "Pull Docker Image"

docker_image="mongo:$db_version"
pull_docker_image $docker_image
console_empty_line

# ------------------------------------------------------------

console_module_title "Sync by $docker_image"

console_content_starting "Syncing data from $from_hostname to $to_hostname..."

if [[ $(echo "$db_version" | cut -d. -f1) -ge 5 ]]; then
  shell_cmd="mongosh"
else
  shell_cmd="mongo"
fi

sync_command=$(cat <<EOF
# Export data from source database
mongodump --host=$from_hostname --port=$from_port --username=$from_username --password=$from_password --authenticationDatabase=admin --db=$from_database --out=/data-backup/$sync_dir

# Import data to target database
$shell_cmd --host=$to_hostname --port=$to_port --username=$to_username --password=$to_password --authenticationDatabase=admin --eval 'db.getSiblingDB("'""$to_database""'"').dropDatabase()'
mongorestore --host=$to_hostname --port=$to_port --username=$to_username --password=$to_password --authenticationDatabase=admin --db=$to_database --dir=/data-backup/$sync_dir/$from_database
EOF
)

eval """
sudo docker run --rm \
  --platform linux/amd64 \
  -v '$temp/backup:/data-backup' \
  '$docker_image' \
  bash -c \"$sync_command\" $(console_redirect_output)
"""

console_content_complete
console_empty_line

# ------------------------------------------------------------

console_script_end "Install complete."
