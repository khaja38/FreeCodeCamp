#!/bin/bash
# Number Guessing Game
# This script allows users to guess a randomly generated number between 1 and 1000.
# User data and game statistics are stored in a PostgreSQL database.

# PostgreSQL command shortcut
PSQL="psql --username=freecodecamp --dbname=number_guess -t --no-align -c"

# Generate random number between 1 and 1000
SECRET_NUMBER=$(( RANDOM % 1000 + 1 ))

# Counter for number of guesses
NUMBER_OF_GUESSES=0

# Prompt user for username (must not be empty)
echo "Enter your username:"
read USERNAME

while [[ -z $USERNAME ]]
do
  echo "Enter your username:"
  read USERNAME
done

# Check if user already exists
USER_ID=$($PSQL "SELECT user_id FROM users WHERE username='$USERNAME';")

# If user does not exist, create new user
if [[ -z $USER_ID ]]
then
  echo "Welcome, $USERNAME! It looks like this is your first time here."
  $PSQL "INSERT INTO users(username) VALUES('$USERNAME');"
  USER_ID=$($PSQL "SELECT user_id FROM users WHERE username='$USERNAME';")
else

  # Retrieve user statistics for returning user
  GAMES_PLAYED=$($PSQL "SELECT COUNT(*) FROM games WHERE user_id=$USER_ID;")
  BEST_GAME=$($PSQL "SELECT MIN(guesses) FROM games WHERE user_id=$USER_ID;")
  echo "Welcome back, $USERNAME! You have played $GAMES_PLAYED games, and your best game took $BEST_GAME guesses."
fi

# Prompt user to start guessing
echo "Guess the secret number between 1 and 1000:"
read GUESS

# Main guessing loop
while true
do

  # Validate that input is an integer
  if [[ ! $GUESS =~ ^[0-9]+$ ]]
  then
    echo "That is not an integer, guess again:"
  else

    # Increment guess counter
    NUMBER_OF_GUESSES=$(( NUMBER_OF_GUESSES + 1 ))

    # Check guess against secret number
    if [[ $GUESS -eq $SECRET_NUMBER ]]
    then

      # Correct guess: store game result and exit
      echo "You guessed it in $NUMBER_OF_GUESSES tries. The secret number was $SECRET_NUMBER. Nice job!"
      $PSQL "INSERT INTO games(user_id, guesses) VALUES($USER_ID, $NUMBER_OF_GUESSES);"
      break
    elif [[ $GUESS -gt $SECRET_NUMBER ]]
    then

      # Guess is too high
      echo "It's lower than that, guess again:"
    else
    
      # Guess is too low
      echo "It's higher than that, guess again:"
    fi
  fi

  # Read next guess
  read GUESS
done
