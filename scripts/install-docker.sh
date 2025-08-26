#!/bin/bash
_m_='♥'

SHELL_NAME="Docker CE Installer"
SHELL_DESC="Install 'docker-ce' and 'docker-compose'."

PARAMTERS=(
  "--help${_m_}-h${_m_}Print help message.${_m_}false"
  "--debug${_m_}${_m_}Print debug message.${_m_}false"

  "--network${_m_}${_m_}Specify network environment (e.g., 'in-china').${_m_}default"

  "--docker-version${_m_}${_m_}Docker CE version. Default is latest available.${_m_}default"
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
docker_version=$(get_param '--docker-version')
compose_version=$(get_param '--compose-version')

# ------------------------------------------------------------

console_module_title "Install Docker CE"

if command -v docker &>/dev/null; then
  console_content "Docker is already installed: $(docker --version)"
else
  install_by_apt_get() {
    apt_setup_mirrors "$network"

    if command -v curl &>/dev/null; then
      console_content "Curl is already installed."
    else
      console_content "Curl is not installed. Please install curl first."
      exit 1
    fi
    if ! dpkg -s "ca-certificates" &>/dev/null; then
      console_content "ca-certificates is not installed. Please install ca-certificates first."
    else
      console_content "ca-certificates is already installed."
    fi

    local docker_mirror_url

    if [[ "$network" == "in-china" ]]; then
      console_content_starting "Using Docker China mirrors..."
      if [[ "$OS_NAME" == "Ubuntu" ]]; then
        docker_mirror_url="https://mirrors.huaweicloud.com/docker-ce/linux/ubuntu"
      elif [[ "$OS_NAME" == "Debian" ]]; then
        docker_mirror_url="https://mirrors.huaweicloud.com/docker-ce/linux/debian"
      else
        echo "Not support this OS."
        exit 1
      fi
    else
      console_content_starting "Using up Docker Default mirrors..."
      if [[ "$OS_NAME" == "Ubuntu" ]]; then
        docker_mirror_url="https://download.docker.com/linux/ubuntu"
      elif [[ "$OS_NAME" == "Debian" ]]; then
        docker_mirror_url="https://download.docker.com/linux/rhel/debian"
      else
        echo "Not support this OS."
        exit 1
      fi
    fi
    console_content_complete

    if [ ! -f '/etc/apt/keyrings/docker.asc' ]; then
      console_content_starting "The GPG certificate is installing..."
      sudo install -m 0755 -d /etc/apt/keyrings
      curl -fsSL ${docker_mirror_url}/gpg | sudo tee /etc/apt/keyrings/docker.asc > /dev/null
      sudo chmod a+r /etc/apt/keyrings/docker.asc
      console_content_complete
    else
      console_content "The GPG certificate is already installed."
    fi

    if [ ! -f '/etc/apt/sources.list.d/docker.list' ]; then
      console_content_starting "The software source information is writting..."

      echo \
      "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] ${docker_mirror_url} $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
      sudo tee /etc/apt/sources.list.d/docker.list >/dev/null

      console_content_complete
    else
      console_content "The software source information is already written."
    fi

    apt_get_update

    apt_get_install_tzdata "Asia\nShanghai"

    local local="Docker CE"
    local name="docker-ce"
    local version=$docker_version
    
    apt_get_install "$local" "$name" "$version"

    local="Docker CE Cli"
    name="docker-ce-cli"
    version=$docker_version
    apt_get_install "$local" "$name" "$version"

    apt_get_install "containerd.io" "containerd.io"
    apt_get_install "docker-buildx-plugin " "docker-buildx-plugin"
    apt_get_install "docker-compose-plugin" "docker-compose-plugin"
  }

  install_by_dnf() {
    dnf_setup_mirrors "$network"

    if ! rpm -q "ca-certificates" &>/dev/null; then
      console_content "ca-certificates is not installed. Please install ca-certificates first."
      exit 1
    else
      console_content "ca-certificates is already installed."
    fi

    local docker_mirror_url

    if [[ "$network" == "in-china" ]]; then
      console_content_starting "Setting up Docker China mirrors..."
      if [[ "$OS_NAME" == "Fedora" ]]; then
        docker_mirror_url="https://mirrors.huaweicloud.com/docker-ce/linux/fedora/docker-ce.repo"
      elif [[ "$OS_NAME" == "RedHat" ]]; then
        docker_mirror_url="https://mirrors.huaweicloud.com/docker-ce/linux/rhel/docker-ce.repo"
      else
        echo "Not support this OS."
        exit 1
      fi
    else
      console_content_starting "Setting up Docker Default mirrors..."
      if [[ "$OS_NAME" == "Fedora" ]]; then
        docker_mirror_url="https://download.docker.com/linux/fedora/docker-ce.repo"
      elif [[ "$OS_NAME" == "RedHat" ]]; then
        docker_mirror_url="https://download.docker.com/linux/rhel/docker-ce.repo"
      else
        echo "Not support this OS."
        exit 1
      fi
    fi
    
    console_content_complete

    dnf_config_manager_add_repo "Docker mirrors" "docker-ce.repo" "$docker_mirror_url"
  
    dnf_update

    # Step 5: Install
    local local="Docker CE"
    local name="docker-ce"
    local version=$docker_version
    dnf_install "$local" "$name" "$version"

    local="Docker CE Cli"
    name="docker-ce-cli"
    version=$docker_version
    dnf_install "$local" "$name" "$version"

    dnf_install "containerd.io" "containerd.io"
    dnf_install "docker-buildx-plugin " "docker-buildx-plugin"
    dnf_install "docker-compose-plugin" "docker-compose-plugin"
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

console_empty_line

console_key_value "Docker CE" "$(docker --version | awk '{print $3}' | sed 's/,//')"
console_key_value "Docker compose" "$(docker compose version | awk '{print $4}')"
console_empty_line

# Start and enable Docker service
console_content_starting "Starting Docker service..."
eval "sudo systemctl start docker $(console_redirect_output)"
eval "sudo systemctl enable docker $(console_redirect_output)"
console_content_complete

# Add current user to docker group
console_content_starting "Adding current user to docker group..."
eval "sudo usermod -aG docker $USER $(console_redirect_output)"
console_content_complete

console_content "Note: You may need to log out and back in for group changes to take effect."

console_empty_line

# ------------------------------------------------------------

console_script_end "Docker installation complete."
