local addonName, addon = ...
local eventHandler = CreateFrame("Frame")

-- "Nodes" are treasure, herbs, ore, etc.
eventHandler:RegisterEvent("CHAT_MSG_COMBAT_XP_GAIN")
eventHandler:SetScript("OnEvent", function(self, event, ...)
	if event == "CHAT_MSG_COMBAT_XP_GAIN" then
		if addon.playerLevel == GetMaxLevelForPlayerExpansion() then
			-- The player is max level, so unregister the event and return.
			eventHandler:UnregisterEvent("CHAT_MSG_COMBAT_XP_GAIN")
			return
		end

		local msg = ...
		if string.find(msg, "experience%.") and (not string.find(msg, "dies")) then
			-- The player looted a node for some experience, so
			-- let's add it to the Nodes experience for the current
			-- map.
			local currentExperience = ExpBuddyDataDB[addon.mapID].Nodes
			local experienceGained = tonumber(addon.FindNumber(msg, 1))
			local newExperience = currentExperience + experienceGained
			ExpBuddyDataDB[addon.mapID].Nodes = newExperience
			--addonTable.nodesLabel:SetText("\n" .. CreateAtlasMarkup("Mobile-TreasureIcon", 16, 16) .. " |cffFFD100" .. "Nodes|r: " .. addonTable.FormatNumber(tostring(experience)) .. " (" .. addonTable.CalculatePercent(ExpBuddyDataDB[addonTable.currentMap]["Nodes"]) .. "%)")
		end
	end
end)