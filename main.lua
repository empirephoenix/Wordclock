dofile("wlancfg.lua")
dofile("timecore.lua")
dofile("wordclock.lua")

timezoneoffset=1

-- Wait to be connect to the WiFi access point. 
tmr.alarm(0, 100, 1, function()
  if wifi.sta.status() ~= 5 then
     print("Connecting to AP...")
  else
     tmr.stop(0)
     print('IP: ',wifi.sta.getip())

    --ptbtime1.ptb.de
    sntp.sync('ptbtime1.ptb.de',
     function(sec,usec,server)
      print('sync', sec, usec, server)
     end,
     function()
       print('failed!')
     end
   )

  end
end)

function generateLEDs(words)
 buf=""
 if (words.min4 == 1) then
    buf=string.char(0,0,50):rep(110)
  else
    buf=string.char(0,0,0):rep(110)
  end
  return buf
end

tmr.alarm(1, 1000, 1 ,function()
 sec, usec = rtctime.get()
 time = getTime(sec, timezoneoffset)
 print("Time : " , sec)
 print("Local time : " .. time.year .. "-" .. time.month .. "-" .. time.day .. " " .. time.hour .. ":" .. time.minute .. ":" .. time.second)

 words = display_timestat(time.hour, time.minute)
 ledBuf = generateLEDs(words)
 -- Write the buffer to the LEDs
 ws2812.write(4, ledBuf)
 
 for key,value in pairs(words) do 
    if (value > 0) then
      print(key,value) 
    end
 end
end)

