local addonName, addonTable = ...
local e = CreateFrame("Frame")

e:RegisterEvent("QUEST_TURNED_IN")
e:SetScript("OnEvent", function(self, event, ...)
	if event == "QUEST_TURNED_IN" then
		if addonTable.playerLevel == addonTable.data["MAX_LEVEL"] then return end
		
		local _, questXP = ...
		C_Timer.After(1, function()
			if questXP > 0 then
				-- The player completed a quest for some experience, so
				-- let's add it to the Quests experience for the current
				-- map.
				local experience = ExpBuddyDataDB[addonTable.currentMap]["Quests"]
				experience = experience + questXP
				ExpBuddyDataDB[addonTable.currentMap]["Quests"] = experience
				addonTable.questsLabel:SetText("\n" .. CreateAtlasMarkup("NPE_TurnIn", 16, 16) .. " |cffFFD100" .. "Quests|r: " .. addonTable.FormatNumber(tostring(experience)) .. " (" .. addonTable.CalculatePercent(ExpBuddyDataDB[addonTable.currentMap]["Quests"]) .. "%)")
			end
			
			-- This event will also add to the Nodes category, but we can
			-- safely deduct the quest experience from the Nodes category
			-- to remove the false positive.
			if ExpBuddyDataDB[addonTable.currentMap]["Nodes"] ~= 0 then
				ExpBuddyDataDB[addonTable.currentMap]["Nodes"] = ExpBuddyDataDB[addonTable.currentMap]["Nodes"] - questXP
				addonTable.nodesLabel:SetText("\n" .. CreateAtlasMarkup("Mobile-TreasureIcon", 16, 16) .. " |cffFFD100" .. "Nodes|r: " .. addonTable.FormatNumber(tostring(ExpBuddyDataDB[addonTable.currentMap]["Nodes"])) .. " (" .. addonTable.CalculatePercent(ExpBuddyDataDB[addonTable.currentMap]["Nodes"]) .. "%)")
			end
		end)
	end
end)