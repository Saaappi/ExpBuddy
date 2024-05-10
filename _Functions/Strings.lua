local addonName, addon = ...

-- This function is used when the zone name is just a little
-- too long.
addon.Substring = function(str)
    if str:len() <= 15 then
		return str
	end
    return str:sub(1, 15) .. "..."
end