#!/bin/bash

MANILA_DOCKER_CONTAINER_NAME=${MANILA_DOCKER_CONTAINER_NAME:-"manila-docker-container"}
MANILA_DOCKER_CONTAINER_IMAGE_NAME=${MANILA_DOCKER_CONTAINER_IMAGE_NAME:-"$MANILA_DOCKER_CONTAINER_NAME.tar"}

if [ -e /etc/os-release ]; then
    platform=$(cat /etc/os-release | awk -F= '/^ID=/ {print tolower($2);}')
    # remove eventual quotes around ID=...
    platform=$(echo $platform | sed -e 's,^",,;s,"$,,')
elif [ -e /etc/system-release ]; then
    case "$(head -1 /etc/system-release)" in
        "Red Hat Enterprise Linux Server"*)
            platform=rhel
            ;;
        "CentOS"*)
            platform=centos
            ;;
        *)
            echo -e "Unknown value in /etc/system-release. Impossible to build images.\nAborting"
            exit 2
            ;;
    esac
else
    echo -e "Unknown host OS. Impossible to build images.\nAborting"
    exit 2
fi

is_docker_installed() {
    package_name="docker"
    if [ "$platform" = 'ubuntu' ]; then
        dpkg -s "docker.io" &> /dev/null
    else
        # centos, fedora, opensuse, or rhel
        if ! rpm -q "$package_name" &> /dev/null; then
            rpm -q "$(rpm -q --whatprovides "$package_name")"
        fi
    fi
}

if ! is_docker_installed; then
    echo "Docker is not found. Installing it."
    case "$platform" in
        "ubuntu")
            sudo apt-get update
            sudo apt-get install -y apparmor lxc cgroup-lite
            sudo apt-get install -y docker.io
            ;;
        "opensuse")
            sudo zypper --non-interactive --gpg-auto-import-keys in docker
            ;;
        "fedora" | "rhel" | "centos")
            if [ ${platform} = "centos" ]; then
                # install EPEL repo, in order to install argparse
                sudo rpm -Uvh --force https://dl.fedoraproject.org/pub/epel/6/x86_64/epel-release-6-8.noarch.rpm
            fi
            sudo yum install docker -y
            ;;
        *)
            echo -e "Unknown platform '$platform' for installing packages.\nAborting"
            exit 2
            ;;
    esac
else
    echo "Docker is found."
fi

echo "Starting building a container."

sudo docker build -t $MANILA_DOCKER_CONTAINER_NAME data/docker
sudo docker save -o $MANILA_DOCKER_CONTAINER_IMAGE_NAME $MANILA_DOCKER_CONTAINER_NAME
sudo gzip -v --force $MANILA_DOCKER_CONTAINER_IMAGE_NAME
