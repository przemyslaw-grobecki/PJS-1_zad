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

#1 arg: cell
#2 arg: player signature
function check_column_for_win(){
   local is_odd=$(($1%2))
   if [$1 -eq 1]
   then
   #!!!!!!!!!!!
   #TODO: LEFT IT HERE
   #!!!!!!!!!!!
   fi
}

#1 arg: cell
#2 arg: player signature
function check_diagonals_for_win(){
   local column=$((($1-1)%3+1))
   if [ ${upper_row[$colum]}=$2 ]
   then
      if [ ${middle_row[$colum]}=$2 ]
      then
         if [ ${lower_row[$colum]}=$2 ]
         then
            is_game_finished=true
         fi
      fi
   fi
}

#1 arg: row
#2 arg: player signature
function check_row_for_win(){
   local win_counter=0
   for cell in $1
      do
         if [ $cell != $2 ]
         then
            break
         else
            counter=$(($counter+1))
         fi
      done
      if [$win_counter -eq 3]
      then
         is_game_finished=true
         return
      fi
}

#1 arg: last move
#2 arg: player signature
function check_for_win(){
   #Check row
   case $1 in
      [1-3])
         check_row_for_win $upper_row $2
      ;;
      [4-6])
         check_row_for_win $middle_row $2
      ;;
      [7-9])
         check_row_for_win $lower_row $2
      ;;
      *)
      return
      ;;
   esac
   if [ $is_game_finished=true ]
   then 
      return
   fi

   #Check column
   check_column_for_win $1 $2
   if [ $is_game_finished=true ]
   then 
      return
   fi

   #Check diagonals

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
    if [${upper_row[0]}=$current_player]
    then
      if [${upper_row[1]}=$current_player]
      then
         if [${upper_row[2]}=$current_player]
         then
            is_game_finished=true
         fi
      fi
    fi
    ;;
 [4-6])
    middle_row[$line-4]=$current_player
    ;;
 [7-9])
    lower_row[$line-7]=$current_player
    ;;
 q) 
    break
    ;;
 *)
   continue
   ;;
esac

if [ $current_player = "o" ]
then
current_player="x"
else
current_player="o"
fi

print_board ${upper_row[0]}${upper_row[1]}${upper_row[2]} ${middle_row[0]}${middle_row[1]}${middle_row[2]} ${lower_row[0]}${lower_row[1]}${lower_row[2]}



if [ $is_game_finished = true ]
then
   echo "
   
   Congratulations! Player:
   "
   echo $current_player
   echo "
   Lost the game!
   "
   break
fi
done

