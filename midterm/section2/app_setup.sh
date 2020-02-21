#!/bin/bash
USER_NAME="hichat"
#use to install the service that we neeed
install_services(){
    ssh A01023366 'sudo yum upgrade -y'
    ssh A01023366 'sudo yum install git -y'
    ssh A01023366 'sudo yum install nodejs -y'
    ssh A01023366 'sudo yum install mongodb-server -y'
    ssh A01023366 'sudo systemctl enable mongod && sudo systemctl start mongod'
    ssh A01023366 'sudo yum install nginx -y'
    
    echo "############################################ finished install############################################ "
}

#use to create the todo user and set the password and change the permission
create_user(){
    ssh A01023366 "sudo useradd "$USER_NAME""
    ssh A01023366 'echo $USER_NAME:disabled | sudo chpasswd'
    echo "############################################ User created ############################################ "
}

#use to download from Tim's github
get_app(){
    ssh A01023366 'mkdir /app'
    ssh A01023366 'sudo git clone https://github.com/wayou/Hichat.git /app'
	echo "############################################ APP Cloned############################################ "
}

#use to move the files to correct places
move_configs(){
    scp -r ./database.js $USER_NAME:~
    scp -r ./A01023366.service $USER_NAME:~
    scp -r ./nginx.conf $USER_NAME:~
    ssh A01023366 "sudo rm /etc/nginx/nginx.conf"
    ssh A01023366 "sudo cp ~/nginx.conf /etc/nginx/"
	echo "############################################ move configs done############################################ "
}

#use to restart service
service_start(){
    ssh A01023366 'sudo systemctl daemon-reload'
    ssh A01023366 'sudo systemctl enable nginx'
    ssh A01023366 'sudo systemctl start nginx'
echo "############################################ service started############################################ "
}

#npm install
connect(){
    ssh A01023366 "cd /app && sudo npm install"
    ssh A01023366 "cd /app && sudo iojs server"

    echo "############################################finished############################################"
}
install_services

create_user

get_app

move_configs

connect

service_start

