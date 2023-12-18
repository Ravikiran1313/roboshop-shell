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

dnf module disable mysql -y &>> $LOGFILE
VALIDATE $? "disabling of mysql old version" 

cp /home/centos/roboshop-shell/mysql.repo /etc/yum.repos.d/mysql.repo &>> $LOGFILE
VALIDATE $? "copying mysql repo" 

dnf install mysql-community-server -y &>> $LOGFILE
VALIDATE $? "installing mysql community" 

systemctl enable mysqld &>> $LOGFILE
VALIDATE $? "enabling mysql" 

systemctl start mysqld &>> $LOGFILE
VALIDATE $? "starting mysql" 

mysql_secure_installation --set-root-pass RoboShop@1 &>> $LOGFILE
VALIDATE $? "changing password" 

mysql -uroot -pRoboShop@1 &>> $LOGFILE
VALIDATE $? "changing to root user" 