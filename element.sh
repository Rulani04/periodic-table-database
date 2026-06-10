#! /bin/bash

PSQL="psql --username=freecodecamp --dbname=periodic_table --no-align --tuples-only -c"

# Check if argument provided
if [[ -z $1 ]]
then
  echo "Please provide an element as an argument."
  exit 0
fi

# Query element info
ELEMENT_INFO=$($PSQL "SELECT atomic_number, symbol, name, atomic_mass, melting_point_celsius, boiling_point_celsius, type FROM elements INNER JOIN properties USING(atomic_number) INNER JOIN types USING(type_id) WHERE atomic_number::text = '$1' OR symbol = '$1' OR name = '$1'")

# If not found
if [[ -z $ELEMENT_INFO ]]
then
  echo "I could not find that element in the database."
  exit 0
fi

# Parse and output
echo "$ELEMENT_INFO" | while IFS="|" read NUMBER SYMBOL NAME MASS MELT BOIL TYPE
do
  echo "The element with atomic number $NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $MASS amu. $NAME has a melting point of $MELT°c and a boiling point of $BOIL°c."
done
