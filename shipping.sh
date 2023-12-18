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

dnf install maven -y

id roboshop &>> $LOGFILE

if [ $? -ne 0 ]
then   
    useradd roboshop &>> $LOGFILE
    VALIDATE $? "new user roboshop added"
else   
    echo -e "already user exists $Y skipping"
fi     

mkdir -p /app
VALIDATE $? "making new directory app"

curl -L -o /tmp/shipping.zip https://roboshop-builds.s3.amazonaws.com/shipping.zip
VALIDATE $? "getting shipping contents from web"

cd /app
VALIDATE $? "changing directory app"

unzip -o /tmp/shipping.zip
VALIDATE $? "unzipping the shipping file"

mvn clean package
VALIDATE $? "clean package"

mv target/shipping-1.0.jar shipping.jar
VALIDATE $? "renaming jar file"

cp /home/centos/roboshop-shell/shipping.service /etc/systemd/system/shipping.service
VALIDATE $? "copying the shipping service"

systemctl daemon-reload
VALIDATE $? "reloading the demon"

systemctl enable shipping 
VALIDATE $? "enabling shipping service"

systemctl start shipping
VALIDATE $? "starting shipping service"

dnf install mysql -y
VALIDATE $? "installing my sql"

mysql -h 172.31.95.147 -uroot -pRoboShop@1 < /app/schema/shipping.sql 
VALIDATE $? "loading my sql schema"

systemctl restart shipping
VALIDATE $? "restarting the shipping"