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
		if addonTable.playerLevel == maxLevel then return end
		
		local msg = ...
		if string.find(msg, "experience%.") and not string.find(msg, "dies") then
			-- The player looted a node for some experience, so
			-- let's add it to the Nodes experience for the current
			-- map.
			-- Nodes are considered treasures, herbs, ore, etc.
			local experience = ExpBuddyDataDB[addonTable.currentMap]["Nodes"]
			local nodeXP = tonumber(FindNumber(msg, 1))
			experience = experience + nodeXP
			ExpBuddyDataDB[addonTable.currentMap]["Nodes"] = experience
			addonTable.nodesLabel:SetText("\n" .. CreateAtlasMarkup("Mobile-TreasureIcon", 16, 16) .. " |cffFFD100" .. "Nodes|r: " .. addonTable.FormatNumber(tostring(experience)))
		end
	end
end)