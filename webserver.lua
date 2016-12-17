--TODO:

configFile="config.lua"

sentLines=0
sendFile=nil
function sendPage(conn, nameOfFile)
  if (sentLines > 0) then
   print("There is a site already sent")
   return
  end
  sendFile=nameOfFile

  if file.open(sendFile, "r") then
    local line = file.readLine()
    -- TODO replace the tokens in the line
    local buf=""
    while (line ~= nil) do
        buf = buf .. line
        sentLines= sentLines+1
        -- Sent after 1k data
        if (string.len(buf) >= 1000) then
            line=nil
            conn.send(buf)
        else
            -- fetch the next line
            line = file.readLine()
        end
    end
  end
  
  conn:on("sent", function(conn) 
    conn:close() 
    -- Clear the webpage generation
    sendWebPage=nil
    print("Clean webpage from RAM")
  end)

end

function startWebServer()
 srv=net.createServer(net.TCP)
 srv:listen(80,function(conn)
  conn:on("receive", function(conn,payload)
   
   if (payload:find("GET /") ~= nil) then
   --here is code for handling http request from a web-browser

    if (sendWebPage == nil) then
       print("Loading webpage ...")
       -- Load the webcontent
       mydofile("webpage")
    end
  
    ssid, password, bssid_set, bssid = wifi.sta.getconfig()
    endOfPage=false
    sendWebPage(conn,1)
    conn:on("sent", function(conn) 
        if (endOfPage==true) then
            conn:close() 
            -- Clear the webpage generation
            sendWebPage=nil
            print("Clean webpage from RAM")
            collectgarbage()
        else
            sendWebPage(conn,10)
        end
    end)

    
   else if (payload:find("POST /") ~=nil) then
     --code for handling the POST-request (updating settings)
     _, postdatastart = payload:find("\r\n\r\n")
     --Next lines catches POST-requests without POST-data....
     if postdatastart==nil then postdatastart = 1 end
     local postRequestData=string.sub(payload,postdatastart+1)
     local _POST = {}
     for i, j in string.gmatch(postRequestData, "(%w+)=([^&]+)&*") do
       _POST[i] = j
     end
     postRequestData=nil

     --- Do the magic!
     if (_POST.action ~= nil and _POST.action == "Reboot") then
        node.restart()
     end
    
      print("Inform user via Web")
      if (sendWebPage == nil) then
        print("Loading webpage ...")
        -- Load the webcontent
        mydofile("webpage")
      end
      
      conn:on("sent", function(conn) 
        conn:close() 
        -- Clear the webpage generation
        sendWebPage=nil
        print("Clean webpage from RAM")
      end)
     
     if ((_POST.ssid~=nil) and (_POST.sntpserver~=nil) and (_POST.timezoneoffset~=nil)) then
      print("New config!")
      if (_POST.password==nil) then
        _, password, _, _ = wifi.sta.getconfig()
        print("Restoring password : " .. password)
        _POST.password = password
        password = nil
      end
      -- Safe configuration:
      file.remove(configFile .. ".new")
      sec, _ = rtctime.get()
      file.open(configFile.. ".new", "w+")
      file.write("-- Config\n" .. "wifi.sta.config(\"" .. _POST.ssid .. "\",\"" .. _POST.password .. "\")\n" .. "sntpserverhostname=\"" .. _POST.sntpserver .. "\"\n" .. "timezoneoffset=\"" .. _POST.timezoneoffset .. "\"\n")
      if ( _POST.fcolor ~= nil) then
        -- color=string.char(_POST.green, _POST.red, _POST.blue)  
        print ("Got fcolor: " .. _POST.fcolor)
        local hexColor=string.sub(_POST.fcolor, 4)
        local red = tonumber(string.sub(hexColor, 1, 2), 16)
        local green = tonumber(string.sub(hexColor, 3, 4), 16)
        local blue = tonumber(string.sub(hexColor, 5, 6), 16)
        color=string.char(green, red, blue)
      end
      if ( _POST.colorMin1  ~= nil) then
        local hexColor=string.sub(_POST.colorMin1, 4)
        local red = tonumber(string.sub(hexColor, 1, 2), 16)
        local green = tonumber(string.sub(hexColor, 3, 4), 16)
        local blue = tonumber(string.sub(hexColor, 5, 6), 16)
        file.write("color1=string.char(" .. green .. "," .. red .. "," .. blue .. ")\n")
      end
      if ( _POST.colorMin2  ~= nil) then
        local hexColor=string.sub(_POST.colorMin2, 4)
        local red = tonumber(string.sub(hexColor, 1, 2), 16)
        local green = tonumber(string.sub(hexColor, 3, 4), 16)
        local blue = tonumber(string.sub(hexColor, 5, 6), 16)
        file.write("color2=string.char(" .. green .. "," .. red .. "," .. blue .. ")\n")
      end
      if ( _POST.colorMin3  ~= nil) then
        local hexColor=string.sub(_POST.colorMin3, 4)
        local red = tonumber(string.sub(hexColor, 1, 2), 16)
        local green = tonumber(string.sub(hexColor, 3, 4), 16)
        local blue = tonumber(string.sub(hexColor, 5, 6), 16)
        file.write("color3=string.char(" .. green .. "," .. red .. "," .. blue .. ")\n")
      end
      if ( _POST.colorMin4  ~= nil) then
        local hexColor=string.sub(_POST.colorMin4, 4)
        local red = tonumber(string.sub(hexColor, 1, 2), 16)
        local green = tonumber(string.sub(hexColor, 3, 4), 16)
        local blue = tonumber(string.sub(hexColor, 5, 6), 16)
        file.write("color4=string.char(" .. green .. "," .. red .. "," .. blue .. ")\n")
      end
      if ( _POST.colorMode ~= nil) then
        file.write("colorMode=true\n")
      else
        file.write("colorMode=nil\n") -- unset colorMode
      end
      time = getTime(sec, timezoneoffset)
      file.write("color=string.char(" .. string.byte(color,1) .. "," .. string.byte(color, 2) .. "," .. string.byte(color, 3) .. ")\n")
      file.write("print(\"Config from " .. time.year .. "-" .. time.month .. "-" .. time.day .. " " .. time.hour .. ":" .. time.minute .. ":" .. time.second .. "\")\n")
      if (_POST.threequater ~= nil) then
        file.write("threequater=true\n")
      else
        file.write("threequater=nil\n") -- unset threequater
      end
      file.close()
      sec=nil
      file.remove(configFile)
      print("Rename config")
      if (file.rename(configFile .. ".new", configFile)) then
        print("Successfully")
        dofile(configFile) -- load the new values
        sendWebPage(conn,2) -- success
      else
        print("Error")
        sendWebPage(conn,3) -- error
      end
      
     else
      ssid, password, bssid_set, bssid = wifi.sta.getconfig()
      sendWebPage(conn,4) -- not all parameter set
     end
    
    else
     print("Hello via telnet")
     --here is code, if the connection is not from a webbrowser, i.e. telnet or nc
     global_c=conn
     function s_output(str)
      if(global_c~=nil)
        then global_c:send(str)
      end
     end
     node.output(s_output, 0)
     global_c:on("receive",function(c,l)
       node.input(l)
     end)
     global_c:on("disconnection",function(c)
       node.output(nil)
       global_c=nil
     end)
     print("Welcome to Word Clock")
     
    end
   end
   end)
    
  conn:on("disconnection", function(c)
          node.output(nil)        -- un-register the redirect output function, output goes to serial
       end)
 end)

end
