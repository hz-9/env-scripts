#!/bin/bash
_m_='♥'

# shellcheck disable=SC2034
SHELL_NAME="Node.js Installer"
# shellcheck disable=SC2034
SHELL_DESC="Install 'nvm', 'node.js' and 'pm2'."

# shellcheck disable=SC2034
PARAMTERS=(
  "--help${_m_}-h${_m_}Print help message.${_m_}false"
  "--debug${_m_}${_m_}Print debug message.${_m_}false"

  "--network${_m_}${_m_}Specify network environment (e.g., 'in-china').${_m_}default"

  "--nvm-version${_m_}${_m_}NVM version.${_m_}v0.40.3"
  "--node-version${_m_}${_m_}Node.js version.${_m_}v18.20.3"
  "--skip-pm2${_m_}${_m_}Skip PM2 installation.${_m_}false"
  "--pm2-version${_m_}${_m_}PM2 version.${_m_}5.4.2"
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
nvmVersion=$(get_param '--nvm-version')
nodeVersion=$(get_param '--node-version')
pm2Version=$(get_param '--pm2-version')
skipPm2=$(get_param '--skip-pm2')

nvmHome="${HOME}/.nvm"

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

# Install NVM
if [[ -d "$nvmHome" ]] && [[ -s "$nvmHome/nvm.sh" ]] && [[ -s "$nvmHome/README.md" ]]; then
  console_content "NVM is already installed at $nvmHome"
else
  console_content_starting "Installing NVM ${nvmVersion}..."
  
  if [[ "$network" == "in-china" ]]; then
    # Use Gitee mirror for China users
    nvmRepoUrl="https://gitee.com/mirrors/nvm.git"
  else
    nvmRepoUrl="https://github.com/nvm-sh/nvm.git"
  fi
  
  # Clone NVM repository to specific version
  eval "git clone --depth 1 --branch \"$nvmVersion\" \"$nvmRepoUrl\" \"$nvmHome\" $(console_redirect_output)"
  
  console_content_complete
fi

if [[ "$network" == "in-china" ]]; then      
  console_content_starting "Setting up China NVM mirrors..."

  export NVM_NODEJS_ORG_MIRROR=https://npmmirror.com/mirrors/node/
  export NVM_IOJS_ORG_MIRROR=https://mirrors.huaweicloud.com/iojs/
else
  console_content_starting "Using default NVM sources..."
fi
console_content_complete


# Source NVM
export NVM_DIR="$nvmHome"
# Source NVM if available
if [ -s "$NVM_DIR/nvm.sh" ]; then
    source "$NVM_DIR/nvm.sh"
fi
if [ -s "$NVM_DIR/bash_completion" ]; then
    source "$NVM_DIR/bash_completion"
fi

console_key_value "nvm" "$(nvm -v)"
console_empty_line

install_node() {
  console_content_starting "Installing Node.js ${nodeVersion}..."
  eval "nvm install \"$nodeVersion\" $(console_redirect_output)"
  eval "nvm use \"$nodeVersion\" $(console_redirect_output)"
  eval "nvm alias default \"$nodeVersion\" $(console_redirect_output)"
  console_content_complete
}

# Install Node.js
if command -v node &>/dev/null; then
  currentNodeVersion=$(node --version)
  console_content "Node.js is already installed: $currentNodeVersion"
  if [[ "$currentNodeVersion" != "$nodeVersion" ]]; then
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
  console_content_starting "pm2 ${pm2Version} is installing..."
  # npm install -g pm2@"$pm2Version"
  if [[ "$pm2Version" == "default" ]]; then
    eval "npm install -g pm2                  $(console_redirect_output)"
  else
    eval "npm install -g pm2@\"$pm2Version\"  $(console_redirect_output)"
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
if [[ "$skipPm2" != "true" ]]; then
  if command -v pm2 &>/dev/null; then
    console_content "PM2 is already installed: $(pm2 --version)"
  else
    install_pm2
  fi
fi

if [[ "$skipPm2" != "true" ]]; then
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
