#!/bin/bash
R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m
FILE=/etc/passwd

if [ ! -f $FILE]
do
    echo -e "$R file $FILE not found"
fi

while [IFS ":" -r user_name user_passwd user_id]
do
echo -e "$user_name $user_passwd $user_id"
done << $FILE    