#!/bin/bash

source rows.sh

is_game_finished=false
upper_row=("_" "_" "_")
middle_row=("_" "_" "_")
lower_row=("_" "_" "_")
current_player="o"
current_game_mode=1
choice_proposal=1

function print_board(){
    clear
    echo "             ________________________________________"
    $1
    $2
    $3
}

function save_game(){
    > saved_state.txt
    echo $current_game_mode >> saved_state.txt
    echo $current_player >> saved_state.txt
    echo ${upper_row[0]} ${upper_row[1]} ${upper_row[2]} >> saved_state.txt
    echo ${middle_row[0]} ${middle_row[1]} ${middle_row[2]} >> saved_state.txt
    echo ${lower_row[0]} ${lower_row[1]} ${lower_row[2]} >> saved_state.txt
}

function load_game(){
    local file_content=$(< saved_state.txt)
    local serialized_matrix=($file_content)
    current_game_mode=${serialized_matrix[0]}
    current_player=${serialized_matrix[1]}
    upper_row[0]=${serialized_matrix[2]}
    upper_row[1]=${serialized_matrix[3]}
    upper_row[2]=${serialized_matrix[4]}
    
    middle_row[0]=${serialized_matrix[5]}
    middle_row[1]=${serialized_matrix[6]}
    middle_row[2]=${serialized_matrix[7]}
    
    lower_row[0]=${serialized_matrix[8]}
    lower_row[1]=${serialized_matrix[9]}
    lower_row[2]=${serialized_matrix[10]}
}

#1 arg: cell
#2 arg: player signature
function check_diagonals_for_win(){
    local is_odd=$(($1%2))
    if [ $is_odd -eq 1 ]
    then
        if [ ${upper_row[0]} = $2 ]
        then
            if [ ${middle_row[1]} = $2 ]
            then
                if [ ${lower_row[2]} = $2 ]
                then
                    is_game_finished=true
                fi
            fi
        fi
        
        if [ ${upper_row[2]} = $2 ]
        then
            if [ ${middle_row[1]} = $2 ]
            then
                if [ ${lower_row[0]} = $2 ]
                then
                    is_game_finished=true
                fi
            fi
        fi
    fi
}

#1 arg: cell
#2 arg: player signature
function check_column_for_win(){
    local column=$((($1-1)%3+1))
    if [ ${upper_row[$colum]} = $2 ]
    then
        if [ ${middle_row[$colum]} = $2 ]
        then
            if [ ${lower_row[$colum]} = $2 ]
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
            win_counter=$(($win_counter+1))
        fi
    done
    if [ $win_counter -eq 3 ]
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
    if [ $is_game_finished = true ]
    
    then
        return
    fi
    
    #Check column
    check_column_for_win $1 $2
    if [ $is_game_finished = true ]
    then
        return
    fi
    
    #Check diagonals
    check_diagonals_for_win $1 $2
}

cat<< "WelcomeMessage"
Welcome! Good luck playing tic-tac-toe :-)
These are the enumerators for the fields:
WelcomeMessage
print_board 123 456 789
echo "



Press anything to start! Enjoy :-)"
read

echo "Choose mode:
Player vs Player =====> press (1)
Player vs Computer ======> press (2)"
while read mode
do
    case $mode in
        1)
            current_game_mode=$mode
            break
        ;;
        2)
            current_game_mode=$mode
            break
        ;;
        *)
            continue
        ;;
    esac
done

while read choice
do
    #Verify command
    case $choice in
        [1-3])
            if [ ${upper_row[$choice-1]} == "_" ]
            then
                upper_row[$choice-1]=$current_player
            else
                continue
            fi
        ;;
        [4-6])
            if [ ${middle_row[$choice-4]} == "_" ]
            then
                middle_row[$choice-4]=$current_player
            else
                continue
            fi
        ;;
        [7-9])
            if [ ${lower_row[$choice-7]} == "_" ]
            then
                lower_row[$choice-7]=$current_player
            else
                continue
            fi
        ;;
        q)
            break
        ;;
        save)
            save_game
            continue
        ;;
        load)
            load_game
            print_board ${upper_row[0]}${upper_row[1]}${upper_row[2]} ${middle_row[0]}${middle_row[1]}${middle_row[2]} ${lower_row[0]}${lower_row[1]}${lower_row[2]}
            continue
        ;;
        *)
            continue
        ;;
    esac
    
    check_for_win $choice $current_player
    
    if [ $current_player = "o" ]
    then
        current_player="x"
    else
        current_player="o"
    fi
    
    #Player vs Computer logic
    if [ $is_game_finished = false ]
    then
        
        if [ $current_game_mode = 2 ]
        then
            
            choice_proposal=$((1 + $RANDOM %9))
            while true
            do
                case $choice_proposal in
                    [1-3])
                        if [ ${upper_row[$choice_proposal-1]} = "_" ]
                        then
                            upper_row[$choice_proposal-1]=$current_player
                            break
                        else
                            choice_proposal=$((1 + $RANDOM %10))
                            continue
                        fi
                    ;;
                    [4-6])
                        if [ ${middle_row[$choice_proposal-4]} = "_" ]
                        then
                            middle_row[$choice_proposal-4]=$current_player
                            break
                        else
                            choice_proposal=$((1 + $RANDOM %10))
                            continue
                        fi
                    ;;
                    [7-9])
                        if [ ${lower_row[$choice_proposal-7]} = "_" ]
                        then
                            lower_row[$choice_proposal-7]=$current_player
                            break
                        else
                            choice_proposal=$((1 + $RANDOM %10))
                            continue
                        fi
                    ;;
                    *)
                        continue
                    ;;
                esac
            done
            check_for_win $choice_proposal $current_player
            if [ $current_player = "o" ]
            then
                current_player="x"
            else
                current_player="o"
            fi
        fi
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

