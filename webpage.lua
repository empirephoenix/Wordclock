-------------
--- The webpage for the Webserver
function sendWebPage(conn,answertype)
  if (ssid == nil) then
    ssid="Not set"
  end
  if (sntpserverhostname == nil) then
    sntpserverhostname="ptbtime1.ptb.de"
  end
  if (timezoneoffset == nil) then
    timezoneoffset=1
  end
  -- Set the default color, if nothing is set
  if (color == nil) then
    color=string.char(0,0,250)
  end
  local hexColor = "#" .. string.format("%02x",string.byte(color,1)) .. string.format("%02x",string.byte(color,2)) .. string.format("%02x",string.byte(color,3))
  local buf="HTTP/1.1 200 OK\nServer: NodeMCU\nContent-Type: text/html\n\n"
  if (node.heap() < 8000) then
  buf = buf .. "<h1>Busy, please come later again</h1>"
  else
  buf = buf .. "<html>"
  buf = buf .. "<head><title>WordClock Setup Page</title>"
  buf = buf .. "</head><body>\n"
  buf = buf .. "<h1>Welcome to the WordClock</h1>"
  buf = buf .."<form action=\"\" method=\"POST\">"
  buf = buf .."<table>"
  buf = buf .."<tr><th>WIFI-SSID</b></th><td><input name=\"ssid\" value=\"" .. ssid .. "\"></td><td /></tr>"
  buf = buf .."<tr><th>WIFI-Password</th><td><input name=\"password\"></td><td /></tr>"
  buf = buf .."<tr><th>SNTP Server</th><td><input name=\"sntpserver\" value=\"" .. sntpserverhostname .. "\"></td><td>ntp server to sync the time</tr>"
  buf = buf .."<tr><th>Offset to UTC time</th><td><input type=\"number\" name=\"timezoneoffset\" value=\"" .. timezoneoffset .. "\"></td><td>Define the offset to UTC time in hours. E.g +1</tr>"  
  buf = buf .."<tr><th>Color</th><td><input type=\"color\" name=\"fcolor\" value=\"" .. hexColor .. "\"></td><td /></tr>"
  buf = buf .."<tr><th>Three quater</th><td><input type=\"checkbox\" name=\"threequater\" ".. (threequater and "checked" or "") .. "></td><td>Dreiviertel Joa/nei</td></tr>"
  buf = buf .. "<tr><td colspan=\"3\"><div align=\"center\"><input type=\"submit\" value=\"Save Configuration\" onclick=\"this.value='Submitting ..';this.disabled='disabled'; this.form.submit();\"></div></td></tr>"
  buf = buf .. "<tr><td colspan=\"3\"><div align=\"center\"><input type=\"submit\" name=\"action\" value=\"Reboot\"></div></td></tr>"
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
