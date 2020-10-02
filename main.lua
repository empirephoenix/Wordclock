nightMode = true

colors = {}
colors.misc={}
colors.misc.r = 64
colors.misc.g = 64
colors.min={}
colors.min.g = 64
colors.min.b = 64
colors.part={}
colors.part.r = 64
colors.part.b = 64
colors.seperator={}
colors.seperator.r=128
colors.hour={}
colors.hour.g=128

local function syncTimeFromInternet()
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

function displayTimeUnsafe()
     sec, usec = rtctime.get()
     -- Handle lazy programmer:
     if (timezoneoffset == nil) then
        timezoneoffset=1
     end
     local time = getTime(sec, timezoneoffset)
     local words = display_timestat(time.hour, time.minute)

     local charactersOfTime = display_countcharacters_de(words)
     local wordsOfTime = display_countwords_de(words)
     generateLEDs(words, charactersOfTime)

    print("Local time : " .. time.year .. "-" .. time.month .. "-" .. time.day .. " " .. time.hour .. ":" .. time.minute .. ":" .. time.second .. " in " .. charactersOfTime .. " chars " .. wordsOfTime .. " words")

    drawLEDs()
    collectgarbage()
end

function displayTime()
    local ran, errorMsg = pcall(displayTimeUnsafe)
    if not ran then
        print("updateDisplay " .. errorMsg)
    end
      
end


local mqttReady = false
local mqttReconnectTimer = tmr.create()
local mqqtCurrentClient = nil
local function mqttConnectedCallback()
  mqqtCurrentClient:publish("wordclock/tele/error","", 0, 1)

  local tbl = {}
  tbl.colors = colors
  tbl.nightmode = nightMode
  local data = sjson.encode(tbl)
  mqqtCurrentClient:publish("wordclock/samplecommand/", data, 0, 1)
  mqqtCurrentClient:subscribe("wordclock/command", 0)
  mqttReady = true
end

local function mqttErrorCallback(mqttClient, errorCode)
  print("Error connecting mqtt: "..errorCode)
  mqttReady = false
  mqttReconnectTimer:alarm(mqtt_cfg.reconnectRetryDelay or 10,tmr.ALARM_SINGLE, connectMqtt)
end

function connectMqtt()
    print("Connecting mqtt to " .. mqtt_cfg.host .. " port " .. mqtt_cfg.port)
    mqqtCurrentClient:connect(mqtt_cfg.host, mqtt_cfg.port,false, mqttConnectedCallback,mqttErrorCallback)
end

local function decodeData(data)
  local msg = sjson.decode(data)
  nightMode = msg.nightmode
  if(msg.colors)then
    colors = msg.colors
  end
  displayTime()
end

local function loadStuff()
    dofile("timecore.lua")
    dofile("wordclock.lua")
    dofile("displayword.lua")
    print("after files")
    mqqtCurrentClient = mqtt.Client(mqtt_cfg.clientId, mqtt_cfg.keepAlive or 10, mqtt_cfg.userName, mqtt_cfg.password , true, 256)
    mqqtCurrentClient:lwt("wordclock/tele/error","Wordclock testament executed", 0, 1)
    local consolePrint = print
    print = function(msg)
      consolePrint(msg)
      if(mqttReady)then
        local json = {}
        json.msg = msg
        local data = sjson.encode(json)
        mqqtCurrentClient:publish("wordclock/tele/log", data, 0, 0)
      end
    end

    mqqtCurrentClient:on("message", function(client, topic, data)
      if data ~= nil then
        local ran, errorMsg = pcall(decodeData,data)
        if not ran then
            print("mqqtread " .. errorMsg)
        end
      end
    end)

    mqqtCurrentClient:on("overflow", function(client, topic, data)
      print(topic .. " partial overflowed message: " .. data )
    end)


    connectMqtt()
    loadStuff = nil
end

local function normalOperation()
  clearLED()
  drawLEDs()

  local connect_counter=0
  -- Wait to be connect to the WiFi access point. 
  timer1:alarm(1000, tmr.ALARM_AUTO, function()
    connect_counter=connect_counter+1
    if wifi.sta.status() ~= 5 then
        print(connect_counter ..  "/60 Connecting to AP...")
        local r = (connect_counter % 6) * 20
        local g = (connect_counter % 5)*20
        local b = (connect_counter % 3)*20
        clearLED()
        if (connect_counter % 2 == 0) then
          xy(7,1,r,g,b,0)
          xy(6,2,r,g,b,0)
          xy(7,2,r,g,b,0)
          xy(8,2,r,g,b,0)
          drawLEDs()
        else
          xy(7,5,r,g,b,0)
          xy(7,6,r,g,b,0)
          xy(8,7,r,g,b,0)
          xy(9,8,r,g,b,0)
          drawLEDs()
        end
    else
      timer1:stop()
      print('IP: ',wifi.sta.getip())
      local ran, errorMsg = pcall(loadStuff)
      if ran then
        local syncTimer = tmr.create()
        syncTimer:alarm(500, tmr.ALARM_SINGLE ,function()
          syncTimeFromInternet()
        end)
        displayTime()
            -- Start the time Thread
        timer1:alarm(20000, tmr.ALARM_AUTO ,function()
          displayTime()
        end)
      else
        print("loadingFiles " .. errorMsg)
      end
    end
  end)

end

wifi.setmode(wifi.STATION)
dofile("config.lua")
wifi.sta.config(station_cfg)

normalOperation()

