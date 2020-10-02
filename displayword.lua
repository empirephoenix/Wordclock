local r = 0
local g = 0
local b = 0
local w = 0

local function adjustNightMode()
    if nightMode then
        r = r / 4
        g = g / 4
        b = b / 4
        w = w / 4
    end
end

local function color(type)
    r = colors[type].r or 0
    g = colors[type].g or 0
    b = colors[type].b or 0
    w = colors[type].w or 0
    adjustNightMode()
end

function generateLEDs(words, characters)
    clearLED()
    
    color("misc")
    if (words.it==1) then
        xy(1,1,r,g,b,w)
        xy(2,1,r,g,b,w)
    end

    if (words.is == 1) then
        xy(4,1,r,g,b,w)
        xy(5,1,r,g,b,w)
        xy(6,1,r,g,b,w)
    end
    if (words.clock == 1) then -- UHR
        xy(9,10,r,g,b,w)
        xy(10,10,r,g,b,w)
        xy(11,10,r,g,b,w)
    end

    color("min")
    if (words.fiveMin== 1) then
        xy(8,1,r,g,b,w)
        xy(9,1,r,g,b,w)
        xy(10,1,r,g,b,w)
        xy(11,1,r,g,b,w)
    end

    if (words.twenty == 1) then
        xy(5,2,r,g,b,w)
        xy(6,2,r,g,b,w)
        xy(7,2,r,g,b,w)
        xy(8,2,r,g,b,w)
        xy(9,2,r,g,b,w)
        xy(10,2,r,g,b,w)
        xy(11,2,r,g,b,w)
    end

    if (words.tenMin == 1) then
        xy(1,2,r,g,b,w)
        xy(2,2,r,g,b,w)
        xy(3,2,r,g,b,w)
        xy(4,2,r,g,b,w)
    end

    color("part")
    if (words.threequater == 1) then
        xy(1,3,r,g,b,w)
        xy(2,3,r,g,b,w)
        xy(3,3,r,g,b,w)
        xy(4,3,r,g,b,w)
        xy(5,3,r,g,b,w)
        xy(6,3,r,g,b,w)
        xy(7,3,r,g,b,w)
        xy(8,3,r,g,b,w)
        xy(9,3,r,g,b,w)
        xy(10,3,r,g,b,w)
        xy(11,3,r,g,b,w)
    elseif (words.quater == 1) then -- VIERTEL
        xy(5,3,r,g,b,w)
        xy(6,3,r,g,b,w)
        xy(7,3,r,g,b,w)
        xy(8,3,r,g,b,w)
        xy(9,3,r,g,b,w)
        xy(10,3,r,g,b,w)
        xy(11,3,r,g,b,w)
    end
    
    if (words.half == 1) then
        xy(1,5,r,g,b,w)
        xy(2,5,r,g,b,w)
        xy(3,5,r,g,b,w)
        xy(4,5,r,g,b,w)
    end

    color("seperator")
    if (words.before == 1) then     
        xy(7,4,r,g,b,w)
        xy(8,4,r,g,b,w)
        xy(9,4,r,g,b,w)
    end

    if (words.after == 1) then
        xy(3,4,r,g,b,w)
        xy(4,4,r,g,b,w)
        xy(5,4,r,g,b,w)
        xy(6,4,r,g,b,w)
    end


    color("hour")
    if (words.twelve == 1) then
        xy(6,5,r,g,b,w)
        xy(7,5,r,g,b,w)
        xy(8,5,r,g,b,w)
        xy(9,5,r,g,b,w)
        xy(10,5,r,g,b,w)
    end

    if (words.seven == 1) then
        xy(6,6,r,g,b,w)
        xy(7,6,r,g,b,w)
        xy(8,6,r,g,b,w)
        xy(9,6,r,g,b,w)
        xy(10,6,r,g,b,w)
        xy(11,6,r,g,b,w)
    elseif (words.oneLong == 1) then -- EINS
        xy(3,6,r,g,b,w)
        xy(4,6,r,g,b,w)
        xy(5,6,r,g,b,w)
        xy(6,6,r,g,b,w)
    elseif (words.one == 1) then -- EIN
        xy(3,6,r,g,b,w)
        xy(4,6,r,g,b,w)
        xy(5,6,r,g,b,w)
    elseif (words.two == 1) then -- ZWEI
        xy(1,6,r,g,b,w)
        xy(2,6,r,g,b,w)
        xy(3,6,r,g,b,w)
        xy(4,6,r,g,b,w)
    end

    if (words.three == 1) then
        xy(2,7,r,g,b,w)
        xy(3,7,r,g,b,w)
        xy(4,7,r,g,b,w)
        xy(5,7,r,g,b,w)
    elseif (words.five == 1) then
        xy(8,7,r,g,b,w)
        xy(9,7,r,g,b,w)
        xy(10,7,r,g,b,w)
        xy(11,7,r,g,b,w)
    end

    if (words.four == 1) then
        xy(8,8,r,g,b,w)
        xy(9,8,r,g,b,w)
        xy(10,8,r,g,b,w)
        xy(11,8,r,g,b,w)
    elseif (words.nine == 1) then
        xy(4,8,r,g,b,w)
        xy(5,8,r,g,b,w)
        xy(6,8,r,g,b,w)
        xy(7,8,r,g,b,w)
    elseif (words.eleven == 1) then
        xy(1,8,r,g,b,w)
        xy(2,8,r,g,b,w)
        xy(3,8,r,g,b,w)
    end

    if (words.eight == 1) then
        xy(2,9,r,g,b,w)
        xy(3,9,r,g,b,w)
        xy(4,9,r,g,b,w)
        xy(5,9,r,g,b,w)
    elseif (words.ten == 1) then
        xy(6,9,r,g,b,w)
        xy(7,9,r,g,b,w)
        xy(8,9,r,g,b,w)
        xy(9,9,r,g,b,w)
    end

    if (words.six == 1) then
        xy(2,10,r,g,b,w)
        xy(3,10,r,g,b,w)
        xy(4,10,r,g,b,w)
        xy(5,10,r,g,b,w)
        xy(6,10,r,g,b,w)
    end
end
