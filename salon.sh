#! /bin/bash

PSQL="psql --username=freecodecamp --dbname=salon --tuples-only -c"

echo -e "\n ~~ Welcome to freeCodeCamp salon ~~\n"

PRINT_SERVICES() {
  echo -e "\nHere is a list of our services:"
  echo "$($PSQL "SELECT * FROM services")" | while read SERVICE_ID BAR SERVICE_NAME
  do
    echo "$SERVICE_ID) $SERVICE_NAME"
  done
  echo -e "\nPlease enter the number of the service you need"
}

PRINT_SERVICES

read SERVICE_ID_SELECTED

while [[ -z $SELECTED_SERVICE_NAME ]]
do
  if [[ $SERVICE_ID_SELECTED =~ ^[0-9]+$ ]]
  then
    SELECTED_SERVICE_NAME=$($PSQL "SELECT name FROM services WHERE service_id=$SERVICE_ID_SELECTED;")
    if [[ -z $SELECTED_SERVICE_NAME ]]
    then
      echo "The number you entered doesn't correspond to a service, please try again!"
      PRINT_SERVICES
      read SERVICE_ID_SELECTED
    fi
  else
    echo "You didn't enter a number, please try again"
    PRINT_SERVICES
    read SERVICE_ID_SELECTED
  fi  
done

echo -e "\nPlease enter your phone number:"
read CUSTOMER_PHONE

CUSTOMER_ID=$($PSQL "SELECT customer_id FROM customers WHERE phone='$CUSTOMER_PHONE'")
CUSTOMER_NAME=$($PSQL "SELECT name FROM customers WHERE phone='$CUSTOMER_PHONE'")

if [[ -z $CUSTOMER_NAME ]]
then
  echo -e "\nHey I see it's your first time in our salon, welcome! Please enter your name so we can remember you next time:"
  read CUSTOMER_NAME
  INSERT_CUSTOMER_RESULT=$($PSQL "INSERT INTO customers(phone, name) VALUES('$CUSTOMER_PHONE', '$CUSTOMER_NAME');")
  CUSTOMER_ID=$($PSQL "SELECT customer_id FROM customers WHERE phone='$CUSTOMER_PHONE'")
fi

echo -e "\nAt what time do you want your appointment to be ?"
read SERVICE_TIME

INSERT_APPOINTMENT_RESULT=$($PSQL "INSERT INTO appointments(customer_id, service_id, time) VALUES($CUSTOMER_ID, $SERVICE_ID_SELECTED, '$SERVICE_TIME');")

echo -e "\nI have put you down for a $SELECTED_SERVICE_NAME at $SERVICE_TIME, $CUSTOMER_NAME."
