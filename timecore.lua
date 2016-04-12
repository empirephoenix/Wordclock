-- As we are located in central europe, we have GMT+1
local TIMEZONE_OFFSET_WINTER = 1

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
function getLocalTime(year, month, day, hour, minutes, seconds,dow)
  -- Always adapte the timezoneoffset:
  hour = hour + (TIMEZONE_OFFSET_WINTER)

  -- we are in 100% in the summer time
  if (month > 3 and month < 10) then 
    hour = hour + 1
  -- March is not 100% Summer time, only starting at the last sunday
  elseif ((month == 3 and day >= 25 and day <= 31 and hour > 2 and dow == 7) or
          -- Only handle days after the last sunday in this month
          ((month == 3 and day >= 25 and day <= 31 and dow < 7 and ((7-dow + day) > 31))) ) then
   hour = hour + 1
  -- October is not 100% Summer time, ending with the last sunday
  elseif ((month == 10 and day >= 25 and day <= 31 and hour < 2 and dow == 7) or
          (month == 10 and day >= 25 and day <= 31 and dow < 7 and ((7-dow + day) <= 31)) or 
           -- Handle all days up to the 25. of october
           (month == 10 and day < 25 )
           )then
   hour = hour + 1
  end
  
  return year, month, day, hour, minutes, seconds
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