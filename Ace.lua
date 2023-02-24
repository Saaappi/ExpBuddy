local addonName, addonTable = ...
local AceGUI = LibStub("AceGUI-3.0")
local xpcall = xpcall

ExpBuddy = LibStub("AceAddon-3.0"):NewAddon("ExpBuddy", "AceConsole-3.0")

function ExpBuddy:SlashCommandHandler(cmd)
	local cmd, arg1, arg2 = string.split(" ", cmd)
	if not cmd or cmd == "" then
		Settings.OpenToCategory(addonName)
	elseif cmd == "tracker" then
		local frame = AceGUI:Create("Frame")
		frame:SetCallback("OnClose", function(widget) AceGUI:Release(widget) end)
		frame:SetTitle("ExpBuddy")
		frame:SetStatusText(GetAddOnMetadata(addonName, "Version"))
		frame:SetLayout("List")
		frame:EnableResize(false)
		frame:SetWidth(200)
		frame:SetHeight(300)
		
		-- All widgets are created in Data\Constants.lua.
		-- Current Zone Label
		addonTable.currentMapLabel:SetText("|cffFFD100" .. "Current Map|r: " .. addonTable.Substring(addonTable.currentMap))
		frame:AddChild(addonTable.currentMapLabel)
		
		-- Monsters Label
		local monstersXP = addonTable.FormatNumber(tostring(ExpBuddyDataDB[addonTable.currentMap]["Monsters"]))
		addonTable.monstersLabel:SetText("\n" .. CreateAtlasMarkup("ShipMission_DangerousSkull", 16, 16) .. " |cffFFD100" .. "Monsters|r: " .. monstersXP)
		frame:AddChild(addonTable.monstersLabel)
		
		-- Rested XP Label
		local restedXP = addonTable.FormatNumber(tostring(ExpBuddyDataDB[addonTable.currentMap]["Rested"]))
		addonTable.restedLabel:SetText("\n |T136090:0|t" .. " |cffFFD100" .. "Rested|r: " .. restedXP)
		frame:AddChild(addonTable.restedLabel)
		
		-- Quests Label
		local questsXP = addonTable.FormatNumber(tostring(ExpBuddyDataDB[addonTable.currentMap]["Quests"]))
		addonTable.questsLabel:SetText("\n" .. CreateAtlasMarkup("NPE_TurnIn", 16, 16) .. " |cffFFD100" .. "Quests|r: " .. questsXP)
		frame:AddChild(addonTable.questsLabel)
		
		-- Nodes Label
		local nodesXP = addonTable.FormatNumber(tostring(ExpBuddyDataDB[addonTable.currentMap]["Nodes"]))
		addonTable.nodesLabel:SetText("\n" .. CreateAtlasMarkup("Mobile-TreasureIcon", 16, 16) .. " |cffFFD100" .. "Nodes|r: " .. nodesXP)
		frame:AddChild(addonTable.nodesLabel)
		
		-- Exploration Label
		local explorationXP = addonTable.FormatNumber(tostring(ExpBuddyDataDB[addonTable.currentMap]["Exploration"]))
		addonTable.explorationLabel:SetText("\n" .. CreateAtlasMarkup("GarrMission_MissionIcon-Exploration", 16, 16) .. " |cffFFD100" .. "Exploration|r: " .. explorationXP)
		frame:AddChild(addonTable.explorationLabel)
		
		-- Entry Level Editbox
		addonTable.entryLevelEditbox:SetLabel("Entry Level")
		addonTable.entryLevelEditbox:SetWidth(75)
		addonTable.entryLevelEditbox:SetCallback("OnEnterPressed", function(widget, event, text)
			if tonumber(text) then
				ExpBuddyDataDB[addonTable.currentMap]["EntryLevel"] = tonumber(text)
			else
				print("Please input a number.")
				addonTable.entryLevelEditbox:SetText("")
			end
		end)
		addonTable.entryLevelEditbox:SetText(ExpBuddyDataDB[addonTable.currentMap]["EntryLevel"])
		frame:AddChild(addonTable.entryLevelEditbox)
		
		-- Exit Level Editbox
		addonTable.exitLevelEditbox:SetLabel("Exit Level")
		addonTable.exitLevelEditbox:SetWidth(75)
		addonTable.exitLevelEditbox:SetCallback("OnEnterPressed", function(widget, event, text)
			if tonumber(text) then
				ExpBuddyDataDB[addonTable.currentMap]["ExitLevel"] = tonumber(text)
			else
				print("Please input a number.")
				addonTable.exitLevelEditbox:SetText("")
			end
		end)
		addonTable.exitLevelEditbox:SetText(ExpBuddyDataDB[addonTable.currentMap]["ExitLevel"])
		frame:AddChild(addonTable.exitLevelEditbox)
	end
end

function ExpBuddy:OnInitialize()
	LibStub("AceConfig-3.0"):RegisterOptionsTable("ExpBuddy_Main", addonTable.mainOptions)
	self.mainOptions = LibStub("AceConfigDialog-3.0"):AddToBlizOptions("ExpBuddy_Main", addonName); addonTable.mainOptions = self.mainOptions
	self:RegisterChatCommand("xp", "SlashCommandHandler")
end