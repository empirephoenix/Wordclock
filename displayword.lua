-- Module filling a buffer, sent to the LEDs

function updateColor(data)
    if (data.usedCharacters <= data.charsPerMinute) then 
        if (data.words.min1 == 1) then
            return data.colorMin1
        else
            return data.colorFg
        end
    elseif (data.usedCharacters <= data.charsPerMinute*2) then 
        if (data.words.min2 == 1) then
            return data.colorMin2
        else
            return data.colorFg
        end
    elseif (data.usedCharacters <= data.charsPerMinute*3) then 
        if (data.words.min3 == 1) then
            return data.colorMin3
        else
            return data.colorFg
        end
    elseif (data.usedCharacters > data.charsPerMinute*3) then 
        if (data.words.min4 == 1) then
            return data.colorMin4
        else
            return data.colorFg
        end
    else
        return data.colorFg
    end
end

function drawLEDs(data, numberNewChars)
    local tmpBuf=nil
    for i=1,numberNewChars do
        if (tmpBuf == nil) then
            tmpBuf = updateColor(data)
        else
            tmpBuf=tmpBuf .. updateColor(data)
        end
        data.usedCharacters=data.usedCharacters+1
        
    end
    return tmpBuf
end

-- Module displaying of the words
function generateLEDs(words, colorFg, colorMin1, colorMin2, colorMin3, colorMin4, characters)
 -- Set the local variables needed for the colored progress bar
 data={}
 data.charsPerMinute=math.floor(characters/3) -- devide by three (Minute 1 to Minute 3, Minute 4 takes the last chars)
 data.words=words
 data.colorFg=colorFg
 data.colorMin1=colorMin1
 data.colorMin2=colorMin2
 data.colorMin3=colorMin3
 data.colorMin4=colorMin4
 data.usedCharacters=0
 local space=string.char(0,0,0)
 -- update the background color, if set
 if (colorBg ~= nil) then
   space = colorBg
 end

 -- Set the foreground color as the default color
 local buf=colorFg

 -- line 1----------------------------------------------
 if (words.itis == 1) then
    buf=drawLEDs(data,2) -- ES
    print(tostring(buf))
    -- K fill character
    buf=buf .. space:rep(1)
    buf=buf .. drawLEDs(data,3) -- IST
    -- L fill character
    buf=buf .. space:rep(1)
 else
    buf=space:rep(7)
 end
 if (words.fiveMin== 1) then
    buf= buf .. drawLEDs(data,4) -- FUENF
  else
    buf= buf .. space:rep(4)
 end
 -- line 2-- even row (so inverted) --------------------
 if (words.twenty == 1) then
    buf= buf .. drawLEDs(data,7) -- ZWANZIG
  else
    buf= buf .. space:rep(7)
 end
 if (words.tenMin == 1) then
    buf= buf .. drawLEDs(data,4) -- ZEHN
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
    buf= buf .. drawLEDs(data,3) -- VOR
  else
    buf= buf .. space:rep(5)
 end
 if (words.after == 1) then
    buf= buf .. drawLEDs(data,4) -- NACH
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
    buf= buf .. drawLEDs(data,6) -- SIEBEN
    buf= buf .. space:rep(5)
 elseif (words.oneLong == 1) then
    buf= buf .. space:rep(5)
    buf= buf .. drawLEDs(data,4) -- EINS
    buf= buf .. space:rep(2)
 elseif (words.one == 1) then
    buf= buf .. space:rep(6)
    buf= buf .. drawLEDs(data,3) -- EIN
    buf= buf .. space:rep(2)
 elseif (words.two == 1) then
    buf= buf .. space:rep(7)
    buf= buf .. drawLEDs(data,4) -- ZWEI
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
    buf= buf .. drawLEDs(data,4) -- VIER
    buf= buf .. space:rep(7)
  elseif (words.nine == 1) then
    buf= buf .. space:rep(4)
    buf= buf .. drawLEDs(data,4) -- NEUN
    buf= buf .. space:rep(3)
 elseif (words.eleven == 1) then
    buf= buf .. space:rep(8)
    buf= buf .. drawLEDs(data,3) -- ELEVEN
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
    buf= buf .. drawLEDs(data,3) -- UHR
  else
    buf= buf .. space:rep(3)
 end
 if (words.six == 1) then
    buf= buf .. space:rep(2)
    buf= buf .. drawLEDs(data,5) -- SECHS
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
