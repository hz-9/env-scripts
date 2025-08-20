#!/bin/bash
_m_='♥'

SHELL_NAME="MySQL Syncer"
SHELL_DESC="Sync MySQL database."

PARAMTERS=(
  "--help${_m_}-h${_m_}Print help message.${_m_}false"
  "--debug${_m_}${_m_}Print debug message.${_m_}false"

  "--network${_m_}${_m_}Specify network environment (e.g., 'in-china').${_m_}default"

  "--db-version${_m_}${_m_}The version of the database.${_m_}8.0"

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

dbVersion=$(get_param '--db-version')

fromHostname=$(get_param '--from-hostname')
fromPort=$(get_param '--from-port')
fromUsername=$(get_param '--from-username')
fromPassword=$(get_param '--from-password')
fromDatabase=$(get_param '--from-database')

toHostname=$(get_param '--to-hostname')
toPort=$(get_param '--to-port')
toUsername=$(get_param '--to-username')
toPassword=$(get_param '--to-password')
toDatabase=$(get_param '--to-database')

# ------------------------------------------------------------

console_module_title "Temp Directory"

temp=$(get_param '--temp')
syncFile="dump.mysql.$(date +"%Y-%m-%dT%H:%M:%S").sql"

console_key_value "Temp Dir" "$temp"
console_key_value "Sync File" "$syncFile"

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

dockerImage="mysql:$dbVersion"
console_key_value "Docker image" "$dockerImage"

console_content_starting "Image $dockerImage is pulling..."

eval "sudo docker pull $dockerImage --platform linux/amd64 $(console_redirect_output)"

console_content_complete
console_empty_line

# ------------------------------------------------------------

console_module_title "Sync by $dockerImage"

console_content_starting "Syncing data from $fromHostname to $toHostname..."

syncCommand="""
# Export data from source database
mysqldump -h $fromHostname -P $fromPort -u $fromUsername -p$fromPassword $fromDatabase > '/data-backup/$syncFile'

# Import data to target database
mysql -h $toHostname -P $toPort -u $toUsername -p$toPassword -e 'DROP DATABASE IF EXISTS $toDatabase;'
mysql -h $toHostname -P $toPort -u $toUsername -p$toPassword -e 'CREATE DATABASE $toDatabase;'
mysql -h $toHostname -P $toPort -u $toUsername -p$toPassword $toDatabase < '/data-backup/$syncFile'
"""

eval """
sudo docker run --rm \
  --platform linux/amd64 \
  -e 'MYSQL_ROOT_PASSWORD=12345678' \
  -v '$temp/backup:/data-backup' \
  '$dockerImage' \
  bash -c \"$syncCommand\" $(console_redirect_output)
"""

# ------------------------------------------------------------

console_script_end "Install complete."
