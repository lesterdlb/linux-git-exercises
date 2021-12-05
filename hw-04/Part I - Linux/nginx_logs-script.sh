#!/bin/bash
echo "Nginx Logs"

# Variables
YEAR=`date +%Y`
MONTH=`date +%m`
DAY=`date +%d`

DIR=~/backup/lesterdavid/$YEAR/$MONTH/$DAY

URL="https://raw.githubusercontent.com/elastic/examples/master/Common%20Data%20Formats/nginx_logs/nginx_logs"
FILENAME="nginx_log_requests_$YEAR$MONTH$DAY.log"

function create_logfile()
{
    curl $URL | grep -Eo '[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}' | sort | uniq -c | awk '{print $2" -> "$1}' > $FILENAME
}

# Create directory
if [ ! -d "$DIR" ]; then
    mkdir -p $DIR
    cd $DIR
    create_logfile
else
    cd $DIR
    create_logfile
fi

# Last day
if [[ $(date +%u) -eq 7 ]]; then
    VAR=""
    for (( counter=0; counter<7; counter++ )) do
        FILE=`date '+nginx_log_requests_%Y%m%d.log' -d "$counter day ago"`
    
        # Check if the file exists before creating tar
        if test -f "$FILE"; then
            VAR+="$FILE "
        fi
    done

    tar czf nginx_log_requests_$YEAR$MONTH$DAY.tar.gz $VAR
fi
