#/bin/bash

# date command is all we need, as shown:
#date -d '2007-011-01 17:30:24' '+%:z'
#+01:00


HEAD=timetest_head.template
TAIL=timetest_tail.template
# remove the tailing "./" and the extension of this script
OUTPUT="$(echo "$0" | sed 's;^./;;' | cut -d'.' -f1).lua"
#rename OUTPUT from generate to test
OUTPUT="$(echo "$OUTPUT" | sed 's;generate;test;')"

echo "Generating $OUTPUT ..."
cat $HEAD > $OUTPUT

for year in {2017..2020}; do
 echo "For $year ..."
 for month in {1..12}; do
  for day in {1..31}; do
    hour=$((RANDOM%24))
    minutes=$((RANDOM%60))
    seconds=$((RANDOM%60))
    timestmp="$year-$month-$day $hour:$minutes:$seconds"
    date -d "$timestmp" "+%F %T" >> /dev/null
    if [ $? -ne 0 ]; then
     echo "--Time $timestmp is not valid" >> $OUTPUT
    else
     # Result of date looks like +01:00
     # Grep extracts the hour, then remove the plus in front and at the end remove leading zeros
     offset=$(date -d "$timestmp" '+%:z' | grep -o "+[0-9]*" | sed 's/+//' | sed 's/^0//')
     dayofweek=$(date -d "$timestmp" '+%u')
     # Generate the lua test command, like: checkTime(2015, 1, 1, 10, 11, 12, 0, 1)
     echo "checkTime($year, $month, $day, $hour, $minutes, $seconds, $dayofweek, $offset)" >> $OUTPUT
    fi
  done
 done
done

cat $TAIL >> $OUTPUT

echo "---------------------------"
echo "Usage:"
echo "Call >lua $OUTPUT< in the terminal to execute the test"

exit 0
