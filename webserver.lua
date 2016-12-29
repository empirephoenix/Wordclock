--TODO:

configFile="config.lua"

sentBytes=0
function sendPage(conn, nameOfFile)
  
  conn:on("sent", function(conn) 
    if (sentBytes == 0) then
        conn:close() 
        print("Page sent")
    else 
        sendPage(conn, nameOfFile)
    end
  end)

  if file.open(nameOfFile, "r") then
    local buf=""
    if (sentBytes <= 0) then
        buf=buf .. "HTTP/1.1 200 OK\r\n"
        buf=buf .. "Content-Type: text/html\r\n"
        buf=buf .. "Connection: close\r\n"
        buf=buf .. "Date: Thu, 29 Dec 2016 20:18:20 GMT\r\n"
        buf=buf .. "\r\n\r\n"
    end
    -- amount of sent bytes is always zero at the beginning (so no problem)
    file.seek("set", sentBytes)
    
    local line = file.readline()
    -- TODO replace the tokens in the line
    while (line ~= nil) do
        buf = buf .. line
        -- increase the amount of sent bytes
        sentBytes=sentBytes+string.len(line)
        -- Sent after 1k data
        if (string.len(buf) >= 500) then
            line=nil
            conn:send(buf)
            -- end the function, this part is sent
            return 
        else
            -- fetch the next line
            line = file.readline()
        end
    end
    --reset amount of sent bytes, as we reached the end
    sentBytes=0
    -- send the rest
    conn:send(buf)
  end
  
  

end

function startWebServer()
 srv=net.createServer(net.TCP)
 srv:listen(80,function(conn)
  conn:on("receive", function(conn,payload)
   
   if (payload:find("GET /") ~= nil) then
   --here is code for handling http request from a web-browser

    if (sendPage ~= nil) then
       print("Sending webpage.html ...")
       -- Load the sendPagewebcontent
       sendPage(conn, "webpage.html")
    end
    
   else if (payload:find("POST /") ~=nil) then
    -- Fixme handle it later
    print("POST request detected")
    
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
          
          --reset amount of sent bytes, as we reached the end
          sentBytes=0
       end)
 end)

end
