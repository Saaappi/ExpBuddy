local addonName, addon = ...
local eventHandler = CreateFrame("Frame")

addon.CreateNewMap = function(mapID, mapName)
    ExpBuddyDataDB[mapID] = {}
    ExpBuddyDataDB[mapID].mapName = mapName
    ExpBuddyDataDB[mapID].Exploration = 0
    ExpBuddyDataDB[mapID].Monsters = 0
    ExpBuddyDataDB[mapID].Nodes = 0
    ExpBuddyDataDB[mapID].Rested = 0
    ExpBuddyDataDB[mapID].Quests = 0
end

eventHandler:RegisterEvent("ADDON_LOADED")
eventHandler:RegisterEvent("PLAYER_LOGIN")
eventHandler:RegisterEvent("ZONE_CHANGED")
eventHandler:RegisterEvent("ZONE_CHANGED_NEW_AREA")
eventHandler:SetScript("OnEvent", function(self, event, ...)
    if event == "ADDON_LOADED" then
        local addonLoaded = ...
        if addonLoaded == addonName then
            -- Make a table for the entire addon to use, namely for functions
            -- but other stuff can be put in here too.
            ExpBuddy = {}

            -- Initialize the addon's saved variables.
            if ExpBuddyDataDB == nil then
                ExpBuddyDataDB = {}
            end

            -- Unregister the event for performance.
            eventHandler:UnregisterEvent("ADDON_LOADED")
        end
    end
    if event == "PLAYER_LOGIN" then
        C_Timer.After(0.5, function()
            local mapID = C_Map.GetBestMapForUnit("player")
            -- If the mapID is valid, then set addon.mapID and
            -- create the map table if it doesn't exist.
            if mapID then
                local mapInfo = C_Map.GetMapInfo(mapID)
                if mapInfo.mapType == 3 then -- It's a zone!
                    addon.mapID = mapID
                    if not ExpBuddyDataDB[addon.mapID] then
                        addon.CreateNewMap(addon.mapID, mapInfo.name)
                    end
                end
            end

            -- Unregister the event for performance.
            eventHandler:UnregisterEvent("PLAYER_LOGIN")
        end)
    end
    if event == "ZONE_CHANGED" or event == "ZONE_CHANGED_NEW_AREA" then
        C_Timer.After(0.5, function()
            local mapID = C_Map.GetBestMapForUnit("player")
            -- If the mapID is valid, then set addon.mapID and
            -- create the map table if it doesn't exist.
            if mapID then
                local mapInfo = C_Map.GetMapInfo(mapID)
                if mapInfo.mapType == 3 then -- It's a zone!
                    addon.mapID = mapID
                    if not ExpBuddyDataDB[addon.mapID] then
                        addon.CreateNewMap(addon.mapID, mapInfo.name)
                    end
                end
            end
        end)
    end
end)