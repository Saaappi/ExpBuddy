local addonName, addonTable = ...
local e = CreateFrame("Frame")
local L_GLOBALSTRINGS = addonTable.L_GLOBALSTRINGS
local isQuest = false

e:RegisterEvent("CHAT_MSG_COMBAT_XP_GAIN")
e:RegisterEvent("CHAT_MSG_SYSTEM")
e:RegisterEvent("QUEST_TURNED_IN")
e:SetScript("OnEvent", function(self, event, ...)
	if event == "CHAT_MSG_COMBAT_XP_GAIN" then
		local msg = ...
		if string.find(msg, "dies") then
			-- The player defeated an NPC for some
			-- experience.
			local killsExp = ExpBuddyDB[addonTable.currentMap]["Kills"]
			local experience = string.match(msg, "%d+"); killsExp = killsExp + experience
			ExpBuddyDB[addonTable.currentMap]["Kills"] = killsExp
		else
			C_Timer.After(3, function()
				if not isQuest then
					-- The player collected a node
					-- (herb, treasure, etc.) for some
					-- experience.
					local nodesExp = ExpBuddyDB[addonTable.currentMap]["Nodes"]
					local experience = string.match(msg, "%d+"); nodesExp = nodesExp + experience
					ExpBuddyDB[addonTable.currentMap]["Nodes"] = nodesExp
				else
					isQuest = false
				end
			end)
		end
	end
	if event == "CHAT_MSG_SYSTEM" then
		local msg = ...
		if string.find(msg, "Discovered") then
			-- The player explored an area for some
			-- experience.
			local explorationExp = ExpBuddyDB[addonTable.currentMap]["Exploration"]
			local experience = string.match(msg, "%d+"); explorationExp = explorationExp + experience
			ExpBuddyDB[addonTable.currentMap]["Exploration"] = explorationExp
		end
	end
	if event == "QUEST_TURNED_IN" then
		-- The player turned in a quest for some
		-- experience.
		isQuest = true
		local _, experience = ...
		local questsExp = ExpBuddyDB[addonTable.currentMap]["Quests"]
		questsExp = questsExp + experience
		ExpBuddyDB[addonTable.currentMap]["Quests"] = questsExp
	end
end)