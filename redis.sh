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

dnf install https://rpms.remirepo.net/enterprise/remi-release-8.rpm -y &>> $LOGFILE
VALIDATE $? "installing redis db from web"

dnf module enable redis:remi-6.2 -y &>> $LOGFILE
VALIDATE $? "enabling the redis db"

dnf install redis -y &>> $LOGFILE
VALIDATE $? "installing the redis db"

sed -i 's/127.0.0.1/0.0.0.0/g' /etc/redis.conf &>> $LOGFILE
VALIDATE $? "changes the redis db access from anywhere web"

sed -i 's/127.0.0.1/0.0.0.0/g' /etc/redis/redis.conf &>> $LOGFILE
VALIDATE $? "changes the redis db access from anywhere web"

systemctl enable redis &>> $LOGFILE
VALIDATE $? "enabling the redis db from system"

systemctl start redis &>> $LOGFILE
VALIDATE $? "starting the redid db"