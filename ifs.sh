#!/bin/bash

R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"

FILE=/etc/passwd

if [ ! -f $FILE ]
then
    echo -e "$R file $FILE not found"
fi

while IFS=":" read -r user_name user_passwd user_id
do
    echo "$user_name"
    echo "$user_passwd"
    echo "$$user_id"
done < $FILE    