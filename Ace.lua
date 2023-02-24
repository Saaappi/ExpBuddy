local addonName, addonTable = ...
local AceGUI = LibStub("AceGUI-3.0")
local xpcall = xpcall

ExpBuddy = LibStub("AceAddon-3.0"):NewAddon("ExpBuddy", "AceConsole-3.0")

local function FormatNumber(number)
	local formattedNumber = number
	while true do  
		formattedNumber, k = string.gsub(formattedNumber, "^(-?%d+)(%d%d%d)", '%1,%2')
		if (k==0) then
			break
		end
	end
	return formattedNumber
end

function ExpBuddy:SlashCommandHandler(cmd)
	local cmd, arg1, arg2 = string.split(" ", cmd)
	if not cmd or cmd == "" then
		Settings.OpenToCategory(addonName)
	elseif cmd == "tracker" then
		local frame = AceGUI:Create("Frame")
		_G["ExpBuddyTrackerFrame"] = frame.frame
		frame:SetCallback("OnClose", function(widget) AceGUI:Release(widget) end)
		frame:SetTitle("ExpBuddy")
		frame:SetStatusText(GetAddOnMetadata(addonName, "Version"))
		frame:SetLayout("List")
		frame:EnableResize(false)
		frame:SetWidth(200)
		frame:SetHeight(250)
		--tinsert(UISpecialFrames, "ExpBuddyTrackerFrame")
		
		-- Monsters Label
		local monstersXP = FormatNumber(tostring(ExpBuddyDB[addonTable.currentMap]["Monsters"]))
		local monstersLabel = AceGUI:Create("Label")
		monstersLabel:SetText(CreateAtlasMarkup("ShipMission_DangerousSkull", 16, 16) .. " |cffFFD100" .. "Monsters|r: " .. monstersXP)
		frame:AddChild(monstersLabel)
		
		-- Rested XP Label
		local restedXP = FormatNumber(tostring(ExpBuddyDB[addonTable.currentMap]["Rested"]))
		local restedLabel = AceGUI:Create("Label")
		restedLabel:SetText("\n |T136090:0|t" .. " |cffFFD100" .. "Rested|r: " .. restedXP)
		frame:AddChild(restedLabel)
		
		-- Quests Label
		local questsXP = FormatNumber(tostring(ExpBuddyDB[addonTable.currentMap]["Quests"]))
		local questsLabel = AceGUI:Create("Label")
		questsLabel:SetText("\n" .. CreateAtlasMarkup("NPE_TurnIn", 16, 16) .. " |cffFFD100" .. "Quests|r: " .. questsXP)
		frame:AddChild(questsLabel)
		
		-- Nodes Label
		local nodesXP = FormatNumber(tostring(ExpBuddyDB[addonTable.currentMap]["Nodes"]))
		local nodesLabel = AceGUI:Create("Label")
		nodesLabel:SetText("\n" .. CreateAtlasMarkup("Mobile-TreasureIcon", 16, 16) .. " |cffFFD100" .. "Nodes|r: " .. nodesXP)
		frame:AddChild(nodesLabel)
		
		-- Exploration Label
		local explorationXP = FormatNumber(tostring(ExpBuddyDB[addonTable.currentMap]["Exploration"]))
		local explorationLabel = AceGUI:Create("Label")
		explorationLabel:SetText("\n" .. CreateAtlasMarkup("GarrMission_MissionIcon-Exploration", 16, 16) .. " |cffFFD100" .. "Exploration|r: " .. explorationXP)
		frame:AddChild(explorationLabel)
		
		-- Entry Level Editbox
		local entryLevelEditbox = AceGUI:Create("EditBox")
		entryLevelEditbox:SetLabel("Entry Level")
		entryLevelEditbox:SetWidth(75)
		entryLevelEditbox:SetCallback("OnEnterPressed", function(widget, event, text)
			if tonumber(text) then
				ExpBuddy[addonTable.currentMap]["EntryLevel"] = tonumber(text)
			end
		end)
		frame:AddChild(entryLevelEditbox)
		
		-- Exit Level Editbox
		local exitLevelEditbox = AceGUI:Create("EditBox")
		exitLevelEditbox:SetLabel("Exit Level")
		exitLevelEditbox:SetWidth(75)
		exitLevelEditbox:SetCallback("OnEnterPressed", function(widget, event, text)
			if tonumber(text) then
				ExpBuddy[addonTable.currentMap]["ExitLevel"] = tonumber(text)
			end
		end)
		frame:AddChild(exitLevelEditbox)
	end
end

function ExpBuddy:OnInitialize()
	LibStub("AceConfig-3.0"):RegisterOptionsTable("ExpBuddy_Main", addonTable.mainOptions)
	self.mainOptions = LibStub("AceConfigDialog-3.0"):AddToBlizOptions("ExpBuddy_Main", addonName); addonTable.mainOptions = self.mainOptions
	self:RegisterChatCommand("xp", "SlashCommandHandler")
end