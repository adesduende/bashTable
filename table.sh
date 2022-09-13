#! /bin/bash

#Variables
IFS=$'\n'
separator='_'           #This is the char that use tu separate the columns
table_left_offset=2     #This value is use for spacing table from left of terminal
declare -a offset=(1 1) #There are the space after and before a column word

#Chars ▓ ▒ ░ │ ┤ ╣ ║ ╝ ╗ └ ┴ ┬ ├ ─ ┼ ╚ ╔ ╩ ╦ ╠ ═ ╬ █ ▄ ¦ ▀ ■
lines_header_h_char="═"
lines_h_char="─"

lines_v_char="│"
lines_header_v_char="║"

corner_header_char="╬"
corner_char="┼"
#Colors
NC='\033[0m'
declare -A Colors=(
    NC '\033[0m'
    Black '\033[0;30m'     
    Red '\033[0;31m' 
    Green '\033[0;32m'     
    Orange '\033[0;33m'     
    Blue '\033[0;34m'     
    Purple '\033[0;35m'     
    Cyan '\033[0;36m'     
    Light_Gray '\033[0;37m'     
    Dark_Gray '\033[1;30m'
    Light_Red '\033[1;31m'
    Light_Green '\033[1;32m'
    Yellow '\033[1;33m'
    Light_Blue '\033[1;34m'
    Light_Purple '\033[1;35m'
    Light_Cyan '\033[1;36m'
    White '\033[1;37m'
)
#Colors of table
header_color=$NC
header_line_color=$NC
data_color=$NC
data_line_color=$NC


#Option Functions
function Help(){
    #Display Help menu
    echo
    echo "Descripcion de la herramienta "
    echo
    echo $"Syntax: table [-h][-v][-d \"col_delimiter\"][-l \"ch1 ch2 ch3\"][-t \"ch1 ch2 ch3\"] [-c Yellow Black NC NC] \"DataString\""
    echo
    echo $'\tOptions:'
    echo $'\th\t\t\t\t\tPrint this help'
    echo $'\td <delimiter_char>\t\t\tSelect char for column delimiter [-d \"_\"]'
    echo $'\tl <horizontal vertical corner>\t\tSelect normal lines [-l \"─ │ ┼\"]'
    echo $'\tt <horizontal vertical corner>\t\tSelect header lines [-t \"═ ║ ╬\"]'
    echo $'\tc <title title_lines data data_lines>\tSelect the color of the header, data an the lines of both'
    echo $'\t\t1:\t\t\t\tBlack'
    echo $'\t\t2:\t\t\t\tRed'
    echo $'\t\t3:\t\t\t\tGreen'
    echo $'\t\t4:\t\t\t\tOrange'
    echo $'\t\t5:\t\t\t\tBlue'
    echo $'\t\t6:\t\t\t\tPurple'
    echo $'\t\t7:\t\t\t\tCyan'
    echo $'\t\t8:\t\t\t\tLight_Gray'
    echo $'\t\t9:\t\t\t\tDark_Gray'
    echo $'\t\t10:\t\t\t\tLight_Red'
    echo $'\t\t11:\t\t\t\tLight_Green'
    echo $'\t\t12:\t\t\t\tYellow'
    echo $'\t\t13:\t\t\t\tLight_Blue'
    echo $'\t\t14:\t\t\t\tLight_Purple'
    echo $'\t\t15:\t\t\t\tLight_Cyan'
    echo $'\t\t16:\t\t\t\tWhite'
    echo $'\tv\t\t\t\t\tDisplay version'

    exit
}
#Options Passed
optcount=0
while getopts ":hd:l:c:h:v" args;
do
    case $args in
         c) #Selected Color
            readarray -t chars <<< "$(tr ' ' '\n' <<< $OPTARG)"
            if [[ ${#chars[@]} -ne 4 ]]
            then
                echo "Error: the number of colors must be four, if only want a one color put NC in others"
                exit 1
            fi

            for ((i=0;i<4;i++));
            do  
                name=${chars[$i]}
                if [[ ! ${!Colors[*]} =~ ${name} ]]
                then
                    echo "Error: the color doesn't exist"
                    exit 1
                fi
                case $i in
                    0)
                        #Header text                         
                        header_color=${Colors[$name]};;
                    1)
                        #Header Lines
                        header_line_color=${Colors[$name]};;
                    2)
                        #Data text
                        data_color=${Colors[$name]};;
                    3)
                        #Data Lines
                        data_line_color=${Colors[$name]};;    
                    *)
                        echo "Insert only 4 colors delimiter by a space"
                        exit 1;;
                esac
            done

            unset chars
            let optcount+=2
         ;;
         l) #Lines table
            readarray -t chars <<< "$(tr ' ' '\n' <<< $OPTARG)"
            if [[ ${#chars[@]} -eq 4 ]]
            then
                for ((i=0;i<3;i++));
                do
                    if [[ ${#chars[$i]} -ne 1 ]] 
                    then
                        echo "The line should be construct only by 3 characters delimiters by a space"
                        exit 1
                    fi
                    case $i in
                        0)
                         #Horizontal
                         lines_h_char=${chars[$i]};;
                        1)
                         #Vertical
                         lines_v_char=${chars[$i]};;
                        2)
                         #Corner
                         corner_char=${chars[$i]};;
                        *)
                        echo "Insert only 3 chars delimiter by a space"
                        exit 1;;
                    esac
                done
            fi
            unset chars
            let optcount+=2
         ;;
         t) #Header lines
            readarray -t chars <<< "$(tr ' ' '\n' <<< $OPTARG)"
            if [[ ${#chars[@]} -eq 3 ]]
            then
                if [[ ${#chars[$i]} -ne 1 ]] 
                then
                    echo "The line should be construct only by 3 characters delimiters by a space"
                    exit 1
                fi
                for ((i=0;i<3;i++));
                do
                    case $i in
                        0)
                         #Horizontal
                         lines_header_h_char=${chars[$i]};;
                        1)
                         #Vertical
                         lines_header_v_char=${chars[$i]};;
                        2)
                         #Corner
                         corner_header_char=${chars[$i]};;
                        *)
                        echo "Insert only 3 chars delimiter by a space"
                        exit 1;;
                    esac
                done
            fi
            unset chars
            let optcount+=2
         ;;
         d) #Column Delimiter
            separator=$OPTARG
            let optcount+=2
            ;;
         h) #Display Help
            Help;;
         v) #Display version
            echo "Version 1.0";;
        \?) #Invalid option
            echo -e ${Red}"Invalid syntax"${NC}
            Help ;;
    esac
done

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
    readarray -t dats <<< "${*}"
    rows=${#dats[@]}
    cols=0
    fst_line=1

    #Get the init row
    init_row=$optcount

    #Get number of columns of the first line
    readarray -t fcolumn <<< "$(tr $separator '\n' <<< "${dats[$init_row]}")"
    cols=${#fcolumn[*]}

    #Save data ina matrix
    declare -A dataMatrix;
    declare -A maxLenCols;

    #First go over rows    
    rownum=1
    for ((j=$init_row;j<=$rows;j++));
    do
        #Split the row in cols
        readarray -t column <<< "$(tr $separator $'\n' <<< "${dats[$j]}")"
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
    
    #For each row in matrix
    for ((i=1; i<=$rows-$init_row; i++))
    do
        

        #Print first line of title
        if [[ $i -eq 1 ]];
        then
            echo -n $(repeat_char $'\t' $table_left_offset)
            echo -ne $header_line_color
            echo $(printLine $cols $lines_header_h_char $corner_header_char)
            echo -ne $NC
        fi
        
        echo -n $(repeat_char $'\t' $table_left_offset)
        #For each column in matrix row print data
        for ((j=1;j<=$cols; j++))
        do
            lenmax=${maxLenCols[$j]}
            lencol=${#dataMatrix[$i,$j]}
            end_line=$(($lenmax-$lencol+${offset[1]}))

            if [[ $i -eq 1 ]];
            then
                echo -ne $header_line_color
                echo -n "$lines_header_v_char"
                echo -ne $NC
                echo -n $(repeat_char ' ' ${offset[0]})
                echo -ne $header_color
                echo -n ${dataMatrix[$i,$j]}
                echo -ne $NC
                echo -n $(repeat_char ' ' $end_line)
            else
                echo -ne $data_line_color
                echo -n "$lines_v_char"
                echo -ne $NC
                echo -n $(repeat_char ' ' ${offset[0]})
                echo -ne $data_color
                echo -n ${dataMatrix[$i,$j]}
                echo -ne $NC
                echo -n $(repeat_char ' ' $end_line)
            fi            
        done

        if [[ $i -eq 1 ]];
        then            
            echo -ne $header_line_color
            echo -n "$lines_header_v_char"
            echo -ne $NC
        else
            echo -ne $data_line_color
            echo -n "$lines_v_char"
            echo -ne $NC
        fi    
        echo -n $'\n'

        #Print second line of title
        if [[ $i -eq 1 ]];
        then
            echo -n $(repeat_char $'\t' $table_left_offset)
            echo -ne $header_line_color
            echo $(printLine $cols $lines_header_h_char $corner_header_char)
            echo -ne $NC
        fi

        #Print footer
        if [[ $i -eq $rows-$init_row ]]
        then
            echo -ne $data_line_color
            echo -n $(repeat_char $'\t' $table_left_offset)
            echo $(printLine $cols $lines_h_char $corner_char)
            echo -ne $NC
        fi

    done 

    echo -n $'\n'
    echo "Numero de filas: ${#}"
    echo "Numero de columnas: $cols"
}

printTable $@;
