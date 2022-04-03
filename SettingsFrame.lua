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
	else
		if UnitAffectingCombat("player") == false then
			ExpBuddyMenu:Show()
			
			-- Make the menu movable.
			ExpBuddyMenu:SetMovable(true)
			ExpBuddyMenu:EnableMouse(true)
			ExpBuddyMenu:RegisterForDrag("LeftButton")
			ExpBuddyMenu:SetScript("OnDragStart", ExpBuddyMenu.StartMoving)
			ExpBuddyMenu:SetScript("OnDragStop", ExpBuddyMenu.StopMovingOrSizing)
			
			-- Check settings!
			if ExpBuddyOptionsDB.Trace then
				ExpBuddyTraceCB:SetChecked(true)
			else
				ExpBuddyTraceCB:SetChecked(false)
			end
			if ExpBuddyOptionsDB.MapIcon then
				ExpBuddyMapIconCB:SetChecked(true)
			else
				ExpBuddyMapIconCB:SetChecked(false)
			end
			
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
				else
					ExpBuddyOptionsDB.Trace = false
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
				-- Ensure the zone name field has a value.
				if ExpBuddyZoneNameEditBox:GetText() ~= "" then
					local zoneName = ExpBuddyZoneNameEditBox:GetText()
					for k,v in pairs(ExpBuddyDB) do
						if string.find(string.lower(k), string.lower(zoneName)) then
							print("|cffFED55F" .. k .. "|r")
							print("Quests: " .. ExpBuddyDB[k]["Quests"])
							print("Kills: " .. ExpBuddyDB[k]["Kills"])
							print("Nodes: " .. ExpBuddyDB[k]["Nodes"])
							print("Exploration: " .. ExpBuddyDB[k]["Exploration"])
						end
					end
					ExpBuddyZoneNameEditBox:SetText("")
					ExpBuddyZoneNameEditBox:ClearFocus()
				else
					local zoneName = C_Map.GetMapInfo(C_Map.GetBestMapForUnit("player")).name
					for k,v in pairs(ExpBuddyDB) do
						if string.find(string.lower(k), string.lower(zoneName)) then
							print("|cffFED55F" .. k .. "|r")
							print("Quests: " .. ExpBuddyDB[k]["Quests"])
							print("Kills: " .. ExpBuddyDB[k]["Kills"])
							print("Nodes: " .. ExpBuddyDB[k]["Nodes"])
							print("Exploration: " .. ExpBuddyDB[k]["Exploration"])
						end
					end
				end
			end)
		end
	end
end