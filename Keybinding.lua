local addonName, addonTable = ...
local e = CreateFrame("Frame")

BINDING_HEADER_EXPBUDDY = "ExpBuddy"
BINDING_NAME_EXPBUDDY_OPEN_MENU = "Open Menu"
BINDING_NAME_EXPBUDDY_OPEN_TRACKER = "Open Tracker"

function ExpBuddyKeyPressHandler(key)
	if key == GetBindingKey("EXPBUDDY_OPEN_MENU") then
		ExpBuddyLoadMenu()
	elseif key == GetBindingKey("EXPBUDDY_OPEN_TRACKER") then
		ExpBuddyTrackerLoad()
	end
end