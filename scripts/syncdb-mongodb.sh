#!/bin/bash
_m_='♥'

SHELL_NAME="MongoDB Syncer"
SHELL_DESC="Sync MongoDB database."

PARAMTERS=(
  "--help${_m_}-h${_m_}Print help message.${_m_}false"
  "--debug${_m_}${_m_}Print debug message.${_m_}false"

  "--network${_m_}${_m_}Specify network environment (e.g., 'in-china').${_m_}default"

  "--db-version${_m_}${_m_}The version of the database.${_m_}6.0"

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
  "--temp${_m_}${_m_}The temporary directory.${_m_}/tmp/hz-9/env-prepare/sync-db-mongodb"
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
syncDir="dump.mongodb.$(date +"%Y-%m-%dT%H:%M:%S")"

console_key_value "Temp Dir" "$temp"
console_key_value "Sync Dir" "$syncDir"

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

dockerImage="mongo:$dbVersion"
console_key_value "Docker image" "$dockerImage"

console_content_starting "Image $dockerImage is pulling..."

eval "sudo docker pull $dockerImage --platform linux/amd64 $(console_redirect_output)"

console_content_complete
console_empty_line

# ------------------------------------------------------------

console_module_title "Sync by $dockerImage"

console_content_starting "Syncing data from $fromHostname to $toHostname..."

if [[ $(echo "$dbVersion" | cut -d. -f1) -ge 5 ]]; then
  shell_cmd="mongosh"
else
  shell_cmd="mongo"
fi

syncCommand="""
# Export data from source database
mongodump --host=$fromHostname --port=$fromPort --username=$fromUsername --password=$fromPassword --authenticationDatabase=admin --db=$fromDatabase --out=/data-backup/$syncDir

# Import data to target database
$shell_cmd --host=$toHostname --port=$toPort --username=$toUsername --password=$toPassword --authenticationDatabase=admin --eval 'db.getSiblingDB(\"$toDatabase\").dropDatabase()'
mongorestore --host=$toHostname --port=$toPort --username=$toUsername --password=$toPassword --authenticationDatabase=admin --db=$toDatabase --dir=/data-backup/$syncDir/$fromDatabase
"""

eval """
sudo docker run --rm \
  --platform linux/amd64 \
  -v '$temp/backup:/data-backup' \
  '$dockerImage' \
  bash -c \"$syncCommand\" $(console_redirect_output)
"""

# ------------------------------------------------------------

console_script_end "Install complete."
