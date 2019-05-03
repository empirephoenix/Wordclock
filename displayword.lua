-- Module filling a buffer, sent to the LEDs
local M
do
local updateColor = function (data, inverseRow)
    --FIXME magic missing to start on the left side
    return data.colorFg
end

local drawLEDs = function(data, numberNewChars, inverseRow)
    if (inverseRow == nil) then
         inverseRow=false
    end
    if (numberNewChars == nil) then
        numberNewChars=0
    end
    local tmpBuf=nil
    for i=1,numberNewChars do
        if (tmpBuf == nil) then
            tmpBuf = updateColor(data, inverseRow)
        else
            tmpBuf=tmpBuf .. updateColor(data, inverseRow)
        end
        data.drawnCharacters=data.drawnCharacters+1
    end
    return tmpBuf
end

-- Utility function for round
local round = function(num)
    under = math.floor(num)
    upper = math.floor(num) + 1
    underV = -(under - num)
    upperV = upper - num
    if (upperV > underV) then
        return under
    else
        return upper
    end
end

local data={}

-- Module displaying of the words
local generateLEDs = function(words, colorForground, colorMin1, colorMin2, colorMin3, colorMin4)
 -- Set the local variables needed for the colored progress bar
 data={}

 if (words == nil) then
   return nil
 end

 -- Initial value of percentage
 if (words.briPercent == nil) then
    words.briPercent=50
 end
 
 local minutes=1
 if (words.min1 == 1) then
   minutes = minutes + 1
 elseif (words.min2 == 1) then
   minutes = minutes + 2
 elseif (words.min3 == 1) then
   minutes = minutes + 3
 elseif (words.min4 == 1) then
   minutes = minutes + 4
 end
 if (adc ~= nil) then
    local per = math.floor(100*adc.read(0)/1000)
    words.briPercent = tonumber( ((words.briPercent * 4) +  per) / 5)
    print("Minutes : " .. tostring(minutes) .. " bright: " .. tostring(words.briPercent) .. "% current: " .. tostring(per) .. "%")
    data.colorFg   = string.char(string.byte(colorForground,1) * briPercent / 100, string.byte(colorForground,2) * briPercent / 100, string.byte(colorForground,3) * briPercent / 100) 
    data.colorMin1 = string.char(string.byte(colorMin1,1) * briPercent / 100, string.byte(colorMin1,2) * briPercent / 100, string.byte(colorMin1,3) * briPercent / 100)
    data.colorMin2 = string.char(string.byte(colorMin2,1) * briPercent / 100, string.byte(colorMin2,2) * briPercent / 100, string.byte(colorMin2,3) * briPercent / 100)
    data.colorMin3 = string.char(string.byte(colorMin3,1) * briPercent / 100, string.byte(colorMin3,2) * briPercent / 100, string.byte(colorMin3,3) * briPercent / 100)
    data.colorMin4 = string.char(string.byte(colorMin4,1) * briPercent / 100, string.byte(colorMin4,2) * briPercent / 100, string.byte(colorMin4,3) * briPercent / 100)
 else
    -- devide by five (Minute 0, Minute 1 to Minute 4 takes the last chars)
    data.colorFg=colorForground
    data.colorMin1=colorMin1
    data.colorMin2=colorMin2
    data.colorMin3=colorMin3
    data.colorMin4=colorMin4
 end
 data.words=words
 data.drawnCharacters=0
 data.drawnWords=0
 local charsPerLine=11
 -- Space / background has no color by default
 local space=string.char(0,0,0)
 -- set FG to fix value:
 colorFg = string.char(255,255,255)

 -- Set the foreground color as the default color
 local buf=colorFg

 -- line 1----------------------------------------------
 if (words.it==1) then
    buf=drawLEDs(data,2) -- ES
  else
    buf=space:rep(2)
 end
-- K fill character
buf=buf .. space:rep(1)
 if (words.is == 1) then
    buf=buf .. drawLEDs(data,3) -- IST
 else
    buf=buf .. space:rep(3)
 end
 -- L fill character
buf=buf .. space:rep(1)
if (words.fiveMin== 1) then
    buf= buf .. drawLEDs(data,4) -- FUENF
  else
    buf= buf .. space:rep(4)
 end
 -- line 2-- even row (so inverted) --------------------
 if (words.twenty == 1) then
    buf= buf .. drawLEDs(data,7,true) -- ZWANZIG
  else
    buf= buf .. space:rep(7)
 end
 if (words.tenMin == 1) then
    buf= buf .. drawLEDs(data,4,true) -- ZEHN
  else
    buf= buf .. space:rep(4)
 end
 -- line3----------------------------------------------
 if (words.threequater == 1) then
    buf= buf .. drawLEDs(data,11) -- Dreiviertel
  elseif (words.quater == 1) then
    buf= buf .. space:rep(4)
    buf= buf .. drawLEDs(data,7) -- VIERTEL
 else
    buf= buf .. space:rep(11)
 end
 --line 4-------- even row (so inverted) -------------
 if (words.before == 1) then
    buf=buf .. space:rep(2) 
    buf= buf .. drawLEDs(data,3,true) -- VOR
  else
    buf= buf .. space:rep(5)
 end
 if (words.after == 1) then
    buf= buf .. drawLEDs(data,4,true) -- NACH
    buf= buf .. space:rep(2) -- TG
  else
    buf= buf .. space:rep(6)
 end
 ------------------------------------------------
 if (words.half == 1) then
    buf= buf .. drawLEDs(data,4) -- HALB
    buf= buf .. space:rep(1) -- X
  else
    buf= buf .. space:rep(5)
 end
 if (words.twelve == 1) then
    buf= buf .. drawLEDs(data,5) -- ZWOELF
    buf= buf .. space:rep(1) -- P
  else
    buf= buf .. space:rep(6)
 end
 ------------even row (so inverted) ---------------------
 if (words.seven == 1) then
    buf= buf .. drawLEDs(data,6,true) -- SIEBEN
    buf= buf .. space:rep(5)
 elseif (words.oneLong == 1) then
    buf= buf .. space:rep(5)
    buf= buf .. drawLEDs(data,4,true) -- EINS
    buf= buf .. space:rep(2)
 elseif (words.one == 1) then
    buf= buf .. space:rep(6)
    buf= buf .. drawLEDs(data,3,true) -- EIN
    buf= buf .. space:rep(2)
 elseif (words.two == 1) then
    buf= buf .. space:rep(7)
    buf= buf .. drawLEDs(data,4,true) -- ZWEI
 else
    buf= buf .. space:rep(11)
 end
 ------------------------------------------------
 if (words.three == 1) then
    buf= buf .. space:rep(1)
    buf= buf .. drawLEDs(data,4) -- DREI
    buf= buf .. space:rep(6)
  elseif (words.five == 1) then
    buf= buf .. space:rep(7)
    buf= buf .. drawLEDs(data,4) -- FUENF
 else
    buf= buf .. space:rep(11)
 end
 ------------even row (so inverted) ---------------------
 if (words.four == 1) then
    buf= buf .. drawLEDs(data,4,true) -- VIER
    buf= buf .. space:rep(7)
  elseif (words.nine == 1) then
    buf= buf .. space:rep(4)
    buf= buf .. drawLEDs(data,4,true) -- NEUN
    buf= buf .. space:rep(3)
 elseif (words.eleven == 1) then
    buf= buf .. space:rep(8)
    buf= buf .. drawLEDs(data,3,true) -- ELEVEN
 else
    buf= buf .. space:rep(11)
 end
 ------------------------------------------------
 if (words.eight == 1) then
    buf= buf .. space:rep(1)
    buf= buf .. drawLEDs(data,4) -- ACHT
    buf= buf .. space:rep(6)
  elseif (words.ten == 1) then
    buf= buf .. space:rep(5)
    buf= buf .. drawLEDs(data,4) -- ZEHN
    buf= buf .. space:rep(2)
 else
    buf= buf .. space:rep(11)
 end
 ------------even row (so inverted) ---------------------
 if (words.clock == 1) then
    buf= buf .. drawLEDs(data,3,true) -- UHR
  else
    buf= buf .. space:rep(3)
 end
 if (words.six == 1) then
    buf= buf .. space:rep(2)
    buf= buf .. drawLEDs(data,5,true) -- SECHS
    buf= buf .. space:rep(1)
  else
    buf= buf .. space:rep(8)
 end
 
 if (words.min1 == 1) then
    buf= buf .. colorFg
  else
    buf= buf .. space:rep(1)
 end
 if (words.min2 == 1) then
    buf= buf .. colorFg
  else
    buf= buf .. space:rep(1)
  end
 if (words.min3 == 1) then
    buf= buf .. colorFg
  else
    buf= buf .. space:rep(1)
  end
 if (words.min4 == 1) then
    buf= buf .. colorFg
  else
    buf= buf .. space:rep(1)
  end
  collectgarbage()
  return buf
end
M = {
    generateLEDs = generateLEDs,
    round        = round,
    drawLEDs     = drawLEDs,
    updateColor  = updateColor,
    data         = data,
}
end
return M