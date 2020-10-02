 local ret = {}

 local function clear()
ret.it=0;ret.is=0;ret.fiveMin=0;ret.tenMin=0;ret.after=0;ret.before=0;ret.threeHour=0;ret.quater=0;ret.threequater=0;ret.half=0;ret.s=0;ret.one=0;ret.oneLong=0;ret.two=0;ret.three=0;ret.four=0;ret.five=0;ret.six=0;ret.seven=0;ret.eight=0;ret.nine=0;ret.ten=0;ret.eleven=0;ret.twelve=0;ret.twenty=0;ret.clock=0;ret.sr_nc=0;ret.min1=0;ret.min2=0;ret.min3=0;ret.min4=0
 end
 
 function display_timestat(hours, minutes, longmode)
   clear()
   if (longmode == nil) then
     longmode=0
   end
 
 
 
  -- return black screen if there is no real time given
  if (hours == nil or minutes == nil) then
    return ret
  end
 
  -- transcode minutes
  local minutesLeds = minutes%5
  local minutes=math.floor(minutes/5)
 
  -- "It is" only display each half hour and each hour
  -- or if longmode is set
  if ((longmode==1) 
     or (minutes==0)
     or (minutes==6)) then
         ret.it=1
         ret.is=1        
  end
 
  -- Handle minutes
  if (minutes > 0) then
    if (minutes==1) then
     ret.fiveMin=1
     ret.after=1
    elseif (minutes==2) then
     ret.tenMin=1
     ret.after=1
    elseif (minutes==3) then
     ret.quater=1
     ret.after=1
    elseif (minutes==4) then
     ret.twenty=1
     ret.after=1
    elseif (minutes==5) then
     ret.fiveMin=1
     ret.half=1
     ret.before=1
    elseif (minutes==6) then 
     ret.half=1
    elseif (minutes==7) then 
     ret.fiveMin=1
     ret.half=1
     ret.after=1
    elseif (minutes==8) then 
     ret.twenty=1
     ret.before=1
    elseif (minutes==9) then
     -- Hande if three quater or quater before is displayed
     if (threequater ~= nil) then
         ret.threequater=1
     else
         ret.quater = 1
         ret.before = 1
     end
    elseif (minutes==10) then 
     ret.tenMin=1
     ret.before=1
    elseif (minutes==11) then 
     ret.fiveMin=1
     ret.before=1
    end
 
    if (minutes > 4) then
     hours=hours+1
    end
  else
    ret.clock=1
  end
  -- Display the minutes as as extra gimmic on min1 to min 4 to display the cut number  
  if (minutesLeds==1) then
   ret.min1=1
  elseif (minutesLeds==2) then
   ret.min2=1
  elseif (minutesLeds==3) then
   ret.min3=1
  elseif (minutesLeds==4) then
   ret.min4=1
  end
 
  -- handle hours
  if (hours > 12) then
   hours = hours - 12
  end
 
  if (hours==0) then
   hours=12
  end
  
  if (hours == 1) then
   if ((ret.it == 1) and (ret.half == 0) ) then
     ret.one=1
   else
     ret.oneLong=1
   end
  elseif (hours == 2) then
   ret.two=1
  elseif (hours == 3) then
   ret.three=1
  elseif (hours == 4) then
   ret.four=1
  elseif (hours == 5) then
   ret.five=1
  elseif (hours == 6) then
   ret.six=1
  elseif (hours == 7) then
   ret.seven=1 
  elseif (hours == 8) then
   ret.eight=1 
  elseif (hours == 9) then
   ret.nine=1 
  elseif (hours == 10) then
   ret.ten=1  
  elseif (hours == 11) then
   ret.eleven=1 
  elseif (hours == 12) then
   ret.twelve=1 
  end
  collectgarbage()
  return ret
 end
