-- Example usage of the word clock
dofile("wordclock.lua")

-- Manually set something
leds=display_timestat(15,30)
for k,v in pairs(leds) do 
    if (v == 1) then
        print(k) 
    end
end
