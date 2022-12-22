#! /bin/bash

PSQL="psql -X --username=freecodecamp --dbname=salon --tuples-only -c"

MAIN_MENU(){
  echo -e "\n1) cut\n2) wash\n3) comb"
  read SERVICE_ID_SELECTED
  case $SERVICE_ID_SELECTED in
    1) SCHEDUL_APPOINTMENT ;;
    2) SCHEDUL_APPOINTMENT ;;
    3) SCHEDUL_APPOINTMENT ;;
    *) MAIN_MENU
  esac
}

SCHEDUL_APPOINTMENT(){
  echo -e "\nPlease enter your phone number."
  read CUSTOMER_PHONE
  # get customer info
  CUSTOMER_NAME=$($PSQL "SELECT name FROM customers WHERE phone = '$CUSTOMER_PHONE'")
  # if customer does not exist
  if [[ -z $CUSTOMER_NAME ]]; then
    # get customer info
    echo -e "\nWhat's your name?"
    read CUSTOMER_NAME
    INSERT_CUSTOMER_RESULT=$($PSQL "INSERT INTO customers(phone, name) VALUES('$CUSTOMER_PHONE', '$CUSTOMER_NAME')")
  fi
  # ask for service time
  echo -e "\nWhat time would you like the service?"
  read SERVICE_TIME
  # get customer_id
  CUSTOMER_ID=$($PSQL "SELECT customer_id FROM customers WHERE phone='$CUSTOMER_PHONE'")
  INSERT_SERVICE_RESULT=$($PSQL "INSERT INTO appointments(customer_id, service_id, time) VALUES($CUSTOMER_ID, $SERVICE_ID_SELECTED, '$SERVICE_TIME')")
  # Get service name
  SERVICE_INFO=$($PSQL "SELECT name FROM services WHERE service_id=$SERVICE_ID_SELECTED")
  # Confirmation message
  echo -e "I have put you down for a $(echo $SERVICE_INFO | sed -r 's/^ *| *$//g') at $SERVICE_TIME, $(echo $CUSTOMER_NAME | sed -r 's/^ *| *$//g')."
}

MAIN_MENU