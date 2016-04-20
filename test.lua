dofile("wlancfg.lua")
dofile("timecore.lua")
dofile("wordclock.lua")
print("Initialize Wordclock")

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
    -- Manually set something
    leds=display_timestat(hour,minutes)
    for k,v in pairs(leds) do 
        if (v == 1) then
            print(k) 
        end
    end
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
