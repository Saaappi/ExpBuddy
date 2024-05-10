local addonName, addon = ...
local eventHandler = CreateFrame("Frame")

eventHandler:RegisterEvent("CHAT_MSG_SYSTEM")
eventHandler:SetScript("OnEvent", function(self, event, ...)
	if event == "CHAT_MSG_SYSTEM" then
		if addon.playerLevel == GetMaxLevelForPlayerExpansion() then
			-- The player is max level, so unregister the event and return.
			eventHandler:UnregisterEvent("CHAT_MSG_SYSTEM")
			return
		end

		local msg = ...
		if string.find(msg, "Discovered") then
			-- The player discovered an area for some experience, so
			-- let's add it to the Exploration experience for the current
			-- map.
			local currentExperience = ExpBuddyDataDB[addon.mapID].Exploration
			local experienceGained = tonumber(addon.FindNumber(msg, 1))
			local newExperience = currentExperience + experienceGained
			ExpBuddyDataDB[addon.mapID].Exploration = newExperience
			--addonTable.explorationLabel:SetText("\n" .. CreateAtlasMarkup("GarrMission_MissionIcon-Exploration", 16, 16) .. " |cffFFD100" .. "Exploration|r: " .. addonTable.FormatNumber(tostring(experience)) .. " (" .. addonTable.CalculatePercent(ExpBuddyDataDB[addonTable.currentMap]["Exploration"]) .. "%)\n\n")
		end
	end
end)