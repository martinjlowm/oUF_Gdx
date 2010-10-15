if (not oUF) then
	return
end

oUF.Tags["diffColor"] = function(unit)
	local r, g, b
	local level = UnitLevel(unit)
	if (level < 1) then
		r, g, b = 0.69, 0.31, 0.31
	else
		local levelDiff = UnitLevel("target") - UnitLevel("player")
		if (levelDiff >= 5) then
			r, g, b = 0.69, 0.31, 0.31
		elseif (levelDiff >= 3) then
			r, g, b = 0.71, 0.43, 0.27
		elseif (levelDiff >= -2) then
			r, g, b = 0.84, 0.75, 0.65
		elseif (-levelDiff <= GetQuestGreenRange()) then
			r, g, b = 0.33, 0.59, 0.33
		else
			r, g, b = 0.55, 0.57, 0.61
		end
	end
	
	return string.format("|cff%02x%02x%02x", r * 255, g * 255, b * 255)
end
oUF.TagEvents["diffColor"] = "UNIT_LEVEL"

oUF.Tags["nameColor"] = function(unit)
	local reaction = UnitReaction(unit, "player")
	if (unit == "pet" and GetPetHappiness()) then
		local c = oUF.colors.happiness[GetPetHappiness()]
		return string.format("|cff%02x%02x%02x", c[1] * 255, c[2] * 255, c[3] * 255)
	elseif (UnitIsPlayer(unit)) then
		return oUF.Tags["raidcolor"](unit)
	elseif (reaction) then
		local c = oUF.colors.reaction[reaction]
		return string.format("|cff%02x%02x%02x", c[1] * 255, c[2] * 255, c[3] * 255)
	else
		r, g, b = .84,.75,.65
		return string.format("|cff%02x%02x%02x", r * 255, g * 255, b * 255)
	end
end
oUF.TagEvents["nameColor"] = "UNIT_HAPPINESS"

local numberize = function(value)
	if (value >= 1e6) then
		return format("%.1fm", value / 1e6)
	elseif (value >= 1e3) then
		return format("%.1fk", value / 1e3)
	else
		return format("%d", value)
	end
end

local utf8sub = function(string, i, dots)
	local bytes = string:len()
	if (bytes <= i) then
		return string
	else
		local len, pos = 0, 1
		while pos <= bytes do
			len = len + 1
			local c = string:byte(pos)
			if (c > 0 and c <= 127) then
				pos = pos + 1
			elseif (c >= 192 and c <= 223) then
				pos = pos + 2
			elseif (c >= 224 and c <= 239) then
				pos = pos + 3
			elseif (c >= 240 and c <= 247) then
				pos = pos + 4
			end
			if (len == i) then
				break
			end
		end
		
		if (len == i and pos <= bytes) then
			return string:sub(1, pos - 1)..(dots and "..." or "")
		else
			return string
		end
	end
end


oUF.Tags["shortName"] = function(unit)
	local name = UnitName(unit)
	if (name) then
		return utf8sub(name, 6, false)
	end
end
oUF.TagEvents["shortName"] = "UNIT_NAME_UPDATE"

oUF.Tags["mediumName"] = function(unit)
	local name = UnitName(unit)
	if (not name) then
		return
	end
	
	if (unit == "pet" and name == "Unknown") then
		return "Pet"
	else
		return utf8sub(name, 18, true)
	end
end
oUF.TagEvents["mediumName"] = "UNIT_NAME_UPDATE"

oUF.Tags["longName"] = function(unit)
	local name = UnitName(unit)
	if (name) then
		return utf8sub(name, 36, true)
	end
end
oUF.TagEvents["longName"] = "UNIT_NAME_UPDATE"

oUF.Tags["raidHP"] = function(unit)
	if (not unit) then
		return
	end
	
	local def = oUF.Tags["missinghp"](unit)
	local per = oUF.Tags["perhp"](unit)
	local result
	if (UnitIsDead(unit)) then
		result = "Dead"
	elseif (UnitIsGhost(unit)) then
		result = "Ghost"
	elseif (not UnitIsConnected(unit)) then
		result = "D/C"
	elseif (per < 90 and def) then
		result = "-"..numberize(def)
	else
		result = utf8sub(UnitName(unit), 4) or "N/A"
	end
	
	return result
end
oUF.TagEvents["raidHP"] = "UNIT_NAME_UPDATE UNIT_HEALTH UNIT_MAXHEALTH"

local ShortValue = function(value)
	if (value >= 1e6) then
		return ("%.1fm"):format(value / 1e6):gsub("%.?0+([km])$", "%1")
	elseif (value >= 1e3 or value <= -1e3) then
		return ("%.1fk"):format(value / 1e3):gsub("%.?0+([km])$", "%1")
	else
		return value
	end
end

oUF.Tags["healthText"] = function(unit)
	if (not unit) then
		return
	end
	
	local cur, max = UnitHealth(unit), UnitHealthMax(unit)
	
	if (not UnitIsConnected(unit)) then
		result = "|cffD7BEA5Offline|r"
	elseif (UnitIsDead(unit)) then
		result = "|cffD7BEA5Dead|r"
	elseif (UnitIsGhost(unit)) then
		result = "|cffD7BEA5Ghost|r"
	else
		if (cur ~= max) then
			local r, g, b = oUF.ColorGradient(cur/max, 0.69, 0.31, 0.31, 0.65, 0.63, 0.35, 0.33, 0.59, 0.33)
			if (unit == "player" or unit:find("boss%d")) then
				result = format("|cffAF5050%s|r |cffD7BEA5-|r |cff%02x%02x%02x%d%%|r", ShortValue(cur), r*255, g*255, b*255, floor(cur / max * 100))
			else
				result = format("|cff%02x%02x%02x%d%%|r |cffD7BEA5-|r |cffAF5050%s|r", r*255, g*255, b*255, floor(cur / max * 100), ShortValue(cur))
			end
		else
			result = "|cff559655"..max.."|r"
		end
	end
	
	return result
end
oUF.TagEvents["healthText"] = "UNIT_HEALTH UNIT_MAXHEALTH"

local power = {
	["MANA"] = {0.31, 0.45, 0.63},
	["RAGE"] = {0.69, 0.31, 0.31},
	["FOCUS"] = {0.71, 0.43, 0.27},
	["ENERGY"] = {0.65, 0.63, 0.35},
	["RUNES"] = {0.55, 0.57, 0.61},
	["RUNIC_POWER"] = {0, 0.82, 1},
	["AMMOSLOT"] = {0.8, 0.6, 0},
	["FUEL"] = {0, 0.55, 0.5},
	["POWER_TYPE_STEAM"] = {0.55, 0.57, 0.61},
	["POWER_TYPE_PYRITE"] = {0.60, 0.09, 0.17},
	["POWER_TYPE_HEAT"] = {0.60, 0.09, 0.17}
}

oUF.Tags["powerText"] = function(unit)
	if (not unit) then
		return
	end
	
	local r, g, b, t
	local cur, max = UnitPower(unit), UnitPowerMax(unit)
	local pType, pToken = UnitPowerType(unit)
	local t = power[pToken]
	
	if (t) then
		r, g, b = t[1], t[2], t[3]
	else
		r, g, b = .6, .6, .6
	end

	if (cur == 0) then
		result = ""
	elseif (not UnitIsPlayer(unit) and not UnitPlayerControlled(unit) or not UnitIsConnected(unit)) then
		result = ""
	elseif (UnitIsDead(unit) or UnitIsGhost(unit)) then
		result = ""
	elseif (cur == max and (pType == 2 or pType == 3 and pToken ~= "POWER_TYPE_PYRITE")) then
		result = ""
	else
		if (cur ~= max and pType == 0) then
			if (unit == "player" or unit:find("boss%d")) then
				result = format("|cff%02x%02x%02x%d%% - %s|r", r*255, g*255, b*255, floor(cur / max * 100), ShortValue(max - (max - cur)))
			else
				result = format("|cff%02x%02x%02x%s - %d%%|r", r*255, g*255, b*255, ShortValue(max - (max - cur)), floor(cur / max * 100))
			end
		else
			result = format("|cff%02x%02x%02x%s|r", r*255, g*255, b*255, cur)
		end
	end
	
	return result
end
oUF.TagEvents["powerText"] = "UNIT_MAXPOWER UNIT_POWER UPDATE_SHAPESHIFT_FORM"


local _, class = UnitClass("player")
local spells
oUF.Indicators = {
	["TL"] = "",
	["TR"] = "",
	["BL"] = "",
	["BR"] = ""
}
if (class == "DRUID") then
	spells = {
		["Lifebloom"] = GetSpellInfo(33763),
		["Rejuvenation"] = GetSpellInfo(774),
		["Regrowth"] = GetSpellInfo(8936),
		["Wild Growth"] = GetSpellInfo(48438),
		["Tree of Life"] = GetSpellInfo(33891),
		["Mark of the Wild"] = GetSpellInfo(1126)
	}
	local LBCount = {
		4,
		2,
		3
	}
	oUF.Tags["LB"] = function(unit) 
		local _, _, _, count, _, _, expirationTime, caster = UnitAura(unit, spells["Lifebloom"])
		if (caster and caster == "player") then
			local timeLeft = GetTime() - expirationTime
			if (timeLeft > -2) then
				return "|cffFF0000"..LBCount[count].."|r"
			else
				return "|cffA7FD0A"..LBCount[count].."|r"
			end
		end
		
	end
	oUF.TagEvents["LB"] = "UNIT_AURA"
	
	oUF.Tags["Rejuv"] = function(unit) 
		local _, _,_,_,_,_,_, caster = UnitAura(unit, spells["Rejuvenation"])
		if (caster and caster == "player") then
			return "|cff00FEBFM|r"
		end
	end
	oUF.TagEvents["Rejuv"] = "UNIT_AURA"
	
	oUF.Tags["Regrowth"] = function(unit)
		if (UnitAura(unit, spells["Regrowth"])) then
			return "|cff00FF10M|r"
		end
	end
	oUF.TagEvents["Regrowth"] = "UNIT_AURA"
	
	oUF.Tags["WG"] = function(unit)
		if (UnitAura(unit, spells["Wild Growth"])) then
			return "|cff33FF33M|r"
		end
	end
	oUF.TagEvents["WG"] = "UNIT_AURA"
	
	oUF.Tags["Tree"] = function(unit)
		if (UnitAura(unit, spells["Tree of Life"])) then
			return "|cff33FF33M|r"
		end
	end
	oUF.TagEvents["Tree"] = "UNIT_AURA"
	
	oUF.Tags["MotW"] = function(unit)
		if (not UnitAura(unit, spells["Mark of the Wild"])) then
			return "|cffFF00FFM|r"
		end
	end
	oUF.TagEvents["MotW"] = "UNIT_AURA"
	
	oUF.Indicators["TL"] = "[Tree]"
	oUF.Indicators["TR"] = "[MotW]"
	oUF.Indicators["BL"] = "[Regrowth][WG]"
	oUF.Indicators["BR"] = "[LB]"
elseif (class == "DEATHKNIGHT") then
	spells = {
		["Horn of Winter"] = GetSpellInfo(57330)
	}
	oUF.Tags["HoW"] = function(unit)
		if (UnitAura(unit, spells["Horn of Winter"])) then
			return "|cffffff10M|r"
		end
	end
	oUF.TagEvents["HoW"] = "UNIT_AURA"
	
	oUF.Indicators["TR"] = "[HoW]"
elseif (class == "HUNTER") then
	spells = {}
elseif (class == "MAGE") then
	spells = {
		["Focus Magic"] = GetSpellInfo(54646)
	}
	oUF.Tags["FM"] = function(unit)
		if (UnitAura(unit, spells["Focus Magic"])) then
			return "|cffffff00M|r"
		end
	end
	oUF.TagEvents["FM"] = "UNIT_AURA"
	
	oUF.Indicators["TR"] = "[FM]"
elseif (class == "PALADIN") then
	spells = {
		["Beacon of Light"] = GetSpellInfo(53563),
		["Blessing of Kings"] = GetSpellInfo(20217),
		["Blessing of Might"] = GetSpellInfo(19740)
	}
	
	oUF.Tags["BoL"] = function(unit)
		if (UnitAura(unit, spells["Beacon of Light"])) then
			return "|cffffff10M|r"
		end
	end
	oUF.TagEvents["BoL"] = "UNIT_AURA"
	
	oUF.Tags["sBoL"] = function(unit)
		local _, _, _, _, _, _, _, caster = UnitAura(unit, spells["Beacon of Light"])
		if (caster and caster == "player") then
			return "|cffff33ffM|r"
		end
	end
	oUF.TagEvents["sBoL"] = "UNIT_AURA"
	
	oUF.Tags["Blessing"] = function(unit)
		if (not (select(8, UnitAura(unit, spells["Blessing of Kings"])) == "player" or
			select(8, UnitAura(unit, spells["Blessing of Might"])) == "player")) then
			return "|cffffff00M|r"
		end
	end
	oUF.TagEvents["Blessing"] = "UNIT_AURA"
	
	oUF.Indicators["TR"] = "[Blessing]"
	oUF.Indicators["BR"] = "[sBoL][BoL]"
elseif (class == "PRIEST") then
	spells = {
		["Fear Ward"] = GetSpellInfo(6346),
		["Power Word: Fortitude"] = GetSpellInfo(21562),
		["Power Word: Shield"] = GetSpellInfo(17),
		["Prayer of Mending"] = GetSpellInfo(33076),
		["Renew"] = GetSpellInfo(139),
		["Shadow Protection"] = GetSpellInfo(27683),
		["Weakened Soul"] = GetSpellInfo(6788)
	}
	
	oUF.Tags["FW"] = function(unit)
		if (UnitAura(unit, spells["Fear Ward"])) then
			return "|cff8B4513M|r"
		end
	end
	oUF.TagEvents["FW"] = "UNIT_AURA"
	
	local PoMCount = {
		"i",
		"h",
		"g",
		"f",
		"Z",
		"Y"
	}
	oUF.Tags["PoM"] = function(unit)
		local _, _, _, count = UnitAura(unit, spells["Prayer of Mending"])
		if (count) then
			return "|cffFFCF7F"..PoMCount[count].."|r"
		end
	end
	oUF.TagEvents["PoM"] = "UNIT_AURA"
	
	oUF.Tags["PW:S"] = function(unit)
		if (UnitAura(unit, spells["Power Word: Shield"])) then
			return "|cff33FF33M|r"
		end
	end
	oUF.TagEvents["PW:S"] = "UNIT_AURA"
	
	oUF.Tags["PW:F"] = function(unit)
		if (not UnitAura(unit, spells["Power Word: Fortitude"])) then
			return "|cff00A1DEM|r"
		end
	end
	oUF.TagEvents["PW:F"] = "UNIT_AURA"
	
	oUF.Tags["SP"] = function(unit)
		if (not UnitAura(unit, spells["Shadow Protection"])) then
			return "|cff9900FFM|r"
		end
	end
	oUF.TagEvents["SP"] = "UNIT_AURA"
	
	oUF.Tags["Renew"] = function(unit)
		local _, _, _, _, _, _, _, caster = UnitAura(unit, spells["Renew"])
		if (caster and caster == "player") then
			return "|cff33FF33M|r"
		end
	end
	oUF.TagEvents["Renew"] = "UNIT_AURA"
	
	oUF.Tags["WS"] = function(unit)
		if (UnitDebuff(unit, spells["Weakened Soul"])) then
			return "|cffFF9900M|r"
		end
	end
	oUF.TagEvents["WS"] = "UNIT_AURA"
	
	oUF.Indicators["TL"] = "[PW:S][WS]"
	oUF.Indicators["TR"] = "[SP][PW:F][FW]"
	oUF.Indicators["BL"] = "[Renew]"
	oUF.Indicators["BR"] = "[PoM]"
elseif (class == "ROGUE") then
	spells = {}
elseif (class == "SHAMAN") then
	spells = {
		["Earth Shield"] = GetSpellInfo(974),
		["Riptide"] = GetSpellInfo(61295)
	}
	local earthCount = {
		"i",
		"h",
		"g",
		"f",
		"p",
		"q",
		"Z",
		"Y"
	}
	
	oUF.Tags["ES"] = function(unit)
		local _, _, _, count = UnitAura(unit, spells["Earth Shield"])
		if (count) then
			return "|cffFFCF7F"..earthCount[count].."|r"
		end
	end
	oUF.TagEvents["ES"] = "UNIT_AURA"
	
	oUF.Tags["Riptide"] = function(unit) 
		local _, _, _, _, _, _, _, caster = UnitAura(unit, spells["Riptide"])
		if (caster and caster == "player") then
			return "|cff00FEBFM|r"
		end
	end
	oUF.TagEvents["Riptide"] = "UNIT_AURA"
	
	oUF.Indicators["TL"] = "[Riptide]"
	oUF.Indicators["BR"] = "[ES]"
elseif (class == "WARLOCK") then
	spells = {}
elseif (class == "WARRIOR") then
	spells = {
		["Battle Shout"] = GetSpellInfo(6673),
		["Commanding Shout"] = GetSpellInfo(469),
		["Vigilance"] = GetSpellInfo(50720)
	}
	oUF.Tags["BS"] = function(unit)
		if (UnitAura(unit, spells["Battle Shout"])) then
			return "|cffff0000M|r"
		end
	end
	oUF.TagEvents["BS"] = "UNIT_AURA"
	
	oUF.Tags["CS"] = function(unit)
		if (UnitAura(unit, spells["Commanding Shout"])) then
			return "|cffffff00M|r"
		end
	end
	oUF.TagEvents["CS"] = "UNIT_AURA"
	
	oUF.Tags["Vigilance"] = function(unit)
		local _, _, _, _, _, _, _, caster = UnitAura(unit, spells["Vigilance"])
		if (caster and caster == "player") then
			return "|cffDEB887M|r"
		end
	end
	oUF.TagEvents["Vigilance"] = "UNIT_AURA"
	
	oUF.Indicators["TL"] = "[Vigilance]"
	oUF.Indicators["TR"] = "[BS][CS]"
end

local _, race = UnitRace("player")
if (race == "Draenei") then
	spells["Gift of the Naaru"] = GetSpellInfo(59542)
	oUF.Tags["GotN"] = function(unit)
		if (UnitAura(unit, spells["Gift of the Naaru"])) then
			return "|cff33FF33M|r"
		end
	end
	oUF.TagEvents["GotN"] = "UNIT_AURA"
	oUF.Indicators["BR"] = oUF.Indicators["BR"].."[GotN]"
end