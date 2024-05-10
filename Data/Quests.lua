local addonName, addon = ...
local eventHandler = CreateFrame("Frame")

eventHandler:RegisterEvent("QUEST_TURNED_IN")
eventHandler:SetScript("OnEvent", function(self, event, ...)
	if event == "QUEST_TURNED_IN" then
		if addon.playerLevel == GetMaxLevelForPlayerExpansion() then
			-- The player is max level, so unregister the event and return.
			eventHandler:UnregisterEvent("QUEST_TURNED_IN")
			return
		end

		local _, experienceGained = ...
		C_Timer.After(1, function()
			local newExperience = 0
			if experienceGained > 0 then
				-- The player completed a quest for some experience, so
				-- let's add it to the Quests experience for the current
				-- map.
				local currentExperience = ExpBuddyDataDB[addon.mapID].Quests
				newExperience = currentExperience + experienceGained
				ExpBuddyDataDB[addon.mapID].Quests = newExperience
			end

			-- This event will also add to the Nodes category, but we can
			-- safely deduct the quest experience from the Nodes category
			-- to remove the false positive.
			if ExpBuddyDataDB[addon.mapID].Nodes ~= 0 then
				ExpBuddyDataDB[addon.mapID].Nodes = ExpBuddyDataDB[addon.mapID].Nodes - experienceGained
			end
			addon.RefreshFrame(addon.mapID)
		end)
	end
end)