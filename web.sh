#!/bin/bash

ID=$(id -u)
TIMESTAMP=$(date +%F-%H-%M-%S)
LOGFILE="/tmp/$0-$TIMESTAMP.log"

R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"

VALIDATE(){
    if [ $1 -ne 0 ]
    then 
        echo -e "$R error::while $2"
        exit 1
    else 
        echo -e "$G sucessfully $2" 
    fi       
}

if [ $ID -ne 0 ]
then 
    echo -e "$R error:: your are not a root user"
    exit 1
else 
    echo -e "$G your a root user" 
fi 

dnf install nginx -y &>> $LOGFILE
VALIDATE $? "installing nginx"

systemctl enable nginx &>> $LOGFILE
VALIDATE $? "enabling nginx"

systemctl start nginx &>> $LOGFILE
VALIDATE $? "starting nginx"

rm -rf /usr/share/nginx/html/* &>> $LOGFILE
VALIDATE $? "removing front end default content"

curl -o /tmp/web.zip https://roboshop-builds.s3.amazonaws.com/web.zip &>> $LOGFILE
VALIDATE $? "getting front end content from web"

cd /usr/share/nginx/html &>> $LOGFILE
VALIDATE $? "copying new front content to our web page"

unzip -o /tmp/web.zip &>> $LOGFILE
VALIDATE $? "unzipping the web page"

cp /home/centos/roboshop-shell/roboshop.conf /etc/nginx/default.d/roboshop.conf &>> $LOGFILE
VALIDATE $? "copying the roboshop cong file"

systemctl restart nginx &>> $LOGFILE
