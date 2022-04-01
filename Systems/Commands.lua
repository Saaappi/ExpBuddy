local addonName, addonTable = ...
local e = CreateFrame("Frame")
local L_GLOBALSTRINGS = addonTable.L_GLOBALSTRINGS

SLASH_ExpBuddy1 = L_GLOBALSTRINGS["Slash EXP"]
SlashCmdList["ExpBuddy"] = function(command, editbox)
	local _, _, command, arguments = string.find(command, "%s?(%w+)%s?(.*)") -- Using pattern matching the addon will be able to interpret subcommands.
	if not command or command == "" then
		if ExpBuddyMenu:IsVisible() then
			ExpBuddyMenu:Hide()
		else
			ExpBuddyLoadMenu()
		end
	end
end