local addonName, addonTable = ...

addonTable.GetData = function()
	local tbl = {
		["Monsters"] 	= ExpBuddyDataDB[addonTable.currentMap]["Monsters"],
		["Rested"] 		= ExpBuddyDataDB[addonTable.currentMap]["Rested"],
		["Quests"] 		= ExpBuddyDataDB[addonTable.currentMap]["Quests"],
		["Nodes"] 		= ExpBuddyDataDB[addonTable.currentMap]["Nodes"],
		["Exploration"] = ExpBuddyDataDB[addonTable.currentMap]["Exploration"],
	}
	return tbl
end

addonTable.ResetLabels = function()
	local labels = addonTable.GetData()
	addonTable.monstersLabel:SetText("\n" .. CreateAtlasMarkup("ShipMission_DangerousSkull", 16, 16) .. " |cffFFD100" .. "Monsters|r: " .. addonTable.FormatNumber(tostring(labels.Monsters)) .. " (" .. addonTable.CalculatePercent(labels.Monsters) .. "%)")
	addonTable.restedLabel:SetText("\n" .. CreateAtlasMarkup("Gamepad_Rev_Home_64", 16, 16) .. " |cffFFD100" .. "Rested|r: " .. addonTable.FormatNumber(tostring(labels.Rested)) .. " (" .. addonTable.CalculatePercent(labels.Rested) .. "%)")
	addonTable.questsLabel:SetText("\n" .. CreateAtlasMarkup("NPE_TurnIn", 16, 16) .. " |cffFFD100" .. "Quests|r: " .. addonTable.FormatNumber(tostring(labels.Quests)) .. " (" .. addonTable.CalculatePercent(labels.Quests) .. "%)")
	addonTable.nodesLabel:SetText("\n" .. CreateAtlasMarkup("Mobile-TreasureIcon", 16, 16) .. " |cffFFD100" .. "Nodes|r: " .. addonTable.FormatNumber(tostring(labels.Nodes)) .. " (" .. addonTable.CalculatePercent(labels.Nodes) .. "%)")
	addonTable.explorationLabel:SetText("\n" .. CreateAtlasMarkup("GarrMission_MissionIcon-Exploration", 16, 16) .. " |cffFFD100" .. "Exploration|r: " .. addonTable.FormatNumber(tostring(labels.Exploration)) .. " (" .. addonTable.CalculatePercent(labels.Exploration) .. "%)\n\n")
end