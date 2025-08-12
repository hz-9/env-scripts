#!/bin/bash
_m_='♥'

SHELL_NAME="Nginx Installer"
SHELL_DESC="Install and configure 'nginx' web server."

PARAMTERS=(
  "--help${_m_}-h${_m_}Print help message.${_m_}false"
  "--debug${_m_}${_m_}Print debug message.${_m_}false"

  "--network${_m_}${_m_}Specify network environment (e.g., 'in-china').${_m_}default"

  "--nginx-version${_m_}${_m_}Nginx version. Default is latest available.${_m_}default"
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
nginxVersion=$(get_param '--nginx-version')

# ------------------------------------------------------------

console_module_title "Install Nginx"

if command -v nginx &>/dev/null; then
  console_content "Nginx is already installed: $(nginx -v 2>&1 | awk '{print $3}' | cut -d'/' -f2)"
else
  install_by_apt_get() {
    apt_setup_mirrors "$network"

    apt_get_update

    apt_get_install_tzdata "Asia\nShanghai"

    apt_get_install "Nginx" "nginx" "$nginxVersion"
  }

  install_by_dnf() {
    dnf_setup_mirrors "$network"

    dnf_update

    dnf_install "Nginx" "nginx" "$nginxVersion"
  }

  if [[ "$OS_NAME" == "Ubuntu" ]] || [[ "$OS_NAME" == "Debian" ]]; then
    install_by_apt_get
  elif [[ "$OS_NAME" == "Fedora" ]] || [[ "$OS_NAME" == "RedHat" ]]; then
    install_by_dnf
  else
    console_error "Unsupported operating system: $OS_NAME"
    exit 1
  fi
fi

# # Configure firewall
# console_content_starting "Configuring firewall..."
# if command -v ufw &>/dev/null; then
#   # Ubuntu/Debian firewall
#   eval "sudo ufw allow 'Nginx Full' $(console_redirect_output)" 2>/dev/null || true
# elif command -v firewall-cmd &>/dev/null; then
#   # Fedora/RedHat firewall
#   eval "sudo firewall-cmd --permanent --add-service=http $(console_redirect_output)" 2>/dev/null || true
#   eval "sudo firewall-cmd --permanent --add-service=https $(console_redirect_output)" 2>/dev/null || true
#   eval "sudo firewall-cmd --reload $(console_redirect_output)" 2>/dev/null || true
# fi
# console_content_complete

# Start and enable nginx
console_content_starting "Starting Nginx service..."
eval "sudo systemctl start nginx $(console_redirect_output)"
eval "sudo systemctl enable nginx $(console_redirect_output)"
console_content_complete

# Create sample site
console_content_starting "Creating sample website..."
  
  sampleSiteDir="/var/www/html"
  sudo mkdir -p "$sampleSiteDir"
  
  sudo tee "$sampleSiteDir/index.html" > /dev/null <<EOF
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Welcome to Nginx</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            max-width: 800px;
            margin: 50px auto;
            padding: 20px;
            background-color: #f5f5f5;
        }
        .container {
            background-color: white;
            padding: 30px;
            border-radius: 10px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
        }
        h1 {
            color: #333;
            text-align: center;
        }
        .info {
            background-color: #e8f4fd;
            padding: 15px;
            border-radius: 5px;
            margin: 20px 0;
        }
        .success {
            color: #28a745;
            font-weight: bold;
        }
    </style>
</head>
<body>
    <div class="container">
        <h1>🎉 Nginx Installation Successful!</h1>
        <div class="info">
            <p class="success">✅ Nginx is running and serving this page</p>
            <p><strong>Server:</strong> $(hostname)</p>
            <p><strong>Timestamp:</strong> $(date)</p>
            <p><strong>Nginx Version:</strong> $(nginx -v 2>&1 | cut -d'/' -f2)</p>
        </div>
        <h2>Next Steps:</h2>
        <ul>
            <li>Configuration files: <code>/etc/nginx/</code></li>
            <li>Document root: <code>/var/www/html/</code></li>
            <li>Access logs: <code>/var/log/nginx/access.log</code></li>
            <li>Error logs: <code>/var/log/nginx/error.log</code></li>
        </ul>
        <h2>Useful Commands:</h2>
        <ul>
            <li>Check status: <code>sudo systemctl status nginx</code></li>
            <li>Restart: <code>sudo systemctl restart nginx</code></li>
            <li>Reload config: <code>sudo nginx -s reload</code></li>
            <li>Test config: <code>sudo nginx -t</code></li>
        </ul>
    </div>
</body>
</html>
EOF
  
sudo chown -R www-data:www-data "$sampleSiteDir" 2>/dev/null || sudo chown -R nginx:nginx "$sampleSiteDir" 2>/dev/null || true

console_content_complete

# Test nginx configuration
console_content_starting "Testing Nginx configuration..."
if sudo nginx -t &>/dev/null; then
  console_content "Nginx configuration test passed"
else
  console_content "Nginx configuration test failed - please check manually"
fi
console_content_complete

# Get server information
localIp=$(hostname -I 2>/dev/null | awk '{print $1}' || echo "Unable to determine")

# Display installation summary
console_empty_line
console_key_value "Nginx Version" "$(nginx -v 2>&1 | cut -d'/' -f2)"
console_key_value "Local IP" "$localIp"
console_empty_line

console_content "🌐 Access your website:"
console_content "  Local:  http://$localIp"
console_empty_line

console_content "📁 Important paths:"
console_content "  Config:   /etc/nginx/nginx.conf"
console_content "  Sites:    /etc/nginx/sites-available/"
console_content "  Web root: /var/www/html/"
console_content "  Logs:     /var/log/nginx/"

# ------------------------------------------------------------

console_script_end "Nginx installation complete."
