--TODO:

configFile="config.lua"

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
    sendWebPage(conn,1)
    conn:on("sent", function(conn) 
        conn:close() 
        -- Clear the webpage generation
        sendWebPage=nil
        print("Clean webpage from RAM")
        collectgarbage()
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
      if ( (_POST.red ~= nil) and (_POST.green ~= nil) and (_POST.blue ~= nil) ) then
        color=string.char(_POST.green, _POST.red, _POST.blue)  
      end
      file.write("color=string.char(" .. string.byte(color,1) .. "," .. string.byte(color, 2) .. "," .. string.byte(color, 3) .. ")\n print(\"Config from " .. sec .. "\")\n")
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
