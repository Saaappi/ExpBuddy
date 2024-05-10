local addonName, addon = ...
local eventHandler = CreateFrame("Frame")

local function FindNumber(str, nth)
	local arr = {}
	for i in string.gmatch(str, "%d+") do
		table.insert(arr, i)
	end
	return arr[nth]
end

eventHandler:RegisterEvent("CHAT_MSG_SYSTEM")
eventHandler:SetScript("OnEvent", function(self, event, ...)
	if event == "CHAT_MSG_SYSTEM" then
		if addonTable.playerLevel == addonTable.data["MAX_LEVEL"] then return end
		
		local msg = ...
		if string.find(msg, "Discovered") then
			-- The player discovered an area for some experience, so
			-- let's add it to the Exploration experience for the current
			-- map.
			local experience = ExpBuddyDataDB[addonTable.currentMap]["Exploration"]
			local explorationXP = tonumber(FindNumber(msg, 1))
			experience = experience + explorationXP
			ExpBuddyDataDB[addonTable.currentMap]["Exploration"] = experience
			addonTable.explorationLabel:SetText("\n" .. CreateAtlasMarkup("GarrMission_MissionIcon-Exploration", 16, 16) .. " |cffFFD100" .. "Exploration|r: " .. addonTable.FormatNumber(tostring(experience)) .. " (" .. addonTable.CalculatePercent(ExpBuddyDataDB[addonTable.currentMap]["Exploration"]) .. "%)\n\n")
		end
	end
end)