#!/bin/bash

# PSQL command shortcut
PSQL="psql -X --username=freecodecamp --dbname=salon --tuples-only -c"

# welcome banner
echo -e "\n~~~~~ MY SALON ~~~~~\n"

# greeting  
echo "Welcome to My Salon, how can I help you?"

MAIN_MENU() {

  # show error message if passed
  if [[ $1 ]]
  then
    echo -e "\n$1"
  fi

  # get list of services
  SERVICES=$($PSQL "SELECT service_id, name FROM services ORDER BY service_id")

  # display services
  echo "$SERVICES" | while read SERVICE_ID BAR SERVICE_NAME
  do
    echo "$SERVICE_ID) $SERVICE_NAME"
  done

  # read service selection
  read SERVICE_ID_SELECTED

  # check if service exists
  SERVICE_NAME=$($PSQL "SELECT name FROM services WHERE service_id = $SERVICE_ID_SELECTED")

  # if service not found
  if [[ -z $SERVICE_NAME ]]
  then
    MAIN_MENU "I could not find that service. What would you like today?"
  else
    BOOK_APPOINTMENT
  fi
}

BOOK_APPOINTMENT() {

  # ask for phone number
  echo "What's your phone number?"
  read CUSTOMER_PHONE

  # check for existing customer
  CUSTOMER_NAME=$($PSQL "SELECT name FROM customers WHERE phone = '$CUSTOMER_PHONE'")

  # if customer does not exist
  if [[ -z $CUSTOMER_NAME ]]
  then
      echo "I don't have a record for that phone number, what's your name?"
    read CUSTOMER_NAME

    # insert new customer (capture output)
    INSERT_CUSTOMER_RESULT=$(
      $PSQL "INSERT INTO customers(phone, name) VALUES('$CUSTOMER_PHONE', '$CUSTOMER_NAME')"
    )
  fi

  # get customer_id
  CUSTOMER_ID=$($PSQL "SELECT customer_id FROM customers WHERE phone = '$CUSTOMER_PHONE'")

  # trim formatting
  SERVICE_NAME_FORMATTED=$(echo $SERVICE_NAME | sed 's/^ *| *$//g')
  CUSTOMER_NAME_FORMATTED=$(echo $CUSTOMER_NAME | sed 's/^ *| *$//g')

  # ask for appointment time
  echo "What time would you like your $SERVICE_NAME_FORMATTED, $CUSTOMER_NAME_FORMATTED?"
  read SERVICE_TIME

  # insert appointment (capture output)
  INSERT_APPOINTMENT_RESULT=$($PSQL "INSERT INTO appointments(customer_id, service_id, time) VALUES($CUSTOMER_ID, $SERVICE_ID_SELECTED, '$SERVICE_TIME')")

  # confirmation message
  echo "I have put you down for a $SERVICE_NAME_FORMATTED at $SERVICE_TIME, $CUSTOMER_NAME_FORMATTED."
}

# start program
MAIN_MENU
