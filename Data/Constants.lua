local addonName, addonTable = ...

addonTable.FormatNumber = function(number)
	local formattedNumber = number
	while true do  
		formattedNumber, k = string.gsub(formattedNumber, "^(-?%d+)(%d%d%d)", '%1,%2')
		if (k==0) then
			break
		end
	end
	return formattedNumber
end

local data = {
	-- Numbers
	["MAX_LEVEL"] 			= 70,
	--
	-- Strings
	["COLORED_ADDON_NAME"] 	= "|cff00FFFF"..addonName.."|r"
}
addonTable.data = data