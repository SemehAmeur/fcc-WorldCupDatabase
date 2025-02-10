#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.
echo "$($PSQL "TRUNCATE games, teams;")"

cat games.csv | while IFS="," read -r YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS
do
  if [[ $YEAR != "year" ]]
  then
    WINNER_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER';")
    OPPONENT_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT';")
    if [[ -z $WINNER_ID ]]
    then
      if [[ $($PSQL "INSERT INTO teams(name) VALUES('$WINNER');") == "INSERT 0 1" ]]
      then
        WINNER_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER';")
        echo -e "\ninstered team:$WINNER_ID"
      fi
    fi

    if [[ -z $OPPONENT_ID ]]
    then
      if [[ $($PSQL "INSERT INTO teams(name) VALUES('$OPPONENT');") == "INSERT 0 1" ]]
      then
        OPPONENT_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT';")
        echo -e "\ninstered team:$OPPONENT_ID"
      fi
    fi
    if [[ $($PSQL "INSERT INTO games(year, round, winner_id, opponent_id, winner_goals, opponent_goals) VALUES($YEAR, '$ROUND', $WINNER_ID, $OPPONENT_ID, $WINNER_GOALS, $OPPONENT_GOALS);") == "INSERT 0 1" ]]
    then
      echo -e "\ngame inserted successfuly"
    fi
  fi


done
