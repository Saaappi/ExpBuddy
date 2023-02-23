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
		--[[addedHeader = {
			name = "Added",
			order = 10,
			type = "header",
		},
		addedText = {
			--name = coloredDash .. "|cffFF0000Nothing was added in this release.",
			name = coloredDash .. "Added the ability for HelpMePlay to ignore specific quest rewards from being equipped. The |cffFFD100Wind-Sealed Mana Capsule|r is the only item on the list...for now.\n" ..
			coloredDash .. "Automated the gossips for the Maidens of Inspiration during the Tyr quests.",
			order = 11,
			type = "description",
			fontSize = "medium",
		},]]
		updatedHeader = {
			name = "Changed / Updated",
			order = 20,
			type = "header",
		},
		updatedText = {
			--name = coloredDash .. "|cffFF0000Nothing was updated in this release.",
			name = coloredDash .. "Completely overhauled the entire addon and introduced the Ace3 framework.",
			order = 21,
			type = "description",
			fontSize = "medium",
		},
		--[[fixedHeader = {
			name = "Fixed",
			order = 30,
			type = "header",
		},
		fixedText = {
			name = coloredDash .. "Fixed an issue that I caused in 2.0.13 that prevented most looted items from being equipped.",
			order = 31,
			type = "description",
			fontSize = "medium",
		},]]
		--[[removedHeader = {
			name = "Removed",
			order = 40,
			type = "header",
		},
		removedText = {
			name = coloredDash .. "|cffFF0000Nothing was removed in this release.|r",
			order = 41,
			type = "description",
			fontSize = "medium",
		},]]
	},
}
addonTable.mainOptions = mainOptions