local addonName, addonTable = ...

BINDING_HEADER_EXPBUDDY = "ExpBuddy"
BINDING_NAME_EXPBUDDY_OPEN_TRACKER = "Open Tracker"

function ExpBuddyKeybindHandler(key)
	if key == GetBindingKey("EXPBUDDY_OPEN_TRACKER") then
		ExpBuddy:SlashCommandHandler("tracker")
	end
end