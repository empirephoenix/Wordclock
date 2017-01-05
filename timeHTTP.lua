-- timeHTTP.lua
-- Retrieve the current time of a given webserver

-- Some local variables, needed to receive the time
local httpRequestRunning=false
local gYear=nil
local gMon=nil
local gDay=nil
local gHour=nil
local gMin=nil
local gSec=nil
local gDow=nil

-- The function will trigger a callback, when received the answer of the webserver
-- Example Callback: 
-- function httpTimeCB(time)
--   for key,value in pairs(time) do 
--       print(key,value) 
--   end
-- end
-- The Function call would look like the following:
-- getTimeViaHTTP("www.google.com", httpTimeCB)
function getTimeViaHTTP(httpServer, callback)
    collectgarbage()
    
    httpconn=net.createConnection(net.TCP, 0)
    httpconn:on("disconnection", function(con)
        print("[HTTP] Connection closed")
        httpRequestRunning=false
        if (callback ~= nil) then
            callback({ year = gYear, month = gMon, day = gDay, hour = gHour, minute = gMin, second = gSec, dow = gDow })
        end
    end)
    httpconn:on("receive", function(con, pl) 
        --print("[HTTP]" .. pl)
        local dow, day, month, year, hour, min, sec =string.match(pl, "Date: (%w+), (%d+) (%w+) (%d+) (%d+):(%d+):(%d+)")
        
        if (hour ~= nil) then
            --decode Day of week
            if ( dow == "Mon" ) then
                gDow=1
            elseif ( dow == "Tue" ) then
                gDow=2
            elseif ( dow == "Wed" ) then
                gDow=3
            elseif ( dow == "Thu" ) then
                gDow=4
            elseif ( dow == "Fri" ) then
                gDow=5
            elseif ( dow == "Sat" ) then
                gDow=6
            elseif ( dow == "Sun" ) then
                gDow=7
            else
                gDow=0
            end
            -- decode month
            if ( month == "Jan" ) then
                gMon=1
            elseif ( month == "Feb" ) then
                gMon=2
            elseif ( month == "Mar" ) then
                gMon=3
            elseif ( month == "Apr" ) then
                gMon=4
            elseif ( month == "May" ) then
                gMon=5
            elseif ( month == "Jun" ) then
                gMon=6
            elseif ( month == "Jul" ) then
                gMon=7
            elseif ( month == "Aug" ) then
                gMon=8
            elseif ( month == "Sep" ) then
                gMon=9
            elseif ( month == "Oct" ) then
                gMon=10
            elseif ( month == "Nov" ) then
                gMon=11
            elseif ( month == "Dec" ) then
                gMon=12
            else
                gMon=0
            end
            
            gYear=year
            gHour=hour
            gMin=min
            gSec=sec
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
