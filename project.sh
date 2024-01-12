#!bin/bash
LC_COLLATE=C
shopt -s extglob
 
notAlphanumerics='[^a-zA-Z0-9_ ]'

echo "Welcome to MZohry and Abdelrahman Database Management System. Please choose an option below:"

select choose in "Create a Database" "List All Databases" "Delete A Database" "Access a Database" Exit;
do
    case $choose in
    "Create a Database")
        while [ true ]
        do
            echo "What would you like to name the database?"
            read CDB
            if [ -d $CDB ]; then 
                echo "Database already exists. Please enter a different name."; continue;
            elif [[ $CDB =~ $notAlphanumerics ]]; then 
                echo 'Database name cannot have non-alphanumeric characters, except underscores and spaces(which are converted to underscores).'; continue;
            elif [[ $CDB =~ ^[0-9] ]]; then 
                echo "Database names cannot start with a number. Please enter a different name."; continue;
            else
                var=$CDB;
                var=${var//" "/"_"};
                mkdir $var;
                break;
            fi
        done      
    ;;
    "List All Databases")
        ls -d */;
    ;;
    "Delete A Database")
        echo "List of Databases:" 
            ls -d */;
        echo "Which database would you like to delete?"
        read DDB
        if [ -d $DDB ];then
            rm -r $DDB;
            echo "Database deleted!";
        else 
            echo "Database $DDB does not exist. Returning to previous menu."; 
        fi
    ;;
    "Access a Database")
        echo "List of Databases:" 
            ls -d */;
        echo "Which database would you like to connect to?"
        read NDB
        if [ ! -d $NDB ];then
            echo "Database does not exist";
        else
            cd $NDB;
        
    echo "Please choose what you want to do in this database."

    select chooseT in "Create a Table"  "List contents of a table" "Drop a Table" "Insert values into Table" "Select Row/Column from Table" Delete_From_Table Update_From_table Exit;
    do
        case $chooseT in
            "Create a Table")
               echo "List of tables:";
                find  $pwd -type f;
                while [ true ]
                do
                    echo "Enter the name of the new table:"; 
                    read Tname;

                    if [[ $Tname =~ $notAlphanumerics ]]; then 
                        echo 'Table names can only contain alphanumeric characters, underscores, and spaces(which are converted to spaces).';
                        continue;
                    elif [[ $Tname =~ ^[0-9] ]]; then 
                        echo "Table names cannot start with a number.";
                        continue;
                    else
                        var=$Tname
                        IFS=","
                        var=${var//" "/"_"}
                        break
                    fi
                done

                if [ -f $Tname ];then
                    echo "Table already exists."
                else
                touch $Tname

                arr=()
                arrType=()

                echo "How many columns should it have?"
                read Tcolumn
                for (( i=1; i<=$Tcolumn;i++ ))
                do
                    if [ $i -eq 1 ];then
                        read -p"Enter the name of column number $i and it will be Primary Key " ColName
                        read -p"choose the type of column number $i (int,string,float,date) " Coltype
                        arr[$i]="*$ColName"
                        arrType[$i]="$Coltype"
                    else
                        read -p"Enter the name of column number $i " ColName
                        read -p"choose the type of column number $i (int,string,float,date) " Coltype
                        arr[$i]=$ColName
                        arrType[$i]=$Coltype
                    fi    
                done
                echo "${arrType[*]}">>$Tname
                echo "${arr[*]}">>$Tname
                echo >>$Tname
                fi    
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
                        break;
                    else 
                        echo "Table $insTable does not exist."
                        continue;
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
                echo "Which table would you like to insert the data into?"
                read insTable
                    if [ ! -f $insTable ];then
                        echo "Table $insTable does not exist."
                    else
                        x=$(sed -n 1p $insTable)
                        y=$(sed -n 2p $insTable)

                        IFS=','
                        read -ra types <<<"$x"
                        read -ra headlines <<<"$y"
                        
                        arr=()

                        for (( i=0; i<${#headlines[@]}; i++ ))
                        do
                            echo "Enter the value of ${headlines[i]} type ${types[$i]} "
                            read data
                            y=$(check_type $data)
                            if [ ! "$y" == ${types[$i]} ];then
                                echo "Please Re-Enter type maching the data value of ${headlines[i]} type ${types[$i]} "
                                read data
                            else
                                if [ i==0 ];then
                                    exist=$(awk -F "," -v var="$data" ' $1==var { print "the value already exist " } ' $insTable)
                                    if [ $exist=="the value already exist " ];then
                                    echo $exist
                                    grep ^$data $insTable
                                    else
                                    arr[$i]=$data
                                    fi
                                else
                                    arr[$i]=$data
                                fi
                            fi       
                        done
                        echo "${arr[*]}" >> $insTable
                    fi
            ;;
            "Select Row/Column from Table")
                select selectone in "Show Whole Table" "Show Multiple Rows" "Show a single column" Exit;
                    do
                        case $selectone in
                        "Show Whole Table")
                            echo "List of Tables:"
                            find  $pwd -type f;
                            while [ true ]
                            do
                                echo "Which table would you like to view?"
                                read insTable
                                if [ -f $insTable ];then
                                cat $insTable;
                                break;
                                else 
                                echo "Table $insTable does not exist. Please choose a different table.";
                                continue;
                                fi
                            done
                        ;;
                        "Show Multiple Rows")
                            echo "List of tables:"
                            find  $pwd -type f;
                            echo "Which table would you like to choose rows from?" 
                            read insTable
                            if [ ! -f $insTable ];then
                                echo "Table $insTable does not exist"
                            else
                                sed -n 1,2p $insTable
                                echo "How many rows would you like to see?" 
                                read rowshow
                                arr=()

                                for (( i=1; i<=$rowshow; i++ ))
                                do
                                    echo "Please enter the row number of row $i that you want to see:"
                                    read rowName
                                    rowName=$(($rowName + 3))
                                    arr+=($rowName)
                                done

                                for i in ${arr[@]}
                                do
                                    echo "Row $(($i-3)):"
                                    sed -n "$i p" $insTable
                                done
                            fi
                        ;;
                        "Show a single column")
                            echo "List of Tables:"
                            find  $pwd -type f;
                            echo "Which table would you like to see the columns of?" 
                            read insTable
                            if [ ! -f $insTable ];then
                                echo "Table $insTable does not exist";
                            else
                                sed -n 2p $insTable

                                select choice in "By Column Number" "By Column Name"
                                do
                                case $choice in
                                    "By Column Number")
                                    echo "Which column would you like to view all data of?"
                                    read columnNumber
                                    cat $insTable | while read line
                                    do
                                        awk myvar='$columnNumber' -F ' ' 'NR>3 {print myvar}'
                                    done
                                    ;;

                                    "By Column Name")
                                    echo "Which column name would you like to view all the data of?"
                                    read columnName

                                    col_Num=$( awk -F "," -v var="$columnName"  ' NR==2 { 
                                                for ( i=1; i<=NF; i++ )
                                                {
                                                    if($i == var)
                                                    {
                                                    print (i);
                                                    break;
                                                    }
                                                }
                                            }' $insTable)
                                    echo $col_Num
                                    cat $insTable | while read line
                                    do
                                        awk myvar='$col_Num' -F ' ' 'NR>3 {print myvar}'
                                    done
                                    ;;
                                esac
                                done
                            fi
                        ;;
                        "Exit") 
                            echo "Returned to previous menu."
                            break;
                        esac
                    done
                
            ;;
            Delete_From_Table)
                select selectone in Delete_row Delete_column exit;
                do
                case $selectone in 
                Delete_row)
                read -p""

                ;;
                Delete_column)
                echo "List of Tables:"
                find  $pwd -type f;

                    read -p "Choose The Table that you need to Delete column from " DelTable
                    if [ -f $DelTable ];then
                    sed -n 2p $DelTable
                        read -p "name of colname that you need to delete " colnam
                            col_Num=$( awk -F "," -v var="$DelTable"  ' NR==2 { 
                                for ( i=1; i<=NF; i++ )
                                        {
                                            if($i == var)
                                            {
                                            print (i);
                                            break;
                                            }
                                            }
                                        }' $DelTable)
                            echo $col_Num
                                $( awk -F "," -v col="$col_Num"'{
                                    print $col"
                                    }' $DelTable)



                    else print "No exist Table like what you want"
                    fi

                esac
                done






            ;;
            *)
                break
            ;;
    esac

    done

  
fi

    ;;
    Exit)
        break
    ;;
    esac

done