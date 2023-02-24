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
			local experience = ExpBuddyDataDB[addonTable.currentMap]["Monsters"]
			local monsterXP = tonumber(FindNumber(msg, 1))
			experience = experience + monsterXP
			ExpBuddyDataDB[addonTable.currentMap]["Monsters"] = experience
			addonTable.monstersLabel:SetText(CreateAtlasMarkup("ShipMission_DangerousSkull", 16, 16) .. " |cffFFD100" .. "Monsters|r: " .. addonTable.FormatNumber(tostring(experience)))
			
			-- If the player has rested experience, then let's track
			-- how much experience was earned from the monster while
			-- rested.
			if GetXPExhaustion() then
				-- In case the value doesn't exist in the table.
				if ExpBuddyDataDB[addonTable.currentMap]["Rested"] == nil then
					ExpBuddyDataDB[addonTable.currentMap]["Rested"] = 0
				end
				
				local experience = ExpBuddyDataDB[addonTable.currentMap]["Rested"]
				local restedXP = tonumber(FindNumber(msg, 2))
				experience = experience + restedXP
				ExpBuddyDataDB[addonTable.currentMap]["Rested"] = experience
				addonTable.restedLabel:SetText("\n |T136090:0|t" .. " |cffFFD100" .. "Rested|r: " .. addonTable.FormatNumber(tostring(experience)))
			end
		end
	end
end)