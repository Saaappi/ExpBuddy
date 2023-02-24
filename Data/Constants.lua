local addonName, addonTable = ...
local AceGUI = LibStub("AceGUI-3.0")

-- AceGUI Widgets
addonTable.currentMapLabel = AceGUI:Create("Label")
addonTable.monstersLabel = AceGUI:Create("Label")
addonTable.restedLabel = AceGUI:Create("Label")
addonTable.questsLabel = AceGUI:Create("Label")
addonTable.nodesLabel = AceGUI:Create("Label")
addonTable.explorationLabel = AceGUI:Create("Label")
addonTable.entryLevelEditbox = AceGUI:Create("EditBox")
addonTable.exitLevelEditbox = AceGUI:Create("EditBox")
addonTable.resetButton = AceGUI:Create("Button")

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

addonTable.ResetLabels = function()
	addonTable.monstersLabel:SetText("\n" .. CreateAtlasMarkup("ShipMission_DangerousSkull", 16, 16) .. " |cffFFD100" .. "Monsters|r: " .. addonTable.FormatNumber(tostring(ExpBuddyDataDB[addonTable.currentMap]["Monsters"])))
	addonTable.restedLabel:SetText("\n" .. CreateAtlasMarkup("Gamepad_Rev_Home_64", 16, 16) .. " |cffFFD100" .. "Rested|r: " .. addonTable.FormatNumber(tostring(ExpBuddyDataDB[addonTable.currentMap]["Rested"])))
	addonTable.questsLabel:SetText("\n" .. CreateAtlasMarkup("NPE_TurnIn", 16, 16) .. " |cffFFD100" .. "Quests|r: " .. addonTable.FormatNumber(tostring(ExpBuddyDataDB[addonTable.currentMap]["Quests"])))
	addonTable.nodesLabel:SetText("\n" .. CreateAtlasMarkup("Mobile-TreasureIcon", 16, 16) .. " |cffFFD100" .. "Nodes|r: " .. addonTable.FormatNumber(tostring(ExpBuddyDataDB[addonTable.currentMap]["Nodes"])))
	addonTable.explorationLabel:SetText("\n" .. CreateAtlasMarkup("GarrMission_MissionIcon-Exploration", 16, 16) .. " |cffFFD100" .. "Exploration|r: " .. addonTable.FormatNumber(tostring(ExpBuddyDataDB[addonTable.currentMap]["Exploration"])))
end

local data = {
	-- Numbers
	["MAX_LEVEL"] 			= 70,
	--
	-- Strings
	["COLORED_ADDON_NAME"] 	= "|cff00FFFF"..addonName.."|r"
}
addonTable.data = data