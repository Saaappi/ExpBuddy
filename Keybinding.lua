local addonName, addonTable = ...
local e = CreateFrame("Frame")

BINDING_HEADER_EXPBUDDY = "ExpBuddy"
BINDING_NAME_EXPBUDDY_OPEN_MENU = "Open Menu"

function ExpBuddyKeyPressHandler(key)
	if key == GetBindingKey("EXPBUDDY_OPEN_MENU") then
		ExpBuddyLoadMenu()
	end
end