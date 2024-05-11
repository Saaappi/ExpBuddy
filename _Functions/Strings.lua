local addonName, addon = ...

-- This function is used when the zone name is just a little
-- too long.
addon.TruncateMapName = function(str)
    if str:len() <= 15 then
		return str
	end
    return str:sub(1, 15) .. "..."
end

addon.StringContains = function(str1, str2)
    return string.find(str1:lower(), str2:lower(), 1, true) ~= nil
end