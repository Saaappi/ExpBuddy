local addonName, addon = ...
local eventHandler = CreateFrame("Frame")

eventHandler:RegisterEvent("CHAT_MSG_COMBAT_XP_GAIN")
eventHandler:SetScript("OnEvent", function(self, event, ...)
	if event == "CHAT_MSG_COMBAT_XP_GAIN" then
		if addon.playerLevel == GetMaxLevelForPlayerExpansion() then
			-- The player is max level, so unregister the event and return.
			eventHandler:UnregisterEvent("CHAT_MSG_COMBAT_XP_GAIN")
			return
		end

		local msg = ...
		if string.find(msg, "dies") then
			-- The player defeated a monster for some experience, so
			-- let's add it to the Monsters experience for the current
			-- map.
			local currentExperience = ExpBuddyDataDB[addon.mapID].Monsters
			local experienceGained = tonumber(addon.FindNumber(msg, 1))
			local newExperience = currentExperience + experienceGained
			ExpBuddyDataDB[addon.mapID].Monsters = newExperience
			--addonTable.monstersLabel:SetText("\n\n" .. CreateAtlasMarkup("ShipMission_DangerousSkull", 16, 16) .. " |cffFFD100" .. "Monsters|r: " .. addonTable.FormatNumber(tostring(experience)) .. " (" .. addonTable.CalculatePercent(ExpBuddyDataDB[addonTable.currentMap]["Monsters"]) .. "%)")

			-- If the player has rested experience, then let's track
			-- how much experience was earned from the monster while
			-- rested.
			if GetXPExhaustion() then
				local restedExperience = ExpBuddyDataDB[addon.mapID].Rested
				local restedExperienceGained = tonumber(addon.FindNumber(msg, 2))
				local newRestedExperience = restedExperience + restedExperienceGained
				ExpBuddyDataDB[addon.mapID].Rested = newRestedExperience
				--addonTable.restedLabel:SetText("\n" .. CreateAtlasMarkup("Gamepad_Rev_Home_64", 16, 16) .. " |cffFFD100" .. "Rested|r: " .. addonTable.FormatNumber(tostring(experience)) .. " (" .. addonTable.CalculatePercent(ExpBuddyDataDB[addonTable.currentMap]["Rested"]) .. "%)")
			end
		end
	end
end)