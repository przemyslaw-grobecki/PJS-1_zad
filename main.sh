#!/bin/bash

source rows.sh

is_game_finished=false
upper_row=("_" "_" "_")
middle_row=("_" "_" "_")
lower_row=("_" "_" "_")

function print_board(){
    clear
    echo "             ________________________________________"
    $1
    $2
    $3
}

function check_for_win(){
    


}

cat<< "WelcomeMessage"
Welcome! Good luck playing tic-tac-toe :-)
These are the enumerators for the fields:
WelcomeMessage
print_board 123 456 789
echo "



Press anything to start! Enjoy :-)"
read

current_player="o"

while read line
do 
#Verify command
case $line in
 [1-3])
    upper_row[$line-1]=$current_player
    ;;
 [4-6])
    middle_row[$line-4]=$current_player
    ;;
 [7-9])
    lower_row[$line-7]=$current_player
    ;;
 q*) 
    break
    ;;
esac

if [ $current_player = "o" ]
then
current_player="x"
else
current_player="o"
fi

print_board ${upper_row[0]}${upper_row[1]}${upper_row[2]} ${middle_row[0]}${middle_row[1]}${middle_row[2]} ${lower_row[0]}${lower_row[1]}${lower_row[2]}



done

