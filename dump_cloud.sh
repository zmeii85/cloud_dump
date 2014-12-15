#!/bin/bash

source ./config.sh

echo "Show tables in database Cloud..."
mysql -h $ip -u $user -p$pass $db -e "$show" > show_cloud.sql

# delete rows
    sed -i "/Tables_in_cloud/d" "show_cloud.sql"
    sed -i "/synchro_session/d" "show_cloud.sql"
    sed -i "/session/d" "show_cloud.sql"
    sed -i "/event_log/d" "show_cloud.sql"
# make one line
cat show_cloud.sql | tr -s '\r\n' ' ' > dump/tables_cloud

# insert tables=''.
N=1; sed -e $N"s/^/tables_cloud='/" -i dump/tables_cloud
sed "s/$/'/" -i dump/tables_cloud
sed '1i #!/bin/bash\n\n' -i dump/tables_cloud

rm show_cloud.sql

echo "Show tables in database Cloud_Client..."
mysql -h $ip -u $user -p$pass $db2 -e "$show" > show_cloud_client.sql

# delete rows
    sed -i "/Tables_in_cloud/d" "show_cloud_client.sql"
    sed -i "/ci_session/d" "show_cloud_client.sql"
    sed -i "/printer_linking/d" "show_cloud_client.sql"
# make one line
cat show_cloud_client.sql | tr -s '\r\n' ' ' > dump/tables_cloud_client

# insert tables=''.
N=1; sed -e $N"s/^/tables_cloud_client='/" -i dump/tables_cloud_client
sed "s/$/'/" -i dump/tables_cloud_client
sed '1i #!/bin/bash\n\n' -i dump/tables_cloud_client

rm show_cloud_client.sql
