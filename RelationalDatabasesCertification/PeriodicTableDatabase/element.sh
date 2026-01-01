#!/bin/bash

# PSQL variable
PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c"

# Check if no argument is passed
if [[ -z $1 ]]; then
    echo "Please provide an element as an argument."
    exit 0
fi

# Check if the input is numeric (atomic_number)
if [[ $1 =~ ^[0-9]+$ ]]; then
    # If it's numeric, search by atomic_number
    RESULT=$($PSQL "SELECT e.atomic_number, e.symbol, e.name, t.type, p.atomic_mass, p.melting_point_celsius, p.boiling_point_celsius
                    FROM elements e
                    JOIN properties p ON e.atomic_number = p.atomic_number
                    JOIN types t ON p.type_id = t.type_id
                    WHERE e.atomic_number = $1;")
else
    # If it's not numeric, search by symbol or name
    RESULT=$($PSQL "SELECT e.atomic_number, e.symbol, e.name, t.type, p.atomic_mass, p.melting_point_celsius, p.boiling_point_celsius
                    FROM elements e
                    JOIN properties p ON e.atomic_number = p.atomic_number
                    JOIN types t ON p.type_id = t.type_id
                    WHERE e.symbol = '$1' OR e.name = '$1';")
fi

# Check if no result was found
if [[ -z $RESULT ]]; then
    echo "I could not find that element in the database."
else
    # Print the element info
    echo "$RESULT" | while IFS="|" read ATOMIC_NUMBER SYMBOL NAME TYPE ATOMIC_MASS MELTING_POINT BOILING_POINT
    do
        echo "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $ATOMIC_MASS amu. $NAME has a melting point of $MELTING_POINT celsius and a boiling point of $BOILING_POINT celsius."
    done
fi
