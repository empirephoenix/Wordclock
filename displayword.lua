-- Module filling a buffer, sent to the LEDs

function updateColor(data, inverseRow, characters2draw)
  if (inverseRow == nil) then
    inverseRow=false
  end
  -- special case, and there are exactly 4 words to display (so each word for each minute)
    if (not inverseRow) then -- nomral row
         if (data.drawnCharacters < data.charsPerMinute) then
            return data.colorFg
        elseif (data.drawnCharacters < data.charsPerMinute*2) then
            return data.colorMin1
        elseif (data.drawnCharacters < data.charsPerMinute*3) then 
            return data.colorMin2
        elseif (data.drawnCharacters > data.charsPerMinute*4) then 
            return data.colorMin3
        elseif (data.drawnCharacters > data.charsPerMinute*5) then 
            return data.colorMin4
        else
            return data.colorFg
        end
    else -- inverse row
        --FIXME magic missing to start on the left side
         if (data.drawnCharacters < data.charsPerMinute) then
                return data.colorMin1
        elseif (data.drawnCharacters < data.charsPerMinute*2) then
                return data.colorMin2
        elseif (data.drawnCharacters < data.charsPerMinute*3) then 
                return data.colorMin3
        elseif (data.drawnCharacters > data.charsPerMinute*4) then 
                return data.colorMin4
        else
            return data.colorFg
        end
    end
end

function drawLEDs(data, numberNewChars, inverseRow)
    if (inverseRow == nil) then
         inverseRow=false
    end
    if (numberNewChars == nil) then
        numberNewChars=0
    end
    print(tostring(numberNewChars)  .. " charactes " .. tostring(data.charsPerMinute) .. " per minute; " .. tonumber(data.drawnCharacters) .. " used characters")
    local tmpBuf=nil
    for i=1,numberNewChars do
        if (tmpBuf == nil) then
            tmpBuf = updateColor(data, inverseRow, numberNewChars)
        else
            tmpBuf=tmpBuf .. updateColor(data, inverseRow, numberNewChars)
        end
        data.drawnCharacters=data.drawnCharacters+1
    end
    data.drawnWords=data.drawnWords+1 
    return tmpBuf
end

-- Utility function for round
function round(num)
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

-- Module displaying of the words
function generateLEDs(words, colorForground, colorMin1, colorMin2, colorMin3, colorMin4, characters)
 -- Set the local variables needed for the colored progress bar
 data={}
 
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
 data.charsPerMinute = round( (characters / minutes) )
 
 -- devide by five (Minute 0, Minute 1 to Minute 4 takes the last chars)
 print("Minutes : " .. tostring(minutes) .. " Char minutes: " .. tostring(data.charsPerMinute) )
 data.words=words
 data.colorFg=colorForground
 data.colorMin1=colorMin1
 data.colorMin2=colorMin2
 data.colorMin3=colorMin3
 data.colorMin4=colorMin4
 data.drawnCharacters=0
 data.drawnWords=0
 data.amountWords=display_countwords_de(words)
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

