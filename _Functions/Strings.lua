local addonName, addon = ...

addon.Substring = function(str)
    if str:len() <= 15 then
		return str
	end
    return str:sub(1, 15) .. "..."
end