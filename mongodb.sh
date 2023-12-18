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

cp mongo.repo /etc/yum.repos.d/ &>> $LOGFILE
VALIDATE $? "copy of mangodb repo"

dnf install mongodb-org -y &>> $LOGFILE
VALIDATE $? "installation of mangodb"

systemctl enable mongod &>> $LOGFILE
VALIDATE $? "enabling of mangodb"

systemctl start mongod &>> $LOGFILE
VALIDATE $? "starting of mangodb"

sei -i 's/127.0.0.1/0.0.0.0/g' /etc/mongod.conf &>> $LOGFILE
VALIDATE $? "replacing ip address"

systemctl restart mongod &>> $LOGFILE
VALIDATE $? "restarting of mangodb"