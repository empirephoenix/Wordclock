function isSummerTime(a)if a.month>3 and a.month<10 then return true elseif a.month==3 and a.day>=25 and a.day<=31 and a.hour>2 and a.dow==7 or a.month==3 and a.day>=25 and a.day<=31 and a.dow<7 and 7-a.dow+a.day>31 then return true elseif a.month==10 and a.day>=25 and a.day<=31 and a.hour<2 and a.dow==7 or a.month==10 and a.day>=25 and a.day<=31 and a.dow<7 and 7-a.dow+a.day<=31 or a.month==10 and a.day<25 then return true end;return false end
  
  ----------------------------------------------------------
  -- Here comes some code to extract the year, month, day, hour, minute, second and day of week of a unix timestamp
  
  -- Source:
  -- http://www.jbox.dk/sanos/source/lib/time.c.html
  
  local YEAR0=1900
  
  local EPOCH_YR=1970
  --SECS_DAY=(24L * 60L * 60L)
  local SECS_DAY=86400
  
  local ytab = {}
  ytab[0] = {}
  ytab[1] = {}
  ytab[0][0] = 31
  ytab[0][1] = 28
  ytab[0][2] = 31
  ytab[0][3] = 30
  ytab[0][4] = 31
  ytab[0][5] = 30
  ytab[0][6] = 31
  ytab[0][7] = 31
  ytab[0][8] = 30
  ytab[0][9] = 31
  ytab[0][10] = 30
  ytab[0][11] = 31
  ytab[1][0] =  31
  ytab[1][1] = 29
  ytab[1][2] = 31
  ytab[1][3] = 30
  ytab[1][4] = 31
  ytab[1][5] = 30
  ytab[1][6] = 31
  ytab[1][7] = 31
  ytab[1][8] = 30
  ytab[1][9] = 31
  ytab[1][10] = 30
  ytab[1][11] = 31
  
  
  local leapyear = function(year)
      return  ( not ((year) % 4 ~= 0) and (((year) % 100 ~= 0) or not ((year) % 400 ~= 0)))
  end
  
  local yearsize = function(year)
   if leapyear(year) then
    return 366
   else
    return 365
   end
  end
  
function getUTCtime(a)local b=EPOCH_YR;local c=math.floor(a%SECS_DAY)local d=math.floor(a/SECS_DAY)local e=math.floor(c%60)local f=math.floor(c%3600/60)local g=math.floor(c/3600)local h=math.floor((d+4)%7)while d>=yearsize(b)do d=d-yearsize(b)b=b+1 end;local i=0;while d>=ytab[leapyear(b)and 1 or 0][i]do d=d-ytab[leapyear(b)and 1 or 0][i]i=i+1 end;local j=d+1;return{year=b,month=i+1,day=j,hour=g,minute=f,second=e,dow=h}end
  
  
function getTime(a,b)local c=getUTCtime(a+3600*b)if isSummerTime(c)then c=getUTCtime(a+3600*(b+1))end;return c end
  
