#!/bin/bash

# ------------------------------- Requirements ------------------------------- #

# Must run as root for docker
if [[ $(/usr/bin/id -u) -ne 0 ]]; then
  echo "Not running as root"
  echo "Please run as root user for docker."
  echo "If your docker installation does not need root, remove this requirement in the script."
  exit
fi

if ! [[ -x "$(command -v docker)" ]]; then
  echo "Docker not installed or detected. Docker is required"
  echo "Install docker with: \"curl -fsSL https://get.docker.com | sh\""
  exit
fi

if ! [[ -x "$(command -v docker-compose)" ]]; then
  echo "docker-compose not installed or detected. Docker-compose is required"
  exit
fi

if ! [[ -x "$(command -v sed)" ]]; then
  echo "sed not installed or detected. sed is required"
  exit
fi

# ----------------------------------- Info ----------------------------------- #

echo "This script will automatically build the OSX container in docker and run it."
echo "This instance of OSX is headless, you will need to use VNC to connect to a GUI."
echo "A VNC password will be displayed during the build phase. or with \"docker exec docker-osx-qemu tail vncpasswd_file\""
echo ""
echo "To start OSX again, enter the new \"docker-osx\" directory and type \"/docker-compose up --detach\""
echo ""
echo "Waiting 10 seconds..."
sleep 10

# -------------------------------- Pull Files -------------------------------- #

if ! [[ -d `pwd`/docker-osx ]]; then
  echo "Creating working folder in current directory called 'docker-osx'"
  mkdir -p `pwd`/docker-osx
fi

cd `pwd`/docker-osx

if ! [[ -f docker-compose.yml ]]; then
  echo "Pulling down docker-compose.yml"
  curl -o docker-compose.yml https://raw.githubusercontent.com/sickcodes/Docker-OSX/master/docker-compose.yml
  sed -i '/SIZE=/ s/200G/16G/' docker-compose.yml
fi

if ! [[ -f Dockerfile ]]; then
  echo "Pulling down Dockerfile"
  curl -o Dockerfile https://raw.githubusercontent.com/sickcodes/Docker-OSX/master/vnc-version/Dockerfile
fi

# ------------------------------------ Run ----------------------------------- #

docker-compose up