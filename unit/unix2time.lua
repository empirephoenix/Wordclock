---
-- Source:
-- http://www.jbox.dk/sanos/source/lib/time.c.html

YEAR0=1900

EPOCH_YR=1970
--SECS_DAY=(24L * 60L * 60L)
SECS_DAY=86400

ytab = {}
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
 
  isleap=0 if leapyear(year) then isleap=1 end
  while (dayno >= ytab[isleap][mon]) 
  do
      dayno = dayno - ytab[isleap][mon];
      mon = mon + 1
      isleap=0 if leapyear(year) then isleap=1 end
   end
   mday = dayno + 1

  return year, mon, mday, hour, min, sec, wday
end

print( gettime(1462391501) )

