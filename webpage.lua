-------------
--- The webpage for the Webserver
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
  local buf="HTTP/1.1 200 OK\nServer: NodeMCU\nContent-Type: text/html\n\n"
  if (node.heap() < 8000) then
  buf = buf .. "<h1>Busy, please come later again</h1>"
  else
  buf = buf .. "<html>"
  buf = buf .. "<head><title>WordClock Setup Page</title>"
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