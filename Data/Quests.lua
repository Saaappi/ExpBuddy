local addonName, addonTable = ...
local e = CreateFrame("Frame")

e:RegisterEvent("QUEST_TURNED_IN")
e:SetScript("OnEvent", function(self, event, ...)
	if event == "QUEST_TURNED_IN" then
		if addonTable.playerLevel == addonTable.data["MAX_LEVEL"] then return end
		
		local _, questXP = ...
		C_Timer.After(1, function()
			local experience = 0
			if questXP > 0 then
				-- The player completed a quest for some experience, so
				-- let's add it to the Quests experience for the current
				-- map.
				experience = ExpBuddyDB[addonTable.currentMap]["Quests"]
				experience = experience + questXP
				ExpBuddyDB[addonTable.currentMap]["Quests"] = experience
				ExpBuddyPctDB[addonTable.currentMap]["Quests"] = ExpBuddyPctDB[addonTable.currentMap]["Quests"] + questXP
			end
			
			-- This event will also add to the Nodes category, but we can
			-- safely deduct the quest experience from the Nodes category
			-- to remove the false positive.
			if ExpBuddyDB[addonTable.currentMap]["Nodes"] ~= 0 then
				ExpBuddyDB[addonTable.currentMap]["Nodes"] = ExpBuddyDB[addonTable.currentMap]["Nodes"] - questXP
			end
			if ExpBuddyPctDB[addonTable.currentMap]["Nodes"] ~= 0 then
				ExpBuddyPctDB[addonTable.currentMap]["Nodes"] = ExpBuddyPctDB[addonTable.currentMap]["Nodes"] - questXP
			end
			
			-- TODO: This should be stored silently unless the GUI is
			-- shown.
			--[[if ExpBuddyOptionsDB.Verbose then
				print(addonTable.data["COLORED_ADDON_NAME"] .. ": [Exploration]: " .. explorationExp .. " [+" .. experience .. "] [" .. addonTable.currentMap .. "]")
			elseif ExpBuddyTrackerMenu:IsVisible() then
				ExpBuddyUpdateExperience("ExpBuddyTracker")
			end]]
		end)
	end
end)