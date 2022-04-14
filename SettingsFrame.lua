local addonName, addonTable = ...
local e = CreateFrame("Frame")
local L_DIALOG = addonTable.L_DIALOG
local L_NOTES = addonTable.L_NOTES
local L_GLOBALSTRINGS = addonTable.L_GLOBALSTRINGS
local icon = ""

local function ShowTooltip(self, text)
	GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
	GameTooltip:SetText(text)
	GameTooltip:Show()
end

local function HideTooltip(self)
	if GameTooltip:GetOwner() == self then
		GameTooltip:Hide()
	end
end

local function FormatNumber(number)
	local formattedNumber = number
	while true do
		formattedNumber, k = string.gsub(formattedNumber, "^(-?%d+)(%d%d%d)", '%1,%2')
		if k == 0 then
			break
		end
	end
	return formattedNumber
end

function ExpBuddyShowMinimapIcon(show)
	if show then
		if icon ~= "" then
			icon:Show(addonName)
		else
			icon = LibStub("LibDBIcon-1.0")
			-- Create a Lib DB first to hold all the
			-- information for the minimap icon.
			local iconLDB = LibStub:GetLibrary("LibDataBroker-1.1"):NewDataObject(addonName, {
				type = "launcher",
				icon = "Interface\\Icons\\xp_icon",
				OnTooltipShow = function(tooltip)
					tooltip:SetText(L_GLOBALSTRINGS["Colored Addon Name"] .. " |cffFFFFFFv" .. GetAddOnMetadata(addonName, "Version") .. "|r")
					tooltip:AddLine("Open the addon menu and search experience data!")
					tooltip:Show()
				end,
				OnClick = function() ExpBuddyLoadMenu() end,
			})
			
			-- Register the minimap button with the
			-- LDB.
			icon:Register(addonName, iconLDB, ExpBuddyOptionsDB)
			icon:Show(addonName)
		end
	else
		icon:Hide(addonName)
	end
end

function ExpBuddyLoadMenu()
	if ExpBuddyMenu:IsVisible() then
		ExpBuddyMenu:Hide()
		PlaySound(SOUNDKIT.IG_SPELLBOOK_CLOSE)
	else
		if UnitAffectingCombat("player") == false then
			ExpBuddyMenu:Show()
			
			PlaySound(SOUNDKIT.IG_SPELLBOOK_OPEN)
			
			-- Make the menu movable.
			ExpBuddyMenu:SetMovable(true)
			ExpBuddyMenu:EnableMouse(true)
			ExpBuddyMenu:RegisterForDrag("LeftButton")
			ExpBuddyMenu:SetScript("OnDragStart", ExpBuddyMenu.StartMoving)
			ExpBuddyMenu:SetScript("OnDragStop", ExpBuddyMenu.StopMovingOrSizing)
			
			-- Check settings!
			if ExpBuddyOptionsDB.Trace then
				ExpBuddyTraceCB:SetChecked(true)
				ExpBuddyVerboseCB:Show()
				ExpBuddyVerboseText:Show()
			else
				ExpBuddyTraceCB:SetChecked(false)
				ExpBuddyVerboseCB:Hide()
				ExpBuddyVerboseText:Hide()
			end
			if ExpBuddyOptionsDB.Verbose then
				ExpBuddyVerboseCB:SetChecked(true)
			else
				ExpBuddyVerboseCB:SetChecked(false)
			end
			if ExpBuddyOptionsDB.MapIcon then
				ExpBuddyMapIconCB:SetChecked(true)
			else
				ExpBuddyMapIconCB:SetChecked(false)
			end
			
			-- Make the icons circular.
			SetPortraitToTexture(ExpBuddyQuestsIcon, "Interface\\ICONS\\achievement_quests_completed_08")
			SetPortraitToTexture(ExpBuddyKillsIcon, "Interface\\ICONS\\inv_misc_bone_humanskull_01")
			SetPortraitToTexture(ExpBuddyExplorationIcon, "Interface\\ICONS\\inv_misc_map02")
			SetPortraitToTexture(ExpBuddyNodesIcon, "Interface\\ICONS\\trade_archaeology_chestoftinyglassanimals")
			
			-- Trace Check Button
			ExpBuddyTraceCB:SetScript("OnEnter", function(self)
				ShowTooltip(self, "ExpBuddy will only log experience activity when\ntracing is enabled!")
			end)
			ExpBuddyTraceCB:SetScript("OnLeave", function(self)
				HideTooltip(self)
			end)
			ExpBuddyTraceCB:SetScript("OnClick", function(self)
				if self:GetChecked() then
					ExpBuddyOptionsDB.Trace = true
					ExpBuddyVerboseCB:Show()
					ExpBuddyVerboseText:Show()
				else
					ExpBuddyOptionsDB.Trace = false
					ExpBuddyOptionsDB.Verbose = false
					ExpBuddyVerboseCB:Hide()
					ExpBuddyVerboseText:Hide()
				end
			end)
			
			-- Verbose Check Button
			ExpBuddyVerboseCB:SetScript("OnEnter", function(self)
				ShowTooltip(self, "When enabled, experience activity will be logged\nto the chat window.\n\nThis setting is only available when tracing\nis enabled.\n\n|cffFFFFFFNote|r: This setting is considered \"debug\". What you experience\nwhen using this setting may not be considered broken.")
			end)
			ExpBuddyVerboseCB:SetScript("OnLeave", function(self)
				HideTooltip(self)
			end)
			ExpBuddyVerboseCB:SetScript("OnClick", function(self)
				if self:GetChecked() then
					ExpBuddyOptionsDB.Verbose = true
				else
					ExpBuddyOptionsDB.Verbose = false
				end
			end)
			
			-- Map Icon Check Button
			ExpBuddyMapIconCB:SetScript("OnEnter", function(self)
				ShowTooltip(self, "Use this button to enable or disable the minimap icon.")
			end)
			ExpBuddyMapIconCB:SetScript("OnLeave", function(self)
				HideTooltip(self)
			end)
			ExpBuddyMapIconCB:SetScript("OnClick", function(self)
				if self:GetChecked() then
					ExpBuddyOptionsDB.MapIcon = true
					ExpBuddyShowMinimapIcon(true)
				else
					ExpBuddyOptionsDB.MapIcon = false
					ExpBuddyShowMinimapIcon(false)
				end
			end)
			
			ExpBuddyZoneNameEditBox:SetScript("OnEnter", function(self)
				ShowTooltip(self, "|cffFFFFFFZone Name|r\nEnter a full zone name, a partial name, or leave the\nfield blank to search the current zone.\n\nWhen using partial names, only the first match\nwill be returned.")
			end)
			ExpBuddyZoneNameEditBox:SetScript("OnLeave", function(self)
				HideTooltip(self)
			end)
			
			ExpBuddySearchButton:SetScript("OnClick", function(self)
				-- First, set the texts to empty strings.
				--
				-- If nothing is found, then we'll get the
				-- illusion of no results.
				ExpBuddyZoneNameReturnText:SetText("")
				ExpBuddyQuestsXPText:SetText("")
				ExpBuddyKillsXPText:SetText("")
				ExpBuddyNodesXPText:SetText("")
				ExpBuddyExplorationXPText:SetText("")
				
				-- Ensure the zone name field has a value.
				if ExpBuddyZoneNameEditBox:GetText() ~= "" then
					local zoneName = ExpBuddyZoneNameEditBox:GetText()
					for k,v in pairs(ExpBuddyDB) do
						if string.find(string.lower(k), string.lower(zoneName)) then
							ExpBuddyZoneNameReturnText:SetText("|cffFED55F" .. k .. "|r")
							ExpBuddyQuestsXPText:SetText(FormatNumber(ExpBuddyDB[k]["Quests"]))
							ExpBuddyKillsXPText:SetText(FormatNumber(ExpBuddyDB[k]["Kills"]))
							ExpBuddyNodesXPText:SetText(FormatNumber(ExpBuddyDB[k]["Nodes"]))
							ExpBuddyExplorationXPText:SetText(FormatNumber(ExpBuddyDB[k]["Exploration"]))
							
							local totalExp = ExpBuddyDB[k]["Quests"] + ExpBuddyDB[k]["Kills"] + ExpBuddyDB[k]["Nodes"] + ExpBuddyDB[k]["Exploration"]
							ExpBuddyTotalXPReturnText:SetText(FormatNumber(totalExp))
						end
					end
					ExpBuddyZoneNameEditBox:SetText("")
					ExpBuddyZoneNameEditBox:ClearFocus()
				else
					local zoneName = C_Map.GetMapInfo(C_Map.GetBestMapForUnit("player")).name
					for k,v in pairs(ExpBuddyDB) do
						if string.find(string.lower(k), string.lower(zoneName)) then
							ExpBuddyZoneNameReturnText:SetText("|cffFED55F" .. k .. "|r")
							ExpBuddyQuestsXPText:SetText(FormatNumber(ExpBuddyDB[k]["Quests"]))
							ExpBuddyKillsXPText:SetText(FormatNumber(ExpBuddyDB[k]["Kills"]))
							ExpBuddyNodesXPText:SetText(FormatNumber(ExpBuddyDB[k]["Nodes"]))
							ExpBuddyExplorationXPText:SetText(FormatNumber(ExpBuddyDB[k]["Exploration"]))
							
							local totalExp = ExpBuddyDB[k]["Quests"] + ExpBuddyDB[k]["Kills"] + ExpBuddyDB[k]["Nodes"] + ExpBuddyDB[k]["Exploration"]
							ExpBuddyTotalXPReturnText:SetText(FormatNumber(totalExp))
						end
					end
				end
			end)
		end
	end
end