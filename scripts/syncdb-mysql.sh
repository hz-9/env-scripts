#!/bin/bash
_m_='♥'

SHELL_NAME="MySQL Database Synchronizer"
SHELL_DESC="Efficiently synchronize MySQL databases between remote and local environments, supporting backup and restore operations."

PARAMTERS=(
  "--help${_m_}-h${_m_}Print help message.${_m_}false"
  "--debug${_m_}${_m_}Print debug message.${_m_}false"

  "--network${_m_}${_m_}Specify network environment (e.g., 'in-china').${_m_}default"

  "--db-version${_m_}${_m_}The version of the database.${_m_}8.0"
  "--docker-image-quick-check${_m_}${_m_}Is there a local quick detection of the docker image.${_m_}false"

  "--from-hostname${_m_}${_m_}The hostname of the source database.${_m_}127.0.0.1"
  "--from-port${_m_}${_m_}The port of the source database.${_m_}3306"
  "--from-username${_m_}${_m_}The username of the source database.${_m_}root"
  "--from-password${_m_}${_m_}The password of the source database.${_m_}12345678"
  "--from-database${_m_}${_m_}The database name of the source database.${_m_}mysql"

  "--to-hostname${_m_}${_m_}The hostname of the target database.${_m_}127.0.0.1"
  "--to-port${_m_}${_m_}The port of the target database.${_m_}3306"
  "--to-username${_m_}${_m_}The username of the target database.${_m_}root"
  "--to-password${_m_}${_m_}The password of the target database.${_m_}12345678"
  "--to-database${_m_}${_m_}The database name of the target database.${_m_}mysql_backup"
  "--temp${_m_}${_m_}The temporary directory.${_m_}/tmp/hz-9/env-prepare/sync-db-mysql"
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

print_help_or_param

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
sync_file="dump.mysql.$(date +"%Y-%m-%dT%H:%M:%S").sql"

console_key_value "Temp Dir" "$temp"
console_key_value "Sync File" "$sync_file"

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

docker_image="mysql:$db_version"
pull_docker_image $docker_image
console_empty_line

# ------------------------------------------------------------

console_module_title "Sync by $docker_image"

console_content_starting "Syncing data from $from_hostname to $to_hostname..."

syncCommand="""
# Export data from source database
mysqldump -h $from_hostname -P $from_port -u $from_username -p$from_password $from_database > '/data-backup/$sync_file'

# Import data to target database
mysql -h $to_hostname -P $to_port -u $to_username -p$to_password -e 'DROP DATABASE IF EXISTS $to_database;'
mysql -h $to_hostname -P $to_port -u $to_username -p$to_password -e 'CREATE DATABASE $to_database;'
mysql -h $to_hostname -P $to_port -u $to_username -p$to_password $to_database < '/data-backup/$sync_file'
"""

eval """
sudo docker run --rm \
  --platform linux/amd64 \
  -e 'MYSQL_ROOT_PASSWORD=12345678' \
  -v '$temp/backup:/data-backup' \
  '$docker_image' \
  bash -c \"$syncCommand\" $(console_redirect_output)
"""

console_content_complete
console_empty_line


# ------------------------------------------------------------

console_script_end "Install complete."
