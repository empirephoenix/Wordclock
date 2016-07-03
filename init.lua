print("Autostart in 10 seconds...")

ws2812.init() -- WS2812 LEDs initialized on GPIO2

counter1=0
ws2812.write(string.char(0,0,0):rep(114))
tmr.alarm(2, 85, 1, function()
    counter1=counter1+1
    ws2812.write(string.char(128,0,0):rep(counter1))     
end)

local blacklistfile="init.lua config.lua"
function recompileAll()
    -- compile all files
    l = file.list();
    for k,_ in pairs(l) do
      if (string.find(k, ".lc", -3)) then
        print ("Skipping " .. k)
      elseif  (string.find(blacklistfile, k) == nil) then
        print("Compiling and deleting " .. k)
        node.compile(k)
        -- remove the lua file
        file.remove(k)
      end
    end
end

function mydofile(mod)
    if (file.open(mod ..  ".lua")) then
      dofile( mod .. ".lua")
    else
      dofile(mod .. ".lc")
    end
end    


tmr.alarm(1, 10000, 0, function()
    tmr.stop(2)
    if (file.open("main.lua")) then    
        recompileAll()
        print("Rebooting ...")
        -- reboot repairs everything
        node.restart()
    elseif (file.open("main.lc")) then
        print("Starting main")      
        dofile("main.lc")
    else
        print("No Main file found")
    end
end)
