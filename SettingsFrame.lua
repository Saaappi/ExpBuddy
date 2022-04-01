local addonName, addonTable = ...
local e = CreateFrame("Frame")
local L_DIALOG = addonTable.L_DIALOG
local L_NOTES = addonTable.L_NOTES
local L_GLOBALSTRINGS = addonTable.L_GLOBALSTRINGS
local icon = ""

function HMPTab_OnClick(self)
	local tabId = self
	PanelTemplates_SetTab(ExpBuddyMenu, tabId)
	if tabId == 1 then
		-- Show the widgets hidden from the Systems
		-- tab.
		HMPDialogCB:Show()
		HMPDialogText:Show()
		HMPEmotesCB:Show()
		HMPEmotesText:Show()
		HMPGarrTblCB:Show()
		HMPGarrisonTblText:Show()
		HMPMerchantsCB:Show()
		HMPMerchantsText:Show()
		HMPTrainersV2CB:Show()
		HMPTrainersV2Text:Show()
		HMPSpeechCB:Show()
		HMPSpeechText:Show()
		HMPQuestsCB:Show()
		HMPQuestsText:Show()
		HMPToFCB:Show()
		HMPToFText:Show()
		HMPCinematicsCB:Show()
		HMPCinematicsText:Show()
		HMPQueuesCB:Show()
		HMPQueuesText:Show()
		HMPChromieTimeDropDown:Show()
		HMPCovenantsDropDown:Show()
		HMPBFAZoneSelDropDown:Show()
		HMPSLZoneSelDropDown:Show()
		
		-- Hide the widgets from the Systems tab.
		HMPWarModeCB:Hide()
		HMPWarModeText:Hide()
		HMPNotesCB:Hide()
		HMPNotesText:Hide()
		HMPTalentsCB:Hide()
		HMPTalentsText:Hide()
		HMPPartyPlayCB:Hide()
		HMPPartyPlayText:Hide()
		HMPPartyPlayAnnounceCB:Hide()
		HMPPartyPlayAutoShareCB:Hide()
		HMPMinimapIconCB:Hide()
		HMPMinimapIconText:Hide()
		HMPLoggingCB:Hide()
		HMPLoggingText:Hide()
		HMPTorghastPowersDropDown:Hide()
	elseif tabId == 2 then
		-- Show the widgets hidden from the Automations
		-- tab.
		HMPWarModeCB:Show()
		HMPWarModeText:Show()
		HMPNotesCB:Show()
		HMPNotesText:Show()
		HMPTalentsCB:Show()
		HMPTalentsText:Show()
		HMPPartyPlayCB:Show()
		HMPPartyPlayText:Show()
		-- These two buttons should only be shown if
		-- Party Play is enabled.
		if HelpMePlayOptionsDB.PartyPlay then
			HMPPartyPlayAnnounceCB:Show()
			HMPPartyPlayAutoShareCB:Show()
		else
			HMPPartyPlayAnnounceCB:Hide()
			HMPPartyPlayAutoShareCB:Hide()
		end
		HMPTorghastPowersDropDown:Show()
		
		-- Hide the widgets from the Automations tab.
		HMPDialogCB:Hide()
		HMPDialogText:Hide()
		HMPEmotesCB:Hide()
		HMPEmotesText:Hide()
		HMPGarrTblCB:Hide()
		HMPGarrisonTblText:Hide()
		HMPMerchantsCB:Hide()
		HMPMerchantsText:Hide()
		HMPTrainersV2CB:Hide()
		HMPTrainersV2Text:Hide()
		HMPSpeechCB:Hide()
		HMPSpeechText:Hide()
		HMPQuestsCB:Hide()
		HMPQuestsText:Hide()
		HMPToFCB:Hide()
		HMPToFText:Hide()
		HMPCinematicsCB:Hide()
		HMPCinematicsText:Hide()
		HMPQueuesCB:Hide()
		HMPQueuesText:Hide()
		HMPMinimapIconCB:Hide()
		HMPMinimapIconText:Hide()
		HMPLoggingCB:Hide()
		HMPLoggingText:Hide()
		HMPChromieTimeDropDown:Hide()
		HMPCovenantsDropDown:Hide()
		HMPBFAZoneSelDropDown:Hide()
		HMPSLZoneSelDropDown:Hide()
	else
		-- Show the widgets hidden from the other tabs.
		HMPMinimapIconCB:Show()
		HMPMinimapIconText:Show()
		HMPLoggingCB:Show()
		HMPLoggingText:Show()
		
		-- Hide the widgets from the other tabs.
		HMPDialogCB:Hide()
		HMPDialogText:Hide()
		HMPEmotesCB:Hide()
		HMPEmotesText:Hide()
		HMPGarrTblCB:Hide()
		HMPGarrisonTblText:Hide()
		HMPMerchantsCB:Hide()
		HMPMerchantsText:Hide()
		HMPTrainersV2CB:Hide()
		HMPTrainersV2Text:Hide()
		HMPSpeechCB:Hide()
		HMPSpeechText:Hide()
		HMPQuestsCB:Hide()
		HMPQuestsText:Hide()
		HMPToFCB:Hide()
		HMPToFText:Hide()
		HMPCinematicsCB:Hide()
		HMPCinematicsText:Hide()
		HMPQueuesCB:Hide()
		HMPQueuesText:Hide()
		HMPWarModeCB:Hide()
		HMPWarModeText:Hide()
		HMPNotesCB:Hide()
		HMPNotesText:Hide()
		HMPTalentsCB:Hide()
		HMPTalentsText:Hide()
		HMPPartyPlayCB:Hide()
		HMPPartyPlayText:Hide()
		HMPPartyPlayAnnounceCB:Hide()
		HMPPartyPlayAutoShareCB:Hide()
		HMPChromieTimeDropDown:Hide()
		HMPCovenantsDropDown:Hide()
		HMPTorghastPowersDropDown:Hide()
		HMPBFAZoneSelDropDown:Hide()
		HMPSLZoneSelDropDown:Hide()
	end
end

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
			
			ExpBuddyZoneNameEditBox:SetScript("OnEnterPressed", function(self)
				self:SetText("")
				self:ClearFocus()
				ExpBuddyLevelEditBox:SetText("")
			end)
			
			ExpBuddyLevelEditBox:SetScript("OnEnterPressed", function(self)
				-- Make sure the input is a number.
				if tonumber(self:GetText()) then
					-- Make sure the zone name field has text.
					if ExpBuddyZoneNameEditBox:GetText() ~= "" then
						self:SetText("")
						self:ClearFocus()
					else
						print(L_GLOBALSTRINGS["Colored Addon Name"] .. ": You must also enter a zone name.")
					end
				else
					self:SetText("")
					print(L_GLOBALSTRINGS["Colored Addon Name"] .. ": Your input must be a number.")
				end
			end)
		end
	end
end