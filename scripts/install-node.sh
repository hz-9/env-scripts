#!/bin/bash
_m_='♥'

SHELL_NAME="Node.js Installer"
SHELL_DESC="Install 'nvm', 'node.js' and 'pm2'."

PARAMTERS=(
  "--help${_m_}-h${_m_}Print help message.${_m_}false"
  "--debug${_m_}${_m_}Print debug message.${_m_}false"

  "--network${_m_}${_m_}Specify network environment (e.g., 'in-china').${_m_}default"

  "--nvm-version${_m_}${_m_}NVM version.${_m_}v0.40.3"
  "--node-version${_m_}${_m_}Node.js version.${_m_}v18.20.3"
  "--skip-pm2${_m_}${_m_}Skip PM2 installation.${_m_}false"
  "--pm2-version${_m_}${_m_}PM2 version.${_m_}5.4.2"
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
nvm_version=$(get_param '--nvm-version')
node_version=$(get_param '--node-version')
pm2_version=$(get_param '--pm2-version')
skip_pm2=$(get_param '--skip-pm2')

 nvm_home="${HOME}/.nvm"

# ------------------------------------------------------------

console_module_title "Install Node.js Development Environment"

if command -v curl &>/dev/null; then
  console_content "Curl is already installed."
else
  console_content "Curl is not installed. Please install curl first."
  exit 1
fi
if command -v git &>/dev/null; then
  console_content "Git is already installed."
else
  console_content "Git is not installed. Please install git first."
  exit 1
fi

default_nvm_repo_url="https://github.com/nvm-sh/nvm.git"
if [[ "$network" == "in-china" ]]; then
  # Use Gitee mirror for China users
  nvm_repo_url="https://gitee.com/mirrors/nvm.git"
else
  nvm_repo_url="https://github.com/nvm-sh/nvm.git"
fi

install_nvm() {
  local current_nvm_repo_url="$1"
  # Install NVM
  if [[ -d "$nvm_home" ]] && [[ -s "$nvm_home/nvm.sh" ]] && [[ -s "$nvm_home/README.md" ]]; then
    console_content "NVM is already installed at $nvm_home"
  else
    console_content_starting "Installing NVM ${nvm_version} [$current_nvm_repo_url]..."

    # Clone NVM repository to specific version
    eval "git clone --depth 1 --branch \"$nvm_version\" \"$current_nvm_repo_url\" \"$nvm_home\" $(console_redirect_output)"

    if [[ ! -d "$nvm_home" ]]; then
      console_content_error "Failed to install NVM. Use default nvm repo url retry."
    else
      console_content_complete
    fi
  fi
}

install_nvm "$nvm_repo_url"

# In Debian 12.2, the nvm installation may fail due to git clone failure.
if [[ ! -d "$nvm_home" ]]; then
  install_nvm "$default_nvm_repo_url"
fi

setting_nvm() {
  if [[ "$network" == "in-china" ]]; then      
    console_content_starting "Setting up China NVM mirrors..."

    export NVM_NODEJS_ORG_MIRROR=https://npmmirror.com/mirrors/node/
    export NVM_IOJS_ORG_MIRROR=https://mirrors.huaweicloud.com/iojs/
  else
    console_content_starting "Using default NVM sources..."
  fi
  console_content_complete

  # Source NVM
  export NVM_DIR="$nvm_home"
  if [ -s "$NVM_DIR/nvm.sh" ]; then
      source "$NVM_DIR/nvm.sh"
  fi
  if [ -s "$NVM_DIR/bash_completion" ]; then
      source "$NVM_DIR/bash_completion"
  fi
}
setting_nvm

console_key_value "NVM Dir" "${NVM_DIR}"
console_key_value "NVM Version" "$(nvm -v)"
console_empty_line

install_node() {
  console_content_starting "Installing Node.js ${node_version}..."
  eval "nvm install \"$node_version\" $(console_redirect_output)"
  eval "nvm use \"$node_version\" $(console_redirect_output)"
  eval "nvm alias default \"$node_version\" $(console_redirect_output)"
  console_content_complete
}

# Install Node.js
if command -v node &>/dev/null; then
  current_node_version=$(node --version)
  console_content "Node.js is already installed: $current_node_version"
  if [[ "$current_node_version" != "$node_version" ]]; then
    install_node
  fi
else
  install_node
fi

if [[ "$network" == "in-china" ]]; then      
  console_content_starting "Setting up China NPM mirrors..."
  npm config set registry https://registry.npmmirror.com/
else
  console_content_starting "Using default NPM sources..."
fi
console_content_complete

console_key_value "Node" "$(node -v)"
console_key_value "npm" "$(npm -v)"
console_empty_line

install_pm2() {
  console_content_starting "pm2 ${pm2_version} is installing..."
  # npm install -g pm2@"$pm2_version"
  if [[ "$pm2_version" == "default" ]]; then
    eval "npm install -g pm2                  $(console_redirect_output)"
  else
    eval "npm install -g pm2@\"$pm2_version\"  $(console_redirect_output)"
  fi

  # pm2 ping
  eval "pm2 ping                              $(console_redirect_output)"
  console_content_complete

  # pm2 startup
  eval "pm2 startup                           $(console_redirect_output)"
  console_content "pm2 startup is done."

  console_content_starting "pm2-logrotate is installing..."
  # pm2 install pm2-logrotate
  eval "pm2 install pm2-logrotate             $(console_redirect_output)"
  # pm2 set pm2-logrotate:max_size 100M
  eval "pm2 set pm2-logrotate:max_size 100M   $(console_redirect_output)"
  console_content_complete
}

# Install PM2
if [[ "$skip_pm2" != "true" ]]; then
  if command -v pm2 &>/dev/null; then
    console_content "PM2 is already installed: $(pm2 --version)"
  else
    install_pm2
  fi
fi

if [[ "$skip_pm2" != "true" ]]; then
  console_key_value "pm2" "$(pm2 -v)"
  console_key_value "pm2-logrotate" "$(pm2 info pm2-logrotate | grep 'version' | head -n 1 | awk '{print $4}')"
fi
console_empty_line

console_content "To start using NVM in your current session, run:"
console_content "  source ~/.bashrc"
console_content "  # or"
console_content "  source ~/.zshrc"
console_empty_line

# ------------------------------------------------------------

console_script_end "Node.js installation complete."
