dofile("wlancfg.lua")
print("Initialize Wordclock")

function startTimeupdate()
  -- Found: http://thearduinoguy.org/using-an-esp8266-as-a-time-source-part-2/
  -- retrieve the current time from Google
  conn=net.createConnection(net.TCP, 0) 
 
  conn:on("connection",function(conn, payload)
  conn:send("HEAD / HTTP/1.1\r\n".. 
            "Host: google.com\r\n"..
            "Accept: */*\r\n"..
            "User-Agent: Mozilla/4.0 (compatible; esp8266 Lua;)"..
            "\r\n\r\n") 
  end)
            
  conn:on("receive", function(conn, payload)
    print('Time: '..string.sub(payload,string.find(payload,"Date: ")
           +6,string.find(payload,"Date: ")+35))
    conn:close()
  end) 
  t = tmr.now()    
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