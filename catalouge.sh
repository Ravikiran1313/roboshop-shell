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

dnf module disable nodejs -y &>> $LOGFILE
VALIDATE $? "disabling of nodejs version" 

dnf module enable nodejs:18 -y &>> $LOGFILE
VALIDATE $? "enabling of nodejs 18  version"

dnf install nodejs -y &>> $LOGFILE
VALIDATE $? "installing of nodejs 18  version"
id roboshop
if[ $? -ne 0 ]
then   
    useradd roboshop &>> $LOGFILE
    VALIDATE $? "new user roboshop added"
else   
    echo -e "already user exists $Y skipping"
fi       


mkdir -p /app &>> $LOGFILE
VALIDATE $? "making new directory app"

curl -o /tmp/catalogue.zip https://roboshop-builds.s3.amazonaws.com/catalogue.zip &>> $LOGFILE
VALIDATE $? "coyping of catalouge list"

cd /app &>> $LOGFILE
VALIDATE $? "changing to app directory"

unzip -o /tmp/catalogue.zip &>> $LOGFILE
VALIDATE $? "unziping the catalouge file"

npm install &>> $LOGFILE
VALIDATE $? "installing depenency packages"

cp /home/centos/roboshop-shell/catalogue.service /etc/systemd/system/catalogue.service
VALIDATE $? "copying the catalouge service file"

systemctl daemon-reload &>> $LOGFILE
VALIDATE $? "reloading demon"

systemctl enable catalogue &>> $LOGFILE
VALIDATE $? "enabling catalouge server"

systemctl start catalogue &>> $LOGFILE
VALIDATE $? "starting catalogue sever"

cp /home/centos/roboshop-shell/mongo.repo /etc/yum.repos.d/mongo.repo
VALIDATE $? "copying the mongodb repo"

dnf install mongodb-org-shell -y &>> $LOGFILE
VALIDATE $? "installing mongodb org shell"


mongo --host 172.31.24.199 </app/schema/catalogue.js &>> $LOGFILE
VALIDATE $? "connecting ro mongodb"

