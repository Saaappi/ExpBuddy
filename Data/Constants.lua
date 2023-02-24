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

addonTable.Substring = function(str)
	if string.len(str) <= 15 then
		return str
	else
		return string.sub(str, 1, 15) .. "..."
	end
end

addonTable.CalculatePercent = function(cat)
	local monsters = ExpBuddyDataDB[addonTable.currentMap]["Monsters"]
	local rested = ExpBuddyDataDB[addonTable.currentMap]["Rested"]
	local quests = ExpBuddyDataDB[addonTable.currentMap]["Quests"]
	local nodes = ExpBuddyDataDB[addonTable.currentMap]["Nodes"]
	local exploration = ExpBuddyDataDB[addonTable.currentMap]["Exploration"]
	
	if (monsters+rested+quests+nodes+exploration) == 0 then
		return 0
	else
		return string.format(
			"%.2f",
			(cat/(monsters+rested+quests+nodes+exploration))*100
		)
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