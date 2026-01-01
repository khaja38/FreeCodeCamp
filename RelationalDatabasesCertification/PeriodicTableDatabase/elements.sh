#!/bin/bash

# PSQL variable
PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c"

# Function to check if element exists and print information
print_element_info() {
    local result="$1"
    
    if [[ -z $result ]]; then
        echo "I could not find that element in the database."
    else
        # Format and print the element info
        echo "$result" | while IFS="|" read ATOMIC_NUMBER SYMBOL NAME TYPE ATOMIC_MASS MELTING_POINT BOILING_POINT
        do
            echo "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $ATOMIC_MASS amu. $NAME has a melting point of $MELTING_POINT celsius and a boiling point of $BOILING_POINT celsius."
        done
    fi
}

# Function to search element by atomic number
get_element_by_atomic_number() {
    local atomic_number="$1"
    $PSQL "SELECT e.atomic_number, e.symbol, e.name, t.type, p.atomic_mass, p.melting_point_celsius, p.boiling_point_celsius
           FROM elements e
           JOIN properties p ON e.atomic_number = p.atomic_number
           JOIN types t ON p.type_id = t.type_id
           WHERE e.atomic_number = $atomic_number;"
}

# Function to search element by symbol
get_element_by_symbol() {
    local symbol="$1"
    $PSQL "SELECT e.atomic_number, e.symbol, e.name, t.type, p.atomic_mass, p.melting_point_celsius, p.boiling_point_celsius
           FROM elements e
           JOIN properties p ON e.atomic_number = p.atomic_number
           JOIN types t ON p.type_id = t.type_id
           WHERE e.symbol = '$symbol';"
}

# Function to search element by name
get_element_by_name() {
    local name="$1"
    $PSQL "SELECT e.atomic_number, e.symbol, e.name, t.type, p.atomic_mass, p.melting_point_celsius, p.boiling_point_celsius
           FROM elements e
           JOIN properties p ON e.atomic_number = p.atomic_number
           JOIN types t ON p.type_id = t.type_id
           WHERE e.name = '$name';"
}

# Function to check if the input is numeric (for atomic_number)
is_numeric() {
    [[ $1 =~ ^[0-9]+$ ]]
}

# Main script logic
main() {
    # Check if no argument is passed
    if [[ -z $1 ]]; then
        echo "Please provide an element as an argument."
        exit 0
    fi

    # Check if the input is numeric (atomic_number)
    if is_numeric "$1"; then
        # If it's numeric, search by atomic_number
        RESULT=$(get_element_by_atomic_number "$1")
    else
        # If it's a string, check length to determine whether to search by symbol or name
        if [ ${#1} -lt 3 ]; then
            # Search by symbol if length is less than 3
            RESULT=$(get_element_by_symbol "$1")
        else
            # Search by name if length is greater than or equal to 3
            RESULT=$(get_element_by_name "$1")
        fi
    fi

    # Print the element info or error message
    print_element_info "$RESULT"
}

# Call main function to execute the script
main "$1"
