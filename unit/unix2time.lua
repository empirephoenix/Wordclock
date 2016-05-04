---
-- Source:
-- http://www.jbox.dk/sanos/source/lib/time.c.html

YEAR0=1900

EPOCH_YR=1970
--SECS_DAY=(24L * 60L * 60L)
SECS_DAY=86400

ytab = {}
ytab[0] = {}
ytab[0][0] = 31 
--31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31}
ytab[1] = {}
--{31, 29, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31}


leapyear = function(year)
    return  ( not ((year) % 4) and (((year) % 100) or not ((year) % 400)))
end

yearsize = function(year)
 if leapyear(year) then
  return 366
 else
  return 365
 end
end

gettime = function(unixtimestmp)
  local year = EPOCH_YR
  local dayclock = math.floor(unixtimestmp % SECS_DAY)
  local dayno = math.floor(unixtimestmp / SECS_DAY)

  local sec = dayclock % 60
  local min = math.floor( (dayclock % 3600) / 60)
  local hour = math.floor(dayclock / 3600)
  local wday = math.floor( (dayno + 4) % 7) -- Day 0 was a thursday

  while (dayno >= yearsize(year))
  do
    dayno = dayno - yearsize(year);
    year=year + 1
  end
  local yday = dayno
  local mon = 0
 
  --isleap=0 if leapyear(year) then isleap=1 end
  --while (dayno >= ytab[isleap][mon]) 
  --do
  --    dayno = dayno - ytab[isleap][mon];
  --    mon = mon + 1
  --    isleap=0 if leapyear(year) then isleap=1 end
  -- end
  -- mday = dayno + 1

  return year, hour, min, sec
end

print( gettime(1462391501) )

