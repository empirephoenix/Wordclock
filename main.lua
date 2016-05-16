dofile("wlancfg.lua")
dofile("timecore.lua")

timezoneoffset=1

-- Wait to be connect to the WiFi access point. 
tmr.alarm(0, 100, 1, function()
  if wifi.sta.status() ~= 5 then
     print("Connecting to AP...")
  else
     tmr.stop(0)
     -- Switch of the booting lamp
     gpio.write(5, gpio.LOW)
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


tmr.alarm(1, 1000, 1 ,function()
 sec, usec = rtctime.get()
 time = getTime(sec, timezoneoffset)
 print("Time : " , sec)
 print("Local time : " .. time.year .. "-" .. time.month .. "-" .. time.day .. " " .. time.hour .. ":" .. time.minute .. ":" .. time.second)
end)

