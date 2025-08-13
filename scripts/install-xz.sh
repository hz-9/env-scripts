#!/bin/bash
_m_='♥'

SHELL_NAME="XZ Installer"
SHELL_DESC="Install 'xz' compression utility by installation package."

PARAMTERS=(
  "--help${_m_}-h${_m_}Print help message.${_m_}false"
  "--debug${_m_}${_m_}Print debug message.${_m_}false"

  "--network${_m_}${_m_}Specify network environment (e.g., 'in-china').${_m_}default"

  "--xz-version${_m_}${_m_}XZ version. Default is lastest available.${_m_}default"
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
xzVersion=$(get_param '--xz-version')

# ------------------------------------------------------------

console_module_title "Install XZ"

if command -v xz &>/dev/null; then
  console_content "XZ is already installed."
else
  install_by_apt_get() {
    apt_setup_mirrors "$network"
    
    apt_get_update

    local local="XZ Utils"
    local name="xz-utils"
    local version=$xzVersion

    apt_get_install "$local" "$name" "$version"
  }

  install_by_dnf() {
    # Setup mirrors if China network is specified
    dnf_setup_mirrors "$network"
    
    dnf_update

    local local="XZ"
    local name="xz"
    local version=$xzVersion
    
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

# Check if XZ is installed and get version
if command -v xz &>/dev/null; then
  console_key_value "XZ" "$(xz --version | head -n 1 | cut -d' ' -f4)"
else
  console_content_error "Failed to install XZ"
  exit 1
fi
console_empty_line

# ------------------------------------------------------------

console_script_end "Install complete."
