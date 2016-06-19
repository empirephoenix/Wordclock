-- Main Module
ledPin=4

function startSetupMode()
    tmr.stop(0)
    tmr.stop(1)
    -- start the webserver module 
    mydofile("webserver")
    
    wifi.setmode(wifi.SOFTAP)
    cfg={}
    cfg.ssid="wordclock"
    cfg.pwd="wordclock"
    wifi.ap.config(cfg)

    -- Write the buffer to the LEDs
    local color=string.char(0,128,0)
    local white=string.char(0,0,0)
    local ledBuf= white:rep(6) .. color .. white:rep(7) .. color:rep(3) .. white:rep(44) .. color:rep(3) .. white:rep(50)
    ws2812.write(ledPin, ledBuf)
    color=nil
    white=nil
    ledBuf=nil
    
    print("Waiting in access point >wordclock< for Clients")
    print("Please visit 192.168.4.1")
    startWebServer()
    collectgarbage()
end


function syncTimeFromInternet()
--ptbtime1.ptb.de
    sntp.sync(sntpserverhostname,
     function(sec,usec,server)
      print('sync', sec, usec, server)
     end,
     function()
       print('failed!')
     end
   )
end

function displayTime()
    sec, usec = rtctime.get()
             
     time = getTime(sec, timezoneoffset)
     print("Local time : " .. time.year .. "-" .. time.month .. "-" .. time.day .. " " .. time.hour .. ":" .. time.minute .. ":" .. time.second)
     words = display_timestat(time.hour, time.minute)
     ledBuf = generateLEDs(words, color)
     -- Write the buffer to the LEDs
     ws2812.write(ledPin, ledBuf)
    
     -- Used for debugging
     if (clockdebug ~= nil) then
         for key,value in pairs(words) do 
            if (value > 0) then
              print(key,value) 
            end
         end
     end
     -- cleanup
     ledBuf=nil
     words=nil
     time=nil
     collectgarbage()
end

function normalOperation()
    -- Color is defined as GREEN, RED, BLUE
    color=string.char(0,0,250)
   
    connect_counter=0
    -- Wait to be connect to the WiFi access point. 
    tmr.alarm(0, 1000, 1, function()
      connect_counter=connect_counter+1
      if wifi.sta.status() ~= 5 then
         print(connect_counter ..  "/60 Connecting to AP...")
         if (connect_counter % 2 == 0) then
            ws2812.write(ledPin, string.char((connect_counter % 6)*20,(connect_counter % 5)*20,(connect_counter % 3)*20):rep(114))
         else
           ws2812.write(ledPin, string.char(0,0,0):rep(114))
         end
      else
        tmr.stop(0)
        print('IP: ',wifi.sta.getip())
        -- Here the WLAN is found, and something is done
        print("Solving dependencies")
        local dependModules = { "timecore" , "wordclock", "displayword" }
        for _,mod in pairs(dependModules) do
            print("Loading " .. mod)
            mydofile(mod)
        end
        
        tmr.alarm(2, 500, 0 ,function()
            syncTimeFromInternet()
        end)
        print("Start webserver...")
        tmr.alarm(3, 2000, 0 ,function()
            mydofile("webserver")
            startWebServer()
        end)

        displayTime()
        -- Start the time Thread
        tmr.alarm(1, 20000, 1 ,function()
             displayTime()
         end)
        
      end
      -- when no wifi available, open an accesspoint and ask the user
      if (connect_counter >= 60) then -- 300 is 30 sec in 100ms cycle
        startSetupMode()
      end
    end)
    
    
end



if ( file.open("config.lua") ) then
    --- Normal operation
    wifi.setmode(wifi.STATION)
    dofile("config.lua")
    normalOperation()
else
    -- Logic for inital setup
    startSetupMode()
end
