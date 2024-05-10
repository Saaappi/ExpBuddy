local addonName, addon = ...

addon.FindNumber = function(str, nth)
    local arr = {}
	for i in string.gmatch(str, "%d+") do
		table.insert(arr, i)
	end
	return arr[nth]
end