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
e:SetScript("OnEvent", function(self, event, ...)
	if event == "CHAT_MSG_COMBAT_XP_GAIN" then
		if ExpBuddyOptionsDB.Trace == false then return end
		if addonTable.playerLevel == maxLevel then return end
		local msg = ...
		if string.find(msg, "experience%.") then
			-- The player looted a node for some experience, so
			-- let's add it to the Nodes experience for the current
			-- map.
			-- Nodes are considered treasures, herbs, ore, etc.
			local experience = ExpBuddyDB[addonTable.currentMap]["Nodes"]
			local nodeXP = tonumber(FindNumber(msg, 1))
			experience = experience + nodeXP
			ExpBuddyDB[addonTable.currentMap]["Nodes"] = experience
			ExpBuddyPctDB[addonTable.currentMap]["Nodes"] = ExpBuddyPctDB[addonTable.currentMap]["Nodes"] + nodeXP
			
			-- TODO: This should be stored silently unless the GUI is
			-- shown.
			--[[if ExpBuddyOptionsDB.Verbose then
				print(L_GLOBALSTRINGS["Colored Addon Name"] .. ": [Exploration]: " .. explorationExp .. " [+" .. experience .. "] [" .. addonTable.currentMap .. "]")
			elseif ExpBuddyTrackerMenu:IsVisible() then
				ExpBuddyUpdateExperience("ExpBuddyTracker")
			end]]
		end
	end
end)