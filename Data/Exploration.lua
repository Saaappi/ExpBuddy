local addonName, addonTable = ...
local e = CreateFrame("Frame")

local function FindNumber(str, nth)
	local arr = {}
	for i in string.gmatch(str, "%d+") do
		table.insert(arr, i)
	end
	return arr[nth]
end

e:RegisterEvent("CHAT_MSG_SYSTEM")
e:SetScript("OnEvent", function(self, event, ...)
	if event == "CHAT_MSG_SYSTEM" then
		if addonTable.playerLevel == addonTable.data["MAX_LEVEL"] then return end
		
		local msg = ...
		if string.find(msg, "Discovered") then
			-- The player discovered an area for some experience, so
			-- let's add it to the Exploration experience for the current
			-- map.
			local experience = ExpBuddyDB[addonTable.currentMap]["Exploration"]
			local explorationXP = tonumber(FindNumber(msg, 1))
			experience = experience + explorationXP
			ExpBuddyDB[addonTable.currentMap]["Exploration"] = experience
			ExpBuddyPctDB[addonTable.currentMap]["Exploration"] = ExpBuddyPctDB[addonTable.currentMap]["Exploration"] + explorationXP
			
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