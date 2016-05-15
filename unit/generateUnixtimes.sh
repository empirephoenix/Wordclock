#/bin/bash

# date command is all we need, as shown:
#date -d '2007-011-01 17:30:24' '+%s'
#1193934624
#date -d '2007-011-01 17:30:24' '+%w'
#4 

# Usage:
# Call this script and generate a new testUnixtime.lua
# Run the test afterwards like the following:
# $ lua testUnixtime.lua 


# remove the tailing "./" and the extension of this script
OUTPUT="$(echo "$0" | sed 's;^./;;' | cut -d'.' -f1).lua"
#rename OUTPUT from generate to test
OUTPUT="$(echo "$OUTPUT" | sed 's;generate;test;')"

echo "Generating $OUTPUT ..."

# Generate the header
cat << EOF > $OUTPUT
dofile("../timecore.lua")
function checkUnixTime(resultYear, resultMonth, resultDay, resultHour, resultMinute, resultSecond, resultDow, unixtime)
 year, month, day, hour, minute, second, dow = getUTCtime(unixtime)

 if not (year == resultYear and resultMonth == month and day == resultDay and hour == resultHour and minute == resultMinute and second == resultSecond and dow == resultDow) then
        print(resultYear .. "-" .. resultMonth .. "-" .. resultDay .. " " .. resultHour .. ":" .. resultMinute .. ":" .. resultSecond .. " day of week : " .. resultDow .. " not extracted from " .. unixtime) 
        print(year .. "-" .. month .. "-" .. day .. " " .. hour .. ":" .. minute .. ":" .. second .. " day of week : " .. dow .. " found instead") 
        os.exit(1)
    else
        print(resultYear .. "-" .. resultMonth .. "-" .. resultDay .. " " .. resultHour .. ":" .. resultMinute .. ":" .. resultSecond .. " OK") 
    end

 
end
EOF

# Generate all the tests
for year in {2016..2020}; do
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
     unixtime=$(date -u -d "$timestmp" '+%s')
     dayofweek=$(date -u -d "$timestmp" '+%w')
     # Generate the lua test command, like: checkTime(2015, 1, 1, 10, 11, 12, 0, 1)
     echo "checkUnixTime($year, $month, $day, $hour, $minutes, $seconds, $dayofweek, $unixtime)" >> $OUTPUT
    fi
  done
 done
done

# Generate the footer
cat << EOF >> $OUTPUT
print "Finished with all tests"
os.exit(0)
EOF

echo "---------------------------"
echo "Usage:"
echo "Call >lua $OUTPUT< in the terminal to execute the test"
exit 0
