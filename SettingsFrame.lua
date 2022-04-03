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
				icon = "Interface\\Icons\\achievement_reputation_08",
				OnTooltipShow = function(tooltip)
					tooltip:SetText(L_GLOBALSTRINGS["Colored Addon Name"] .. " |cffFFFFFFv" .. GetAddOnMetadata(addonName, "Version") .. "|r")
					tooltip:AddLine("Open the addon menu to search experience data!")
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