-- timeHTTP.lua
-- Retrieve the current time of a given webserver

-- Some local variables, needed to receive the time
local httpRequestRunning=false
local gHour=nil
local gMin=nil

-- The function will trigger a callback, when received the answer of the webserver
-- Example Callback: 
-- function httpTimeCB(hour, minutes)
--    print("Received " .. hour .. ":" .. minutes)
-- end
-- The Function call would look like the following:
-- getTimeViaHTTP("www.google.com",0, httpTimeCB)
function getTimeViaHTTP(httpServer, hourOffset, callback)
    if (hourOffset == nil) then
        hourOffset=0
    end
    collectgarbage()
    
    httpconn=net.createConnection(net.TCP, 0)
    httpconn:on("disconnection", function(con)
        print("[HTTP] Connection closed")
        httpRequestRunning=false
        if (callback ~= nil) then
            callback(gHour, gMin)
        end
    end)
    httpconn:on("receive", function(con, pl) 
        --print("[HTTP]" .. pl)
        local hour, min, sec =string.match(pl, "Date: %w+, %d+ %w+ %d+ (%d+):(%d+):(%d+)")
        
        if (hour ~= nil) then
            hour = (hour + hourOffset) % 24
            print("[HTTP] Hour:" .. hour)
            print("[HTTP] Min: " .. min)
            print("[HTTP] Sec: " .. sec)
            gHour=hour
            gMin=min
        end
        httpconn:close()
    end)
    httpconn:connect(80, httpServer)
    httpconn:on("connection", function(sck, c)
      -- Wait for connection before sending.
      httpconn:send("GET / HTTP/1.1\r\nAccept: */*\r\n\r\n")
      httpRequestRunning=true
      print("[HTTP] Started request " .. httpServer)
    end)
    print("[HTTP] Connecting to " .. httpServer)
end
