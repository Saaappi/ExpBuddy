local addonName, addonTable = ...
local locale = GAME_LOCALE or GetLocale()
local isLocaleSupported = false
local supportedLocales = {
	"enGB",
	"enUS",
	"deDE",
	"esMX",
	"ptBR",
	"esES",
	"frFR",
	"itIT",
	"ruRU",
	"koKR",
	"zhTW",
	"zhCN",
}
local L_GLOBALSTRINGS = setmetatable({}, { __index = function(t, k)
	local v = tostring(k)
	rawset(t, k, v)
	return v
end })

for i=1,#supportedLocales do
	if (supportedLocales[i] == locale) then
		isLocaleSupported = true
	end
end

if (isLocaleSupported == false) then
	print(addonName .. " does NOT support " .. locale .. "! There are no plans to localize this addon.")
end

if (isLocaleSupported) then
	L_GLOBALSTRINGS["Slash EXP"]																= "/exp"
	L_GLOBALSTRINGS["Tracker Command"]															= "tracker"
	L_GLOBALSTRINGS["Colored Addon Name"]														= "|cff00FFFF"..addonName.."|r"
end

addonTable.L_GLOBALSTRINGS = L_GLOBALSTRINGS