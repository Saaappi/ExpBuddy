local addonName, addonTable = ...
local AceGUI = LibStub("AceGUI-3.0")

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

addonTable.Substring = function(str)
	if string.len(str) <= 15 then
		return str
	else
		return string.sub(str, 1, 15) .. "..."
	end
end

local data = {
	-- Numbers
	["MAX_LEVEL"] 			= 70,
	--
	-- Strings
	["COLORED_ADDON_NAME"] 	= "|cff00FFFF"..addonName.."|r"
}
addonTable.data = data

-- AceGUI Widgets
addonTable.currentMapLabel = AceGUI:Create("Label")
addonTable.monstersLabel = AceGUI:Create("Label")
addonTable.restedLabel = AceGUI:Create("Label")
addonTable.questsLabel = AceGUI:Create("Label")
addonTable.nodesLabel = AceGUI:Create("Label")
addonTable.explorationLabel = AceGUI:Create("Label")
addonTable.entryLevelEditbox = AceGUI:Create("EditBox")
addonTable.exitLevelEditbox = AceGUI:Create("EditBox")