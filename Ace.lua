local addonName, addonTable = ...
local AceGUI = LibStub("AceGUI-3.0")
local xpcall = xpcall

ExpBuddy = LibStub("AceAddon-3.0"):NewAddon("ExpBuddy", "AceConsole-3.0")

function ExpBuddy:SlashCommandHandler(cmd)
	local cmd, arg1 = string.split(" ", cmd)
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
		frame:SetHeight(350)
		
		-- All widgets are created in Data\Constants.lua.
		-- Current Zone Label
		addonTable.currentMapLabel:SetText("|cffFFD100" .. "Current Map|r: " .. addonTable.Substring(addonTable.currentMap))
		frame:AddChild(addonTable.currentMapLabel)
		
		-- Monsters Label
		local monstersXP = addonTable.FormatNumber(tostring(ExpBuddyDataDB[addonTable.currentMap]["Monsters"]))
		addonTable.monstersLabel:SetText("\n" .. CreateAtlasMarkup("ShipMission_DangerousSkull", 16, 16) .. " |cffFFD100" .. "Monsters|r: " .. monstersXP .. " (" .. addonTable.CalculatePercent(ExpBuddyDataDB[addonTable.currentMap]["Monsters"]) .. "%)")
		frame:AddChild(addonTable.monstersLabel)
		
		-- Rested XP Label
		local restedXP = addonTable.FormatNumber(tostring(ExpBuddyDataDB[addonTable.currentMap]["Rested"]))
		addonTable.restedLabel:SetText("\n" .. CreateAtlasMarkup("Gamepad_Rev_Home_64", 16, 16) .. " |cffFFD100" .. "Rested|r: " .. restedXP .. " (" .. addonTable.CalculatePercent(ExpBuddyDataDB[addonTable.currentMap]["Rested"]) .. "%)")
		frame:AddChild(addonTable.restedLabel)
		
		-- Quests Label
		local questsXP = addonTable.FormatNumber(tostring(ExpBuddyDataDB[addonTable.currentMap]["Quests"]))
		addonTable.questsLabel:SetText("\n" .. CreateAtlasMarkup("NPE_TurnIn", 16, 16) .. " |cffFFD100" .. "Quests|r: " .. questsXP .. " (" .. addonTable.CalculatePercent(ExpBuddyDataDB[addonTable.currentMap]["Quests"]) .. "%)")
		frame:AddChild(addonTable.questsLabel)
		
		-- Nodes Label
		local nodesXP = addonTable.FormatNumber(tostring(ExpBuddyDataDB[addonTable.currentMap]["Nodes"]))
		addonTable.nodesLabel:SetText("\n" .. CreateAtlasMarkup("Mobile-TreasureIcon", 16, 16) .. " |cffFFD100" .. "Nodes|r: " .. nodesXP .. " (" .. addonTable.CalculatePercent(ExpBuddyDataDB[addonTable.currentMap]["Nodes"]) .. "%)")
		frame:AddChild(addonTable.nodesLabel)
		
		-- Exploration Label
		local explorationXP = addonTable.FormatNumber(tostring(ExpBuddyDataDB[addonTable.currentMap]["Exploration"]))
		addonTable.explorationLabel:SetText("\n" .. CreateAtlasMarkup("GarrMission_MissionIcon-Exploration", 16, 16) .. " |cffFFD100" .. "Exploration|r: " .. explorationXP .. " (" .. addonTable.CalculatePercent(ExpBuddyDataDB[addonTable.currentMap]["Exploration"]) .. "%)")
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
		
		-- Reset Button
		addonTable.resetButton:SetText("Reset")
		addonTable.resetButton:SetWidth(100)
		addonTable.resetButton:SetCallback("OnClick", function(widget, event, text)
			StaticPopupDialogs["EXPBUDDY_ACK_RESET"] = {
				text = "Are you sure you want to reset the data for |cffFFD100" .. addonTable.currentMap .. "|r?",
				button1 = YES,
				button2 = CANCEL,
				OnAccept = function(self, data)
					-- Reset zone data to 0
					ExpBuddyDataDB[addonTable.currentMap]["Monsters"] = 0
					ExpBuddyDataDB[addonTable.currentMap]["Rested"] = 0
					ExpBuddyDataDB[addonTable.currentMap]["Quests"] = 0
					ExpBuddyDataDB[addonTable.currentMap]["Nodes"] = 0
					ExpBuddyDataDB[addonTable.currentMap]["Exploration"] = 0
					
					-- Update labels
					addonTable.ResetLabels()
				end,
				showAlert = true,
				whileDead = false,
				hideOnEscape = true,
				enterClicksFirstButton = true,
				preferredIndex = 3,
			}
			StaticPopup_Show("EXPBUDDY_ACK_RESET")
		end)
		frame:AddChild(addonTable.resetButton)
	elseif cmd == "search" and arg1 ~= nil then
		local str = string.lower(arg1)
		for name, data in pairs(ExpBuddyDataDB) do
			if string.find(string.lower(name), str) then
				-- We have a zone name match, so print the data!
				print("|cffFFD100" .. name .. "|r:" .. "\n" ..
					"|cffFFD100" .. "Monsters|r: " .. addonTable.FormatNumber(tostring(ExpBuddyDataDB[addonTable.currentMap]["Monsters"])) .. " |cffADD8E6(" .. addonTable.CalculatePercent(ExpBuddyDataDB[addonTable.currentMap]["Monsters"]) .. "%)|r" .. "\n" ..
					"|cffFFD100" .. "Rested|r: " .. addonTable.FormatNumber(tostring(ExpBuddyDataDB[addonTable.currentMap]["Rested"])) .. " |cffADD8E6(" .. addonTable.CalculatePercent(ExpBuddyDataDB[addonTable.currentMap]["Rested"]) .. "%)|r" .. "\n" ..
					"|cffFFD100" .. "Quests|r: " .. addonTable.FormatNumber(tostring(ExpBuddyDataDB[addonTable.currentMap]["Quests"])) .. " |cffADD8E6(" .. addonTable.CalculatePercent(ExpBuddyDataDB[addonTable.currentMap]["Quests"]) .. "%)|r" .. "\n" ..
					"|cffFFD100" .. "Nodes|r: " .. addonTable.FormatNumber(tostring(ExpBuddyDataDB[addonTable.currentMap]["Nodes"])) .. " |cffADD8E6(" .. addonTable.CalculatePercent(ExpBuddyDataDB[addonTable.currentMap]["Nodes"]) .. "%)|r" .. "\n" ..
					"|cffFFD100" .. "Exploration|r: " .. addonTable.FormatNumber(tostring(ExpBuddyDataDB[addonTable.currentMap]["Exploration"])) .. " |cffADD8E6(" .. addonTable.CalculatePercent(ExpBuddyDataDB[addonTable.currentMap]["Exploration"]) .. "%)|r" .. "\n"
				)
			end
		end
	end
end

function ExpBuddy:OnInitialize()
	LibStub("AceConfig-3.0"):RegisterOptionsTable("ExpBuddy_Main", addonTable.mainOptions)
	self.mainOptions = LibStub("AceConfigDialog-3.0"):AddToBlizOptions("ExpBuddy_Main", addonName); addonTable.mainOptions = self.mainOptions
	self:RegisterChatCommand("xp", "SlashCommandHandler")
end