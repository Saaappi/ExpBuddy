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

local function Round(num, places)
    local mult = 10^(places or 0)
    return math.floor(num * mult + 0.5)/mult
end

function ExpBuddyUpdateExperience(frame)
	if frame == "ExpBuddyMenu" then
		-- First, set the texts to empty strings.
		--
		-- If nothing is found, then we'll get the
		-- illusion of no results.
		ExpBuddyZoneNameText:SetText("")
		ExpBuddyQuestsExpText:SetText("")
		ExpBuddyKillsExpText:SetText("")
		ExpBuddyRestedExpText:SetText("")
		ExpBuddyNodesExpText:SetText("")
		ExpBuddyExplorationExpText:SetText("")
		
		ExpBuddyQuestsExpPctText:SetText("")
		ExpBuddyKillsExpPctText:SetText("")
		ExpBuddyNodesExpPctText:SetText("")
		ExpBuddyExplorationExpPctText:SetText("")

		for k,v in pairs(ExpBuddyDB) do
			if string.find(string.lower(k), string.lower(addonTable.currentMap)) then
				ExpBuddyZoneNameText:SetText("|cffFED55F" .. k .. "|r")
				ExpBuddyQuestsExpText:SetText(FormatNumber(ExpBuddyDB[k]["Quests"]))
				ExpBuddyKillsExpText:SetText(FormatNumber(ExpBuddyDB[k]["Kills"]))
				ExpBuddyRestedExpText:SetText(FormatNumber(ExpBuddyDB[k]["Rested"]))
				ExpBuddyNodesExpText:SetText(FormatNumber(ExpBuddyDB[k]["Nodes"]))
				ExpBuddyExplorationExpText:SetText(FormatNumber(ExpBuddyDB[k]["Exploration"]))
				
				local totalExp = ExpBuddyDB[k]["Quests"] + ExpBuddyDB[k]["Kills"] + ExpBuddyDB[k]["Nodes"] + ExpBuddyDB[k]["Exploration"]
				ExpBuddyTotalExpText:SetText(FormatNumber(totalExp))
				
				ExpBuddyQuestsExpPctText:SetText(Round((ExpBuddyDB[k]["Quests"]/totalExp), 3)*100 .. "%")
				ExpBuddyKillsExpPctText:SetText(Round((ExpBuddyDB[k]["Kills"]/totalExp), 3)*100 .. "%")
				ExpBuddyNodesExpPctText:SetText(Round((ExpBuddyDB[k]["Nodes"]/totalExp), 3)*100 .. "%")
				ExpBuddyExplorationExpPctText:SetText(Round((ExpBuddyDB[k]["Exploration"]/totalExp), 3)*100 .. "%")
			end
		end
	else
		if ExpBuddyTrackerMenu:IsVisible() then
			ExpBuddyTrackerZoneNameText:SetText("|cffFED55F" .. addonTable.currentMap .. "|r")
			ExpBuddyTrackerQuestsExpText:SetText(FormatNumber(ExpBuddyDB[addonTable.currentMap]["Quests"]))
			ExpBuddyTrackerKillsExpText:SetText(FormatNumber(ExpBuddyDB[addonTable.currentMap]["Kills"]))
			ExpBuddyTrackerRestedExpText:SetText(FormatNumber(ExpBuddyDB[addonTable.currentMap]["Rested"]))
			ExpBuddyTrackerNodesExpText:SetText(FormatNumber(ExpBuddyDB[addonTable.currentMap]["Nodes"]))
			ExpBuddyTrackerExplorationExpText:SetText(FormatNumber(ExpBuddyDB[addonTable.currentMap]["Exploration"]))
			
			local totalExp = ExpBuddyDB[addonTable.currentMap]["Quests"] + ExpBuddyDB[addonTable.currentMap]["Kills"] + ExpBuddyDB[addonTable.currentMap]["Nodes"] + ExpBuddyDB[addonTable.currentMap]["Exploration"]
			ExpBuddyTrackerTotalExpText:SetText(FormatNumber(totalExp))
			
			ExpBuddyTrackerQuestsExpPctText:SetText(Round((ExpBuddyDB[addonTable.currentMap]["Quests"]/totalExp), 3)*100 .. "%")
			ExpBuddyTrackerKillsExpPctText:SetText(Round((ExpBuddyDB[addonTable.currentMap]["Kills"]/totalExp), 3)*100 .. "%")
			ExpBuddyTrackerNodesExpPctText:SetText(Round((ExpBuddyDB[addonTable.currentMap]["Nodes"]/totalExp), 3)*100 .. "%")
			ExpBuddyTrackerExplorationExpPctText:SetText(Round((ExpBuddyDB[addonTable.currentMap]["Exploration"]/totalExp), 3)*100 .. "%")
		end
	end
end

function ExpBuddyUpdateZone()
	local currentMapId = C_Map.GetBestMapForUnit("player")
	local currentMapInfo = C_Map.GetMapInfo(currentMapId)
	
	-- If the mapType isn't a zone, then let's check
	-- the parent.
	--
	-- 5: Micro (e.g. caves)
	-- 6: Orphan (e.g. Thunder Totem)
	if currentMapInfo.mapType == 5 or currentMapInfo.mapType == 6 then
		addonTable.currentMap = C_Map.GetMapInfo(currentMapInfo.parentMapID).name
	else
		addonTable.currentMap = currentMapInfo.name
	end
	
	-- If the player's current zone isn't in the
	-- table, then add it.
	--
	-- If the player's current zone isn't in the
	-- table, then none of the subtables will be
	-- either.
	if ExpBuddyDB[addonTable.currentMap] == nil then
		ExpBuddyDB[addonTable.currentMap] = {}
		ExpBuddyDB[addonTable.currentMap]["Quests"] = 0
		ExpBuddyDB[addonTable.currentMap]["Kills"] = 0
		ExpBuddyDB[addonTable.currentMap]["Rested"] = 0
		ExpBuddyDB[addonTable.currentMap]["Nodes"] = 0
		ExpBuddyDB[addonTable.currentMap]["Exploration"] = 0
	end
	
	if ExpBuddyPctDB[addonTable.currentMap] == nil then
		ExpBuddyPctDB[addonTable.currentMap] = {}
		ExpBuddyPctDB[addonTable.currentMap]["Quests"] = 0
		ExpBuddyPctDB[addonTable.currentMap]["Kills"] = 0
		ExpBuddyPctDB[addonTable.currentMap]["Nodes"] = 0
		ExpBuddyPctDB[addonTable.currentMap]["Exploration"] = 0
	end
	
	ExpBuddyUpdateExperience("ExpBuddyTracker")
end

function ExpBuddyTrackerLoad()
	if ExpBuddyTrackerMenu:IsVisible() then
		ExpBuddyTrackerMenu:Hide()
		PlaySound(SOUNDKIT.IG_SPELLBOOK_CLOSE)
	else
		if UnitAffectingCombat("player") == false then
			ExpBuddyTrackerMenu:Show()
			
			PlaySound(SOUNDKIT.IG_SPELLBOOK_OPEN)
			
			-- Make the menu movable.
			ExpBuddyTrackerMenu:SetMovable(true)
			ExpBuddyTrackerMenu:EnableMouse(true)
			ExpBuddyTrackerMenu:RegisterForDrag("LeftButton")
			ExpBuddyTrackerMenu:SetScript("OnDragStart", ExpBuddyTrackerMenu.StartMoving)
			ExpBuddyTrackerMenu:SetScript("OnDragStop", ExpBuddyTrackerMenu.StopMovingOrSizing)
			
			-- Make the icons circular.
			SetPortraitToTexture(ExpBuddyTrackerQuestsIcon, "Interface\\ICONS\\achievement_quests_completed_08")
			SetPortraitToTexture(ExpBuddyTrackerKillsIcon, "Interface\\ICONS\\inv_misc_bone_humanskull_01")
			SetPortraitToTexture(ExpBuddyTrackerRestedExpIcon, "Interface\\ICONS\\spell_nature_sleep")
			SetPortraitToTexture(ExpBuddyTrackerExplorationIcon, "Interface\\ICONS\\inv_misc_map02")
			SetPortraitToTexture(ExpBuddyTrackerNodesIcon, "Interface\\ICONS\\inv_misc_flower_02")
			
			ExpBuddyTrackerZoneNameText:SetText("|cffe6cc80" .. addonTable.currentMap .. "|r")
			
			ExpBuddyTrackerQuestsExpText:SetText(FormatNumber(ExpBuddyDB[addonTable.currentMap]["Quests"]))
			ExpBuddyTrackerKillsExpText:SetText(FormatNumber(ExpBuddyDB[addonTable.currentMap]["Kills"]))
			ExpBuddyTrackerRestedExpText:SetText(FormatNumber(ExpBuddyDB[addonTable.currentMap]["Rested"]))
			ExpBuddyTrackerNodesExpText:SetText(FormatNumber(ExpBuddyDB[addonTable.currentMap]["Nodes"]))
			ExpBuddyTrackerExplorationExpText:SetText(FormatNumber(ExpBuddyDB[addonTable.currentMap]["Exploration"]))
			
			local totalExp = ExpBuddyDB[addonTable.currentMap]["Quests"] + ExpBuddyDB[addonTable.currentMap]["Kills"] + ExpBuddyDB[addonTable.currentMap]["Nodes"] + ExpBuddyDB[addonTable.currentMap]["Exploration"]
			ExpBuddyTrackerTotalExpText:SetText(FormatNumber(totalExp))
			
			ExpBuddyTrackerQuestsExpPctText:SetText(Round((ExpBuddyDB[addonTable.currentMap]["Quests"]/totalExp), 3)*100 .. "%")
			ExpBuddyTrackerKillsExpPctText:SetText(Round((ExpBuddyDB[addonTable.currentMap]["Kills"]/totalExp), 3)*100 .. "%")
			ExpBuddyTrackerNodesExpPctText:SetText(Round((ExpBuddyDB[addonTable.currentMap]["Nodes"]/totalExp), 3)*100 .. "%")
			ExpBuddyTrackerExplorationExpPctText:SetText(Round((ExpBuddyDB[addonTable.currentMap]["Exploration"]/totalExp), 3)*100 .. "%")
		end
	end
end