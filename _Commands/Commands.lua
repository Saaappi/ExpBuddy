local addonName, addon = ...

SLASH_HelpMePlay1 = "/expb"
SLASH_HelpMePlay2 = "/expbuddy"
SlashCmdList["ExpBuddy"] = function(cmd)
	local command, subcommand, arg1 = string.split(" ", cmd)
	if not command or command == "" then
		addon.LoadFrame()
    elseif command == "reset" then
        ExpBuddyPositionDB.SavedPosition = nil
	end
end