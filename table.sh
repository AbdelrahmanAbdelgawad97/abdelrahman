#!bin/bash
LC_COLLATE=C
shopt -s extglob

# List_table


IFS=","
checkChar()
{

    ## These don't do anything in your code anymore. 
    ## -Zohry

    #symbols='[/*-=+()^%$#@!~`{};:<>]|\[|\]';

    #space='[_ ]';

    #numbers='[0-9]';

    notAlphanumerics='[^a-zA-Z0-9_ ]'


    if [[ $1 =~ $notAlphanumerics ]]; then 
    echo 'Please don't enter any of those chars '[/*-=+()^%$#@!~`{};:<>]|\[|\]'' ';
    echo "Enter The Name of the Database:"
    read NDB
    elif [[ $1 =~ ^[0-9] ]]; then 
        echo "Don't start the name of DB with a number.";
        echo "Enter the Name of the Database:"
        read NDB
    else
        var=$1;
        var=${var//" "/"_"}

        ##This prints it to terminal an extra time, we don't need it
        ## -Zohry

        ##echo $var
    fi

    ## 2>/dev/null means that if it has an error it does not output it to terminal 
    ## -Zohry

        return $var 2>/dev/null;
}




echo "Here the all the databases that you have." 
ls -d */;
echo "Please choose the database that you want to access." 
read NDB

if [ -d $NDB ];then
    cd $NDB

    echo "Please choose what you want to do in this database."

    select chooseT in Create_Table  List_Table  Drop_Table Insert_Table Select_From_Table Delete_From_Table Update_From_table Exit;
    do
        case $chooseT in
            Create_Table)
                echo "List of current tables:"
                find  $pwd -type f;
                echo "Enter the name of the new table:" 
                read Tname

                if [ -f $Tname ];then
                    echo "Table already exists."
                else
                checkChar $Tname
                touch $Tname

                arr=()
                arrType=()
                echo "Please enter the number of columns:" 
                read Tcolumn
                for (( i=1; i<=$Tcolumn;i++ ))
                do
                        echo "Enter the name of column number $i:"
                        read ColName
                        echo "Please choose the type of column number $i: (int,string,float,date)." 
                        read Coltype
                        arr[$i]=$ColName
                        arrType[$i]=$Coltype
                done
                echo "${arrType[*]}">>$Tname
                echo "${arr[*]}">>$Tname
                echo >>$Tname
                echo "Table created!"
                fi
            ;;

            List_Table)
                echo "List of all tables:"
                find  $pwd -type f;
                echo "Which table would you like the data of?"
                read insTable
                if [ -f $insTable ];then
                cat $insTable
                else echo "Table '$insTable' does not exist."
                fi
            
            ;;
            Drop_Table)
            echo "List of tables:"
                find  $pwd -type f;
                echo "Which table would you like to delete?"
                read delTable
                
                ##You had a bug here. It should not be $insTable, it should be $deltable.
                ##if [ -f $insTable ];then
                ## -Zohry

                if [ -f $delTable ];then
                rm $delTable
                echo "$delTable deleted!"
                else echo "Table $delTable does not exist."
                fi

            ;;
            Insert_Table)
                echo "List"
                    find  $pwd -type f;
                    echo "Which table would you like to insert data in?"
                    read insTable
                    if [ -f $insTable ];then
                    x=$(sed -n 1p $insTable)
                    y=$(sed -n 2p $insTable)

                    IFS=' '
                    read -ra types <<<"$x"
                    read -ra headlines <<<"$y"
                    
                    arr=()
                    for (( i=0; i<${#headlines[@]}; i++ ))
                    do
                    echo "Enter the values of: ${headlines[i]} of types: ${types[$i]}, separated by a space." 
                        read data
                        arr[$i]=$data
                    done
                    echo "${arr[*]}" >> $insTable
                    echo "Data added!"

                    else echo "Table $insTable does not exist."
                    fi



            ;;
            Select_From_Table)

                #Here:
                    echo "What would you like to select from a table?"
                    select selectone in "Whole Table" "Specific Row" "Specific Column" exit;
                    do
                        case $selectone in
                        "Whole Table")
                            echo "List of tables:"
                            find  $pwd -type f;
                            echo "Choose The Table that you need to show:" 
                            read insTable
                            if [ -f $insTable ];then
                            cat $insTable
                            else echo "Table $insTable does not exist."
                            fi

                        ;;
                        "Specific Row")
                            echo "List of tables:"
                            find  $pwd -type f;
                            echo "Which table would you like to choose rows from?" 
                            read insTable
                                if [ -f $insTable ];then
                                sed -n 1,2p $insTable

                                    echo "How many rows would you like to see?" 
                                    read rowshow
                                    arr=()


                                    ##This doesn't work.

                                    for (( i=1; i<=$rowshow; i++ ))
                                    do
                                    echo "Please enter the row number of row $i that you want to see:"
                                    read rowName

                                    ##Since the first 3 rows of your database are reserved rows, you have to add 3 to the row number
                                    ## -Zohry
                                    ##Delete this comment after reading.

                                    rowName=$(($rowName + 3))
                                    echo $rowName

                                    ##Appending to an array is not done with arr[i]=X. Is it with arr+=X
                                    ## -Zohry

                                    arr+=($rowName)
                                    done

                                    echo "This should be here"
                                    echo $arr
                                    # awk ' NR$rowName' $insTable

                                    ##Testing a new Forloop
                                    ## -Zohry

                                    for i in ${arr[@]}
                                    do
                                    echo "Row $i:"
                                    sed -n "$i p" $insTable
                                    done

                                else echo "Table $insTable does not exist."
                                fi
                            
                        ;;
                        "Specific Column")
                            echo "all table that you have"
                                find  $pwd -type f;

                            read -p "Choose The Table that you need to show " insTable
                                if [ -f $insTable ];then
                                    
                                sed -n 1,2p $insTable
                                y=$(sed -n 2p $insTable)


                                arrValue=();
                            read -p "give us the counts of column that you need to show " colshow

                                for (( i=0; i<$colshow; i++ ))
                                do
                                    # echo '1';
                                    read -p "name of column number ${i} " colnum
                                    arrValue[$i]=$colnum
                                done

                                arr=();
                                IFS=' '
                                read -ra headlines <<<"$y"

                                for (( i=0; i<${#arrValue[@]}; i++ ))
                                do
                                    # echo '2';
                                    for (( j=0; j<=${#headlines[@]}; j++ ))
                                    do
                                        # echo '3';
                                        if [ "$arrValue[i]"=="$headlines[j]" ];then
                                            # echo '4';
                                            arr[$i]=${j+1};
                                        fi
                                    done
                                done
                                    

                                for (( j=0; j<${#arr[@]}; j++ ))
                                    do
                                        var=j+1;
                                        awk '{ print $var }' $insTable
                                    done


                                    # awk {' print $1 , $2 '} $insTable
                                    # y=$(sed -n 2p $insTable)

                                # for (( i=1; i<=colshow; i++ ))
                                # do
                                #     read -p "name of column number $i " colnum
                                #     arr[$i]=$colnum
                                # done

                                # for (( i=0; i<${#arr[@]} ;i++ ))
                                # do
                                # awk -F ' {print $i} ' $insTable;
                                # # echo $(awk -F echo ${array[i]} $insTable) 

                                # done
                            
                                else echo "No exist table like that name that you enter $insTable "
                                fi

                        
                        esac

                    done








            ;;
            *)
                break
            ;;
    esac







    done

else echo "Data Base does not exist";
    
fi














