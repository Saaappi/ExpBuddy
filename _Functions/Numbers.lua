local addonName, addon = ...

addon.CalculatePercent = function(number)
	local monsterExperience = ExpBuddyDataDB[addon.mapID].Monsters
	local restedExperience = ExpBuddyDataDB[addon.mapID].Rested
	local questExperience = ExpBuddyDataDB[addon.mapID].Quests
	local nodeExperience = ExpBuddyDataDB[addon.mapID].Nodes
	local explorationExperience = ExpBuddyDataDB[addon.mapID].Exploration

	local sum = monsterExperience + restedExperience + questExperience + nodeExperience + explorationExperience
	if sum == 0 then
		return 0
	end
	return format("%.2f", (number/(sum)) * 100)
end

addon.FindNumber = function(str, nth)
    local numbers = {}
	for number in str:gmatch("%d+") do
		table.insert(numbers, tonumber(number))
	end
	return numbers[nth]
end

addon.FormatNumber = function(number)
	-- Convert the number to a string.
	local formattedNumber = tostring(number)

	-- Split the string into an integer and decimal part.
	local integerPart, decimalPart = formattedNumber:match("([^.]*)%.?(%d*)")

	-- Add commas to the integer part.
	integerPart = integerPart:reverse():gsub("(%d%d%d)", "%1,"):reverse()

	-- Remove the trailing comma (if necessary).
    if integerPart:sub(1, 1) == "," then
        integerPart = integerPart:sub(2)
    end

	-- Concatenate the integer and decimal parts
    formattedNumber = integerPart
    if decimalPart ~= "" then
        formattedNumber = formattedNumber .. "." .. decimalPart
    end

    return formattedNumber
end