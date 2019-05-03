-- Main Module

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
    ws2812.write(ledBuf)
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
      displayTime()
     end,
     function()
       print('failed!')
     end
   )
end
briPercent = 50
function displayTime()
     local sec, usec = rtctime.get()
     -- Handle lazy programmer:
     if (timezoneoffset == nil) then
        timezoneoffset=0
     end
     local time = getTime(sec, timezoneoffset)
     local words = display_timestat(time.hour, time.minute)
     if ((dim ~= nil) and (dim == "on")) then
        words.briPercent=briPercent
     else
        words.briPercent=nil
     end
     dp = dofile("displayword.lc")
     if (dp ~= nil) then
        ledBuf = dp.generateLEDs(words, color, color1, color2, color3, color4)
        print("Local time : " .. time.year .. "-" .. time.month .. "-" .. time.day .. " " .. time.hour .. ":" .. time.minute .. ":" .. time.second .. " char: " .. tostring(dp.data.drawnCharacters))
     end
     dp = nil
     if (ledBuf ~= nil) then
     --if lines 4 to 6 are inverted due to hardware-fuckup, unfuck it here
	  if ((inv46 ~= nil) and (inv46 == "on")) then
		  tempstring = ledBuf:sub(1,99) -- first 33 leds
		  rowend = {44,55,66}
		  for _, startled  in ipairs(rowend) do
		      for i = 0,10 do
			      tempstring = tempstring .. ledBuf:sub((startled-i)*3-2,(startled-i)*3)
		      end
        end		  
	     tempstring = tempstring .. ledBuf:sub((67*3)-2,ledBuf:len())
     	  ws2812.write(tempstring)
		  tempstring=nil	
	  else
		  ws2812.write(ledBuf)
		  ledBuf=nil
	  end
	end
     -- Used for debugging
     if (clockdebug ~= nil) then
         for key,value in pairs(words) do 
            if (value > 0) then
              print(key,value) 
            end
         end
     end
     -- cleanup
     briPercent=words.briPercent
     words=nil
     time=nil
     collectgarbage()
end

function normalOperation()
    -- use default color, if nothing is defined
    if (color == nil) then
        -- Color is defined as GREEN, RED, BLUE
        color=string.char(0,0,250)
    end
   
    connect_counter=0
    -- Wait to be connect to the WiFi access point. 
    tmr.alarm(0, 500, 1, function()
      connect_counter=connect_counter+1
      if wifi.sta.status() ~= 5 then
         print(connect_counter ..  "/60 Connecting to AP...")
         if (connect_counter % 5 ~= 4) then
            local wlanColor=string.char((connect_counter % 6)*20,(connect_counter % 5)*20,(connect_counter % 3)*20)
            local space=string.char(0,0,0)
            local buf=space:rep(6)
            if ((connect_counter % 5) >= 1) then
                buf = buf .. wlanColor
            else
                buf = buf .. space
            end
            buf = buf .. space:rep(4)
            buf= buf .. space:rep(3) 
            if ((connect_counter % 5) >= 3) then
                buf = buf .. wlanColor
            else
                buf = buf .. space
            end
            if ((connect_counter % 5) >= 2) then
                buf = buf .. wlanColor
            else
                buf = buf .. space
            end
            if ((connect_counter % 5) >= 0) then
                buf = buf .. wlanColor
            else
                buf = buf .. space
            end
            buf = buf .. space:rep(100)
            ws2812.write(buf)
         else
           ws2812.write(string.char(0,0,0):rep(114))
         end
      else
        tmr.stop(0)
        print('IP: ',wifi.sta.getip())
        -- Here the WLAN is found, and something is done
        print("Solving dependencies")
        local dependModules = { "timecore" , "wordclock" }
        for _,mod in pairs(dependModules) do
            print("Loading " .. mod)
            mydofile(mod)
        end
        
        tmr.alarm(2, 500, 0 ,function()
            syncTimeFromInternet()
        end)
        tmr.alarm(3, 2000, 0 ,function()
            print("Start webserver...")
            mydofile("webserver")
            startWebServer()
        end)
        displayTime()
        -- Start the time Thread
        tmr.alarm(1, 10000, 1 ,function()
             displayTime()
             collectgarbage()
         end)
        
      end
      -- when no wifi available, open an accesspoint and ask the user
      if (connect_counter >= 60) then -- 300 is 30 sec in 100ms cycle
        startSetupMode()
      end
    end)
    
    
end

-------------------main program -----------------------------
ws2812.init() -- WS2812 LEDs initialized on GPIO2

if ( file.open("config.lua") ) then
    --- Normal operation
    wifi.setmode(wifi.STATION)
    dofile("config.lua")
    normalOperation()
else
    -- Logic for inital setup
    startSetupMode()
end
----------- button ---------
gpio.mode(3, gpio.INPUT)
btnCounter=0
-- Start the time Thread
tmr.alarm(4, 500, 1 ,function()
     if (gpio.read(3) == 0) then
        tmr.stop(1) -- stop the LED thread
        print("Button pressed " .. tostring(btnCounter))
        btnCounter = btnCounter + 5
        local ledBuf= string.char(128,0,0):rep(btnCounter) .. string.char(0,0,0):rep(110 - btnCounter)
        ws2812.write(ledBuf)
        if (btnCounter >= 110) then
            file.remove("config.lua")
            node.restart()
        end
     end
end)
