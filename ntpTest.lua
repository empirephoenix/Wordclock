dofile("wlancfg.lua")

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
    sntp.sync('192.53.103.108',
     function(sec,usec,server)
      print('sync', sec, usec, server)
     end,
     function()
       print('failed!')
     end
   )

  end
end)


EPOCH_YR=1970
--SECS_DAY=(24L * 60L * 60L)
SECS_DAY=86400

gettime = function(unixtimestmp)
  local year = EPOCH_YR
  local dayclock = math.floor(unixtimestmp % SECS_DAY)
  local dayno = math.floor(unixtimestmp / SECS_DAY)

  local sec = dayclock % 60
  local min = math.floor( (dayclock % 3600) / 60)
  local hour = math.floor(dayclock / 3600)
  local wday = math.floor( (dayno + 4) % 7) -- Day 0 was a thursday

  return  hour, min, sec
end

tmr.alarm(1, 1000, 1 ,function()
 sec, usec = rtctime.get()
 print("Time : " , sec)
 hour, min, sec = gettime(sec)
 print(hour, " ", min, " ", sec)
end)

