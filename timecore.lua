--Summer winter time convertion
--See: https://arduinodiy.wordpress.com/2015/10/13/the-arduino-and-daylight-saving-time/
--
--As October has 31 days, we know that the last Sunday will always fall from the 25th to the 31st
--So our check at the end of daylight saving will be as follows:
--if (dow == 7 && mo == 10 && d >= 25 && d <=31 && h == 3 && DST==1)
--{
--setclockto 2 am;
--DST=0;
--}
--
--To start summertime/daylightsaving time on the last Sunday in March is mutatis mutandis the same:
--if (dow == 7 && mo == 3 && d >= 25 && d <=31 && h ==2 && DST==0)
--{
--setclockto 3 am;
--DST=1;
--}

-- @fn isSummerTime(year, month, day, hour, minute, second,dow)
-- The @param time is a struct containing the following entries:
-- @var year      Current year of day       range (2016 - ...)
-- @var month     Current month of year     range (1 - 12) e.g. 2 is Februrary
-- @var day       Current day in month      range (1 - 31)
-- @var hour      Current hour of day       range (0 - 23)
-- @var minute    Current minute in hour    range (0 - 59)
-- @var second    Current second of minute  range (0 - 59)
-- @var dow       Current day of week       range (1 - 7)   (1 is Monday, 7 is Sunday)
-- @return <code>true</code> if we have currently summer time
-- @return <code>false</code> if we have winter time
function isSummerTime(time)
  -- we are in 100% in the summer time
  if (time.month > 3 and time.month < 10) then 
    return true
  -- March is not 100% Summer time, only starting at the last sunday
  elseif ((time.month == 3 and time.day >= 25 and time.day <= 31 and time.hour > 2 and time.dow == 7) or
          -- Only handle days after the last sunday in this month
          ((time.month == 3 and time.day >= 25 and time.day <= 31 and time.dow < 7 and ((7-time.dow + time.day) > 31))) ) then
   -- summer time
   return true
  -- October is not 100% Summer time, ending with the last sunday
  elseif ((time.month == 10 and time.day >= 25 and time.day <= 31 and (time.hour < 2 or (time.hour == 2 and time.minute== 0 and time.second == 0)) and time.dow == 7) or
          (time.month == 10 and time.day >= 25 and time.day <= 31 and time.dow < 7 and ((7-time.dow + time.day) <= 31)) or 
           -- Handle all days up to the 25. of october
           (time.month == 10 and time.day < 25 )
           )then
   -- summer time
   return true
  end
  -- otherwise it must be winter time
  return false
end

-- Convert a given month in english abr. to number from 1 to 12.
-- On unknown arguments, zero is returned.
function convertMonth(str)
 if (str=="Jan") then
  return 1
 elseif (str == "Feb") then
  return 2
 elseif (str == "Mar") then
  return 3
 elseif (str == "Apr") then
  return 4
 elseif (str == "May") then
  return 5
 elseif (str == "Jun") then
  return 6
 elseif (str == "Jul") then
  return 7
 elseif (str == "Aug") then
  return 8
 elseif (str == "Sep") then
  return 9
 elseif (str == "Oct") then
  return 10
 elseif (str == "Nov") then
  return 11
 elseif (str == "Dec") then
  return 12
 else
  return 0
 end
end

----------------------------------------------------------
-- Here comes some code to extract the year, month, day, hour, minute, second and day of week of a unix timestamp

-- Source:
-- http://www.jbox.dk/sanos/source/lib/time.c.html

YEAR0=1900

EPOCH_YR=1970
--SECS_DAY=(24L * 60L * 60L)
SECS_DAY=86400

ytab = {}
ytab[0] = {}
ytab[1] = {}
ytab[0][0] = 31
ytab[0][1] = 28
ytab[0][2] = 31
ytab[0][3] = 30
ytab[0][4] = 31
ytab[0][5] = 30
ytab[0][6] = 31
ytab[0][7] = 31
ytab[0][8] = 30
ytab[0][9] = 31
ytab[0][10] = 30
ytab[0][11] = 31
ytab[1][0] =  31
ytab[1][1] = 29
ytab[1][2] = 31
ytab[1][3] = 30
ytab[1][4] = 31
ytab[1][5] = 30
ytab[1][6] = 31
ytab[1][7] = 31
ytab[1][8] = 30
ytab[1][9] = 31
ytab[1][10] = 30
ytab[1][11] = 31


local leapyear = function(year)
    return  ( not ((year) % 4 ~= 0) and (((year) % 100 ~= 0) or not ((year) % 400 ~= 0)))
end

local yearsize = function(year)
 if leapyear(year) then
  return 366
 else
  return 365
 end
end

function getUTCtime(unixtimestmp)
  local year = EPOCH_YR
  local dayclock = math.floor(unixtimestmp % SECS_DAY)
  dayno = math.floor(unixtimestmp / SECS_DAY)

  local sec = math.floor(dayclock % 60)
  local min = math.floor( (dayclock % 3600) / 60)
  local hour = math.floor(dayclock / 3600)
  local dow = math.floor( (dayno + 4) % 7) -- Day 0 was a thursday

  while (dayno >= yearsize(year))
  do
    dayno = dayno - yearsize(year);
    year=year + 1
  end
  --Day in whole year: local yday = dayno (Not needed)
  mon = 0
  while (dayno >= ytab[leapyear(year) and 1 or 0][mon])
  do
      dayno = dayno - ytab[leapyear(year) and 1 or 0][mon];
      mon = mon + 1
   end
   mday = dayno + 1

  return { year = year, month = (mon+1), day = mday, hour = hour, minute = min, second = sec, dow = dow }
end


