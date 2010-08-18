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
oUF.TagEvents["powerText"] = "UNIT_MAXENERGY UNIT_MAXFOCUS UNIT_MAXMANA UNIT_MAXRAGE UNIT_ENERGY UNIT_FOCUS UNIT_MANA UNIT_RAGE UNIT_MAXRUNIC_POWER UNIT_RUNIC_POWER UPDATE_SHAPESHIFT_FORM"

local L = {
	["Abolish Disease"] = GetSpellInfo(552),
	["Prayer of Mending"] = GetSpellInfo(33076),
	["Gift of the Naaru"] = GetSpellInfo(59542),
	["Renew"] = GetSpellInfo(139),
	["Power Word: Shield"] = GetSpellInfo(17),
	["Weakened Soul"] = GetSpellInfo(6788),
	["Prayer of Shadow Protection"] = GetSpellInfo(27683),
	["Shadow Protection"] = GetSpellInfo(976),
	["Prayer of Fortitude"] = GetSpellInfo(21562),
	["Power Word: Fortitude"] = GetSpellInfo(1243),
	["Divine Spirit"] = GetSpellInfo(48073),
	["Prayer of Spirit"] = GetSpellInfo(48074),
	["Fear Ward"] = GetSpellInfo(6346),
	["Lifebloom"] = GetSpellInfo(33763),
	["Rejuvenation"] = GetSpellInfo(774),
	["Regrowth"] = GetSpellInfo(8936),
	["Wild Growth"] = GetSpellInfo(48438),
	["Tree of Life"] = GetSpellInfo(33891),
	["Gift of the Wild"] = GetSpellInfo(48470),
	["Mark of the Wild"] = GetSpellInfo(48469),
	["Horn of Winter"] = GetSpellInfo(57623),
	["Battle Shout"] = GetSpellInfo(47436),
	["Commanding Shout"] = GetSpellInfo(47440),
	["Vigilance"] = GetSpellInfo(50720),
	["Magic Concentration"] = GetSpellInfo(54646),
	["Beacon of Light"] = GetSpellInfo(53563),
	["Sacred Shield"] = GetSpellInfo(53601),
	["Earth Shield"] = GetSpellInfo(49284),
	["Riptide"] = GetSpellInfo(61301),
	["Flash of Light"] = GetSpellInfo(66922)
}

local _, class = UnitClass("player")
	-- PRIEST
if (class == "PRIEST") then
	local PoMCount = {
		"i",
		"h",
		"g",
		"f",
		"Z",
		"Y"
	}
	oUF.Tags["PoM"] = function(unit)
		local _, _, _, count = UnitAura(unit, L["Prayer of Mending"])
		if (count) then
			return "|cffFFCF7F"..PoMCount[count].."|r"
		end
	end
	oUF.TagEvents["PoM"] = "UNIT_AURA"
	
	oUF.Tags["GotN"] = function(unit)
		if (UnitAura(unit, L["Gift of the Naaru"])) then
			return "|cff33FF33M|r"
		end
	end
	oUF.TagEvents["GotN"] = "UNIT_AURA"
	
	oUF.Tags["Renew"] = function(unit)
		local _, _, _, _, _, _, _, caster = UnitAura(unit, L["Renew"])
		if (caster and caster == "player") then
			return "|cff33FF33M|r"
		end
	end
	oUF.TagEvents["Renew"] = "UNIT_AURA"
	
	oUF.Tags["AD"] = function(unit)
		local _, _, _, _, _, _, _, caster = UnitAura(unit, L["Abolish Disease"])
		if (caster and caster == "player") then
			return "|cffFFFF33M|r"
		end
	end
	oUF.TagEvents["AD"] = "UNIT_AURA"
	
	oUF.Tags["PW:S"] = function(unit)
		if (UnitAura(unit, L["Power Word: Shield"])) then
			return "|cff33FF33M|r"
		end
	end
	oUF.TagEvents["PW:S"] = "UNIT_AURA"
	
	oUF.Tags["WS"] = function(unit)
		if (UnitDebuff(unit, L["Weakened Soul"])) then
			return "|cffFF9900M|r"
		end
	end
	oUF.TagEvents["WS"] = "UNIT_AURA"
	
	oUF.Tags["FW"] = function(unit)
		if (UnitAura(unit, L["Fear Ward"])) then
			return "|cff8B4513M|r"
		end
	end
	oUF.TagEvents["FW"] = "UNIT_AURA"
	
	oUF.Tags["SP"] = function(unit)
		if (not (UnitAura(unit, L["Prayer of Shadow Protection"]) or UnitAura(unit, "Shadow Protection"))) then
			return "|cff9900FFM|r"
		end
	end
	oUF.TagEvents["SP"] = "UNIT_AURA"
	
	oUF.Tags["PW:F"] = function(unit)
		if (not (UnitAura(unit, L["Prayer of Fortitude"]) or UnitAura(unit, L["Power Word: Fortitude"]))) then
			return "|cff00A1DEM|r"
		end
	end
	oUF.TagEvents["PW:F"] = "UNIT_AURA"
	
	oUF.Tags["DS"] = function(unit)
		if (not (UnitAura(unit, L["Prayer of Spirit"]) or UnitAura(unit, L["Divine Spirit"]))) then
			return "|cffffff00M|r"
		end
	end
	oUF.TagEvents["DS"] = "UNIT_AURA"
	
	oUF.Indicators = {
		["TL"] = "[PW:S][WS]",
		["TR"] = "[DS][SP][PW:F][FW]",
		["BL"] = "[Renew][AD]",
		["BR"] = "[PoM]"
	}
	
	-- DRUID
elseif (class == "DRUID") then
	local LBCount = {
		4,
		2,
		3
	}
	oUF.Tags["LB"] = function(unit) 
		local _, _, _, count, _, _, expirationTime, caster = UnitAura(unit, L["Lifebloom"])
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
		local _, _,_,_,_,_,_, caster = UnitAura(unit, L["Rejuvenation"])
		if (caster and caster == "player") then
			return "|cff00FEBFM|r"
		end
	end
	oUF.TagEvents["Rejuv"] = "UNIT_AURA"
	
	oUF.Tags["Regrowth"] = function(unit)
		if (UnitAura(unit, L["Regrowth"])) then
			return "|cff00FF10M|r"
		end
	end
	oUF.TagEvents["Regrowth"] = "UNIT_AURA"
	
	oUF.Tags["WG"] = function(unit)
		if (UnitAura(unit, L["Wild Growth"])) then
			return "|cff33FF33M|r"
		end
	end
	oUF.TagEvents["WG"] = "UNIT_AURA"
	
	oUF.Tags["Tree"] = function(unit)
		if (UnitAura(unit, L["Tree of Life"])) then
			return "|cff33FF33M|r"
		end
	end
	oUF.TagEvents["Tree"] = "UNIT_AURA"
	
	oUF.Tags["GotW"] = function(unit)
		if (not (UnitAura(unit, L["Gift of the Wild"]) or UnitAura(unit, L["Mark of the Wild"]))) then
			return "|cffFF00FFM|r"
		end
	end
	oUF.TagEvents["GotW"] = "UNIT_AURA"
	
	oUF.Indicators = {
		["TL"] = "[Tree]",
		["TR"] = "[GotW]",
		["BL"] = "[Regrowth][WG]",
		["BR"] = "[LB]"
	}
	
	-- WARRIOR
elseif (class == "WARRIOR") then
	oUF.Tags["BS"] = function(unit)
		if (UnitAura(unit, L["Battle Shout"])) then
			return "|cffff0000M|r"
		end
	end
	oUF.TagEvents["BS"] = "UNIT_AURA"
	
	oUF.Tags["CS"] = function(unit)
		if (UnitAura(unit, L["Commanding Shout"])) then
			return "|cffffff00M|r"
		end
	end
	oUF.TagEvents["CS"] = "UNIT_AURA"
	
	oUF.Tags["Vigilance"] = function(unit)
		local _, _, _, _, _, _, _, caster = UnitAura(unit, L["Vigilance"])
		if (caster and caster == "player") then
			return "|cffDEB887M|r"
		end
	end
	oUF.TagEvents["Vigilance"] = "UNIT_AURA"
	
	oUF.Indicators = {
		["TL"] = "[Vigilance]",
		["TR"] = "[BS][CS]",
		["BL"] = "",
		["BR"] = ""
	}
	
	-- DEATHKNIGHT
elseif (class == "DEATHKNIGHT") then
	oUF.Tags["HoW"] = function(unit)
		if (UnitAura(unit, L["Horn of Winter"])) then
			return "|cffffff10M|r"
		end
	end
	oUF.TagEvents["HoW"] = "UNIT_AURA"
	
	oUF.Indicators = {
		["TL"] = "",
		["TR"] = "[HoW]",
		["BL"] = "",
		["BR"] = "",
	}
	
	-- MAGE
elseif (class == "MAGE") then
	oUF.Tags["MC"] = function(unit)
		if (UnitAura(unit, L["Magic Concentration"])) then
			return "|cffffff00M|r"
		end
	end
	oUF.TagEvents["MC"] = "UNIT_AURA"
	
	oUF.Indicators = {
		["TL"] = "",
		["TR"] = "[MC]",
		["BL"] = "",
		["BR"] = ""
	}
	
	-- PALADIN
elseif (class == "PALADIN") then
	oUF.Tags["SS"] = function(unit)
		if (UnitAura(unit, L["Sacred Shield"])) then
			return "|cffffff10M|r"
		end
	end
	oUF.TagEvents["SS"] = "UNIT_AURA"
	
	oUF.Tags["BoL"] = function(unit)
		if (UnitAura(unit, L["Beacon of Light"])) then
			return "|cffffff10M|r"
		end
	end
	oUF.TagEvents["BoL"] = "UNIT_AURA"
	
	oUF.Tags["sSS"] = function(unit)
		local _, _, _, _, _, _, _, caster = UnitAura(unit, L["Sacred Shield"])
		if (caster and caster == "player") then
			return "|cffff33ffM|r"
		end
	end
	oUF.TagEvents["sSS"] = "UNIT_AURA"
	
	oUF.Tags["sBoL"] = function(unit)
		local _, _, _, _, _, _, _, caster = UnitAura(unit, L["Beacon of Light"])
		if (caster and caster == "player") then
			return "|cffff33ffM|r"
		end
	end
	oUF.TagEvents["sBoL"] = "UNIT_AURA"
	
	oUF.Indicators = {
		["TL"] = "[sSS][SS]",
		["TR"] = "[sBoL][BoL]",
		["BL"] = "",
		["BR"] = ""
	}
	
	-- SHAMAN
elseif (class == "SHAMAN") then
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
		local _, _, _, count = UnitAura(unit, L["Earth Shield"])
		if (count) then
			return "|cffFFCF7F"..earthCount[count].."|r"
		end
	end
	oUF.TagEvents["ES"] = "UNIT_AURA"
	
	oUF.Tags["Riptide"] = function(unit) 
		local _, _, _, _, _, _, _, caster = UnitAura(unit, L["Riptide"])
		if (caster and caster == "player") then
			return "|cff00FEBFM|r"
		end
	end
	oUF.TagEvents["Riptide"] = "UNIT_AURA"
	
	oUF.Indicators = {
		["TL"] = "[Riptide]",
		["TR"] = "",
		["BL"] = "",
		["BR"] = "[ES]"
	}
end