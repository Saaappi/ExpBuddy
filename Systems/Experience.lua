local addonName, addonTable = ...
local e = CreateFrame("Frame")
local L_GLOBALSTRINGS = addonTable.L_GLOBALSTRINGS
local maxLevel = 60

local function FindNumber(str, nth)
	local arr = {}
	for i in string.gmatch(str, "%d+") do
		table.insert(arr, i)
	end
	return arr[nth]
end

e:RegisterEvent("CHAT_MSG_COMBAT_XP_GAIN")
e:RegisterEvent("CHAT_MSG_SYSTEM")
e:RegisterEvent("QUEST_TURNED_IN")
e:SetScript("OnEvent", function(self, event, ...)
	if event == "CHAT_MSG_COMBAT_XP_GAIN" then
		if ExpBuddyOptionsDB.Trace == false then return end
		if addonTable.playerLevel == maxLevel then return end
		local msg = ...
		if string.find(msg, "dies") then
			-- The player defeated an NPC for some
			-- experience.
			local killsExp = ExpBuddyDB[addonTable.currentMap]["Kills"]
			local experience = FindNumber(msg, 1); killsExp = killsExp + experience
			ExpBuddyDB[addonTable.currentMap]["Kills"] = killsExp
			ExpBuddyPctDB[addonTable.currentMap]["Kills"] = ExpBuddyPctDB[addonTable.currentMap]["Kills"] + experience
			
			-- If the player is rested, then let's
			-- track how much XP they earned from
			-- kills while rested.
			if GetXPExhaustion() then
				-- In case the value doesn't exist in the table.
				if ExpBuddyDB[addonTable.currentMap]["Rested"] == nil then
					ExpBuddyDB[addonTable.currentMap]["Rested"] = 0
				end
				local restedExp = ExpBuddyDB[addonTable.currentMap]["Rested"]
				local experience = FindNumber(msg, 2); restedExp = restedExp + experience
				ExpBuddyDB[addonTable.currentMap]["Rested"] = restedExp
			end
			
			-- If Verbose is enabled, then print
			-- to the chat window.
			if ExpBuddyOptionsDB.Verbose then
				print(L_GLOBALSTRINGS["Colored Addon Name"] .. ": [Kills]: " .. killsExp .. " [+" .. experience .. "] [" .. addonTable.currentMap .. "]")
			end
		elseif string.find(msg, "experience%.") then
			-- The player looted a treasure, herb,
			-- etc for some experience.
			local nodesExp = ExpBuddyDB[addonTable.currentMap]["Nodes"]
			local experience = FindNumber(msg, 1); nodesExp = nodesExp + experience
			ExpBuddyDB[addonTable.currentMap]["Nodes"] = nodesExp
			ExpBuddyPctDB[addonTable.currentMap]["Nodes"] = ExpBuddyPctDB[addonTable.currentMap]["Nodes"] + experience
			
			-- If Verbose is enabled, then print
			-- to the chat window.
			if ExpBuddyOptionsDB.Verbose then
				print(L_GLOBALSTRINGS["Colored Addon Name"] .. ": [Nodes]: " .. nodesExp .. " [+" .. experience .. "] [" .. addonTable.currentMap .. "]")
			end
		end
	end
	if event == "CHAT_MSG_SYSTEM" then
		if ExpBuddyOptionsDB.Trace == false then return end
		if addonTable.playerLevel == maxLevel then return end
		local msg = ...
		if string.find(msg, "Discovered") then
			-- The player explored an area for some
			-- experience.
			local explorationExp = ExpBuddyDB[addonTable.currentMap]["Exploration"]
			local experience = FindNumber(msg, 1); explorationExp = explorationExp + experience
			ExpBuddyDB[addonTable.currentMap]["Exploration"] = explorationExp
			ExpBuddyPctDB[addonTable.currentMap]["Exploration"] = ExpBuddyPctDB[addonTable.currentMap]["Exploration"] + experience
			
			-- If Verbose is enabled, then print
			-- to the chat window.
			if ExpBuddyOptionsDB.Verbose then
				print(L_GLOBALSTRINGS["Colored Addon Name"] .. ": [Exploration]: " .. explorationExp .. " [+" .. experience .. "] [" .. addonTable.currentMap .. "]")
			end
		end
	end
	if event == "QUEST_TURNED_IN" then
		if ExpBuddyOptionsDB.Trace == false then return end
		if addonTable.playerLevel == maxLevel then return end
		local _, experience = ...
		C_Timer.After(1.5, function()
			-- The player turned in a quest for some
			-- experience.
			local questsExp = ExpBuddyDB[addonTable.currentMap]["Quests"]
			questsExp = questsExp + experience
			ExpBuddyDB[addonTable.currentMap]["Quests"] = questsExp
			ExpBuddyPctDB[addonTable.currentMap]["Quests"] = ExpBuddyPctDB[addonTable.currentMap]["Quests"] + experience
			
			-- When quests are turned in, it will also
			-- add to the Nodes category, so let's dock
			-- whatever we get here from that category.
			if ExpBuddyDB[addonTable.currentMap]["Nodes"] ~= 0 then
				ExpBuddyDB[addonTable.currentMap]["Nodes"] = ExpBuddyDB[addonTable.currentMap]["Nodes"] - experience
			end
			if ExpBuddy[addonTable.currentMap]["Nodes"] ~= 0 then
				ExpBuddyPctDB[addonTable.currentMap]["Nodes"] = ExpBuddyPctDB[addonTable.currentMap]["Nodes"] - experience
			end
			
			-- If Verbose is enabled, then print
			-- to the chat window.
			if ExpBuddyOptionsDB.Verbose then
				print(L_GLOBALSTRINGS["Colored Addon Name"] .. ": [Quests]: " .. questsExp .. " [+" .. experience .. "] [" .. addonTable.currentMap .. "]")
			end
		end)
	end
end)