local addonName, addonTable = ...
local e = CreateFrame("Frame")

local function GetCurrentZone()
	local mapID = C_Map.GetBestMapForUnit("player")
	if mapID then
		local map = C_Map.GetMapInfo(mapID)
		if map then
			-- Only update the map if it's a zone or dungeon.
			if map.mapType == 3 or map.mapType == 4 then
				addonTable.currentMap = map.name
			elseif map.mapType == 5 or map.mapType == 6 then
				-- Use the parent map because these current map
				-- is either a micro or orphan part of a parenting
				-- map. (e.g. Wailing Caverns in Northern Barrens)
				map = C_Map.GetMapInfo(map.parentMapID)
				if map then
					addonTable.currentMap = map.name
				end
			end
		end
	else
		-- If the mapID is nil, then callback to the function
		-- and try again. This is delayed to not cause
		-- buffer overflow.
		C_Timer.After(1, GetCurrentZone)
	end
end

e:RegisterEvent("ADDON_LOADED")
e:RegisterEvent("PLAYER_LEVEL_UP")
e:RegisterEvent("ZONE_CHANGED")
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
		
			C_Timer.After(1, function()
				-- Set the current map either to the current map or
				-- to its parent.
				GetCurrentZone()
				
				-- If the primary experience table is nil, then
				-- set it to an empty table.
				if ExpBuddyDataDB == nil then
					ExpBuddyDataDB = {}
				end
				
				-- If the player's current zone isn't in the
				-- table, then add it.
				--
				-- If the player's current zone isn't in the
				-- table, then none of the subtables will be
				-- either.
				if ExpBuddyDataDB[addonTable.currentMap] == nil then
					ExpBuddyDataDB[addonTable.currentMap] = {}
					ExpBuddyDataDB[addonTable.currentMap]["Quests"] = 0
					ExpBuddyDataDB[addonTable.currentMap]["Monsters"] = 0
					ExpBuddyDataDB[addonTable.currentMap]["Rested"] = 0
					ExpBuddyDataDB[addonTable.currentMap]["Nodes"] = 0
					ExpBuddyDataDB[addonTable.currentMap]["Exploration"] = 0
					ExpBuddyDataDB[addonTable.currentMap]["EntryLevel"] = 0
					ExpBuddyDataDB[addonTable.currentMap]["ExitLevel"] = 0
				end
			end)
			
			addonTable.playerLevel = UnitLevel("player")
		end
	end
	
	if event == "PLAYER_LEVEL_UP" then
		local level = ...
		addonTable.playerLevel = level
	end
	
	if event == "ZONE_CHANGED" or event == "ZONE_CHANGED_NEW_AREA" then
		GetCurrentZone()
	end
end)