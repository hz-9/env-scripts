#!/bin/bash

remove_docker_container() {
  eval "sudo docker stop $container_name $(console_redirect_output)"
  eval "sudo docker rm   $container_name $(console_redirect_output)"
}

checkpoint_pull_image_from_docker_hub() {
  checkpoint_content "Process" "Docker Pull from Docker Hub"
  eval "sudo docker pull $docker_image --platform linux/amd64 $(console_redirect_output)"
  if [ $? -eq 0 ]; then
      checkpoint_complete
  else
      checkpoint_error
      console_error_line "Failed to pull Docker image: $docker_image"
      exit 1
  fi
}

checkpoint_pull_image() {
  checkpoint_staring "Pull Docker Image ${docker_image}"

  if [ -n "$(get_user_param '--docker-image-quick-check')" ]; then
    local image_exists=$(sudo docker images --format "table {{.Repository}}:{{.Tag}}\t{{.ID}}" | grep "^$docker_image" | wc -l)

    if [ "$image_exists" -gt 0 ]; then
        checkpoint_content "Local" "Exists"

        # 进一步检查平台架构是否匹配
        local platform_match=$(sudo docker image inspect "$docker_image" --format '{{.Architecture}}' 2>/dev/null | grep -c "amd64")
        
        if [ "$platform_match" -gt 0 ]; then
          checkpoint_content "Platform" "Match"
          checkpoint_complete
        else
          checkpoint_content "Platform" "Not Match"
          checkpoint_pull_image_from_docker_hub
        fi
    else
      checkpoint_content "Local" "Not Exists"
      checkpoint_pull_image_from_docker_hub
    fi
  else
    checkpoint_pull_image_from_docker_hub
  fi
}
