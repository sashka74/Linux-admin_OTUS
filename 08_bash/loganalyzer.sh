#!/bin/bash
FILE="/home/sashka/Documents/Linux-admin_OTUS/06_bash/access-4560-644067.log"
PROG="loganalyzer"

requests(){
	less $FILE | awk -F" " '{ print $1}' | sort | uniq -c | sort -k1 -nr | head -n 15
}
urls(){
	less $FILE | cut -d' ' -f 7 | sort | uniq -c | sort -nr -k1 | head -n 10
}
errors(){
	less $FILE | cut -d \" -f 3 | cut -d' ' -f 2 | egrep -v 200\|301
}
codes(){
	less $FILE | cut -d \" -f 3 | cut -d' ' -f 2 | sort | uniq -c
}

lockfile=/tmp/$PROG
tmpfile=/tmp/loganalyzer_out
fromtime=$(cat /tmp/fromtime)

[ -e $FILE ] || exit 5
if ( set -o noclobber; echo "$$" > "$lockfile") 2> /dev/null;
then
    trap 'rm -f "$lockfile"; exit $?' INT TERM EXIT

    echo -n $"Starting $PROG: "
    totime=$( cat access-4560-644067.log  | cut -d " " -f 4 | tail -n 1 )
    echo "$totime" > /tmp/fromtime
    echo "Top $requests_count IPs: " > $tmpfile
    requests >> $tmpfile
    echo "" >> $tmpfile
    echo "Top $url_count URLs: " >> $tmpfile
    urls >> $tmpfile
    echo "" >> $tmpfile
    echo "Errors: " >> $tmpfile
    errors >> $tmpfile
    echo "" >> $tmpfile
    echo "Codes: " >> $tmpfile
    codes >> $tmpfile
   rm -f "$lockfile"
   trap - INT TERM EXIT
else
   echo "Failed to acquire lockfile: $lockfile."
   echo "Held by $(cat $lockfile)"
fi
