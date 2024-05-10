local addonName, addon = ...
local eventHandler = CreateFrame("Frame")

eventHandler:RegisterEvent("ADDON_LOADED")
eventHandler:RegisterEvent("PLAYER_LOGIN")
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
end)