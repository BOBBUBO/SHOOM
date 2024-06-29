#!/bin/bash

# Define the default map
map=( "---------"
      "|        |"
      "|  S    |"
      "|        |"
      "|  D    |"
      "|        |"
      "---------")

# Define the custom level file extension
level_extension=".sad"

# Define the player's starting position
x=1
y=1

# Define the player's health
health=100

# Define the demon's position
demon_x=4
demon_y=4

# Load a custom level if it exists
if [ -f "level$sad" ]; then
  map=($(cat "level$sad"))
fi

# Main game loop
while true; do
  # Print the current map
  for ((i=0; i<${#map[@]}; i++)); do
    line=${map[$i]}
    for ((j=0; j<${#line}; j++)); do
      char=${line:$j:1}
      if [ $j -eq $x ]; then
        if [ $i -eq $y ]; then
          echo -n "P"
        else
          echo -n "${char}"
        fi
      else
        echo -n "${char}"
      fi
    done
    echo
  done

  # Get the player's input
  read -p "Enter direction (n/s/e/w): " direction

  # Update the player's position based on the input
  case $direction in
    n) ((y--));;
    s) ((y++));;
    e) ((x++));;
    w) ((x--));;
  esac

  # Check if the player has reached the demon's position
  if [ $x -eq $demon_x ] && [ $y -eq $demon_y ]; then
    echo "You see a demon!"
    read -p "What do you do? (a/f): " action
    case $action in
      a) echo "You attack the demon and kill it. You win!"; exit 0;;
      f) echo "You flee from the demon. You lose!"; exit 1;;
    esac

  # Check if the player is out of bounds or has hit a wall
  elif [[ $x -lt 0 || $x -ge ${#map[0]} || $y -lt 0 || $y -ge ${#map[@]} ]]; then
    echo "You hit a wall. You lose!"; exit 1;

  # Check if the player has taken damage from being near the demon
  elif [[ $x-1 = $demon_x && $y-1 = $demon_y ]]; then
    ((health--)); echo "The demon is near you. You take some damage ($health remaining)."

  # Check if the player is killed by the demon
  elif [ $health -le 0 ]; then
    echo "You were killed by the demon. You lose!"; exit 1;

  fi

done

exit 0
