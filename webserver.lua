--TODO:

configFile="config.lua"


function sendWebPage(conn,answertype)
  collectgarbage()
  if (ssid == nil) then
    ssid="Not set"
  end
  if (sntpserverhostname == nil) then
    sntpserverhostname="ptbtime1.ptb.de"
  end
  if (timezoneoffset == nil) then
    timezoneoffset=1
  end
  buf="HTTP/1.1 200 OK\nServer: NodeMCU\nContent-Type: text/html\n\n"
  if (node.heap() < 10000) then
  buf = buf .. "<h1>Busy, please come later again</h1>"
  else
  buf = buf .. "<html>"
  buf = buf .. "<head><title>WordClock Setup Page</title>"
  if (bennyHack ~= nil) then
  buf = buf .. "<style type=\"text/css\"> #table-6 { width: 100% border: 1px solid #B0B0B0; } "
  buf = buf .. "#table-6 tbody { margin: 0; padding: 0; border: 0; outline: 0; font-size: 100%; vertical-align: baseline; background: transparent; } #table-6 thead { text-align: left; } "
  buf = buf .. "#table-6 thead th { background: -moz-linear-gradient(top, #F0F0F0 0, #DBDBDB 100%);"
  buf = buf .. " background: -webkit-gradient(linear, left top, left bottom, color-stop(0%, #F0F0F0), color-stop(100%, #DBDBDB)); "
  buf = buf .. "filter: progid:DXImageTransform.Microsoft.gradient(startColorstr='#F0F0F0', endColorstr='#DBDBDB', GradientType=0); border: 1px solid #B0B0B0; color: #444; font-size: 16px; font-weight: bold; padding: 3px 10px; } "
  buf = buf .. "#table-6 td { padding: 3px 10px; }"
  buf = buf .. " #table-6 tr:nth-child(even) { background: #F2F2F2; } </style>"
  end
  buf = buf .. "</head><body>\n"
  buf = buf .. "<h1>Welcome to the WordClock</h1>Please note that all settings are mandatory<br /><br />"
  buf = buf .."<form action=\"\" method=\"POST\">"
  buf = buf .."<table id=\"table-6\">"
  buf = buf .."<tr><th>WIFI-SSID</b></th><td><input id=\"ssid\" name=\"ssid\" value=\"" .. ssid .. "\"></td><td>SSID of the wireless network</td></tr>"
  buf = buf .."<tr><th>WIFI-Password</th><td><input id=\"password\" name=\"password\"></td><td>Password of the wireless network</td></tr>"
  buf = buf .."<tr><th>SNTP Server</th><td><input id=\"sntpserver\" name=\"sntpserver\" value=\"" .. sntpserverhostname .. "\"></td><td>Server to sync the time with. Only one ntp server is allowed.</tr>"
  buf = buf .."<tr><th>Offset to UTC time</th><td><input id=\"timezoneoffset\" name=\"timezoneoffset\" value=\"" .. timezoneoffset .. "\"></td><td>Define the offset to UTC time in hours. For example +1 hour for Germany</tr>"
  buf = buf .. "<tr><td colspan=\"3\"><div align=\"center\"><input type=\"submit\" value=\"Save Configuration\" onclick=\"this.value='Submitting ..';this.disabled='disabled'; this.form.submit();\"></div></td></tr>"
  buf = buf .."</table></form>"
  if answertype==2 then
   buf = buf .. "<h2><font color=\"green\">New configuration saved</font></h2\n>"
  elseif answertype==3 then
   buf = buf .. "<h2><font color=\"red\">ERROR</font></h2\n>"
  elseif answertype==4 then
   buf = buf .. "<h2><font color=\"orange\">Not all parameters set</font></h2\n>"
  end 
  buf = buf .. "\n</body></html>"
  end
  conn:send(buf)
  buf=nil
  collectgarbage()
end

function startWebServer()
 srv=net.createServer(net.TCP)
 srv:listen(80,function(conn)
  conn:on("receive", function(conn,payload)
   if (payload:find("GET /") ~= nil) then
   --here is code for handling http request from a web-browser
    ssid, password, bssid_set, bssid = wifi.sta.getconfig()
    sendWebPage(conn,1)
    conn:on("sent", function(conn) conn:close() end)
   else if (payload:find("POST /") ~=nil) then
     --code for handling the POST-request (updating settings)
     _, postdatastart = payload:find("\r\n\r\n")
     --Next lines catches POST-requests without POST-data....
     if postdatastart==nil then postdatastart = 1 end
     postRequestData=string.sub(payload,postdatastart+1)
     local _POST = {}
     for i, j in string.gmatch(postRequestData, "(%w+)=([^&]+)&*") do
       _POST[i] = j
     end
     postRequestData=nil
     if ((_POST.ssid~=nil) and (_POST.password~=nil) and (_POST.sntpserver~=nil) and (_POST.timezoneoffset~=nil)) then

      -- Safe configuration:
      file.remove(configFile .. ".new")
      file.open(configFile.. ".new", "w")
      file.write("-- Config\n" .. "wifi.sta.config(\"" .. _POST.ssid .. "\",\"" .. _POST.password .. "\")\n" .. "sntpserverhostname=\"" .. _POST.sntpserver .. "\"\n" .. "timezoneoffset=\"" .. _POST.timezoneoffset .. "\"\n")
      file.close()
      file.remove(configFile)
      if (file.rename(configFile .. ".new", configFile)) then
        sendWebPage(conn,2) -- success
      else
        sendWebPage(conn,3) -- error
      end
     else
      ssid, password, bssid_set, bssid = wifi.sta.getconfig()
      sendWebPage(conn,4) -- not all parameter set
     end
     conn:on("sent", function(conn) conn:close() end)
    else
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
