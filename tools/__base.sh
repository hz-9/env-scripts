#!/bin/bash
_m_='♥'

{
  # Color output
  RED='\033[0;31m'
  GREEN='\033[0;32m'
  YELLOW='\033[1;33m'
  BLUE='\033[0;34m'
  NC='\033[0m' # No Color

  # Log functions
  log_info() {
      echo -e "${BLUE}[INFO]${NC} $1"
  }

  log_success() {
      echo -e "${GREEN}[SUCCESS]${NC} $1"
  }

  log_warning() {
      echo -e "${YELLOW}[WARNING]${NC} $1"
  }

  log_error() {
      echo -e "${RED}[ERROR]${NC} $1"
  }

  log_debug() {
      echo -e "[DEBUG] $1"
  }
}

{
  # Print current time (seconds)
  console_time_s() {
    local seconds
    seconds=$(date +%s)
    echo $((seconds * 1))
  }
}

{
  USER_PARAMTERS=()

  # Detect bash version and choose appropriate parsing method
  parse_param_string() {
    local param_string="$1"
    local result_var_name="$2"
    
    # Use printf to replace separators, avoiding bash version differences
    eval "${result_var_name}=()"
    local param_with_newlines
    param_with_newlines=$(printf '%s\n' "${param_string//$_m_/$'\n'}")
    local line_count=0
    while IFS= read -r line; do
      eval "${result_var_name}[$line_count]='$line'"
      ((line_count++))
    done <<< "$param_with_newlines"
  }
  
  # Convenience function: parse parameters with 2 fields (name, value)
  parse_param_2fields() {
    local param_string="$1"
    local name_var="$2"
    local value_var="$3"
    
    parse_param_string "$param_string" "__temp_fields"
    
    eval "${name_var}=\"\${__temp_fields[0]:-}\""
    eval "${value_var}=\"\${__temp_fields[1]:-}\""
  }
  
  parse_user_param() {
    while [[ "$#" -gt 0 ]]; do
      case $1 in
      --*=*)
        key="${1%%=*}"
        value="${1#*=}"
        USER_PARAMTERS+=("$key${_m_}$value")
        ;;
      --*)
        key="$1"
        if [[ -n "$2" && "$2" != --* ]]; then
          USER_PARAMTERS+=("$key${_m_}$2")
          shift
        else
          USER_PARAMTERS+=("$key${_m_}true")
        fi
        ;;
      *)
        echo "Unknown option: $1"
        exit 1
        ;;
      esac
      shift
    done
  }

  get_user_param() {
    local key="$1"

    for PARAMTER in "${USER_PARAMTERS[@]}"; do
      local name value
      parse_param_2fields "$PARAMTER" name value

      if [[ "$name" == "$key" ]]; then
        echo "$value"
      fi
    done
    return
  }
}