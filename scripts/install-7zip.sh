#!/bin/bash
_m_='♥'

SHELL_NAME="7Zip Installer"
SHELL_DESC="Install '7zip' from GitHub release package."

PARAMTERS=(
  "--help${_m_}-h${_m_}Print help message.${_m_}false"
  "--debug${_m_}${_m_}Print debug message.${_m_}false"

  "--network${_m_}${_m_}Specify network environment (e.g., 'in-china').${_m_}default"

  "--7zip-version${_m_}${_m_}7Zip version. Default is 24.09.${_m_}24.09"
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
z7_version=$(get_param '--7zip-version')

# ------------------------------------------------------------

console_module_title "Install 7Zip"

if command -v 7zz &>/dev/null; then
  console_content "7Zip is already installed."
else
  if command -v xz &>/dev/null; then
    console_content "XZ is already installed."
  else
    console_content "XZ is not installed. Please install XZ first."
    exit 1
  fi

  install_7zip_from_github() {
    console_content "Installing 7Zip version ${z7_version} from GitHub..."
    
    # Remove dots from version to create the filename format
    converted_version=$(echo "$z7_version" | tr -d '.')
    # local url="https://github.com/ip7z/7zip/releases/download/$z7Version/7z${converted_version}-linux-x64.tar.xz"
    local url="https://7-zip.org/a/7z${converted_version}-linux-x64.tar.xz"

    # Download the package
    download_file "$url" "/tmp/7z${converted_version}-linux-x64.tar.xz" "false"

    console_content_starting "Creating installation directory..."
    eval "sudo mkdir -p \"/usr/local/7z/${z7_version}\" $(console_redirect_output)"
    console_content_complete

    console_content_starting "7z${converted_version}-linux-x64.tar.xz is decompressing..."
    eval "sudo tar -xf /tmp/7z${converted_version}-linux-x64.tar.xz -C /usr/local/7z/${z7_version} $(console_redirect_output)"
    console_content_complete

    console_content_starting "Deleting 7z${converted_version}-linux-x64.tar.xz..."
    eval "sudo rm -rf \"/tmp/7z${converted_version}-linux-x64.tar.xz\" $(console_redirect_output)"
    console_content_complete

    # Create symbolic link
    console_content_starting "Creating symbolic link..."
    if [ -L /usr/bin/7zz ]; then
      eval "sudo rm -f /usr/bin/7zz $(console_redirect_output)"
    fi
    eval "sudo ln -s \"/usr/local/7z/${z7_version}/7zz\" /usr/bin/7zz $(console_redirect_output)"
    eval "sudo chmod +x /usr/bin/7zz $(console_redirect_output)"
    console_content_complete
    
    console_content "7Zip installation completed."
  }

  # Install 7Zip using the GitHub release
  install_7zip_from_github
fi

console_key_value "7Zip" "$(7zz | head -n 2 | tail -n 1 | awk '{print $3}')"
console_empty_line

# ------------------------------------------------------------

console_script_end "Install complete."
