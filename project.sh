#!bin/bash
LC_COLLATE=C
shopt -s extglob

 
notAlphanumerics='[^a-zA-Z0-9_ ]'

select choose in Creat_DB  List_DB  Drop_DB Conect_DB Exit;

do
    case $choose in
    Creat_DB)
        read -p"Enter The Name Of Data Base " CDB
                if [ -d $CDB ];then 
                    echo "Data base already exist";
                else
                    if [[ $CDB =~ $notAlphanumerics ]]; then 
                    echo 'Please don't enter any of those chars '[/*-=+()^%$#@!~`{};:<>]|\[|\]'' ';
                    read -p"Enter The Name Of Data Base " NDB
                    elif [[ $CDB =~ ^[0-9] ]]; then 
                    echo "don't start the name of DB with number ";
                    read -p"Enter The Name Of Data Base " NDB
                    else
                    var=$CDB;
                    var=${var//" "/"_"}
                    mkdir $var;    
                    fi
                
                
                
                fi
    ;;
    List_DB)
        ls -d */;
    ;;
    Drop_DB)
        echo "Here the all data base that you have" 
            ls -d */;
        read -p"Enter The Name Of Data Base That You Need To Delete " DDB
            if [ -d $DDB ];then
                rm -r $DDB;
                echo "Data Base is already deleted";
            else echo "Data Base is not exist";    
            fi
    ;;
    Conect_DB)
        echo "Here the all data base that you have" 
            ls -d */;
        read -p"Enter The Name Of Data Base That You Need To Connect " NDB

        if [ -d $NDB ];then
    cd $NDB

    echo "Please choose what you want to do in this database."

    select chooseT in Create_Table  List_Table  Drop_Table Insert_Table Select_From_Table Delete_From_Table Update_From_table Exit;
    do
        case $chooseT in
            Create_Table)
                echo "List of tables:"
                find  $pwd -type f;
                read -p "Enter the name of the new table:" Tname
                 

                    if [[ $Tname =~ $notAlphanumerics ]]; then 
                    echo 'Please don't enter any of those chars '[/*-=+()^%$#@!~`{};:<>]|\[|\]'' ';
                    read -p "Enter the name of the new table:" Tname
                    elif [[ $Tname =~ ^[0-9] ]]; then 
                    echo "don't start the name of DB with number ";
                    read -p "Enter the name of the new table:" Tname
                    else
                    var=$Tname;
                    IFS=","
                    var=${var//" "/"_"}   

                        if [ -f $Tname ];then
                            echo "Table already exists."
                        else
                        touch $Tname

                        arr=()
                        arrType=()
                        read -p"Enter The Number Of Column " Tcolumn
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

                echo "all table that you have"
                    find  $pwd -type f;
                read -p "Choose The Table that you need to insert data in " insTable
                    if [ -f $insTable ];then
                    x=$(sed -n 1p $insTable)
                    y=$(sed -n 2p $insTable)

                    
                    IFS=','
                    read -ra types <<<"$x"
                    read -ra headlines <<<"$y"
                    
                    arr=()

                    for (( i=0; i<${#headlines[@]}; i++ ))
                    do
                        read -p"Enter the value of ${headlines[i]} type ${types[$i]} " data
                        y=$(check_type $data)
                        if [ "$y" == ${types[$i]} ];then
                            if [ i==0 ];then
                                exist=$(awk -F "," -v var="$data" ' $1==var { print "the value already exist " } ' $insTable)
                                if [ $exist=="the value already exist " ];then
                                echo $exist
                                grep ^$data $insTable
                                else
                                arr[$i]=$data
                                # read -p"Enter the value of ${headlines[i]} type ${types[$i]} " data
                                fi
                            else
                                arr[$i]=$data
                            fi
                            # arr[$i]=$data
                        else
                            read -p "Please Re-Enter type maching the data value of ${headlines[i]} type ${types[$i]} " data
                        fi       
                        

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
                        choose_column)
                            echo "all table that you have"
                                find  $pwd -type f;

                            read -p "Choose The Table that you need to show column " insTable
                                if [ -f $insTable ];then
                                sed -n 2p $insTable
                                read -p "name of colname " colnam
                                        col_Num=$( awk -F "," -v var="$colnam"  ' NR==2 { 
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
                                         awk -F "," -v col="$col_Num"'{
                                            print ($col)
                                        }' $insTable

                            
                                else echo "No exist table like that name that you enter $insTable "
                                fi

                        
                        esac

                    done


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
                echo "all table that you have"
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

else echo "Data Base does not exist";
    
fi














    ;;
    Exit)
        break
    ;;
    esac

done