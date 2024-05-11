local addonName, addon = ...

SLASH_ExpBuddy1 = "/expb"
SLASH_ExpBuddy2 = "/expbuddy"
SlashCmdList["ExpBuddy"] = function(cmd)
	local command, subcommand, arg1 = string.split(" ", cmd)
	if not command or command == "" then
		addon.LoadFrame()
	elseif tonumber(command) then
		local mapID = tonumber(command)
		if ExpBuddyDataDB[mapID] then
			addon.RefreshFrame(mapID)
		end
	else
		for mapID, mapData in pairs(ExpBuddyDataDB) do
			if addon.StringContains(mapData.mapName, command) then
				addon.RefreshFrame(mapID)
			end
		end
	end
end