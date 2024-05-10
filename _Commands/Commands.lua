local addonName, addon = ...

SLASH_ExpBuddy1 = "/expb"
SLASH_ExpBuddy2 = "/expbuddy"
SlashCmdList["ExpBuddy"] = function(cmd)
	local command, subcommand, arg1 = string.split(" ", cmd)
	if not command or command == "" then
		addon.LoadFrame()
    elseif command == "reset" then
        ExpBuddyPositionDB.SavedPosition = nil
	end
end