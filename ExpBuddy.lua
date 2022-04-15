local addonName, addonTable = ...
local e = CreateFrame("Frame")

e:RegisterEvent("ADDON_LOADED")
e:RegisterEvent("PLAYER_LEVEL_UP")
e:RegisterEvent("ZONE_CHANGED_NEW_AREA")
e:SetScript("OnEvent", function(self, event, ...)
	if event == "ADDON_LOADED" then
		local addonLoaded = ...
		if addonLoaded == addonName then
			-- If the options table is nil, then set it to
			-- an empty table.
			if ExpBuddyOptionsDB == nil then
				ExpBuddyOptionsDB = {}
			end
		
			C_Timer.After(2, function()
				local currentMapId = C_Map.GetBestMapForUnit("player")
				local currentMapInfo = C_Map.GetMapInfo(currentMapId)
				addonTable.currentMap = currentMapInfo.name
				
				-- If the primary experience table is nil, then
				-- set it to an empty table.
				if ExpBuddyDB == nil then
					ExpBuddyDB = {}
				end
				if ExpBuddyPctDB == nil then
					ExpBuddyPctDB = {}
				end
				
				-- If the player's current zone isn't in the
				-- table, then add it.
				--
				-- If the player's current zone isn't in the
				-- table, then none of the subtables will be
				-- either.
				if ExpBuddyDB[addonTable.currentMap] == nil then
					ExpBuddyDB[addonTable.currentMap] = {}
					ExpBuddyDB[addonTable.currentMap]["Quests"] = 0
					ExpBuddyDB[addonTable.currentMap]["Kills"] = 0
					ExpBuddyDB[addonTable.currentMap]["Rested"] = 0
					ExpBuddyDB[addonTable.currentMap]["Nodes"] = 0
					ExpBuddyDB[addonTable.currentMap]["Exploration"] = 0
				end
				
				-- If the player's current zone isn't in the
				-- table, then add it.
				--
				-- If the player's current zone isn't in the
				-- table, then none of the subtables will be
				-- either.
				if ExpBuddyPctDB[addonTable.currentMap] == nil then
					ExpBuddyPctDB[addonTable.currentMap] = {}
					ExpBuddyPctDB[addonTable.currentMap]["Quests"] = 0
					ExpBuddyPctDB[addonTable.currentMap]["Kills"] = 0
					ExpBuddyPctDB[addonTable.currentMap]["Nodes"] = 0
					ExpBuddyPctDB[addonTable.currentMap]["Exploration"] = 0
				end
			end)
			
			if ExpBuddyOptionsDB.MapIcon then
				ExpBuddyShowMinimapIcon(true)
			end
			
			addonTable.playerLevel = UnitLevel("player")
		end
	end
	if event == "PLAYER_LEVEL_UP" then
		local level = ...
		addonTable.playerLevel = level
		
		-- Reset all the percentage values back to
		-- 0 once the player levels up.
		C_Timer.After(2, function()
			for k,_ in pairs(ExpBuddyPctDB) do
				for i,_ in pairs(ExpBuddyPctDB[k]) do 
					ExpBuddyPctDB[k][i] = 0
				end
			end
		end)
	end
	if event == "ZONE_CHANGED_NEW_AREA" then
		local currentMapId = C_Map.GetBestMapForUnit("player")
		local currentMapInfo = C_Map.GetMapInfo(currentMapId)
		addonTable.currentMap = currentMapInfo.name
		
		-- If the player's current zone isn't in the
		-- table, then add it.
		--
		-- If the player's current zone isn't in the
		-- table, then none of the subtables will be
		-- either.
		if ExpBuddyDB[addonTable.currentMap] == nil then
			ExpBuddyDB[addonTable.currentMap] = {}
			ExpBuddyDB[addonTable.currentMap]["Quests"] = 0
			ExpBuddyDB[addonTable.currentMap]["Kills"] = 0
			ExpBuddyDB[addonTable.currentMap]["Rested"] = 0
			ExpBuddyDB[addonTable.currentMap]["Nodes"] = 0
			ExpBuddyDB[addonTable.currentMap]["Exploration"] = 0
		end
		
		if ExpBuddyPctDB[addonTable.currentMap] == nil then
			ExpBuddyPctDB[addonTable.currentMap] = {}
			ExpBuddyPctDB[addonTable.currentMap]["Quests"] = 0
			ExpBuddyPctDB[addonTable.currentMap]["Kills"] = 0
			ExpBuddyPctDB[addonTable.currentMap]["Nodes"] = 0
			ExpBuddyPctDB[addonTable.currentMap]["Exploration"] = 0
		end
	end
end)