#! /bin/bash

#Variables
separator='_'
IFS=$'\n'

#Chars ▓ ▒ ░ │ ┤ ╣ ║ ╝ ╗ └ ┴ ┬ ├ ─ ┼ ╚ ╔ ╩ ╦ ╠ ═ ╬ █ ▄ ¦ ▀ ■
lines_header_h_char="═"
lines_h_char="─"

lines_v_char="│"
lines_header_v_char="║"

corner_header_char="╬"
corner_char="┼"
#Colors
NC='\033[0m'
Black='\033[0;30m'     
Red='\033[0;31m' 
Green='\033[0;32m'     
Orange='\033[0;33m'     
Blue='\033[0;34m'     
Purple='\033[0;35m'     
Cyan='\033[0;36m'     
Light_Gray='\033[0;37m'     
Dark_Gray='\033[1;30m'
Light_Red='\033[1;31m'
Light_Green='\033[1;32m'
Yellow='\033[1;33m'
Light_Blue='\033[1;34m'
Light_Purple='\033[1;35m'
Light_Cyan='\033[1;36m'
White='\033[1;37m'

#Colors of table
header_color=$Green

table_left_offset=2

declare -a offset=(1 1)



#Functions

function repeat_char(){
    # Example repeat_char "char" "num_times"
    chars=""
    for ((i=1; i<=$2; i++))
    do
        echo -n "$1"
    done
}

function printLine(){
        #Print Line ex: printLine "numofCols" "line_h_char" "corner_char"     
        for ((j=1;j<=$1; j++))
        do
            lenmax=${maxLenCols[$j]}
            end_line=$(($lenmax+${offset[0]}+${offset[1]}))

            echo -n "$3"
            echo -n $(repeat_char $2 $end_line)
        done

        echo -n "$3"
        echo -n $'\n'
}

function printTable(){
    rows=${#};
    cols=0;
    fst_line=1

    #Get number of columns of the first line
    readarray -t fcolumn <<< "$(tr $separator '\n' <<< "$1")"
    cols=${#fcolumn[*]}
    #Save data ina matrix
    declare -A dataMatrix;
    declare -A maxLenCols;
    #First go over rows
    rownum=1
    for row in ${*};
    do
        #Split the row in cols
        readarray -t column <<< "$(tr $separator $'\n' <<< "$row")"
        colnum=1
        #Go over the columns
        for ((i=0; i<=cols; i++));
        do
            #Compare if the num of column is equal or minor than the expected
            #to get the max lenght of the strings of columns
            if [[ $colnum -le $cols ]];
            then
                #save data in matrix
                dataMatrix[$rownum,$colnum]=${column[$i]}                
                if [[ ${#column[$i]} -gt ${maxLenCols[$colnum]} ]]
                then
                    maxLenCols[$colnum]=${#column[$i]}
                fi
                let colnum++
            fi
        done
        let rownum++
    done

    ####################Print table####################
    
    #For each row
    for ((i=1; i<=$rows; i++))
    do
        

        #Print first line of title
        if [[ $i -eq 1 ]];
        then
            echo -n $(repeat_char $'\t' $table_left_offset)
            echo $(printLine $cols $lines_header_h_char $corner_header_char) 
        fi
        
        echo -n $(repeat_char $'\t' $table_left_offset)
        #For each column in row print data
        for ((j=1;j<=$cols; j++))
        do
            lenmax=${maxLenCols[$j]}
            lencol=${#dataMatrix[$i,$j]}
            end_line=$(($lenmax-$lencol+${offset[1]}))

            if [[ $i -eq 1 ]];
            then
                echo -n "$lines_header_v_char"
                echo -n $(repeat_char ' ' ${offset[0]})
                echo -ne ${header_color}
                echo -n ${dataMatrix[$i,$j]}
                echo -ne ${NC}
                echo -n $(repeat_char ' ' $end_line)
            else
                echo -n "$lines_v_char"
                echo -n $(repeat_char ' ' ${offset[0]})
                echo -n ${dataMatrix[$i,$j]}
                echo -n $(repeat_char ' ' $end_line)
            fi            
        done

        if [[ $i -eq 1 ]];
        then            
            echo -n "$lines_header_v_char"
        else            
            echo -n "$lines_v_char"
        fi    
        echo -n $'\n'

        #Print second line of title
        if [[ $i -eq 1 ]];
        then
            echo -n $(repeat_char $'\t' $table_left_offset)
            echo $(printLine $cols $lines_header_h_char $corner_header_char)
        fi

        #Print footer
        if [[ $i -eq $rows ]]
        then
            echo -n $(repeat_char $'\t' $table_left_offset)
            echo $(printLine $cols $lines_h_char $corner_char)
        fi

    done 

    echo -n $'\n'
    echo "Numero de filas: ${#}"
    echo "Numero de columnas: $cols"
}

printTable $@;
