
-- Module displaying of the words
function generateLEDs(words, colorForground, colorMin1, colorMin2, colorMin3, colorMin4, characters)
 -- Set the local variables needed for the colored progress bar
 local charsPerMinute=math.floor(characters/5)
 local charsPerLine=11
 -- Space / background has no color by default
 local space=string.char(0,0,0)
 -- set FG to fix value:
 colorFg = string.char(255,255,255)

 -- Set the foreground color as the default color
 local buf=colorFg

 -- line 1----------------------------------------------
 if (words.it==1) then
    buf=colorFg:rep(2) -- ES
  else
    buf=space:rep(2)
 end
-- K fill character
buf=buf .. space:rep(1)
 if (words.is == 1) then
    buf=buf .. colorFg:rep(3) -- IST
 else
    buf=buf .. space:rep(3)
 end
 -- L fill character
buf=buf .. space:rep(1)
if (words.fiveMin== 1) then
    buf= buf .. colorFg:rep(4) -- FUENF
  else
    buf= buf .. space:rep(4)
 end
 -- line 2-- even row (so inverted) --------------------
 if (words.twenty == 1) then
    buf= buf .. colorFg:rep(7,true) -- ZWANZIG
  else
    buf= buf .. space:rep(7)
 end
 if (words.tenMin == 1) then
    buf= buf .. colorFg:rep(4,true) -- ZEHN
  else
    buf= buf .. space:rep(4)
 end
 -- line3----------------------------------------------
 if (words.threequater == 1) then
    buf= buf .. colorFg:rep(11) -- Dreiviertel
  elseif (words.quater == 1) then
    buf= buf .. space:rep(4)
    buf= buf .. colorFg:rep(7) -- VIERTEL
 else
    buf= buf .. space:rep(11)
 end
 --line 4-------- even row (so inverted) -------------
 if (words.before == 1) then
    buf=buf .. space:rep(2) 
    buf= buf .. colorFg:rep(3,true) -- VOR
  else
    buf= buf .. space:rep(5)
 end
 if (words.after == 1) then
    buf= buf .. colorFg:rep(4,true) -- NACH
    buf= buf .. space:rep(2) -- TG
  else
    buf= buf .. space:rep(6)
 end
 ------------------------------------------------
 if (words.half == 1) then
    buf= buf .. colorFg:rep(4) -- HALB
    buf= buf .. space:rep(1) -- X
  else
    buf= buf .. space:rep(5)
 end
 if (words.twelve == 1) then
    buf= buf .. colorFg:rep(5) -- ZWOELF
    buf= buf .. space:rep(1) -- P
  else
    buf= buf .. space:rep(6)
 end
 ------------even row (so inverted) ---------------------
 if (words.seven == 1) then
    buf= buf .. colorFg:rep(6,true) -- SIEBEN
    buf= buf .. space:rep(5)
 elseif (words.oneLong == 1) then
    buf= buf .. space:rep(5)
    buf= buf .. colorFg:rep(4,true) -- EINS
    buf= buf .. space:rep(2)
 elseif (words.one == 1) then
    buf= buf .. space:rep(6)
    buf= buf .. colorFg:rep(3,true) -- EIN
    buf= buf .. space:rep(2)
 elseif (words.two == 1) then
    buf= buf .. space:rep(7)
    buf= buf .. colorFg:rep(4,true) -- ZWEI
 else
    buf= buf .. space:rep(11)
 end
 ------------------------------------------------
 if (words.three == 1) then
    buf= buf .. space:rep(1)
    buf= buf .. colorFg:rep(4) -- DREI
    buf= buf .. space:rep(6)
  elseif (words.five == 1) then
    buf= buf .. space:rep(7)
    buf= buf .. colorFg:rep(4) -- FUENF
 else
    buf= buf .. space:rep(11)
 end
 ------------even row (so inverted) ---------------------
 if (words.four == 1) then
    buf= buf .. colorFg:rep(4,true) -- VIER
    buf= buf .. space:rep(7)
  elseif (words.nine == 1) then
    buf= buf .. space:rep(4)
    buf= buf .. colorFg:rep(4,true) -- NEUN
    buf= buf .. space:rep(3)
 elseif (words.eleven == 1) then
    buf= buf .. space:rep(8)
    buf= buf .. colorFg:rep(3,true) -- ELEVEN
 else
    buf= buf .. space:rep(11)
 end
 ------------------------------------------------
 if (words.eight == 1) then
    buf= buf .. space:rep(1)
    buf= buf .. colorFg:rep(4) -- ACHT
    buf= buf .. space:rep(6)
  elseif (words.ten == 1) then
    buf= buf .. space:rep(5)
    buf= buf .. colorFg:rep(4) -- ZEHN
    buf= buf .. space:rep(2)
 else
    buf= buf .. space:rep(11)
 end
 ------------even row (so inverted) ---------------------
 if (words.clock == 1) then
    buf= buf .. colorFg:rep(3,true) -- UHR
  else
    buf= buf .. space:rep(3)
 end
 if (words.six == 1) then
    buf= buf .. space:rep(2)
    buf= buf .. colorFg:rep(5,true) -- SECHS
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

  local bufColored = string.char()
  --function to set some color to the LEDs
  local word=0
  local firstCharAfterSpace=true
  for x=0,9 do
	for y=0, (charsPerLine-1) do
		local start = ((x * charsPerLine) + y)*3 + 1
		item=string.byte(buf, start)
		-- Color the visible words
		if (item > 0) then
			if (firstCharAfterSpace == true) then
				word = word + 1
			end
			firstCharAfterSpace=false
			if (characters == 4) then -- we have a word for each minute to color differently
				if (words.min4 == 1 and word == 4) then
					bufColored = bufColored .. colorMin4
				elseif (words.min3 == 1 and word == 3) then
                                        bufColored = bufColored .. colorMin3
        			elseif (words.min2 == 1 and word == 2) then
                                        bufColored = bufColored .. colorMin2
				elseif (words.min1 == 1 and word == 1) then
                                        bufColored = bufColored .. colorMin1
				else
					bufColored = bufColored .. colorForground
				end
			else -- FIXME some more magic should be added here
				if (words.min4 == 1) then
					bufColored = bufColored .. colorMin4
				elseif (words.min3 == 1) then
					bufColored = bufColored .. colorMin3
				elseif (words.min2 == 1) then
					bufColored = bufColored .. colorMin2
				elseif (words.min1 == 1) then
					bufColored = bufColored .. colorMin1
				else
					bufColored = bufColored .. colorForground
				end
			end
		else
			firstCharAfterSpace=true
			-- update the background color, if set
			if (colorBg ~= nil) then
				bufColored = bufColored .. colorBg
			end
		end	
		print (x .. "x" .. y .. " : " .. start .. " color " .. tostring(item) .. " len " .. string.len(buf))
	end
  end
  collectgarbage()

  return bufColored
end
