local addonName, addonTable = ...
local coloredDash = "|cffFFD100-|r "
local mainOptions = {
	name = addonName,
	handler = ExpBuddy,
	type = "group",
	args = {
		versionText = {
			name = "|cffFFD100" .. GetAddOnMetadata(addonName, "Version") .. "|r",
			order = 0,
			type = "description",
			fontSize = "large",
		},
		expansionText = {
			name = "Dragonflight",
			order = 1,
			type = "description",
			fontSize = "medium",
		},
		changesHeader = {
			name = "Changes",
			order = 10,
			type = "header",
		},
		changesText = {
			name = coloredDash .. "Updated the TOC to support Patch 10.0.7.",
			order = 11,
			type = "description",
			fontSize = "medium",
		},
	},
}
addonTable.mainOptions = mainOptions