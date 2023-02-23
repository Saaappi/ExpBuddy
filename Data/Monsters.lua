local addonName, addonTable = ...
local e = CreateFrame("Frame")

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
		if addonTable.playerLevel == addonTable.data["MAX_LEVEL"] then return end
		
		local msg = ...
		if string.find(msg, "dies") then
			-- The player defeated a monster for some experience, so
			-- let's add it to the Monsters experience for the current
			-- map.
			local experience = ExpBuddyDB[addonTable.currentMap]["Monsters"]
			local monsterXP = tonumber(FindNumber(msg, 1))
			experience = experience + monsterXP
			ExpBuddyDB[addonTable.currentMap]["Monsters"] = experience
			ExpBuddyPctDB[addonTable.currentMap]["Monsters"] = ExpBuddyPctDB[addonTable.currentMap]["Monsters"] + monsterXP
			
			-- If the player has rested experience, then let's track
			-- how much experience was earned from the monster while
			-- rested.
			if GetXPExhaustion() then
				-- In case the value doesn't exist in the table.
				if ExpBuddyDB[addonTable.currentMap]["Rested"] == nil then
					ExpBuddyDB[addonTable.currentMap]["Rested"] = 0
				end
				
				local experience = ExpBuddyDB[addonTable.currentMap]["Rested"]
				local restedXP = tonumber(FindNumber(msg, 2))
				experience = experience + restedXP
				ExpBuddyDB[addonTable.currentMap]["Rested"] = experience
			end
			
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