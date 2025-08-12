#!/bin/bash
_m_='♥'

SHELL_NAME="p7zip Installer"
SHELL_DESC="Install 'p7zip' command-line 7-Zip archiver."

PARAMTERS=(
  "--help${_m_}-h${_m_}Print help message.${_m_}false"
  "--debug${_m_}${_m_}Print debug message.${_m_}false"

  "--network${_m_}${_m_}Specify network environment (e.g., 'in-china').${_m_}default"

  "--p7zip-version${_m_}${_m_}p7zip version. Default is latest available.${_m_}default"
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
p7zipVersion=$(get_param '--p7zip-version')

# ------------------------------------------------------------

console_module_title "Install p7zip"

if command -v 7z &>/dev/null || command -v 7za &>/dev/null; then
  console_content "p7zip is already installed."
else
  install_by_apt_get() {
    apt_setup_mirrors "$network"
    
    apt_get_update

    local local="p7zip"
    local name="p7zip-full"
    local version=$p7zipVersion

    apt_get_install "$local" "$name" "$version"
  }

  install_by_dnf() {
    dnf_setup_mirrors "$network"
    
    dnf_update

    local local="p7zip"
    local name="p7zip"
    local version=$p7zipVersion
    
    dnf_install "$local" "$name" "$version"
  }

  if [[ "$USE_APT_GET_INSTALL" == true ]]; then
    install_by_apt_get
  elif [[ "$USE_DNF_INSTALL" == true ]]; then
    install_by_dnf
  else
    console_content_error "Unsupported operating system: $OS_NAME"
    exit 1
  fi
fi

if command -v 7z &>/dev/null; then
  console_key_value "p7zip" "$(7z | head -3 | tail -1 | awk '{print $3}')"
elif command -v 7za &>/dev/null; then
  console_key_value "p7zip" "$(7za | head -3 | tail -1 | awk '{print $3}')"
else
  console_key_value "p7zip" "unknown"
fi
console_empty_line

# ------------------------------------------------------------

console_script_end "Install complete."
