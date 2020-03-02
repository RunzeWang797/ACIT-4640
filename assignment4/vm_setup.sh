#!/bin/bash
USER_NAME="todoapp"
#use to install the service that we neeed
install_services(){
    sudo yum upgrade -y
    sudo yum install git -y
    sudo yum install npm -y
    sudo yum install mongodb-server -y
    sudo yum install mongodb -y
    sudo systemctl enable mongod && sudo systemctl start mongod
    sudo yum install nginx -y
    
    echo "############################################ finished install############################################ "
}

#use to create the todo user and set the password and change the permission
create_user(){
    sudo useradd "$USER_NAME"
    echo todoapp:P@ssw0rd | sudo chpasswd
	sudo chown -R todoapp /home/todoapp
    sudo chmod 755 -R /home/todoapp
    echo "############################################ User created and permission changed ############################################ "
}

#use to download from Tim's github
get_app(){
    sudo mkdir /home/todoapp/app
    sudo git clone https://github.com/timoguic/ACIT4640-todo-app.git /home/todoapp/app/ACIT4640-todo-app
	echo "############################################ APP Cloned############################################ "
}

#use to move the files to correct places
move_configs(){
#    scp -r ./database.js todoapp:~
#    scp -r ./todoapp.service todoapp:~
#    scp -r ./nginx.conf todoapp:~
	sudo rm /home/todoapp/app/ACIT4640-todo-app/config/database.js
    sudo rm /etc/nginx/nginx.conf
    sudo cp /home/admin/setup/database.js /home/todoapp/app/ACIT4640-todo-app/config/
    sudo cp /home/admin/setup/nginx.conf /etc/nginx/
    sudo cp /home/admin/setup/todoapp.service /etc/systemd/system
    sudo mongorestore -d acit4640 /home/admin/ACIT4640-mongodb
  
    
	echo "############################################ move configs done############################################ "
}

#use to restart service
service_start(){
    sudo systemctl daemon-reload
    sudo systemctl enable nginx
    sudo systemctl start nginx
    sudo systemctl enable todoapp
    sudo systemctl start todoapp
echo "############################################ service started############################################ "
}

#npm install
connect(){
    cd /home/todoapp/app/ACIT4640-todo-app
    cd /home/todoapp/app/ACIT4640-todo-app && sudo npm install
#	ssh todoapp "cd /home/todoapp/app/ACIT4640-todo-app && sudo node server.js"

    echo "############################################finished############################################"
}
install_services

create_user

get_app

move_configs

connect

service_start

