local addonName, addonTable = ...
local AceGUI = LibStub("AceGUI-3.0")

-- AceGUI Widgets
local frame = AceGUI:Create("Frame")
addonTable.currentMapLabel = AceGUI:Create("Label")
addonTable.monstersLabel = AceGUI:Create("Label")
addonTable.restedLabel = AceGUI:Create("Label")
addonTable.questsLabel = AceGUI:Create("Label")
addonTable.nodesLabel = AceGUI:Create("Label")
addonTable.explorationLabel = AceGUI:Create("Label")
addonTable.entryLevelEditbox = AceGUI:Create("EditBox")
addonTable.exitLevelEditbox = AceGUI:Create("EditBox")
addonTable.resetButton = AceGUI:Create("Button")

-- Hide the frame from view since the Create function
-- automatically shows it. :(
frame:Hide()

ExpBuddy = LibStub("AceAddon-3.0"):NewAddon("ExpBuddy", "AceConsole-3.0")

function ExpBuddy:SlashCommandHandler(cmd)
	local cmd, arg1 = string.split(" ", cmd)
	if not cmd or cmd == "" then
		Settings.OpenToCategory(addonName)
	elseif cmd == "tracker" then
		if frame:IsVisible() == false then
			-- I guess I need to recreate the frame since it's been hidden
			-- (see top of file).
			frame = AceGUI:Create("Frame")
			
			-- Also, since the frame was hidden I need to recreate the children.
			-- They're created twice because the labels are referenced in ExpBuddy.lua.
			addonTable.currentMapLabel = AceGUI:Create("Label")
			addonTable.monstersLabel = AceGUI:Create("Label")
			addonTable.restedLabel = AceGUI:Create("Label")
			addonTable.questsLabel = AceGUI:Create("Label")
			addonTable.nodesLabel = AceGUI:Create("Label")
			addonTable.explorationLabel = AceGUI:Create("Label")
			addonTable.entryLevelEditbox = AceGUI:Create("EditBox")
			addonTable.exitLevelEditbox = AceGUI:Create("EditBox")
			addonTable.resetButton = AceGUI:Create("Button")
			
			-- Set some attributes for the frame.
			frame:SetCallback("OnClose", function(widget) AceGUI:Release(widget) end)
			frame:SetTitle("ExpBuddy")
			frame:SetStatusText(GetAddOnMetadata(addonName, "Version"))
			frame:SetLayout("List")
			frame:EnableResize(false)
			frame:SetWidth(215)
			frame:SetHeight(350)
			
			-- Get all the labels' data.
			local labels = addonTable.GetData()
			
			-- All widgets are created in Data\Constants.lua.
			-- Current Zone Label
			addonTable.currentMapLabel:SetText("|cffFFD100" .. "Current Map|r: " .. addonTable.Substring(addonTable.currentMap))
			frame:AddChild(addonTable.currentMapLabel)
			
			-- Monsters Label
			local monstersXP = addonTable.FormatNumber(tostring(labels.Monsters))
			addonTable.monstersLabel:SetText("\n\n" .. CreateAtlasMarkup("ShipMission_DangerousSkull", 16, 16) .. " |cffFFD100" .. "Monsters|r: " .. monstersXP .. " (" .. addonTable.CalculatePercent(labels.Monsters) .. "%)")
			frame:AddChild(addonTable.monstersLabel)
			
			-- Rested XP Label
			local restedXP = addonTable.FormatNumber(tostring(labels.Rested))
			addonTable.restedLabel:SetText("\n" .. CreateAtlasMarkup("Gamepad_Rev_Home_64", 16, 16) .. " |cffFFD100" .. "Rested|r: " .. restedXP .. " (" .. addonTable.CalculatePercent(labels.Rested) .. "%)")
			frame:AddChild(addonTable.restedLabel)
			
			-- Quests Label
			local questsXP = addonTable.FormatNumber(tostring(labels.Quests))
			addonTable.questsLabel:SetText("\n" .. CreateAtlasMarkup("NPE_TurnIn", 16, 16) .. " |cffFFD100" .. "Quests|r: " .. questsXP .. " (" .. addonTable.CalculatePercent(labels.Quests) .. "%)")
			frame:AddChild(addonTable.questsLabel)
			
			-- Nodes Label
			local nodesXP = addonTable.FormatNumber(tostring(labels.Nodes))
			addonTable.nodesLabel:SetText("\n" .. CreateAtlasMarkup("Mobile-TreasureIcon", 16, 16) .. " |cffFFD100" .. "Nodes|r: " .. nodesXP .. " (" .. addonTable.CalculatePercent(labels.Nodes) .. "%)")
			frame:AddChild(addonTable.nodesLabel)
			
			-- Exploration Label
			local explorationXP = addonTable.FormatNumber(tostring(labels.Exploration))
			addonTable.explorationLabel:SetText("\n" .. CreateAtlasMarkup("GarrMission_MissionIcon-Exploration", 16, 16) .. " |cffFFD100" .. "Exploration|r: " .. explorationXP .. " (" .. addonTable.CalculatePercent(labels.Exploration) .. "%)")
			frame:AddChild(addonTable.explorationLabel)
			
			-- Entry Level Editbox
			addonTable.entryLevelEditbox:SetLabel("Entry Level")
			addonTable.entryLevelEditbox:SetWidth(75)
			addonTable.entryLevelEditbox:SetCallback("OnEnterPressed", function(widget, event, text)
				if tonumber(text) then
					ExpBuddyDataDB[addonTable.currentMap]["EntryLevel"] = tonumber(text)
				else
					print(addonTable.data["COLORED_ADDON_NAME"] .. ": Please input a number.")
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
					print(addonTable.data["COLORED_ADDON_NAME"] .. ": Please input a number.")
					addonTable.exitLevelEditbox:SetText("")
				end
			end)
			addonTable.exitLevelEditbox:SetText(ExpBuddyDataDB[addonTable.currentMap]["ExitLevel"])
			frame:AddChild(addonTable.exitLevelEditbox)
			
			-- Reset Button
			addonTable.resetButton:SetText("Reset")
			addonTable.resetButton:SetWidth(100)
			addonTable.resetButton:SetCallback("OnClick", function(widget, event, text)
				local labels = addonTable.GetData()
				if (labels.Monsters+labels.Rested+labels.Quests+labels.Nodes+labels.Exploration) == 0 then
					print(addonTable.data["COLORED_ADDON_NAME"] .. ": This zone doesn't have any data to reset.")
				else
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
							ExpBuddyDataDB[addonTable.currentMap]["EntryLevel"] = 0
							ExpBuddyDataDB[addonTable.currentMap]["ExitLevel"] = 0
							
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
				end
			end)
			frame:AddChild(addonTable.resetButton)
		else
			-- The frame and its children should be released to the widget
			-- pool on close. This is triggered if the frame is shown and
			-- the player re-enters the /xp tracker command.
			AceGUI:Release(frame)
		end
	elseif cmd == "search" and arg1 ~= nil then
		-- Make a local variable and copy the saved variable to it. We want
		-- the temporary table to sort alphabetically by map name.
		local maps = {}
		for k, v in pairs(ExpBuddyDataDB) do
			table.insert(maps, { ["name"] = k, ["map"] = v })
		end
		table.sort(maps, function(a, b)
			return string.lower(a.name) < string.lower(b.name)
		end)
		
		local str = string.lower(arg1)
		for _, data in ipairs(maps) do
			if str == "*" then
				-- Return every map's data.
				print("|cffFFD100" .. data.name .. "|r:" .. "\n" ..
					"|cffFFD100" .. "Monsters|r: " .. addonTable.FormatNumber(tostring(data.map.Monsters)) .. " |cffADD8E6(" .. addonTable.CalculatePercent(data.map.Monsters) .. "%)|r" .. "\n" ..
					"|cffFFD100" .. "Rested|r: " .. addonTable.FormatNumber(tostring(data.map.Rested)) .. " |cffADD8E6(" .. addonTable.CalculatePercent(data.map.Rested) .. "%)|r" .. "\n" ..
					"|cffFFD100" .. "Quests|r: " .. addonTable.FormatNumber(tostring(data.map.Quests)) .. " |cffADD8E6(" .. addonTable.CalculatePercent(data.map.Quests) .. "%)|r" .. "\n" ..
					"|cffFFD100" .. "Nodes|r: " .. addonTable.FormatNumber(tostring(data.map.Nodes)) .. " |cffADD8E6(" .. addonTable.CalculatePercent(data.map.Nodes) .. "%)|r" .. "\n" ..
					"|cffFFD100" .. "Exploration|r: " .. addonTable.FormatNumber(tostring(data.map.Exploration)) .. " |cffADD8E6(" .. addonTable.CalculatePercent(data.map.Exploration) .. "%)|r" .. "\n"
				)
			elseif string.find(string.lower(data.name), str) then
				-- We have a match, so print the data!
				print("|cffFFD100" .. data.name .. "|r:" .. "\n" ..
					"|cffFFD100" .. "Monsters|r: " .. addonTable.FormatNumber(tostring(data.map.Monsters)) .. " |cffADD8E6(" .. addonTable.CalculatePercent(data.map.Monsters) .. "%)|r" .. "\n" ..
					"|cffFFD100" .. "Rested|r: " .. addonTable.FormatNumber(tostring(data.map.Rested)) .. " |cffADD8E6(" .. addonTable.CalculatePercent(data.map.Rested) .. "%)|r" .. "\n" ..
					"|cffFFD100" .. "Quests|r: " .. addonTable.FormatNumber(tostring(data.map.Quests)) .. " |cffADD8E6(" .. addonTable.CalculatePercent(data.map.Quests) .. "%)|r" .. "\n" ..
					"|cffFFD100" .. "Nodes|r: " .. addonTable.FormatNumber(tostring(data.map.Nodes)) .. " |cffADD8E6(" .. addonTable.CalculatePercent(data.map.Nodes) .. "%)|r" .. "\n" ..
					"|cffFFD100" .. "Exploration|r: " .. addonTable.FormatNumber(tostring(data.map.Exploration)) .. " |cffADD8E6(" .. addonTable.CalculatePercent(data.map.Exploration) .. "%)|r" .. "\n"
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