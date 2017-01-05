-- Retrieve the current time of a given webserver

local httpRequestRunning=false

function getTimeViaHTTP(httpServer, hourOffset)
    if (hourOffset == nil) then
        hourOffset=0
    end

    httpconn=net.createConnection(net.TCP, 0)
    httpconn:on("disconnection", function(con)
        print("[HTTP] Connection closed")
        httpRequestRunning=false
    end)
    httpconn:on("receive", function(con, pl) 
        --print("[HTTP]" .. pl)
        local hour, min, sec =string.match(pl, "Date: %w+, %d+ %w+ %d+ (%d+):(%d+):(%d+)")
        
        if (hour ~= nil) then
            hour = (hour + hourOffset) % 24
            print("[HTTP] Hour:" .. hour)
            print("[HTTP] Min: " .. min)
            print("[HTTP] Sec: " .. sec)
        end
    end)
    httpconn:connect(80, httpServer)
    httpconn:on("connection", function(sck, c)
      -- Wait for connection before sending.
      
      httpconn:send("GET / HTTP/1.1\r\nAccept: */*\r\n\r\n")
      --httpconn:send("GET / HTTP/1.1\r\n\r\n")
      httpRequestRunning=true
      print("[HTTP] Started request " .. httpServer)
    end)
    print("[HTTP] Connecting to " .. httpServer)
end