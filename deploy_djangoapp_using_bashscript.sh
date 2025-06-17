#!/bin/bash

<<comment
This is minimal version of shell script which is used to deploy django app which is clone from the link: https://github.com/LondheShubham153/django-notes-app.git 
comment

cloning(){
  echo "cloning........"
   if [ -d "django-notes-app" ]; then
        echo "The code directory already exists. Skipping clone."
    else
        git clone https://github.com/LondheShubham153/django-notes-app.git || {
            echo "Failed to clone the code."
            return 1
        }
    fi
}
installment(){
sudo apt update
suod apt  install nginx
sudo apt install -y python3.9
sudo apt install -y nodejs
}
restarting(){
   echo "Installing dependencies..."
    sudo apt-get update && sudo apt-get install -y docker.io nginx docker-compose || {
        echo "Failed to install dependencies."
        return 1
    }
}
build(){
echo "Building and deploying the Django app..."
    docker build -t notes-app . && docker-compose up -d || {
        echo "Failed to build and deploy the app."
        return 1
    }
}

echo "************** DEPLOYMENT STARTED *************"

#calling cloning function
if ! cloning;then
  echo "error occur while cloning"
  exit 1
fi

#calling installment function
if ! installment;then
  echo "installment not done "
  exit 1
fi

#calling restarting function
if ! restarting;then
  echo "error occur"
  exit 1
fi

#calling build function
if ! build;then
  echo "building problem"
  exit 1
fi
echo "************** DEPLOYMENT ENDED *************"
