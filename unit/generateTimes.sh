#/bin/bash

# date command is all we need, as shown:
#date -d '2007-011-01 17:30:24' '+%:z'
#+01:00

for year in {2017..2020}; do
 for month in {1..12}; do
  for day in {1..31}; do
    hour=$((RANDOM%24))
    minutes=$((RANDOM%60))
    seconds=$((RANDOM%60))
    timestmp="$year-$month-$day $hour:$minutes:$seconds"
    date -d "$timestmp" "+%F %T" >> /dev/null
    if [ $? -ne 0 ]; then
     echo "--Time $timestmp is not valid"
    else
     # Result of date looks like +01:00
     # Grep extracts the hour, then remove the plus in front and at the end remove leading zeros
     offset=$(date -d "$timestmp" '+%:z' | grep -o "+[0-9]*" | sed 's/+//' | sed 's/^0//')
     dayofweek=$(date -d "$timestmp" '+%u')
     # Generate the lua test command, like: checkTime(2015, 1, 1, 10, 11, 12, 0, 1)
     echo "checkTime($year, $month, $day, $hour, $minutes, $seconds, $dayofweek, $offset)"
    fi
  done
 done
done
exit 0
