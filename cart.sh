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

id roboshop &>> $LOGFILE

if [ $? -ne 0 ]
then   
    useradd roboshop &>> $LOGFILE
    VALIDATE $? "new user roboshop added"
else   
    echo -e "already user exists $Y skipping"
fi       


mkdir -p /app &>> $LOGFILE
VALIDATE $? "making new directory app"

curl -L -o /tmp/cart.zip https://roboshop-builds.s3.amazonaws.com/cart.zip &>> $LOGFILE
VALIDATE $? "coyping of catalouge list"

cd /app &>> $LOGFILE
VALIDATE $? "changing to app directory"

unzip -o /tmp/cart.zip &>> $LOGFILE
VALIDATE $? "unziping the user file"

npm install &>> $LOGFILE
VALIDATE $? "installing depenency packages"

cp /home/centos/roboshop-shell/cart.service /etc/systemd/system/cart.service
VALIDATE $? "copying the cart service file"

systemctl daemon-reload &>> $LOGFILE
VALIDATE $? "reloading demon"

systemctl enable cart &>> $LOGFILE
VALIDATE $? "enabling cart server"

systemctl start cart &>> $LOGFILE
VALIDATE $? "starting cart sever"

