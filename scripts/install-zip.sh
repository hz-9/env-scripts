#!/bin/bash
_m_='♥'

SHELL_NAME="Zip/Unzip Installer"
SHELL_DESC="Install 'zip' and 'unzip' compression utilities."

PARAMTERS=(
  "--help${_m_}-h${_m_}Print help message.${_m_}false"
  "--debug${_m_}${_m_}Print debug message.${_m_}false"

  "--network${_m_}${_m_}Specify network environment (e.g., 'in-china').${_m_}default"

  "--zip-version${_m_}${_m_}Zip version. Default is latest available.${_m_}default"
  "--unzip-version${_m_}${_m_}Unzip version. Default is latest available.${_m_}default"
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
zip_version=$(get_param '--zip-version')
unzip_version=$(get_param '--unzip-version')

# ------------------------------------------------------------

console_module_title "Install Zip/Unzip"

# Check current installation status
zipInstalled=false
unzipInstalled=false

if command -v zip &>/dev/null; then
  console_content "Zip is already installed."
  zipInstalled=true
fi

if command -v unzip &>/dev/null; then
  console_content "Unzip is already installed."
  unzipInstalled=true
fi

if [[ "$zipInstalled" == false ]] || [[ "$unzipInstalled" == false ]]; then
  install_by_apt_get() {
    apt_setup_mirrors "$network"
    
    apt_get_update

    if [[ "$zipInstalled" == false ]]; then
      local local="Zip"
      local name="zip"
      local version=$zip_version
      apt_get_install "$local" "$name" "$version"
    fi
    
    if [[ "$unzipInstalled" == false ]]; then
      local local="Unzip"
      local name="unzip"
      local version=$unzip_version
      apt_get_install "$local" "$name" "$version"
    fi
  }

  install_by_dnf() {
    dnf_setup_mirrors "$network"
    
    dnf_update

    if [[ "$zipInstalled" == false ]]; then
      local local="Zip"
      local name="zip"
      local version=$zip_version
      dnf_install "$local" "$name" "$version"
    fi
    
    if [[ "$unzipInstalled" == false ]]; then
      local local="Unzip"
      local name="unzip"
      local version=$unzip_version
      dnf_install "$local" "$name" "$version"
    fi
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

console_key_value "Zip" "$(zip -v 2>/dev/null | head -2 | tail -1 | awk '{print $4}' || echo 'unknown')"
console_key_value "Unzip" "$(unzip -v 2>/dev/null | head -1 | awk '{print $2}' || echo 'unknown')"
console_empty_line

# ------------------------------------------------------------

console_script_end "Install complete."
