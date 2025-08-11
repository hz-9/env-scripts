#!/bin/bash
_m_='♥'

# shellcheck disable=SC2034
SHELL_NAME="Wget Installer"
# shellcheck disable=SC2034
SHELL_DESC="Install 'wget' command-line tool for downloading files."

# shellcheck disable=SC2034
PARAMTERS=(
  "--help${_m_}-h${_m_}Print help message.${_m_}false"
  "--debug${_m_}${_m_}Print debug message.${_m_}false"

  "--network${_m_}${_m_}Specify network environment (e.g., 'in-china').${_m_}default"

  "--wget-version${_m_}${_m_}Wget version. Default is latest available.${_m_}default"
)

# shellcheck disable=SC2034
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

# shellcheck disable=SC1091
source ./__base.sh

print_help_or_param

network=$(get_param '--network')
wgetVersion=$(get_param '--wget-version')

# ------------------------------------------------------------

console_module_title "Install Wget"

if command -v wget &>/dev/null; then
  console_content "Wget is already installed."
else
  install_by_apt_get() {
    apt_setup_mirrors "$network"
    
    apt_get_update

    local local="Wget"
    local name="wget"
    local version=$wgetVersion

    apt_get_install "$local" "$name" "$version"
  }

  install_by_dnf() {
    dnf_setup_mirrors "$network"
    
    dnf_update

    local local="Wget"
    local name="wget"
    local version=$wgetVersion
    
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

console_key_value "Wget" "$(wget --version | head -1 | awk '{print $3}')"
console_empty_line

# ------------------------------------------------------------

console_script_end "Install complete."
