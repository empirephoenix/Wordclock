uart.setup(0, 115200, 8, 0, 1, 1 )

print("Init file end reached")
print("Autostart in 5 seconds...")

ws2812.init() -- WS2812 LEDs initialized on GPIO2
local buffer = ws2812.newBuffer(66*3+44*4, 1)

function clearLED()
  buffer:fill(0)
end

timer1 = tmr.create()
local RGBLEDS = 66
local RGBWLEDS= 43
MAXLEDS=RGBLEDS+RGBWLEDS

function setLED(index, r, g, b, w)
  if(index < RGBLEDS) then
    buffer:set(1+index*3, g)
    buffer:set(1+index*3+1, r)
    buffer:set(1+index*3+2, b)
  else 
    local indexRGBW = index-RGBLEDS
    buffer:set(1+RGBLEDS*3+indexRGBW*4,g)
    buffer:set(1+RGBLEDS*3+indexRGBW*4+1,r)
    buffer:set(1+RGBLEDS*3+indexRGBW*4+2,b)
    buffer:set(1+RGBLEDS*3+indexRGBW*4+3,w)
  end
end

--0 indexed!
function xy(x,y,r,g,b,w)
  if(y < 0)then
    error("Invalid y index " .. y)
  end
  if(x < 0)then
    error("Invalid x index " .. x)
  end
  if(y > 10)then
    error("Invalid y index " .. y)
  end
  if(x > 11)then
    error("Invalid x index " .. x)
  end
  x = x -1
  if(y == 1) then
    setLED(x,r,g,b,w)
  end
  if(y == 2) then
    setLED(10+ (11-x),r,g,b,w)
  end
  if(y == 3) then
    setLED(22+ x,r,g,b,w)
  end
  if(y == 4) then
    setLED(33+ x,r,g,b,w)
  end
  if(y == 5) then
    setLED(43+ (11-x),r,g,b,w)
  end
  if(y == 6) then
    setLED(55+ x,r,g,b,w)
  end
  if(y == 7) then
    setLED(66+ x,r,g,b,w)
  end
  if(y == 8) then
    setLED(76+ (11-x),r,g,b,w)
  end
  if(y == 9) then
    setLED(88+ x,r,g,b,w)
  end
  if(y == 10) then
    setLED(98+ (11-x),r,g,b,w)
  end
end

function drawLEDs()
  ws2812.write(buffer)
end

clearLED()
local r = 20
local g = 0
local b = 0
local w = 0
local x = 1
local y = 1
function initLED()
    xy(x,y, r,g,b,w)
    x = x+1
    if(x > 11)then
        x = 1
        y = y +1
    end
    if (y > 10) then
      y = 0
      if(r >0)then
        print("checking g next")
        g=r
        r=0
      elseif(g>0)then
        print("checking b next")
        b=g
        g=0
      elseif(b>0)then
        timer1:stop()
        timer1:unregister()
        dofile("main.lua")
        initLED = nil
      end
    end
    drawLEDs()
end

timer1:alarm(50, tmr.ALARM_AUTO,function()
    local ran, errorMsg = pcall(initLED)
    if not ran then
        print("init error " .. errorMsg)
    end
end)

