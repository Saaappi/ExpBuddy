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
		addedHeader = {
			name = "Added",
			order = 10,
			type = "header",
		},
		addedText = {
			name = coloredDash .. "Added support for a keybind to open and close the tracker.",
			order = 11,
			type = "description",
			fontSize = "medium",
		},
		--[[updatedHeader = {
			name = "Changed / Updated",
			order = 20,
			type = "header",
		},
		updatedText = {
			name = "",
			order = 21,
			type = "description",
			fontSize = "medium",
		},]]
		--[[fixedHeader = {
			name = "Fixed",
			order = 30,
			type = "header",
		},
		fixedText = {
			name = "",
			order = 31,
			type = "description",
			fontSize = "medium",
		},]]
		removedHeader = {
			name = "Removed",
			order = 40,
			type = "header",
		},
		removedText = {
			name = coloredDash .. "Removed the Entry and Exit Level editboxes from the tracker.",
			order = 41,
			type = "description",
			fontSize = "medium",
		},
	},
}
addonTable.mainOptions = mainOptions