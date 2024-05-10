local addonName, addon = ...

local frame
local frameBaseHeight = 350
local frameBaseWidth = 275

local currentMapName
local entryLevelEditBox
local exitLevelEditBox
local monsterExperience
local restedExperience
local questExperience
local nodeExperience
local explorationExperience
local icons = {
	{
		["name"] = "Monsters",
		["texture"] = 237272,
	},
	{
		["name"] = "Rested",
		["texture"] = 134414,
	},
	{
		["name"] = "Quests",
		["texture"] = 236669,
	},
	{
		["name"] = "Nodes",
		["texture"] = 133939,
	},
	{
		["name"] = "Exploration",
		["texture"] = 1032149,
	},
}
local versionText
local resetButton

-- Refreshes the frame to update any values that may have changed
-- or need to change.
addon.RefreshFrame = function(mapID)
	if frame and frame:IsVisible() then
		currentMapName:SetText(addon.TruncateMapName(ExpBuddyDataDB[mapID].mapName))
		entryLevelEditBox:SetText(tostring(ExpBuddyDataDB[mapID].entryLevel or 0))
		exitLevelEditBox:SetText(tostring(ExpBuddyDataDB[mapID].exitLevel or 0))
		monsterExperience:SetText(format("|cffFFFFFF%s (%s%%)|r", tostring(addon.FormatNumber(ExpBuddyDataDB[addon.mapID].Monsters)), addon.CalculatePercent(ExpBuddyDataDB[addon.mapID].Monsters)))
		restedExperience:SetText(format("|cffFFFFFF%s (%s%%)|r", tostring(addon.FormatNumber(ExpBuddyDataDB[addon.mapID].Rested)), addon.CalculatePercent(ExpBuddyDataDB[addon.mapID].Rested)))
		questExperience:SetText(format("|cffFFFFFF%s (%s%%)|r", tostring(addon.FormatNumber(ExpBuddyDataDB[addon.mapID].Quests)), addon.CalculatePercent(ExpBuddyDataDB[addon.mapID].Quests)))
		nodeExperience:SetText(format("|cffFFFFFF%s (%s%%)|r", tostring(addon.FormatNumber(ExpBuddyDataDB[addon.mapID].Nodes)), addon.CalculatePercent(ExpBuddyDataDB[addon.mapID].Nodes)))
		explorationExperience:SetText(format("|cffFFFFFF%s (%s%%)|r", tostring(addon.FormatNumber(ExpBuddyDataDB[addon.mapID].Exploration)), addon.CalculatePercent(ExpBuddyDataDB[addon.mapID].Exploration)))
	end
end

addon.LoadFrame = function()
	-- If the frame is already visible, then hide it.
	if frame then
		if frame:IsVisible() then
			frame:Hide()
			return
		end
	end

	-- Create the frame if it doesn't exist and set some standard attributes
	-- for the frame.
	if not frame then
		frame = CreateFrame("Frame", addonName .. "Frame", UIParent, "BasicFrameTemplateWithInset")
		frame:SetSize(frameBaseWidth, frameBaseHeight)
		frame.TitleText:SetText(addonName)
	end

	-- If the player has opened the frame before and moved it, then use the
	-- saved position for the new SetPoint, otherwise use the default.
	if ExpBuddyPositionDB.SavedPosition then
		frame:SetPoint(unpack(ExpBuddyPositionDB.SavedPosition))
	else
		frame:SetPoint("CENTER", UIParent, "CENTER")
	end

	-- Make the frame movable.
	frame:SetMovable(true)
	frame:EnableMouse(true)
	frame:RegisterForDrag("LeftButton")
	frame:SetScript("OnDragStart", function(self)
		self:StartMoving()
	end)
	frame:SetScript("OnDragStop", function(self)
		-- Once the frame stops moving, get the position data so we
		-- can open the frame at that position next time.
		self:StopMovingOrSizing()
		local point, _, relativePoint, xOfs, yOfs = self:GetPoint()
		ExpBuddyPositionDB.SavedPosition = { point, "UIParent", relativePoint, xOfs, yOfs }
	end)

	-- Create a font string for showing the current map name.
	currentMapName = frame:CreateFontString(nil, nil, "GameFontNormal")
	currentMapName:SetPoint("TOP", frame, "TOP", 0, -30)
	currentMapName:SetText(addon.TruncateMapName(ExpBuddyDataDB[addon.mapID].mapName))

	-- Create the entry level edit box.
	entryLevelEditBox = CreateFrame("EditBox", addonName .. "EntryLevelEditBox", frame, "InputBoxTemplate")
	entryLevelEditBox:SetAutoFocus(false)
	entryLevelEditBox:SetSize(80, 10)
	entryLevelEditBox:SetFontObject("ChatFontNormal")

	entryLevelEditBox.title = entryLevelEditBox:CreateFontString(nil, nil, "GameTooltipText")
	entryLevelEditBox.title:SetPoint("BOTTOMLEFT", entryLevelEditBox, "TOPLEFT", 0, 5)
	entryLevelEditBox.title:SetText("Entry Level")

	entryLevelEditBox:SetText(tostring(ExpBuddyDataDB[addon.mapID].entryLevel or 0))

	entryLevelEditBox:SetScript("OnEnterPressed", function(self)
		if tonumber(self:GetText(), 10) then
			ExpBuddyDataDB[addon.mapID].entryLevel = tonumber(self:GetText(), 10)
			self:SetText(ExpBuddyDataDB[addon.mapID].entryLevel)
			self:ClearFocus()
		else
			ExpBuddy.Print("The value must be a number.")
		end
	end)
	entryLevelEditBox:SetPoint("TOPLEFT", frame, "TOPLEFT", 15, -75)

	-- Create the exit level edit box.
	exitLevelEditBox = CreateFrame("EditBox", addonName .. "EntryLevelEditBox", frame, "InputBoxTemplate")
	exitLevelEditBox:SetAutoFocus(false)
	exitLevelEditBox:SetSize(80, 10)
	exitLevelEditBox:SetFontObject("ChatFontNormal")

	exitLevelEditBox.title = entryLevelEditBox:CreateFontString(nil, nil, "GameTooltipText")
	exitLevelEditBox.title:SetPoint("BOTTOMLEFT", exitLevelEditBox, "TOPLEFT", 0, 5)
	exitLevelEditBox.title:SetText("Exit Level")

	exitLevelEditBox:SetText(tostring(ExpBuddyDataDB[addon.mapID].exitLevel or 0))

	exitLevelEditBox:SetScript("OnEnterPressed", function(self)
		if tonumber(self:GetText(), 10) then
			ExpBuddyDataDB[addon.mapID].exitLevel = tonumber(self:GetText(), 10)
			self:SetText(ExpBuddyDataDB[addon.mapID].exitLevel)
			self:ClearFocus()
		else
			ExpBuddy.Print("The value must be a number.")
		end
	end)
	exitLevelEditBox:SetPoint("TOPRIGHT", frame, "TOPRIGHT", -15, -75)

	-- Create the different category icons and labels in the frame.
	for index, icon in ipairs(icons) do
		local texture = frame:CreateTexture(addonName .. "FrameIcon" .. index, "BORDER")
		if index == 1 then
			texture:SetPoint("TOPLEFT", entryLevelEditBox, "BOTTOMLEFT", 0, -20)
		else
			texture:SetPoint("TOPLEFT", addonName .. "FrameIcon" .. (index - 1), "BOTTOMLEFT", 0, -15)
		end
		texture:SetSize(24, 24)
		texture:SetTexture(icon.texture)

		local iconLabel = frame:CreateFontString(nil, nil, "GameFontNormal")
		iconLabel:SetPoint("LEFT", addonName .. "FrameIcon" .. index, "RIGHT", 5, 0)
		iconLabel:SetText(icon.name)

		local border = frame:CreateTexture(nil, "ARTWORK")
		border:SetPoint("CENTER", texture, "CENTER", 0, 0)
		border:SetSize(29, 29)
		border:SetAtlas("Forge-ColorSwatchBorder", false)
	end

	-- Add in the font strings for the various experience values.
	monsterExperience = frame:CreateFontString(nil, nil, "GameFontNormal")
	monsterExperience:SetPoint("LEFT", addonName .. "FrameIcon" .. 1, "RIGHT", 80, 0)
	monsterExperience:SetPoint("RIGHT", -15, 0)
	monsterExperience:SetJustifyH("RIGHT")
	monsterExperience:SetText(format("|cffFFFFFF%s (%s%%)|r", tostring(addon.FormatNumber(ExpBuddyDataDB[addon.mapID].Monsters)), addon.CalculatePercent(ExpBuddyDataDB[addon.mapID].Monsters)))

	restedExperience = frame:CreateFontString(nil, nil, "GameFontNormal")
	restedExperience:SetPoint("LEFT", addonName .. "FrameIcon" .. 2, "RIGHT", 80, 0)
	restedExperience:SetPoint("RIGHT", -15, 0)
	restedExperience:SetJustifyH("RIGHT")
	restedExperience:SetText(format("|cffFFFFFF%s (%s%%)|r", tostring(addon.FormatNumber(ExpBuddyDataDB[addon.mapID].Rested)), addon.CalculatePercent(ExpBuddyDataDB[addon.mapID].Rested)))

	questExperience = frame:CreateFontString(nil, nil, "GameFontNormal")
	questExperience:SetPoint("LEFT", addonName .. "FrameIcon" .. 3, "RIGHT", 80, 0)
	questExperience:SetPoint("RIGHT", -15, 0)
	questExperience:SetJustifyH("RIGHT")
	questExperience:SetText(format("|cffFFFFFF%s (%s%%)|r", tostring(addon.FormatNumber(ExpBuddyDataDB[addon.mapID].Quests)), addon.CalculatePercent(ExpBuddyDataDB[addon.mapID].Quests)))

	nodeExperience = frame:CreateFontString(nil, nil, "GameFontNormal")
	nodeExperience:SetPoint("LEFT", addonName .. "FrameIcon" .. 4, "RIGHT", 80, 0)
	nodeExperience:SetPoint("RIGHT", -15, 0)
	nodeExperience:SetJustifyH("RIGHT")
	nodeExperience:SetText(format("|cffFFFFFF%s (%s%%)|r", tostring(addon.FormatNumber(ExpBuddyDataDB[addon.mapID].Nodes)), addon.CalculatePercent(ExpBuddyDataDB[addon.mapID].Nodes)))

	explorationExperience = frame:CreateFontString(nil, nil, "GameFontNormal")
	explorationExperience:SetPoint("LEFT", addonName .. "FrameIcon" .. 5, "RIGHT", 80, 0)
	explorationExperience:SetPoint("RIGHT", -15, 0)
	explorationExperience:SetJustifyH("RIGHT")
	explorationExperience:SetText(format("|cffFFFFFF%s (%s%%)|r", tostring(addon.FormatNumber(ExpBuddyDataDB[addon.mapID].Exploration)), addon.CalculatePercent(ExpBuddyDataDB[addon.mapID].Exploration)))

	versionText = frame:CreateFontString(nil, nil, "GameFontNormal")
	versionText:SetPoint("BOTTOMLEFT", frame, "BOTTOMLEFT", 15, 15)
	versionText:SetText(C_AddOns.GetAddOnMetadata(addonName, "Version"))

	frame:Show()
end
--local AceGUI = LibStub("AceGUI-3.0")
--[[
-- AceGUI Widgets
local frame = AceGUI:Create("Frame")
addonTable.currentMapLabel = AceGUI:Create("Label")
addonTable.monstersLabel = AceGUI:Create("Label")
addonTable.restedLabel = AceGUI:Create("Label")
addonTable.questsLabel = AceGUI:Create("Label")
addonTable.nodesLabel = AceGUI:Create("Label")
addonTable.explorationLabel = AceGUI:Create("Label")
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
			addonTable.resetButton = AceGUI:Create("Button")
			
			-- Set some attributes for the frame.
			frame:SetCallback("OnClose", function(widget) AceGUI:Release(widget) end)
			frame:SetTitle("ExpBuddy")
			frame:SetStatusText(C_AddOns.GetAddOnMetadata(addonName, "Version"))
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
			addonTable.explorationLabel:SetText("\n" .. CreateAtlasMarkup("GarrMission_MissionIcon-Exploration", 16, 16) .. " |cffFFD100" .. "Exploration|r: " .. explorationXP .. " (" .. addonTable.CalculatePercent(labels.Exploration) .. "%)\n\n")
			frame:AddChild(addonTable.explorationLabel)
			
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
					"|cffFFD100" .. "Exploration|r: " .. addonTable.FormatNumber(tostring(data.map.Exploration)) .. " |cffADD8E6(" .. addonTable.CalculatePercent(data.map.Exploration) .. "%)|r"
				)
			elseif string.find(string.lower(data.name), str) then
				-- We have a match, so print the data!
				print("|cffFFD100" .. data.name .. "|r:" .. "\n" ..
					"|cffFFD100" .. "Monsters|r: " .. addonTable.FormatNumber(tostring(data.map.Monsters)) .. " |cffADD8E6(" .. addonTable.CalculatePercent(data.map.Monsters) .. "%)|r" .. "\n" ..
					"|cffFFD100" .. "Rested|r: " .. addonTable.FormatNumber(tostring(data.map.Rested)) .. " |cffADD8E6(" .. addonTable.CalculatePercent(data.map.Rested) .. "%)|r" .. "\n" ..
					"|cffFFD100" .. "Quests|r: " .. addonTable.FormatNumber(tostring(data.map.Quests)) .. " |cffADD8E6(" .. addonTable.CalculatePercent(data.map.Quests) .. "%)|r" .. "\n" ..
					"|cffFFD100" .. "Nodes|r: " .. addonTable.FormatNumber(tostring(data.map.Nodes)) .. " |cffADD8E6(" .. addonTable.CalculatePercent(data.map.Nodes) .. "%)|r" .. "\n" ..
					"|cffFFD100" .. "Exploration|r: " .. addonTable.FormatNumber(tostring(data.map.Exploration)) .. " |cffADD8E6(" .. addonTable.CalculatePercent(data.map.Exploration) .. "%)|r"
				)
			end
		end
	end
end

function ExpBuddy:OnInitialize()
	LibStub("AceConfig-3.0"):RegisterOptionsTable("ExpBuddy_Main", addonTable.mainOptions)
	self.mainOptions = LibStub("AceConfigDialog-3.0"):AddToBlizOptions("ExpBuddy_Main", addonName); addonTable.mainOptions = self.mainOptions
	self:RegisterChatCommand("xp", "SlashCommandHandler")
end]]