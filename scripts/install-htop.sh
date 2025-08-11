#!/bin/bash
_m_='♥'

# shellcheck disable=SC2034
SHELL_NAME="htop Installer"
# shellcheck disable=SC2034
SHELL_DESC="Install 'htop' interactive process viewer."

# shellcheck disable=SC2034
PARAMTERS=(
  "--help${_m_}-h${_m_}Print help message.${_m_}false"
  "--debug${_m_}${_m_}Print debug message.${_m_}false"

  "--network${_m_}${_m_}Specify network environment (e.g., 'in-china').${_m_}default"

  "--htop-version${_m_}${_m_}htop version. Default is latest available.${_m_}default"
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
  # "RedHat 9.6 AMD64"
)

# shellcheck disable=SC1091
source ./__base.sh

print_help_or_param

network=$(get_param '--network')
htopVersion=$(get_param '--htop-version')

# ------------------------------------------------------------

console_module_title "Install htop"

if command -v htop &>/dev/null; then
  console_content "htop is already installed."
else
  install_by_apt_get() {
    apt_setup_mirrors "$network"
    
    apt_get_update

    local local="htop"
    local name="htop"
    local version=$htopVersion

    apt_get_install "$local" "$name" "$version"
  }

  install_by_dnf() {
    dnf_setup_mirrors "$network"

    dnf_update

    local local="htop"
    local name="htop"
    local version=$htopVersion
    
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

console_key_value "htop" "$(htop --version | head -1 | awk '{print $2}')"
console_empty_line

# ------------------------------------------------------------

console_script_end "Install complete."
