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
  if (color1 == nil) then
    color1=color
  end
  if (color2 == nil) then
    color2=color
  end
  if (color3 == nil) then
    color3=color
  end
  if (color4 == nil) then
    color4=color
  end
  local hexColor = "#" .. string.format("%02x",string.byte(color,1)) .. string.format("%02x",string.byte(color,2)) .. string.format("%02x",string.byte(color,3))
  local hexColor1 = "#" .. string.format("%02x",string.byte(color1,1)) .. string.format("%02x",string.byte(color1,2)) .. string.format("%02x",string.byte(color1,3))
  local hexColor2 = "#" .. string.format("%02x",string.byte(color2,1)) .. string.format("%02x",string.byte(color2,2)) .. string.format("%02x",string.byte(color2,3))
  local hexColor3 = "#" .. string.format("%02x",string.byte(color3,1)) .. string.format("%02x",string.byte(color3,2)) .. string.format("%02x",string.byte(color3,3))
  local hexColor4 = "#" .. string.format("%02x",string.byte(color4,1)) .. string.format("%02x",string.byte(color4,2)) .. string.format("%02x",string.byte(color4,3))
  
  

  
  local buf="HTTP/1.1 200 OK\nServer: NodeMCU\nContent-Type: text/html\n\n"
  if (node.heap() < 8000) then
    buf = buf .. "<h1>Busy, please come later again</h1>"
    endOfPage=true
  else

  -- hack for the second part of the page
  buf=nil
  if (answertype==10) then
      buf = "<tr><th>1. Minute Color</th><td><input type=\"color\" name=\"colorMin1\" value=\"" .. hexColor1 .. "\"></td><td /></tr>"
      buf = buf .."<tr><th>2. Minute Color</th><td><input type=\"color\" name=\"colorMin2\" value=\"" .. hexColor2 .. "\"></td><td /></tr>"
      buf = buf .."<tr><th>3. Minute Color</th><td><input type=\"color\" name=\"colorMin3\" value=\"" .. hexColor3 .. "\"></td><td /></tr>"
      buf = buf .."<tr><th>4. Minute Color</th><td><input type=\"color\" name=\"colorMin4\" value=\"" .. hexColor4 .. "\"></td><td /></tr>"
      buf = buf .."<tr><th>Three quater</th><td><input type=\"checkbox\" name=\"threequater\" ".. (threequater and "checked" or "") .. "></td><td>Dreiviertel Joa/nei</td></tr>"
      --buf = buf .."<tr><th>ColorMode</th><td><input type=\"checkbox\" name=\"threequater\" ".. (colorMode and "checked" or "") .. "></td><td>If checked, words are dark, rest is colored</td></tr>"
      buf = buf .. "<tr><td colspan=\"3\"><div align=\"center\"><input type=\"submit\" value=\"Save Configuration\" onclick=\"this.value='Submitting ..';this.disabled='disabled'; this.form.submit();\"></div></td></tr>"
      buf = buf .. "<tr><td colspan=\"3\"><div align=\"center\"><input type=\"submit\" name=\"action\" value=\"Reboot\"></div></td></tr>"
      buf = buf .."</table></form>"
      conn:send(buf)
      buf=nil
      collectgarbage()
      -- Code will only be added once the page is loaded
      endOfPage=true
      return
  end
  
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
