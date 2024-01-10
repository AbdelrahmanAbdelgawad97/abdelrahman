#!bin/bash
LC_COLLATE=C
shopt -s extglob

# List_table


IFS=","
checkChar()
{

    ## These don't do anything in your code anymore. 

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
        echo $var
    fi
        return $var;
}




echo "Here the all the databases that you have." 
ls -d */;
read -p"Choose The Data Base That You Need To Connect " NDB

if [ -d $NDB ];then
    cd $NDB
    select chooseT in Creat_Table  List_Table  Drop_Table Insert_Table Select_From_Table Delete_From_Table Update_From_table Exit;
    do
        case $chooseT in
            Creat_Table)
                echo "The tables that you have"
                find  $pwd -type f;
                read -p"Enter The Name Of Table that you need to create " Tname

                if [ -f $Tname ];then
                    echo "Table already exist"
                else
                checkChar $Tname
                touch $Tname

                arr=()
                arrType=()
                read -p"Enter The Number Of Column " Tcolumn
                for (( i=1; i<=$Tcolumn;i++ ))
                do
                    
                        read -p"Enter the name of column number $i " ColName
                        read -p"choose the type of column number $i (int,string,float,date) " Coltype
                        arr[$i]=$ColName
                        arrType[$i]=$Coltype

                done
                echo "${arrType[*]}">>$Tname
                echo "${arr[*]}">>$Tname
                echo >>$Tname
                fi
            ;;

            List_Table)
                echo "all table that you have"
                find  $pwd -type f;
                read -p "Choose The Table that you need all inside data " insTable
                if [ -f $insTable ];then
                cat $insTable
                else echo "No exist table like that name that you enter $insTable "
                fi
            
            ;;
            Drop_Table)
            echo "all table that you have"
                find  $pwd -type f;
                read -p "Choose The Table that you need to delete " delTable
                if [ -f $insTable ];then
                rm $delTable
                echo "$delTable already deleted"
                else echo "No exist table like that name that you enter $insTable "
                fi

            ;;
            Insert_Table)
                echo "all table that you have"
                    find  $pwd -type f;
                read -p "Choose The Table that you need to insert data in " insTable
                    if [ -f $insTable ];then
                    x=$(sed -n 1p $insTable)
                    y=$(sed -n 2p $insTable)

                    IFS=' '
                    read -ra types <<<"$x"
                    read -ra headlines <<<"$y"
                    
                    arr=()
                    for (( i=0; i<${#headlines[@]}; i++ ))
                    do
                        read -p"Enter the value of ${headlines[i]} type ${types[$i]} " data
                        arr[$i]=$data

                    done
                    echo "${arr[*]}" >> $insTable

                    else echo "No exist table like that name that you enter $insTable "
                    fi



            ;;
            Select_From_Table)
                    select selectone in allTable choose_row choose_column exit;
                    do

                        case $selectone in
                        allTable)
                            echo "all table that you have"
                            find  $pwd -type f;
                        read -p "Choose The Table that you need to show " insTable
                            if [ -f $insTable ];then
                            cat $insTable
                            else echo "No exist table like that name that you enter $insTable "
                            fi


                        ;;
                        choose_row)
                            echo "all table that you have"
                                find  $pwd -type f;
                            read -p "Choose The Table that you need to show " insTable
                                if [ -f $insTable ];then
                                sed -n 1,2p $insTable

                                    read -p "give us the counts of row that you need to show " rowshow

                                    arr=()
                                    for (( i=1; i<=rowshow; i++ ))
                                    do
                                    read -p "give us the name of row $i that you need " rowName
                                    arr[$i]=$rowName
                                    done
                                    # awk ' NR$rowName' $insTable
                                    for (( i=0; i<${#arr[@]} ;i++ ))
                                    do
                                    sed -n '/${arr[i]}/p' $insTable
                                    done

                                else echo "No exist table like that name that you enter $insTable "
                                fi
                            


                        ;;
                        choose_column)
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














