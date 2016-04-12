dofile("wlancfg.lua")
print("Initialize Wordclock")

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
  -- October is not 100% Summer time
  --FIXME elseif (month == 10 and 
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

function startTimeupdate()
  -- Found: http://thearduinoguy.org/using-an-esp8266-as-a-time-source-part-2/
  -- retrieve the current time from Google
  conn=net.createConnection(net.TCP, 0) 
  -- Send the HTTP request
  conn:on("connection",function(conn, payload)
    conn:send("HEAD / HTTP/1.1\r\n".. 
            "Host: google.com\r\n"..
            "Accept: */*\r\n"..
            "User-Agent: Mozilla/4.0 (compatible; esp8266 Lua;)"..
            "\r\n\r\n") 
  end)
  -- Extract the time from the answer
  conn:on("receive", function(conn, payload)
    local timestr = string.sub(payload,string.find(payload,"Date: ")
           +6,string.find(payload,"Date: ")+35)
    -- time looks like: Tue, 12 Apr 2016 16:26:31 GMT
    print('Time: '.. timestr)
    local firstComma=string.find(timestr, ",")
    dow=string.sub(timestr, 0, firstComma-1)
    nextParts=string.sub(timestr, firstComma+1)
    i=0
    hourminsectxt=nil
    -- Split the text at each space
    for str in string.gmatch(nextParts, "([^ ]+)") do
        if (i==0) then
          day=str
        elseif (i==1) then
          month=convertMonth(str)
        elseif (i==2) then
          year=str
        elseif (i==3) then
         hourminsectxt=str
        end
        i=i+1
    end
    -- Extract the time
    if (hourminsectxt ~= nil) then
       i=0
       -- split the text at each :
       for str in string.gmatch(hourminsectxt, "([^:]+)") do
        if (i==0) then
          hour=str
        elseif (i==1) then
          minutes=str
        elseif (i==2) then
          seconds=str
        end
        i=i+1
       end
    end
    print("---------------")
    year, month, day, hour, minutes, seconds = getLocalTime(year, month, day, hour, minutes, seconds,dow)
    print(year)
    print(month)
    print(day)
    print(hour)
    print(minutes)
    print(seconds)
    print("---------------")
    conn:close()
  end)
  conn:connect(80,'google.com')
end

-- Wait to be connect to the WiFi access point. 
tmr.alarm(0, 100, 1, function()
  if wifi.sta.status() ~= 5 then
     print("Connecting to AP...")
  else
     tmr.stop(0)
     print('IP: ',wifi.sta.getip())
     -- Initaly set the time
     startTimeupdate()
     
     -- Update the time each minute
     tmr.alarm(1, 60000, 1, function()
        startTimeupdate()
     end)
  end
end)