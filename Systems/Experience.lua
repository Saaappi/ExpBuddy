local addonName, addonTable = ...
local e = CreateFrame("Frame")
local L_GLOBALSTRINGS = addonTable.L_GLOBALSTRINGS

e:RegisterEvent("CHAT_MSG_COMBAT_XP_GAIN")
e:RegisterEvent("CHAT_MSG_SYSTEM")
e:RegisterEvent("QUEST_TURNED_IN")
e:SetScript("OnEvent", function(self, event, ...)
	if event == "CHAT_MSG_COMBAT_XP_GAIN" then
		if ExpBuddyOptionsDB.Trace == false then return end
		local msg = ...
		if string.find(msg, "dies") then
			-- The player defeated an NPC for some
			-- experience.
			local killsExp = ExpBuddyDB[addonTable.currentMap]["Kills"]
			local experience = string.match(msg, "%d+"); killsExp = killsExp + experience
			ExpBuddyDB[addonTable.currentMap]["Kills"] = killsExp
			
			-- If Verbose is enabled, then print
			-- to the chat window.
			if ExpBuddyOptionsDB.Verbose then
				print(L_GLOBALSTRINGS["Colored Addon Name"] .. ": [Kills]: " .. killsExp .. " [+" .. experience .. "]")
			end
		elseif string.find(msg, "experience%.") then
			-- The player looted a treasure, herb,
			-- etc for some experience.
			local nodesExp = ExpBuddyDB[addonTable.currentMap]["Nodes"]
			local experience = string.match(msg, "%d+"); nodesExp = nodesExp + experience
			ExpBuddyDB[addonTable.currentMap]["Nodes"] = nodesExp
			
			-- If Verbose is enabled, then print
			-- to the chat window.
			if ExpBuddyOptionsDB.Verbose then
				print(L_GLOBALSTRINGS["Colored Addon Name"] .. ": [Nodes]: " .. nodesExp .. " [+" .. experience .. "]")
			end
		end
	end
	if event == "CHAT_MSG_SYSTEM" then
		if ExpBuddyOptionsDB.Trace == false then return end
		local msg = ...
		if string.find(msg, "Discovered") then
			-- The player explored an area for some
			-- experience.
			local explorationExp = ExpBuddyDB[addonTable.currentMap]["Exploration"]
			local experience = string.match(msg, "%d+"); explorationExp = explorationExp + experience
			ExpBuddyDB[addonTable.currentMap]["Exploration"] = explorationExp
			
			-- If Verbose is enabled, then print
			-- to the chat window.
			if ExpBuddyOptionsDB.Verbose then
				print(L_GLOBALSTRINGS["Colored Addon Name"] .. ": [Exploration]: " .. explorationExp .. " [+" .. experience .. "]")
			end
		end
	end
	if event == "QUEST_TURNED_IN" then
		if ExpBuddyOptionsDB.Trace == false then return end
		local _, experience = ...
		C_Timer.After(1.5, function()
			-- The player turned in a quest for some
			-- experience.
			local questsExp = ExpBuddyDB[addonTable.currentMap]["Quests"]
			questsExp = questsExp + experience
			ExpBuddyDB[addonTable.currentMap]["Quests"] = questsExp
			
			-- When quests are turned in, it will also
			-- add to the Nodes category, so let's dock
			-- whatever we get here from that category.
			if ExpBuddyDB[addonTable.currentMap]["Nodes"] ~= 0 then
				ExpBuddyDB[addonTable.currentMap]["Nodes"] = ExpBuddyDB[addonTable.currentMap]["Nodes"] - experience
			end
			
			-- If Verbose is enabled, then print
			-- to the chat window.
			if ExpBuddyOptionsDB.Verbose then
				print(L_GLOBALSTRINGS["Colored Addon Name"] .. ": [Quests]: " .. questsExp .. " [+" .. experience .. "]")
			end
		end)
	end
end)