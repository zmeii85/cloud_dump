#!/bin/bash

source ./config.sh
source ./dump_cloud.sh
source ./dump/tables_cloud
source ./dump/tables_cloud_client

echo ""
echo "-----List of tables Cloud-----"
echo $tables_cloud
echo ""
echo "-----List of tables Cloud_Client-----"
echo $tables_cloud_client
echo ""

mkdir dump
echo "Dump database CLOUD..."
mysqldump -h $ip -u $user -p$pass $db --no-autocommit --add-drop-table --extended-insert=false $tables_cloud > dump/cloud_central.sql
mysqldump -h $ip -u $user -p$pass $db --no-autocommit --add-drop-table --extended-insert=false -d synchro_session session event_log >> dump/cloud_central.sql

echo "Dump database CLOUD_CLIENT..."
mysqldump -h $ip -u $user -p$pass $db2 --no-autocommit --add-drop-table --extended-insert=false $tables_cloud_client > dump/cloud_central_client.sql
mysqldump -h $ip -u $user -p$pass $db2 --no-autocommit --add-drop-table --extended-insert=false -d ci_sessions printer printer_linking >> dump/cloud_central_client.sql


echo -n "Удаляем локальную базу Cloud и Cloud_client? (y/n) "
read item
case "$item" in
    y|Y) echo "Удаляем локальную базу Cloud и Cloud_client..."
        mysql -u root -plmd -e "DROP DATABASE cloud"
        mysql -u root -plmd -e "DROP DATABASE cloud_client"
        ;;
    n|N) echo "Ввели «n», завершаем..."

        echo -n "Создаем локальную базу Cloud и Cloud_client? (y/n) "
	    read item
	    case "$item" in
	        y|Y) echo "Создаем локальную базу Cloud и Cloud_client..."
	            mysql -u root -plmd -e "CREATE DATABASE cloud CHARSET utf8 COLLATE utf8_general_ci"
		        mysql -u root -plmd -e "CREATE DATABASE cloud_client CHARSET utf8 COLLATE utf8_general_ci"
	        ;;
	    n|N) echo "Ввели «n», завершаем..."

	        echo -n "Создаем таблицы в локальной базе? (y/n) "
            read item
            case "$item" in
                y|Y) echo "Заливаем таблицы..."
                    mysql -u root -plmd $ldb < dump/cloud_central.sql
                    mysql -u root -plmd $ldb2 < dump/cloud_central_client.sql
                    ;;
                n|N) echo "Ввели «n», завершаем..."
                    exit 0
                    ;;
                *) echo "Ничего не ввели. Выполняем действие по умолчанию..."
                    exit 0
                    ;;
            esac
	        ;;
	    *) echo "Ничего не ввели. Выполняем действие по умолчанию..."
	        exit 0
	        ;;
		esac
	        ;;
    *) echo "Ничего не ввели. Выполняем действие по умолчанию..."
        exit 0
        ;;
esac




#mysql -u $user -p$pass -e $db2 "TRUNCATE printer"
