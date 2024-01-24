#!bin/bash
LC_COLLATE=C
##Shell option
shopt -s extglob
 
notAlphanumerics='[^a-zA-Z0-9_ ]'

echo "Welcome to MZohry and Abdelrahman Database Management System. Please choose an option below:"

select choose in "Create a Database" "List All Databases" "Delete A Database" "Access a Database" Exit;
do
    case $choose in
    "Create a Database")
        echo "List of databases (currently):"
        ls -d */ 2>/dev/null || echo "No databases found."
        while [ true ]
        do
            echo "What would you like to name the database? Type 0 to return to previous menu."; read CDB;
            if [ -d $CDB ]; then echo "Database already exists. Please enter a different name."; continue;
            elif [[ $CDB =~ ^[0] ]]; then echo "Returning to previous menu."; break; 
            elif [[ $CDB =~ $notAlphanumerics ]]; then echo 'Database name cannot have non-alphanumeric characters, except underscores and spaces(which are converted to underscores).'; continue;
            elif [[ $CDB =~ ^[1-9] ]]; then echo "Database names cannot start with a number. Please enter a different name."; continue;
            elif ! [[ $CDB =~ [a-zA-Z0-9]+ ]]; then echo "Database names cannot contain only special characters. Please enter a different name."; continue;
            else
                var=$CDB;
                var=${var//" "/"_"};
                mkdir $var;
                echo "Database $var created successfully! Returning to previous menu."
                break;
            fi
        done      
    ;;
    "List All Databases")
        echo "List of databases:"; ls -d */ 2>/dev/null || echo "No databases found."; echo "Returning to previous menu.";
    ;;
    "Delete A Database")
        echo "List of Databases:";
        ls -d */;
        while [ true ]
        do
            echo "Which database would you like to delete? Press 0 to return to previous menu.";
            read DDB;
            if 
                [ $DDB -eq 0 ] 2>/dev/null; then echo "Returning to previous menu."; break;
                elif [ -d $DDB ]; then rm -r $DDB; echo "Database deleted! Returned to previous menu"; break;
                else echo "Database $DDB does not exist. Please try again."; continue;
            fi
        done
    ;;
    "Access a Database")
        echo "List of Databases:" 
        ls -d */;
        echo "Which database would you like to connect to?"; read NDB;
        if [ ! -d $NDB ]; then echo "Database $NDB does not exist. Returning to previous menu."; continue;
        else
        echo "Please choose what you want to do in this database."
        fi
        cd $NDB;

        select chooseT in "Create a Table"  "List contents of a table" "Drop a Table" "Insert values into Table" "Select Row/Column from Table" "Delete Data from Table" "Update Table" Exit;
        do
            case $chooseT in
                "Create a Table")
                    echo "List of tables:";
                    find  $pwd -type f;
                    while [ true ]
                    do
                        echo "Enter the name of the new table. Type 0 to return to previous menu."; 
                        read Tname;
                        if [[ $Tname =~ $notAlphanumerics ]]; then 
                            echo 'Table names can only contain alphanumeric characters, underscores, and spaces(which are converted to spaces).'; continue;
                        elif [[ $Tname =~ ^[0-9] ]]; then 
                            echo "Table names cannot start with a number. Please Enter a different name."; continue;
                        elif ! [[ $Tname =~ [a-zA-Z0-9]+ ]]; then
                            echo "Table names cannot contain only special characters. Please enter a different name."; continue;
                        elif [ -f $Tname ]; then
                            echo "Table already exists. Please enter a different name."; continue;
                        else
                            var=$Tname
                            IFS=","
                            var=${var//" "/"_"}
                            break
                        fi
                    done

                    arr=()
                    arrType=()

                    while [ true ]
                    do
                        echo "How many columns should it have?"
                        read Tcolumn
                        if 
                            [[ $Tcolumn =~ [^0-9]+ ]]; then echo "Input must be a number higher than 0."; continue;
                            elif [[ $Tcolumn -eq 0 ]]; then echo "Table must have at least one column."; continue;
                            else break;
                        fi
                    done
                    for (( i=1; i<=$Tcolumn;i++ ))
                    do
                        if [ $i -eq 1 ];then
                            echo "Enter the name of column number $i. It will be the primary key."; read columnNamee
                            arr[$i]="$columnNamee"
                            while [ true ]
                            do
                                echo "Choose the desired type of column number $i. (int,string,float,date)"; read Coltype
                                if ! [[ "$Coltype" =~ (^int|string|float|date)$ ]]; then echo "Invalid input. Please enter one of the selected types."; continue;
                                else arrType[$i]="$Coltype"; break;
                                fi
                            done
                        else
                            echo "Enter the name of column number $i."; read columnNamee;
                            arr[$i]=$columnNamee
                            echo "Choose the type of column number $i. (int,string,float,date)"; read Coltype;
                            arrType[$i]=$Coltype
                        fi
                        
                    done
                    touch $Tname
                    echo "${arrType[*]}">>$Tname
                    echo "${arr[*]}">>$Tname
                    echo "Primary Key: ${arr[1]}" >>$Tname
                    echo "Table $Tname created!"
                ;;
                "List contents of a table")
                    echo "List of tables:"
                    find  $pwd -type f;

                    while [ true ] 
                    do
                        echo "Which table would you like to view the contents of?"
                        read insTable
                        if [ -f $insTable ];then
                            echo "Contents of Table $insTable:"
                            cat $insTable
                            echo "Returning to previous menu."
                            break;
                        else 
                            echo "Table $insTable does not exist. Returning to previous menu."; break;
                        fi
                    done
                
                ;;
                "Drop a Table")
                    echo "List of Tables:"
                    find  $pwd -type f;
                    while [ true ]
                    do
                        echo "Which table would you like to delete?"
                        read delTable
                        if [ -f $insTable ];then
                            rm $delTable;
                            echo "Table $delTable deleted.";
                            break;
                        else 
                            echo "Table $insTable does not exist."
                            continue;
                        fi
                    done
                ;;
                "Insert values into Table")
                    function check_type()
                        {
                        if [[ $1 =~ ^[+-]?[0-9]+$ ]]; then
                            x="int"
                            echo $x
                        elif [[ $1 =~ ^[a-zA-Z]*$ ]]; then
                            x="string"
                            echo $x
                        elif [[ $1 =~ ^[+-]?[0-9]+\.?[0-9]*$ ]]; then
                            x="float"
                            echo $x
                        else
                            x="string"
                            echo $x
                        fi
                        }
                    echo "List of Tables:"
                    find  $pwd -type f;
                    while [ true ]
                    do
                        echo "Which table would you like to insert the data into?"
                        read insTable
                        if [ ! -f $insTable ]; then echo "Table $insTable does not exist." ; continue;
                        else
                            x=$(sed -n 1p $insTable)
                            y=$(sed -n 2p $insTable)

                            IFS=','
                            read -ra types <<<"$x"
                            read -ra headlines <<<"$y"
                            
                            arr=()

                            for (( i=0; i<${#headlines[@]}; i++ ))
                            do
                                while [ true ]
                                do
                                    echo "Enter the value of ${headlines[i]}, of datatype ${types[$i]}."
                                    read data
                                    y=$(check_type $data)
                                    exist=$(awk -F "," -v var="$data" ' $1==var { print "the value already exist " } ' $insTable)
                                    if [ ! "$y" == ${types[$i]} ]; then echo "This input does not match the data type of this column. Please enter a different value." ; continue;
                                    elif [ $i -eq 0 -a $exist == "the value already exist "  ]; then echo "This value already exists. Please enter a different value".; continue;
                                    else arr[$i]=$data; break;
                                    fi       
                                done
                            done
                            echo "${arr[*]}" >> $insTable
                            echo "Row added!";
                            break;
                        fi
                    done
                ;;
                "Select Row/Column from Table")
                    select selectone in "Show Multiple Rows" "Show a single column" Exit;
                        do
                            case $selectone in
                                "Show Multiple Rows")
                                    echo "List of tables:"
                                    find  $pwd -type f;
                                    while [ true ]
                                    do 
                                        echo "Which table would you like to choose rows from?" 
                                        read insTable
                                        if [ ! -f $insTable ]; then echo "Table $insTable does not exist" ; continue;
                                        else
                                            sed -n 1,2p $insTable
                                            while [ true ]
                                            do
                                                echo "How many rows would you like to see?" 
                                                read rowshow
                                                if [[ $rowshow =~ [^0-9]+ || $rowshow -eq 0  ]]; then echo "Input must be a number higher than 0."; continue;
                                                else break;
                                                fi
                                            done
                                            arr=()

                                            for (( i=1; i<=$rowshow; i++ ))
                                            do
                                                while [ true ]
                                                do
                                                    echo "Please enter the row number of row $i that you want to see:"
                                                    read rowName
                                                    if [[ $rowName =~ [^0-9]+ || $rowshow -eq 0  ]]; then echo "Input must be a number higher than 0."; continue;
                                                    else break;
                                                    fi
                                                done
                                                rowName=$(($rowName + 3))
                                                arr+=($rowName)
                                            done

                                            for i in ${arr[@]}
                                            do
                                                echo "Row $(($i-3)):"
                                                sed -n "$i p" $insTable
                                            done
                                        echo "Returned to previous menu";
                                        break;
                                        fi
                                    done
                                ;;
                                "Show a single column")
                                    echo "List of Tables:"
                                    find  $pwd -type f;
                                    echo "Which table would you like to show column from?" 
                                    read tablename
                                    if [ -f $tablename ];then
                                        sed -n 2p $tablename
                                        echo "Enter the name of the column you would like to see. Note that the asterisk(*) symbol is also part of the name." 
                                        read colnam
                                            col_Num=$( awk -F "," -v var="$colnam"  ' NR==2 { 
                                                for ( i=1; i<=NF; i++ )
                                                            {if($i == var)
                                                                {
                                                                print (i);
                                                                break;
                                                                }
                                                                }
                                                            }' $tablename)
                                                echo $col_Num
                                                     awk -F "," -v col="$col_Num" '{
                                                        print $col
                                                        }' $tablename
                                    else print "Table does not exist."
                                    fi
                                ;;
                                "Exit")
                                    echo "Returned to previous menu."
                                    break;
                                ;;
                            esac
                        done
                ;;
                "Delete Data from Table")
                    select selectone in "Delete Row" exit;
                    do
                        case $selectone in 
                        "Delete Row")
                            echo "List of Tables:"
                            find  $pwd -type f;
                            while [ true ]
                            do 
                                echo "Which table would you like to see the columns of?" ; read insTable
                                if [ -f $insTable ]; then continue;
                                else echo "This table does not exist. Please enter a valid table name."
                                fi
                            done
                            cat $insTable
                            echo "Which row would you like to delete? (The first entry after the column names is row #1)"
                            read rowNumber
                            rowNumber=$(($rowNumber + 3))
                            sed -i "${rowNumber}d" $insTable
                            echo "Row deleted!"
                        ;;
                        esac
                    done
                ;;
                "Update Table")
                    echo "List of Tables:"
                    find  $pwd -type f;
                    echo "Which table would you like to see the columns of?"; read insTable
                    cat $insTable
                    echo "Which row would you like to update? (The first entry after the column names is row #1)"
                    read rowNumber
                    echo "Which column would you like to update? (The leftmost entry is column 1)"
                    read columnNumber
                    echo "Row $rowNumber, column $columnNumber's value is"
                    rowNumber=$((rowNumber+3))
                    awk -v r=$columnNumber -F","  NR==${rowNumber}'{print $r}' $insTable
                    while [ true ]
                    do
                        echo "What would you like to change it to?"
                        read newValue
                        if [[ $newValue =~ [^a-zA-Z0-9_] ]]; then echo "Fields can only contain alphanumeric characters and the underscore(_)." ; continue;
                        else break;
                        fi
                    done

                    ## n is row number
                    ## r is the column number
                    ## a is the new value
                    ## FS is field separator(We use "," as our field separator)

                    awk -v r=$columnNumber 'BEGIN{FS=OFS=","}NR==n{$r=a}1' n="$rowNumber" a="$newValue" $insTable > content && mv content $insTable
                    echo "Value changed!"
                ;;
                *)
                    break
                ;;
            esac
        done
    ;;
    Exit)
        echo "Thanks for using our database service!"
        break
    ;;
    *) 
        echo "Invalid input. Please enter a listed menu number."
    ;;
    esac
done