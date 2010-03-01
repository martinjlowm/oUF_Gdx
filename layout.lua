local _, class = UnitClass("player")

local dispellClass
do
	local t = {
		["PRIEST"] = {
			["Magic"] = true,
			["Disease"] = true,
		},
		["SHAMAN"] = {
			["Poison"] = true,
			["Disease"] = true,
			["Curse"] = true,
		},
		["PALADIN"] = {
			["Poison"] = true,
			["Magic"] = true,
			["Disease"] = true,
		},
		["MAGE"] = {
			["Curse"] = true,
		},
		["DRUID"] = {
			["Curse"] = true,
			["Poison"] = true,
		},
		["DEATHKNIGHT"] = {},
		["HUNTER"] = {},
		["ROGUE"] = {},
		["WARLOCK"] = {},
		["WARRIOR"] = {},
	}
	if t[class] then
		dispellClass = {}
		for k, v in pairs(t[class]) do
			dispellClass[k] = v
		end
		t = nil
	end
end

local numTabs, numTalents, BaS, nameTalent, currRank = GetNumTalentTabs()
for t = 1, numTabs do
	if BaS then
		break
	end
	
	numTalents = GetNumTalents(t)
    for i = 1, numTalents do
        nameTalent, _, _, _, currRank = GetTalentInfo(t, i)
		if nameTalent == GetSpellInfo(64127) and currRank > 0 then
			BaS = true
			
			break
		end
    end
end

local dispellPriority = {
	["Magic"] = 4,
	["Poison"] = 3,
	["Disease"] = 1,
	["Curse"] = 2,
	["None"] = 0,
}

local debuffs = setmetatable({
	--------------------------
	--	Icecrown Citadel	--
	--------------------------
	-- The Lich King
	[GetSpellInfo(73781)] = 3,	-- Infest
	[GetSpellInfo(73912)] = 7,	-- Necrotic Plague
	[GetSpellInfo(72133)] = 5,	-- Pain and Suffering
	[GetSpellInfo(74325)] = 10,	-- Harvest Soul
	
	-- Sindragosa
	[GetSpellInfo(69762)] = 7,	-- Unchained Magic
	[GetSpellInfo(69766)] = 5,	-- Instability
	[GetSpellInfo(70126)] = 10,	-- Frost Beacon
	[GetSpellInfo(70128)] = 3,	-- Mystic Buffet
	
	-- Valithria Dreamwalker
	[GetSpellInfo(70873)] = 10,	-- Emerald Vigor
	
	-- Blood-Queen Lana'thel
	[GetSpellInfo(72649)] = 7,	-- Frenzied Bloodthirst
	[GetSpellInfo(71473)] = 5,	-- Essence of the Blood Queen
	[GetSpellInfo(71265)] = 10,	-- Swarming Shadows
	[GetSpellInfo(71341)] = 10, -- Pact of the Darkfallen
	
	-- Professor Putricide
	[GetSpellInfo(70447)] = 10,	-- Volatile Ooze Adhesive
	[GetSpellInfo(70672)] = 10,	-- Gaseous Bloat
	
	-- Rotface
	[GetSpellInfo(69674)] = 10,	-- Mutated Infection
	
	-- Festergut
	[GetSpellInfo(69279)] = 10,	-- Gas Spore
	
	-- Deathbringer Saurfang
	[GetSpellInfo(72293)] = 10, -- Mark of the Fallen Champion
	
	-- Rotting Frost Giant
	[GetSpellInfo(72865)] = 10, -- Death Plague
	[GetSpellInfo(72884)] = 7, -- Recently Infected
	
	-- Lady Deathwhisper
	[GetSpellInfo(71001)] = 10, -- Death and Decay
	
	-- Lady Deathwhisper trash
	[GetSpellInfo(69482)] = 10,	-- Dark Reckoning
	
	-- Lord Marrowgar
	[GetSpellInfo(69146)] = 7,	-- Coldflame
	[GetSpellInfo(69057)] = 10,	-- Bone Spike Graveyard
	
	
	------------------------------
	--	Trial of the Crusader	--
	------------------------------
	-- Anub'arak
	[GetSpellInfo(65775)] = 5,	-- Acid-Drenched Mandibles
	[GetSpellInfo(66013)] = 10,	-- Penetrating Cold
	
	-- Val'kyr twins
	[GetSpellInfo(66001)] = 5,	-- Touch of Darkness
	[GetSpellInfo(65950)] = 5,	-- Touch of Light
	
	-- Lord Jaraxxus
	[GetSpellInfo(66237)] = 10,	-- Incinerate Flesh
	[GetSpellInfo(66197)] = 5,	-- Legion Flames
	
	-- Northrend Beasts
	[GetSpellInfo(66331)] = 5,	-- Impale
	[GetSpellInfo(66406)] = 2,	-- Snobolled
	[GetSpellInfo(66823)] = 5,	-- Paralytic Toxin
	[GetSpellInfo(66870)] = 5,	-- Burning Bile
	
	
	--------------
	--	Ulduar	--
	--------------
	-- Yogg-Saron
	[GetSpellInfo(63830)] = 8,	-- Malady of the Mind
	[GetSpellInfo(64152)] = 1,	-- Draining Poison
	[GetSpellInfo(63038)] = 0,	-- Dark Volley
	[GetSpellInfo(63134)] = 5,	-- Sara's Blessing
	[GetSpellInfo(63713)] = 10,	-- Dominate Mind
	[GetSpellInfo(36655)] = 1,	-- Drain Life
	[GetSpellInfo(63147)] = 5,	-- Sara's Anger
	[GetSpellInfo(30910)] = 10,	-- Curse of Doom
	[GetSpellInfo(63120)] = 10,	-- Insane
	[GetSpellInfo(64125)] = 7,	-- Squeeze
	
	-- General Vezax
	[GetSpellInfo(63337)] = 10,	-- Saronite Vapors
	[GetSpellInfo(62659)] = 5,	-- Shadow Crash
	
	-- Freya
	[GetSpellInfo(62282)] = 7,	-- Iron Roots
	[GetSpellInfo(63571)] = 10,	-- Nature's Fury
	
	-- Hodir
	[GetSpellInfo(61969)] = 5,	-- Flash Freeze
	
	-- Auriaya
	[GetSpellInfo(64389)] = 8,	-- Sentinel Blast
	[GetSpellInfo(64667)] = 10,	-- Rip Flesh
	[GetSpellInfo(64374)] = 9,	-- Savage Pounce
	[GetSpellInfo(64478)] = 8,	-- Feral Pounce
	
	-- Kologarn
	[GetSpellInfo(62055)] = 1,	-- Brittle Skin
	[GetSpellInfo(63981)] = 5,	-- Stone Grip
	
	-- Iron Council
	[GetSpellInfo(64637)] = 5,	-- Overwhelming Power
	[GetSpellInfo(63493)] = 10,	-- Fusion Punch
	
	-- XT-002 Deconstructor
	[GetSpellInfo(63018)] = 7,	-- Searing Light
	[GetSpellInfo(64234)] = 8,	-- Gravity Bomb
	
	-- Ignis the Furnace Master
	[GetSpellInfo(62717)] = 7,	-- Slag Pot
	
	-- Razorscale
	[GetSpellInfo(64733)] = 5,	-- Devouring Flame
	
	-- Flame Leviathan
	[GetSpellInfo(62376)] = 1,	-- Battering Ram
	
	
	--------------------------
	--	Player vs. Player	--
	--------------------------
	-- Poison damage
	[GetSpellInfo(3034)] = 7,	-- Viper Sting
	
	-- Health reduction
	[GetSpellInfo(13219)] = 9,	-- Wound Poison
	[GetSpellInfo(12294)] = 8,	-- Mortal Strike
	[GetSpellInfo(19434)] = 8,	-- Aimed Shot
	
	-- Silence
	[GetSpellInfo(18469)] = 11, -- Silenced - Improved Counterspell
	[GetSpellInfo(2139)] = 10,	-- Counterspell
	
	-- Disoriented
	[GetSpellInfo(2094)] = 10,	-- Blind
	[GetSpellInfo(33786)] = 10,	-- Cyclone
	[GetSpellInfo(19503)] = 10,	-- Scatter Shot
	
	-- Crowd control effects
	[GetSpellInfo(118)] = 7,	-- Polymorph
	
	-- Root effects
	[GetSpellInfo(339)] = 7,	-- Entangling Roots
	[GetSpellInfo(55041)] = 7,	-- Freezing Trap Effect
	[GetSpellInfo(45524)] = 7,	-- Chains of Ice
	
	-- Slow effects
	[GetSpellInfo(3409)] = 6,	-- Crippling Poison
	[GetSpellInfo(1715)] = 5,	-- Hamstring
	[GetSpellInfo(2974)] = 5,	-- Wing Clip
	
	-- Fear effects
	[GetSpellInfo(6215)] = 3,	-- Fear
	[GetSpellInfo(10890)] = 3,	-- Psychic Scream
	[GetSpellInfo(17928)] = 3,	-- Howl of Terror
}, { __index = function() return 0 end })


local f = CreateFrame("Frame")
f:SetScript("OnEvent", function(self, event, ...)
	return self[event](self, ...)
end)

f.UNIT_AURA = function(self, unit)
	local frame = oUF.units[unit]
	if not frame or frame.unit ~= unit or not frame.DebuffIcon then
		return
	end
	
	if frame:GetAttribute('unitsuffix') == 'pet' or frame:GetAttribute('unitsuffix') == 'target' then
		return
	end
	local cur, tex, dis, timeLeft, Duration, stack
	local name, rank, buffTexture, count, duration, expire, dtype, isPlayer
	for i = 1, 40 do
		name, rank, buffTexture, count, dtype, duration, expire, isPlayer = UnitAura(unit, i, "HARMFUL")
		if not name then break end

		if not cur or (debuffs[name] >= debuffs[cur]) then
			if debuffs[name] > 0 and debuffs[name] > debuffs[cur or 1] then
				cur = name
				tex = buffTexture
				dis = dtype or "none"
				timeLeft = expire
				Duration = duration
				stack = count > 1 and count or ""
			elseif dtype and dtype ~= "none" then
				if not dis or (dispellPriority[dtype] > dispellPriority[dis]) then
					tex = buffTexture
					dis = dtype
					timeLeft = expire
					Duration = duration
					stack = count > 1 and count or ""
				end
			end	
		end
	end
	
	if dis then
		if dispellClass[dis] or cur or ( dis == "Poison" and unit == "player" and BaS ) then
			local col = DebuffTypeColor[dis]
			frame.DebuffIcon.Overlay:SetVertexColor(col.r, col.g, col.b)
			frame.Dispell = true
			frame.DebuffIcon.Count:SetText(stack)
			frame.DebuffIcon.Texture:SetTexture(tex)
			frame.DebuffIcon:Show()
			frame.RaidInfo:Hide()
			
			if Duration > 0 then
				frame.DebuffIcon.Cooldown:SetCooldown(timeLeft - Duration, Duration)
			end
		elseif frame.Dispell then
			frame.Dispell = false
			frame.DebuffIcon:Hide()
			frame.RaidInfo:Show()
		end
	else
		frame.DebuffIcon.Cooldown:SetCooldown(0, 0)
		frame.DebuffIcon.Count:SetText()
		frame.DebuffIcon:Hide()
		frame.RaidInfo:Show()
	end
end
f:RegisterEvent("UNIT_AURA")

local config = {
	barTexture = [=[Interface\AddOns\Guardix\media\statusBarH]=],
	backdropEdge = [=[Interface\Addons\Guardix\media\backdropEdge]=],
	backdropFill = [=[Interface\Addons\Guardix\media\WHITE64X64]=],
	buttonTex = [=[Interface\Addons\Guardix\media\buttonTex]=],
	bubbleTex = [=[Interface\Addons\Guardix\media\bubbleTex]=],
	font = [=[Interface\Addons\Guardix\media\Russel Square LT.ttf]=],
	aurafont = [=[Interface\Addons\Guardix\media\squares.ttf]=],
	symbolfont = [=[Interface\Addons\Guardix\media\PIZZADUDEBULLETS.ttf]=],
	
	["player"] = {
		Dimensions = {
			Width = 230,
			Height = 55,
			Reverse = false,
		},
		Health = {
			Size = 27,
			Value = {
				Point = {
					"BOTTOMRIGHT",
					"BOTTOMRIGHT",
					-5,
					5,
				},
				Justify = "RIGHT",
			},
			Smooth = true,
		},
		Power = {
			Size = 8,
			Value = {
				Point = {
					"BOTTOMLEFT",
					"BOTTOMLEFT",
					5,
					5,
				},
				Justify = "LEFT",
			},
		},
		Castbar = {
			Size = 18,
			Icon = {
				"TOPRIGHT",
				"LEFT",
				-10,
				10,
			},
		},
		Enchant = {
			Size = 26.5,
			Point = {
				"TOPRIGHT",
				"TOPLEFT",
				-3,
				0,
			},
			Anchor = "TOPRIGHT",
			GrowthY = "DOWN",
			Spacing = 2,
		},
		Experience = {
			Size = 18,
		},
		Buffs = {
			Size = 27,
			Point = {
				"BOTTOMLEFT",
				"TOPLEFT",
				0,
				3,
			},
			Anchor = "BOTTOMLEFT",
			GrowthY = "UP",
			GrowthX = "RIGHT",
			num = 24,
			Spacing = 2,
		},
		Debuffs = {
			Size = 27,
			Point = {
				"BOTTOMRIGHT",
				"TOPRIGHT",
				0,
				3,
			},
			Anchor = "BOTTOMRIGHT",
			GrowthY = "UP",
			GrowthX = "LEFT",
			num = 8,
			Spacing = 2,
		},
		Panel = {
			Size = 20,
			
			DPS = {
				Point = {
					"BOTTOM",
					"BOTTOM",
					0,
					5,
				},
			},
		},
		Combat = {
			Size = 32,
			Point = {
				"CENTER",
				"CENTER",
				0,
				15,
			},
		},
		Leader = {
			Size = 16,
			Point = {
				"CENTER",
				"TOPLEFT",
				0,
				0,
			},
		},
		MasterLooter = {
			Size = 16,
			Point = {
				"CENTER",
				"TOPLEFT",
				16,
				0,
			},
		},
		Threat = true,
	},
	
	["pet"] = {
		Dimensions = {
			Width = 115,
			Height = 35,
			Reverse = false,
		},
		Health = {
			Size = 18,
			Smooth = true,
		},
		Panel = {
			Size = 17,
			
			Info = {
				Point = {
					"BOTTOM",
					"BOTTOM",
					0,
					3.5,
				},
				Tag = "[GetNameColor][NameLong] [DiffColor][level] [shortclassification]",
			},
		},
		Experience = {
			Size = 18,
		},
		Debuffs = {
			Size = 27,
			Point = {
				"BOTTOMLEFT",
				"TOPLEFT",
				0,
				3,
			},
			Anchor = "BOTTOMLEFT",
			GrowthY = "UP",
			GrowthX = "RIGHT",
			num = 4,
			Spacing = 2,
		},
	},
	
	["target"] = {
		Dimensions = {
			Width = 230,
			Height = 55,
			Reverse = true,
		},
		Health = {
			Size = 27,
			Value = {
				Point = {
					"BOTTOMLEFT",
					"BOTTOMLEFT",
					5,
					5,
				},
				Justify = "LEFT",
			},
			Smooth = true,
		},
		Power = {
			Size = 8,
			Value = {
				Point = {
					"BOTTOMRIGHT",
					"BOTTOMRIGHT",
					-5,
					5,
				},
				Justify = "RIGHT",
			},
		},
		Castbar = {
			Size = 18,
			Icon = {
				"TOPLEFT",
				"RIGHT",
				10,
				10,
			},
		},
		Buffs = {
			Size = 27,
			Point = {
				"BOTTOMRIGHT",
				"TOPRIGHT",
				0,
				3,
			},
			Anchor = "BOTTOMRIGHT",
			GrowthY = "UP",
			GrowthX = "LEFT",
			num = 8,
			Spacing = 2,
		},
		Debuffs = {
			Size = 27,
			Point = {
				"BOTTOMLEFT",
				"TOPLEFT",
				0,
				3,
			},
			Anchor = "BOTTOMLEFT",
			GrowthY = "UP",
			GrowthX = "RIGHT",
			num = 24,
			Spacing = 2,
		},
		Panel = {
			Size = 20,
			
			Info = {
				Point = {
					"BOTTOM",
					"BOTTOM",
					0,
					5,
				},
				Tag = "[GetNameColor][NameLong] [DiffColor][level] [shortclassification]",
			},
		},
		Leader = {
			Size = 16,
			Point = {
				"CENTER",
				"TOPRIGHT",
				0,
				0,
			},
		},
		MasterLooter = {
			Size = 16,
			Point = {
				"CENTER",
				"TOPRIGHT",
				-16,
				0,
			},
		},
	},
	
	["targettarget"] = {
		Dimensions = {
			Width = 115,
			Height = 35,
			Reverse = true,
		},
		Health = {
			Size = 18,
			Smooth = true,
		},
		Panel = {
			Size = 17,
			Info = {
				Point = {
					"BOTTOM",
					"BOTTOM",
					0,
					3.5,
				},
				Tag = "[GetNameColor][NameMedium]",
			},
		},
		Debuffs = {
			Size = 27,
			Point = {
				"BOTTOMRIGHT",
				"TOPRIGHT",
				0,
				3,
			},
			Anchor = "BOTTOMRIGHT",
			GrowthY = "UP",
			GrowthX = "LEFT",
			num = 4,
			Spacing = 2,
		},
	},
	
	["focus"] = {
		Dimensions = {
			Width = 115,
			Height = 35,
			Reverse = true,
		},
		Health = {
			Size = 16,
			Smooth = true,
		},
		Power = {
			Size = 2,
		},
		Panel = {
			Size = 17,
			Info = {
				Point = {
					"BOTTOM",
					"BOTTOM",
					0,
					3.5,
				},
				Tag = "[GetNameColor][NameMedium]",
			},
		},
		Castbar = {
			Size = 18,
			Icon = {
				"TOPLEFT",
				"RIGHT",
				10,
				10,
			},
		},
	},
	
	["raid"] = {
		Dimensions = {
			Width = 45,
			Height = 35,
			Reverse = false,
		},
		Health = {
			Orientation = "VERTICAL",
			Size = 35,
			HealComm = true,
			ResComm = true,
		},
		RaidInfo = {
			Point = {
				"CENTER",
				"CENTER",
				0,
				0,
			},
			Tag = "[GetNameColor][RaidHP]",
			Justify = "CENTER",
		},
		Leader = {
			Size = 8,
			Point = {
				"CENTER",
				"TOPLEFT",
				0,
				0,
			},
		},
		MasterLooter = {
			Size = 8,
			Point = {
				"CENTER",
				"TOPLEFT",
				8,
				0,
			},
		},
		LFDRole = {
			Size = 12,
			Point = {
				"CENTER",
				"TOPRIGHT",
				0,
				0,
			},
		},
		DebuffIcon = true,
		Status = true,
		Threat = true,
	},
	
	["boss"] = {
		Dimensions = {
			Width = 230,
			Height = 55,
			Reverse = false,
		},
		Health = {
			Size = 27,
			Value = {
				Point = {
					"BOTTOMRIGHT",
					"BOTTOMRIGHT",
					-5,
					5,
				},
				Justify = "RIGHT",
			},
			Smooth = true,
		},
		Power = {
			Size = 8,
			Value = {
				Point = {
					"BOTTOMLEFT",
					"BOTTOMLEFT",
					5,
					5,
				},
				Justify = "LEFT",
			},
		},
		Castbar = {
			Size = 18,
			Icon = {
				"TOPLEFT",
				"RIGHT",
				10,
				10,
			},
		},
		Panel = {
			Size = 20,
			Info = {
				Point = {
					"BOTTOM",
					"BOTTOM",
					0,
					5,
				},
				Tag = "[GetNameColor][NameLong]",
			},
		}
	}
}

-- --
-- Runebar options
-- --

if class == "DEATHKNIGHT" then
	config["player"].Runes = {
		Point = {
			"TOPLEFT",
			"TOPLEFT",
			0,
			0,
		},
		Growth = "RIGHT",
		Anchor = "TOPLEFT",
		Size = 8,
		Spacing = 0,
		Colors = {
			[1] = {.69,.31,.31},
			[2] = {.69,.31,.31},
			[3] = {.33,.59,.33},
			[4] = {.33,.59,.33},
			[5] = {.31,.45,.63},
			[6] = {.31,.45,.63},
		},
	}
end

if class == "ROGUE" or class == "DRUID" then
	config["target"].Combo = {
		Point = {
			"TOPRIGHT",
			"TOPRIGHT",
			0,
			0,
		},
		Anchor = "TOPRIGHT",
		Size = 8,
	}
end

local colors = setmetatable({
	power = setmetatable({
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
	}, {__index = oUF.colors.power}),
	happiness = setmetatable({
		[1] = {.69,.31,.31},
		[2] = {.65,.63,.35},
		[3] = {.33,.59,.33},
	}, {__index = oUF.colors.happiness}),
	runes = setmetatable({
		[1] = {0.69, 0.31, 0.31},
		[2] = {0.33, 0.59, 0.33},
		[3] = {0.31, 0.45, 0.63},
		[4] = {0.84, 0.75, 0.65},
	}, {__index = oUF.colors.runes}),
}, {__index = oUF.colors})

oUF.colors.smooth = {
	.7, .15, .15,
	.85, .8, .45,
	.25, .25, .25
}

local menu = function(self)
	local unit = self.unit:sub(1, -2)
	local cunit = self.unit:gsub("(.)", string.upper, 1)
	
	if unit == "party" or unit == "partypet" then
		ToggleDropDownMenu(1, nil, _G["PartyMemberFrame"..self.id.."DropDown"], "cursor", 0, 0)
	elseif _G[cunit.."FrameDropDown"] then
		ToggleDropDownMenu(1, nil, _G[cunit.."FrameDropDown"], "cursor", 0, 0)
	end
end

-- --
-- Castbar shit START
-- --

local OnCastbarUpdate = function(self, elapsed)
	if self.casting then
		local duration = self.ReverseGrowth and self.duration - elapsed or self.duration + elapsed
		
		if self.ReverseGrowth and duration <= 0 or duration >= self.max then
			self.casting = nil
			self:Hide()

			local parent = self:GetParent()
			if parent.PostCastStop then
				parent:PostCastStop('OnUpdate', parent.unit)
			end

			return
		end

		if self.SafeZone then
			local width = self:GetWidth()
			local _, _, ms = GetNetStats()
			
			local safeZonePercent = (width / self.max) * (ms / 1e5)
			if safeZonePercent > 1 then
				safeZonePercent = 1
			end
			self.SafeZone:SetWidth(width * safeZonePercent)
		end

		if self.Time then
			if self.delay ~= 0 then
				if self.CustomDelayText then
					self:CustomDelayText(duration)
				else
					self.Time:SetFormattedText("%.1f|cffff0000-%.1f|r", duration, self.delay)
				end
			else
				if self.CustomTimeText then
					self:CustomTimeText(duration)
				else
					self.Time:SetFormattedText("%.1f", duration)
				end
			end
		end
		
		self.duration = duration
		self:SetValue(duration)
	

		if self.Spark then
			self.Spark:SetPoint("CENTER", self, "LEFT", (duration / self.max) * self:GetWidth(), 0)
		end
	elseif self.channeling then
		local duration = self.ReverseGrowth and self.duration + elapsed or self.duration - elapsed
		
		if self.ReverseGrowth and duration >= self.max or duration <= 0 then
			self.channeling = nil
			self:Hide()

			local parent = self:GetParent()
			if parent.PostChannelStop then
				parent:PostChannelStop('OnUpdate', parent.unit)
			end

			return
		end

		if self.SafeZone then
			local width = self:GetWidth()
			local _, _, ms = GetNetStats()
			
			local safeZonePercent = (width / self.max) * (ms / 1e5)
			if safeZonePercent > 1 then
				safeZonePercent = 1
			end
			
			self.SafeZone:SetWidth(width * safeZonePercent)
		end


		if self.Time then
			if self.delay ~= 0 then
				if self.CustomDelayText then
					self:CustomDelayText(duration)
				else
					self.Time:SetFormattedText("%.1f|cffff0000-%.1f|r", duration, self.delay)
				end
			else
				if self.CustomTimeText then
					self:CustomTimeText(duration)
				else
					self.Time:SetFormattedText("%.1f", duration)
				end
			end
		end

		self.duration = duration
		self:SetValue(duration)
		if self.Spark then
			self.Spark:SetPoint("CENTER", self, "LEFT", (duration / self.max) * self:GetWidth(), 0)
		end
	else
		self.unitName = nil
		self.channeling = nil
		if self.ReverseGrowth then
			self:SetValue(0)
		else
			self:SetValue(1)
		end
		self:Hide()
	end
end

local PostCastStart = function(self, event, unit, spell, spellrank, castid)
	if self.unit ~= unit then
		return
	end
	local castbar = self.Castbar
	
	if castbar.ReverseGrowth then
		local name, _, _, _, startTime, endTime = UnitCastingInfo(unit)
		if not name then
			castbar:Hide()
			return
		end
		
		endTime = endTime / 1e3
		startTime = startTime / 1e3
		local duration = castbar.ReverseGrowth and endTime - GetTime() or GetTime() - startTime
		
		castbar.duration = duration
		castbar:SetValue(castbar.ReverseGrowth and duration or 0)
	end
end

local PostChannelStart = function(self, event, unit, name, rank, text, interrupt)
	if self.unit ~= unit then
		return
	end
	local castbar = self.Castbar
	
	if castbar.ReverseGrowth then
		local name, _, _, _, startTime, endTime = UnitChannelInfo(unit)
		if not name then
			castbar:Hide()
			return
		end
		
		endTime = endTime / 1e3
		startTime = startTime / 1e3
		local duration = castbar.ReverseGrowth and GetTime() - startTime or endTime - GetTime()
		
		castbar.duration = duration
		castbar:SetValue(castbar.ReverseGrowth and 0 or duration)
	end
end

local PostCastDelayed = function(self, event, unit, name, rank, text)
	if self.unit ~= unit then
		return
	end

	local name, rank, text, texture, startTime, endTime = UnitCastingInfo(unit)
	if not startTime then
		return
	end

	local castbar = self.Castbar
	local duration = castbar.ReverseGrowth and endTime / 1000 - GetTime() or GetTime() - (startTime / 1000)
	
	if duration < 0 then
		duration = 0
	end

	if castbar.ReverseGrowth then
		castbar.delay = castbar.delay + castbar.duration + duration
	else
		castbar.delay = castbar.delay + castbar.duration - duration
	end
	castbar.duration = duration

	castbar:SetValue(duration)
end
 
local PostCastStop = function(self, event, unit)
	if unit ~= self.unit then
		return
	end
end

local FormatCastbarTime = function(self, duration)
	if self.channeling then
		self.Time:SetFormattedText("%.1f ", duration)
	elseif self.casting then
		self.Time:SetFormattedText("%.1f ", self.max - duration)
	end
end

-- --
-- Castbar shit END
-- --

-- --
-- Health Shit Start
-- --

local ShortValue = function(value)
	if value >= 1e6 then
		return ("%.1fm"):format(value / 1e6):gsub("%.?0+([km])$", "%1")
	elseif value >= 1e3 or value <= -1e3 then
		return ("%.1fk"):format(value / 1e3):gsub("%.?0+([km])$", "%1")
	else
		return value
	end
end

local PostUpdateHealth = function(self, event, unit, bar, min, max)
	if not bar.value then
		return
	end
		
	if not UnitIsConnected(unit) then
		bar:SetValue(0)
		bar.value:SetText("|cffD7BEA5Offline|r")
	elseif UnitIsDead(unit) then
		bar.value:SetText("|cffD7BEA5Dead|r")
	elseif UnitIsGhost(unit) then
		bar.value:SetText("|cffD7BEA5Ghost|r")
	else
		if min ~= max then
			local r, g, b = oUF.ColorGradient(min/max, 0.69, 0.31, 0.31, 0.65, 0.63, 0.35, 0.33, 0.59, 0.33)
			if unit == "player" and self:GetAttribute("normalUnit") ~= "pet" then
				bar.value:SetFormattedText("|cffAF5050%d|r |cffD7BEA5-|r |cff%02x%02x%02x%d%%|r", min, r * 255, g * 255, b * 255, floor(min / max * 100))
			elseif unit == "target" then
				bar.value:SetFormattedText("|cffAF5050%s|r |cffD7BEA5-|r |cff%02x%02x%02x%d%%|r", ShortValue(min), r * 255, g * 255, b * 255, floor(min / max * 100))
			else
				bar.value:SetFormattedText("|cff%02x%02x%02x%d%%|r", r * 255, g * 255, b * 255, floor(min / max * 100))
			end
		else
			if unit ~= "player" and unit ~= "pet" then
				bar.value:SetText("|cff559655"..ShortValue(max).."|r")
			else
				bar.value:SetText("|cff559655"..max.."|r")
			end
		end
	end
end

local OverrideUpdateHealth = function(self, event, unit, bar, min, max)
	local r, g, b
	local threat = UnitThreatSituation(unit)
	local name, dtype
	if unit == "player" and class == "PRIEST" then
		for i = 1, 40 do
			name, _, _, _, dtype = UnitAura(unit, i, "HARMFUL")
			if not name then
				break
			end
			
			if dtype == "Poison" then
				dtype = true
				return
			end
		end
	end
	if dtype then
		r, g, b = 80/255, 150/255, 80/255
	elseif ( threat == 2 or threat == 3 ) and self.ThreatColor then
		r, g, b = 153/255, 85/255, 85/255
	else
		r, g, b = self.ColorGradient(min / max, unpack(self.colors.smooth))
	end
	
	if b then
		if bar.ReverseGrowth then
			bar:SetValue(max - min)
			bar.bg:SetVertexColor(r, g, b)
		else
			bar:SetValue(min)
			bar:SetStatusBarColor(r, g, b)
		end
	end
end

-- --
-- Health Shit End
-- --

-- --
-- Power Shit Start
-- --

local PostUpdatePower = function(self, event, unit, bar, min, max)
	if self.unit ~= "player" and self.unit ~= "pet" and self.unit ~= "target" or not bar.value then
		return
	end

	local pType, pToken = UnitPowerType(unit)
	local color = colors.power[pToken]

	if color then
		bar.value:SetTextColor(color[1], color[2], color[3])
	end

	if min == 0 then
		bar.value:SetText()
	elseif not UnitIsPlayer(unit) and not UnitPlayerControlled(unit) or not UnitIsConnected(unit) then
		bar.value:SetText()
	elseif UnitIsDead(unit) or UnitIsGhost(unit) then
		bar.value:SetText()
	elseif min == max and (pType == 2 or pType == 3 and pToken ~= "POWER_TYPE_PYRITE") then
		bar.value:SetText()
	else
		if min ~= max then
			if pType == 0 then
				if unit == "target" then
					bar.value:SetFormattedText("%d%% |cffD7BEA5-|r %s", floor(min / max * 100), ShortValue(max - (max - min)))
				elseif unit == "player" and self:GetAttribute("normalUnit") == "pet" or unit == "pet" then
					bar.value:SetFormattedText("%d%%", floor(min / max * 100))
				else
					bar.value:SetFormattedText("%d%% |cffD7BEA5-|r %d", floor(min / max * 100), max - (max - min))
				end
			else
				bar.value:SetText(max - (max - min))
			end
		else
			if unit == "pet" or unit == "target" then
				bar.value:SetText(ShortValue(min))
			else
				bar.value:SetText(min)
			end
		end
	end
end

local OverrideUpdatePower = function(self, event, unit, bar, min, max)	
	local r, g, b, t
	if bar.colorTapping and UnitIsTapped(unit) and not UnitIsTappedByPlayer(unit) then
		t = self.colors.tapped
	elseif bar.colorDisconnected and not UnitIsConnected(unit) then
		t = self.colors.disconnected
	elseif bar.colorHappiness and unit == "pet" and GetPetHappiness() then
		t = self.colors.happiness[GetPetHappiness()]
	elseif bar.colorPower then
		local _, ptype = UnitPowerType(unit)
		t = self.colors.power[ptype]
	elseif ( bar.colorClass and UnitIsPlayer(unit) ) or ( bar.colorClassNPC and not UnitIsPlayer(unit) ) or ( bar.colorClassPet and UnitPlayerControlled(unit) and not UnitIsPlayer(unit) ) then
		local _, class = UnitClass(unit)
		t = self.colors.class[class]
	elseif(bar.colorReaction and UnitReaction(unit, 'player')) then
		t = self.colors.reaction[UnitReaction(unit, "player")]
	elseif(bar.colorSmooth) then
		r, g, b = self.ColorGradient(min / max, unpack(bar.smoothGradient or self.colors.smooth))
	end
	
	if t then
		r, g, b = t[1], t[2], t[3]
	end
	
	if b then
		if bar.ReverseGrowth then
			bar:SetValue(max - min)
			bar.bg:SetVertexColor(r, g, b)
		else
			bar:SetValue(min)
			bar:SetStatusBarColor(r, g, b)
		end
	end
end

-- --
-- Power Shit End
-- --

-- --
-- Auras Shit Start
-- --

local CustomAuraFilter = function(icons, unit, icon, name, rank, texture, count, dtype, duration, timeLeft, caster)
	local isPlayer
	
	if(caster == 'player' or caster == 'vehicle') then
		isPlayer = true
	end
	
	if((icons.onlyShowPlayer and isPlayer) or (not icons.onlyShowPlayer and name)) then
		icon.isPlayer = isPlayer
		icon.owner = caster
		
		-- We set it to math.huge, because it lasts until cancelled.
		if(timeLeft == 0) then
			icon.timeLeft = math.huge
		else
			icon.timeLeft = timeLeft
		end

		return true
	end
end

local sort = function(a, b)
	return a.timeLeft > b.timeLeft
end
 
local PreAuraSetPosition = function(self, auras, max)
	if self.unit == "player" then
		table.sort(auras, sort)
	end
end

local PostUpdateAuraIcon = function(self, icons, unit, icon, index)
	local _, _, _, _, _, _, _, unitCaster = UnitAura(unit, index, icon.filter)
	
	if unitCaster ~= "player" and unitCaster ~= "pet" and unitCaster ~= "vehicle" then
		if UnitIsEnemy("player", unit) then
			if icon.debuff then
				icon.icon:SetDesaturated(true)
			end
			icon.overlay:SetVertexColor(1, 1, 1)
		end
	else
		icon.icon:SetDesaturated(false)
	end
end

local PostUpdateAura = function(self, event, unit)
	local buffs, debuffs = self.Buffs, self.Debuffs
	
	if buffs then
		local visibleBuffs = buffs.visibleBuffs
		local size = buffs.size
		local width = buffs:GetWidth()
		
		local cols = math.floor(width / size + .5)
		local height = math.floor(visibleBuffs / cols + .1)
		
		buffs:SetHeight(size*(height + 1))

		local point, relativeTo, relativePoint, xOfs = debuffs:GetPoint()
		
		debuffs:ClearAllPoints()
		if visibleBuffs > 0 then
			debuffs:SetPoint(point, relativeTo, relativePoint, xOfs, (size + 2)*(height + 1) + 3)
		else
			debuffs:SetPoint(point, relativeTo, relativePoint, xOfs, 3)
		end
	end
end

local updateTooltip = function(self)
	if GameTooltip:IsOwned(self) then
		GameTooltip:SetUnitAura(self.frame.unit, self:GetID(), self.filter)
	end
end

local OnEnter = function(self)
	if not self:IsVisible() then
		return
	end
	
	GameTooltip:SetOwner(self, "ANCHOR_BOTTOMRIGHT")
	GameTooltip:SetUnitAura(self.frame.unit, self:GetID(), self.filter)
	self:SetScript("OnUpdate", updateTooltip)
end

local OnLeave = function(self)
	self:SetScript("OnUpdate", nil)
	GameTooltip:Hide()
end

local CreateAura = function(self, button, icons)
	local backdrop = CreateFrame("Frame", nil, button)
	backdrop:SetPoint("TOPLEFT", button, "TOPLEFT", -3.5, 3)
	backdrop:SetPoint("BOTTOMRIGHT", button, "BOTTOMRIGHT", 4, -3.5)
	backdrop:SetFrameStrata("BACKGROUND")
	backdrop:SetBackdrop({
		edgeFile = config.backdropEdge, edgeSize = 5,
		insets = {left = 3, right = 3, top = 3, bottom = 3}
	})
	backdrop:SetBackdropColor(0, 0, 0, 0)
	backdrop:SetBackdropBorderColor(0, 0, 0)
	
	button.Backdrop = backdrop

	button.cd:ClearAllPoints()
	button.cd:SetPoint("TOPLEFT", 2, -2)
	button.cd:SetPoint("BOTTOMRIGHT", -2, 2)
	button.cd:SetReverse(true)
	
	button.count:SetPoint("BOTTOMRIGHT", -1, 2)
	button.count:SetJustifyH("RIGHT")
	button.count:SetFont(config.font, 10, "OUTLINE")
	button.count:SetTextColor(0.84, 0.75, 0.65)

	icons.showDebuffType = true

	button.overlay:SetTexture(config.buttonTex)
	button.overlay:SetPoint("TOPLEFT", button, "TOPLEFT", -2, 2)
	button.overlay:SetPoint("BOTTOMRIGHT", button, "BOTTOMRIGHT", 2, -2)
	button.overlay:SetTexCoord(0, 1, 0.02, 1)
	button.overlay.Hide = function(self)
	end

	if icons == self.Enchant then
		button.overlay:SetVertexColor(0.33, 0.59, 0.33)
	else
		button:SetScript("OnEnter", OnEnter)
		button:SetScript("OnLeave", OnLeave)
	end
end

-- --
-- Auras Shit End
-- --

local UNIT_THREAT_SITUATION_UPDATE = function(self)
	local bar = self.Health
	local threat = UnitThreatSituation(self.unit)
	if threat == 2 or threat == 3 then
		if bar.ReverseGrowth then
			bar.bg:SetVertexColor(153/255, 85/255, 85/255)
		else
			bar:SetStatusBarColor(153/255, 85/255, 85/255)
		end
	else
		local min, max = UnitHealth(self.unit), UnitHealthMax(self.unit)
		self:OverrideUpdateHealth(_, self.unit, bar, min, max)
	end
end

local RAID_TARGET_UPDATE = function(self, event)
	local index = GetRaidTargetIndex(self.unit)
	if index then
		self.RIcon:SetText(ICON_LIST[index].."22|t")
	else
		self.RIcon:SetText()
	end
end

local UpdateCPoints = function(self, event, unit)
	if unit == PlayerFrame.unit and unit ~= self.CPoints.unit then
		self.CPoints.unit = unit
	end
end

-- --
-- DPS TESTIUSH
-- --

local time, sumElapsed, dps, hps, damagetotal, healingtotal, pName = 0, 0, 0, 0, 0, 0, UnitName("player")
local damageevents = {
	SWING_DAMAGE = true,
	RANGE_DAMAGE = true,
	SPELL_DAMAGE = true,
	SPELL_PERIODIC_DAMAGE = true,
	DAMAGE_SHIELD = true,
	DAMAGE_SPLIT = true
}
local healingevents = {
	SWING_HEAL = true,
	RANGE_HEAL = true,
	SPELL_HEAL = true,
	SPELL_PERIODIC_HEAL = true,
}

local COMBAT_LOG_EVENT_UNFILTERED = function(self, _, _, eventtype, _, name, _, _, _, _, spellid, _, _, dmgorheal)
	if damageevents[eventtype] then	
		if name == pName then
			if eventtype == "SWING_DAMAGE" then
				dmgorheal = spellid
			end
			
			damagetotal = (damagetotal or 0) + dmgorheal
		end
	elseif healingevents[eventtype] then
		if name == pName then
			if eventtype == "SWING_HEAL" then
				dmgorheal = spellid
			end
			
			healingtotal = (healingtotal or 0) + dmgorheal
		end
	end
end

local PLAYER_REGEN_ENABLED = function(self)
	self.Panel.DPS:SetText()
	
	damagetotal = 0
	healingtotal = 0
	time = 0
end

local calculateDPSandHPS = function(self, elapsed)
	if UnitAffectingCombat("player") then
		time = (time or 0) + elapsed
		
		sumElapsed = sumElapsed + elapsed
		if sumElapsed > 1 then
			dps = (damagetotal or 0) / (time or 1)
			hps = (healingtotal or 0) / (time or 1)
			
			if dps > (hps * .5) then
				self.Panel.DPS:SetText(string.format("%.1f DPS", dps))
				self.Panel.DPS:SetTextColor(153/255, 85/255, 85/255)
			elseif (hps * .5) > dps then
				self.Panel.DPS:SetText(string.format("%.1f HPS", hps))
				self.Panel.DPS:SetTextColor(80/255, 150/255, 80/255)
			end
			
			sumElapsed = 0
		end
	end
end

-- --
-- DPSISH
-- --

local layout = function(self, unit)
	if unit then
		unit = unit:match("boss") and "boss" or unit
	else
		unit = "raid"
	end
	
	self.menu = menu
	
	self:SetScript("OnEnter", UnitFrame_OnEnter)
	self:SetScript("OnLeave", UnitFrame_OnLeave)
	
	self:SetAttribute('initial-height', config[unit].Dimensions.Height)
	self:SetAttribute('initial-width', config[unit].Dimensions.Width)
	
	local backdrop = CreateFrame("Frame", nil, self)
	backdrop:SetPoint("TOPLEFT", self, "TOPLEFT", -5, 5)
	backdrop:SetPoint("BOTTOMRIGHT", self, "BOTTOMRIGHT", 5, -5)
	backdrop:SetFrameStrata("BACKGROUND")
	backdrop:SetBackdrop({
		bgFile = config.backdropFill,
		edgeFile = config.backdropEdge,
		edgeSize = 5,
		insets = {
			left = 5,
			right = 5,
			top = 5,
			bottom = 5
		}
	})
	backdrop:SetBackdropColor(.15,.15,.15)
	backdrop:SetBackdropBorderColor(.15,.15,.15)
	self.backdrop = backdrop
	
	self:RegisterForClicks("anyup")
	self:SetAttribute("*type2", "menu")
	
	local Panel = config[unit].Panel
	if Panel then
		local panel = CreateFrame("Frame", nil, self)
		panel:SetFrameStrata("LOW")
		panel:SetHeight(Panel.Size)
		panel:SetPoint("BOTTOMLEFT", self, "BOTTOMLEFT", 0, 0)
		panel:SetPoint("BOTTOMRIGHT", self, "BOTTOMRIGHT", 0, 0)
		panel:SetBackdrop({
			bgFile = config.backdropFill,
			edgeFile = config.backdropFill, 
			edgeSize = 1,
		})
		panel:SetBackdropColor(0.1,0.1,0.1,1)
		panel:SetBackdropBorderColor(0.4,0.4,0.4,1)
		
		self.Panel = panel
		
		local Info = Panel.Info
		if Info then
			local info = self.Panel:CreateFontString(nil, "OVERLAY")
			info:SetFont(config.font, 12)
			info:SetShadowColor(0, 0, 0)
			info:SetShadowOffset(1.25, -1.25)
			info:SetPoint(Info.Point[1], self, Info.Point[2], Info.Point[3], Info.Point[4])
			info:SetTextColor(0.84, 0.75, 0.65)
			
			self.Panel.Info = info
			
			self:Tag(self.Panel.Info, Info.Tag)
		end
		
		local Castbar = config[unit].Castbar
		if Castbar then
			local cb = CreateFrame("StatusBar", nil, self)
			cb:SetStatusBarTexture(config.barTexture)
			cb:SetPoint("TOPLEFT", self.Panel, "TOPLEFT", 1, -1)
			cb:SetPoint("BOTTOMRIGHT", self.Panel, "BOTTOMRIGHT", -1, 1)
			cb:SetHeight(Castbar.Size)
			cb:SetFrameStrata("HIGH")
			
			local bg = cb:CreateTexture(nil, "BACKGROUND")
			bg:SetAllPoints(cb)
			bg:SetTexture(config.barTexture)
			
			local Reverse = config[unit].Dimensions.Reverse
			if Reverse then
				cb.ReverseGrowth = true
				cb:SetStatusBarColor(.1, .1, .1)
				cb:SetStatusBarTexture(config.backdropFill)
				bg:SetVertexColor(.2, 1, 1)
			else
				cb:SetStatusBarColor(.2, 1, 1)
				bg:SetVertexColor(.1, .1, .1)
				bg:SetTexture(config.backdropFill)
			end
			
			local time = cb:CreateFontString(nil, "OVERLAY")
			time:SetFont(config.font, 12)
			time:SetShadowColor(0, 0, 0)
			time:SetShadowOffset(1.25, -1.25)
			time:SetPoint("RIGHT", -2, .5)
			time:SetTextColor(0.84, 0.75, 0.65)
			time:SetJustifyH("RIGHT")
			
			local text = cb:CreateFontString(nil, "OVERLAY")
			text:SetFont(config.font, 12)
			text:SetShadowColor(0, 0, 0)
			text:SetShadowOffset(1.25, -1.25)
			text:SetPoint("CENTER", 0, .5)
			text:SetTextColor(0.84, 0.75, 0.65)
			
			local icon = cb:CreateTexture(nil, "ARTWORK")
			icon:SetHeight(28.5)
			icon:SetWidth(28.5)
			icon:SetTexCoord(0, 1, 0, 1)
			icon:SetPoint(Castbar.Icon[1], self, Castbar.Icon[2], Castbar.Icon[3], Castbar.Icon[4])
			
			local overlay = cb:CreateTexture(nil, "OVERLAY")
			overlay:SetPoint("TOPLEFT", icon, "TOPLEFT", -1.5, 1)
			overlay:SetPoint("BOTTOMRIGHT", icon, "BOTTOMRIGHT", 1, -1)
			overlay:SetTexture(config.buttonTex)
			overlay:SetVertexColor(1, 1, 1)
			
			local backdrop = CreateFrame("Frame", nil, self)
			backdrop:SetPoint("TOPLEFT", icon, "TOPLEFT", -4, 3)
			backdrop:SetPoint("BOTTOMRIGHT", icon, "BOTTOMRIGHT", 3, -3.5)
			backdrop:SetParent(cb)
			backdrop:SetBackdrop({
				edgeFile = config.backdropEdge, edgeSize = 4,
				insets = {left = 3, right = 3, top = 3, bottom = 3}
			})
			backdrop:SetBackdropColor(0, 0, 0, 0)
			backdrop:SetBackdropBorderColor(0, 0, 0, 0.7)
			
			
			icon.Backdrop = backdrop
			icon.Overlay = overlay
			cb.Icon = icon
			
			cb.CustomTimeText = FormatCastbarTime
			cb.Text = text
			cb.Time = time
			cb.bg = bg
			self.Castbar = cb
			
			self.PostChannelStart = PostChannelStart
			self.PostCastStart = PostCastStart
			self.PostCastStop = PostCastStop
			self.PostChannelStop = PostCastStop
			self.PostCastDelayed = PostCastDelayed
			self.OnCastbarUpdate = OnCastbarUpdate
		end
		if unit == "pet" and not Castbar then
			PetCastingBarFrame:UnregisterAllEvents()
			PetCastingBarFrame.Show = function()
			end
			PetCastingBarFrame:Hide()
		end
		
		local DPS = config[unit].Panel.DPS
		if DPS then
			local dps = self.Panel:CreateFontString(nil, "OVERLAY")
			dps:SetFont(config.font, 12)
			dps:SetShadowColor(0, 0, 0)
			dps:SetShadowOffset(1.25, -1.25)
			dps:SetPoint(DPS.Point[1], self, DPS.Point[2], DPS.Point[3], DPS.Point[4])
			dps:SetTextColor(0.84, 0.75, 0.65)
			
			self:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED", COMBAT_LOG_EVENT_UNFILTERED)
			self:RegisterEvent("PLAYER_REGEN_ENABLED", PLAYER_REGEN_ENABLED)
			self:SetScript("OnUpdate", calculateDPSandHPS)
			
			self.Panel.DPS = dps
		end		
	end
	
	local Runes = config[unit].Runes
	if Runes then
		self:SetAttribute('initial-height', self:GetAttribute('initial-height') + Runes.Size)
		
		local runes = CreateFrame('Frame', nil, self)
		runes:SetPoint(Runes.Point[1], self, Runes.Point[2], Runes.Point[3], Runes.Point[4])
		runes:SetHeight(Runes.Size)
		runes:SetWidth(config[unit].Dimensions.Width)
		runes:SetBackdrop({
			bgFile = config.backdropFill
		})
		runes:SetBackdropColor(0.08, 0.08, 0.08)
		runes.anchor = Runes.Anchor
		runes.growth = Runes.Growth
        runes.height = Runes.Size
		runes.width = config[unit].Dimensions.Width / 6
		runes.spacing = Runes.Spacing
		
		for i = 1, 6 do
			local rune = CreateFrame('StatusBar', nil, runes)
			rune:SetStatusBarTexture(config.barTexture)
			rune:SetStatusBarColor(unpack(Runes.Colors[i]))
			
			runes[i] = rune
		end
		
		self.Runes = runes
	end
	
	local Combo = config[unit].Combo
	if Combo then
		self:SetAttribute('initial-height', self:GetAttribute('initial-height') + Combo.Size)
		
		local combo = CreateFrame("Frame", nil, self)
		combo:SetHeight(Combo.Size)
		combo:SetWidth(config[unit].Dimensions.Width)
		combo:SetBackdrop({
			bgFile = config.backdropFill
		})
		combo:SetBackdropColor(0.08, 0.08, 0.08)
		combo:SetPoint(Combo.Point[1], self, Combo.Point[2], Combo.Point[3], Combo.Point[4])
		combo.unit = PlayerFrame.unit
		local tex
		for i = 1, 5 do
			tex = combo:CreateTexture(nil, "ARTWORK")
			tex:SetHeight(Combo.Size)
			tex:SetWidth(config[unit].Dimensions.Width / 5)
			tex:SetTexture(config.barTexture)
			if i == 1 then
				tex:SetPoint(Combo.Anchor)
				tex:SetVertexColor(0.69, 0.31, 0.31)
			else
				tex:SetPoint("RIGHT", combo[i - 1], "LEFT")
			end
			
			combo[i] = tex
		end
		combo[2]:SetVertexColor(0.69, 0.31, 0.31)
		combo[3]:SetVertexColor(0.65, 0.63, 0.35)
		combo[4]:SetVertexColor(0.65, 0.63, 0.35)
		combo[5]:SetVertexColor(0.33, 0.59, 0.33)
		self:RegisterEvent("UNIT_COMBO_POINTS", UpdateCPoints)
		
		self.CPoints = combo
	end
	
	local Health = config[unit].Health
	if Health then
		local hp = CreateFrame("StatusBar", nil, self)
		hp:SetStatusBarTexture(config.barTexture)
		hp:SetHeight(Health.Size)
		if Health.Smooth then
			hp.Smooth = true
		end
		hp:SetFrameStrata("LOW")
		if Runes then
			hp:SetPoint("TOPLEFT", self.Runes, "BOTTOMLEFT")
			hp:SetPoint("TOPRIGHT", self.Runes, "BOTTOMRIGHT")
		elseif Combo then
			hp:SetPoint("TOPLEFT", self.CPoints, "BOTTOMLEFT")
			hp:SetPoint("TOPRIGHT", self.CPoints, "BOTTOMRIGHT")
		else
			hp:SetPoint("TOPLEFT")
			hp:SetPoint("TOPRIGHT")
		end
		hp.frequentUpdates = true
		if Health.Orientation then
			hp:SetOrientation(Health.Orientation)
		end
		
		local bg = hp:CreateTexture(nil, "BACKGROUND")
		bg:SetAllPoints(hp)
		bg:SetTexture(config.barTexture)
		
		local Reverse = config[unit].Dimensions.Reverse
		if Reverse then
			hp.ReverseGrowth = true
			hp:SetStatusBarColor(.1,.1,.1)
		else
			hp.ReverseGrowth = false
			bg:SetVertexColor(.1,.1,.1)
		end
				
		local Value = Health.Value
		if Value then
			local value = hp:CreateFontString(nil, "OVERLAY")
			value:SetFont(config.font, 12)
			value:SetShadowColor(0, 0, 0)
			value:SetShadowOffset(1.25, -1.25)
			value:SetPoint(Value.Point[1], self, Value.Point[2], Value.Point[3], Value.Point[4])
			value:SetTextColor(0.84, 0.75, 0.65)
			value:SetJustifyH(Value.Justify)
			
			hp.value = value
		end
		
		local HealComm = IsAddOnLoaded("oUF_HealComm4") and config[unit].Health.HealComm
		if HealComm then
			local heal = CreateFrame('StatusBar', nil, hp)
			heal:SetHeight(0)
			heal:SetWidth(0)
			heal:SetStatusBarTexture(config.barTexture)
			heal:SetStatusBarColor(0, 1, 0, 0.4)
			heal:SetPoint("BOTTOM", hp, "BOTTOM")
			
			self.HealCommBar = heal
			self.HealCommOthersOnly = true
			self.HealCommTimeframe = 2
		end
		
		local ResComm = IsAddOnLoaded("oUF_ResComm") and config[unit].Health.ResComm
		if ResComm then
			local rescomm = CreateFrame("StatusBar", nil, self)
			rescomm:SetStatusBarTexture([=[Interface\Icons\Spell_Holy_Resurrection]=])
			rescomm:SetAllPoints(self)
			rescomm:SetAlpha(.25)
			
			rescomm.OthersOnly = true
			self.ResComm = rescomm
		end
		
		hp.bg = bg
		self.Health = hp
		
		self.PostUpdateHealth = PostUpdateHealth
		self.OverrideUpdateHealth = OverrideUpdateHealth
	end
	
	local Power = config[unit].Power
	if Power then
		local pp = CreateFrame("StatusBar", nil, self)
		pp:SetHeight(Power.Size)
		pp.Smooth = true
		pp:SetStatusBarTexture(config.barTexture)
		pp:SetFrameStrata("LOW")
		
		pp.frequentUpdates = true
		pp.colorTapping = true
		pp.colorHappiness = true
		pp.colorClass = true
		pp.colorReaction = true
		
		pp:SetParent(self)
		pp:SetPoint("LEFT")
		pp:SetPoint("RIGHT")
		pp:SetPoint("TOP", self.Health, "BOTTOM", 0, 0)
		
		local bg = pp:CreateTexture(nil, "BORDER")
		bg:SetAllPoints(pp)
		bg:SetTexture(config.barTexture)
		
		if config[unit].Dimensions.Reverse then
			pp.ReverseGrowth = true
			pp:SetStatusBarColor(.1,.1,.1)
		else
			pp.ReverseGrowth = false
			bg:SetVertexColor(.1,.1,.1)
		end
		
		local Value = Power.Value
		if Value then
			local value = pp:CreateFontString(nil, "OVERLAY")
			value:SetFont(config.font, 12)
			value:SetShadowColor(0, 0, 0)
			value:SetShadowOffset(1.25, -1.25)
			value:SetPoint(Value.Point[1], self, Value.Point[2], Value.Point[3], Value.Point[4])
			value:SetTextColor(0.84, 0.75, 0.65)
			value:SetJustifyH(Value.Justify)
			
			pp.value = value
		end
		
		pp.bg = bg
		self.Power = pp
		
		self.OverrideUpdatePower = OverrideUpdatePower
		self.PostUpdatePower = PostUpdatePower
	end
	
	local Enchant = IsAddOnLoaded("oUF_WeaponEnchant") and config[unit].Enchant
	if Enchant then
		local enchant = CreateFrame("Frame", nil, self)
		enchant:SetHeight(Enchant.Size * 2)
		enchant:SetWidth(Enchant.Size)
		enchant:SetPoint(Enchant.Point[1], self, Enchant.Point[2], Enchant.Point[3], Enchant.Point[4])
		enchant.size = Enchant.Size
		enchant.spacing = Enchant.Spacing
		enchant.initialAnchor = Enchant.Anchor
		enchant["growth-y"] = Enchant.GrowthY
		
		self.Enchant = enchant
		
		self.PostCreateEnchantIcon = CreateAura
	end
	
	local Experience = IsAddOnLoaded("oUF_Experience") and config[unit].Experience
	if Experience then
		local xp = CreateFrame("StatusBar", nil, self)
		xp:SetStatusBarTexture(config.barTexture)
		xp:SetPoint("TOPLEFT", self.Panel, "TOPLEFT", 1, -1)
		xp:SetPoint("BOTTOMRIGHT", self.Panel, "BOTTOMRIGHT", -1, 1)
		xp:SetHeight(Experience.Size)
		xp:SetFrameStrata("HIGH")
		xp:SetAlpha(0)
		xp:EnableMouse(true)
		xp.Tooltip = true
		
		local bg = xp:CreateTexture(nil, "BACKGROUND")
		bg:SetAllPoints(xp)
		bg:SetTexture(config.barTexture)
		
		local Reverse = config[unit].Dimensions.Reverse
		if Reverse then
			xp.ReverseGrowth = true
			xp:SetStatusBarColor(.1, .1, .1)
			xp:SetStatusBarTexture(config.backdropFill)
			bg:SetVertexColor(.8, .2, .8)
		else
			xp:SetStatusBarColor(.8, .2, .8)
			bg:SetVertexColor(.1, .1, .1)
			bg:SetTexture(config.backdropFill)
		end
		
		xp:SetScript("OnEnter", function(self)
			self:SetAlpha(.5)
		end)
		xp:SetScript("OnLeave", function(self)
			self:SetAlpha(0)
		end)
		
		xp.bg = bg
		self.Experience = xp
	end
	
	local Buffs = config[unit].Buffs
	if Buffs then
		local buffs = CreateFrame("Frame", nil, self)
		buffs:SetHeight(Buffs.Size)
		buffs:SetWidth(230)
		buffs.size = Buffs.Size
		buffs.spacing = Buffs.Spacing
		buffs.num = Buffs.num
		buffs.numBuffs = Buffs.num
			
		buffs:SetPoint(Buffs.Point[1], self, Buffs.Point[2], Buffs.Point[3], Buffs.Point[4])
		buffs.initialAnchor = Buffs.Anchor
		buffs["growth-y"] = Buffs.GrowthY	
		buffs["growth-x"] = Buffs.GrowthX
			
		self.Buffs = buffs
	end
	
	local Debuffs = config[unit].Debuffs
	if Debuffs then
		local debuffs = CreateFrame("Frame", nil, self)
		debuffs:SetHeight(Debuffs.Size)
		debuffs:SetWidth(230)
		debuffs.size = Debuffs.Size
		debuffs.spacing = Debuffs.Spacing
		debuffs.num = Debuffs.num
		debuffs.numBuffs = Debuffs.num
		
		debuffs:SetPoint(Debuffs.Point[1], self, Debuffs.Point[2], Debuffs.Point[3], Debuffs.Point[4])
		debuffs.initialAnchor = Debuffs.Anchor
		debuffs["growth-y"] = Debuffs.GrowthY	
		debuffs["growth-x"] = Debuffs.GrowthX
		
		self.Debuffs = debuffs
	end
	
	if Buffs or Debuffs then
		self.PreAuraSetPosition = PreAuraSetPosition
		self.PostUpdateAura = PostUpdateAura
		self.PostUpdateAuraIcon = PostUpdateAuraIcon
		self.PostCreateAuraIcon = CreateAura
		self.CustomAuraFilter = CustomAuraFilter
	end
	
	local RaidInfo = config[unit].RaidInfo
	if RaidInfo then
		local raidinfo = self:CreateFontString(nil, "OVERLAY")
		raidinfo:SetFont(config.font, 14)
		raidinfo:SetShadowColor(0, 0, 0)
		raidinfo:SetShadowOffset(1.25, -1.25)
		raidinfo:SetPoint(RaidInfo.Point[1], self, RaidInfo.Point[2], RaidInfo.Point[3], RaidInfo.Point[4])
		raidinfo:SetTextColor(0.84, 0.75, 0.65)
		raidinfo.frequentUpdates = true
		self:Tag(raidinfo, RaidInfo.Tag)
		
		self.RaidInfo = raidinfo
	end
	
	local Combat = config[unit].Combat
	if Combat then
		local combat = self:CreateTexture(nil, "OVERLAY")
		combat:SetVertexColor(.7, .15, .15)
		combat:SetHeight(Combat.Size)
		combat:SetWidth(Combat.Size)
		combat:SetPoint(Combat.Point[1], self, Combat.Point[2], Combat.Point[3], Combat.Point[4])
		
		self.Combat = combat
	end
	
	local Leader = config[unit].Leader
	if Leader then
		local leader = self:CreateTexture(nil, "OVERLAY")
		leader:SetHeight(Leader.Size)
		leader:SetWidth(Leader.Size)
		leader:SetPoint(Leader.Point[1], self, Leader.Point[2], Leader.Point[3], Leader.Point[4])
		
		self.Leader = leader
	end
	
	local MasterLooter = config[unit].MasterLooter
	if MasterLooter then
		local masterlooter = self:CreateTexture(nil, 'OVERLAY')
		masterlooter:SetHeight(MasterLooter.Size)
		masterlooter:SetWidth(MasterLooter.Size)
		masterlooter:SetPoint(MasterLooter.Point[1], self, MasterLooter.Point[2], MasterLooter.Point[3], MasterLooter.Point[4])
		
		self.MasterLooter = masterlooter
	end
	
	local ricon = self:CreateFontString(nil, "OVERLAY")
	ricon:SetPoint("CENTER", self, "TOP")
	ricon:SetFont(config.font, 18)
	ricon:SetJustifyH("CENTER")
	ricon:SetFontObject(GameFontNormalSmall)
	ricon:SetTextColor(1, 1, 1)
	
	self.RIcon = ricon
	self:RegisterEvent("RAID_TARGET_UPDATE", RAID_TARGET_UPDATE)
	table.insert(self.__elements, RAID_TARGET_UPDATE)
	
	local DebuffIcon = config[unit].DebuffIcon
	if DebuffIcon then
		local icon = CreateFrame("Frame", nil, self)
		icon:SetPoint("CENTER")
		icon:SetHeight(20)
		icon:SetWidth(20)
		icon:Hide()
		
		local iconTex = icon:CreateTexture(nil, "OVERLAY")
		iconTex:SetAllPoints(icon)
		iconTex:SetTexCoord(0.07, 0.93, 0.07, 0.93)
		
		local overlay = icon:CreateTexture(nil, "OVERLAY")
		overlay:SetTexture(config.buttonTex)
		overlay:SetPoint("TOPLEFT", icon, "TOPLEFT", -2, 2)
		overlay:SetPoint("BOTTOMRIGHT", icon, "BOTTOMRIGHT", 2, -2)
		overlay:SetTexCoord(0, 1, 0.02, 1)
		
		local count = icon:CreateFontString(nil, "OVERLAY")
		count:SetPoint("BOTTOMRIGHT", 0, 2)
		count:SetJustifyH("RIGHT")
		count:SetFont(config.font, 10, "OUTLINE")
		count:SetTextColor(0.84, 0.75, 0.65)
		
		local cooldown = CreateFrame("Cooldown", nil, icon)
		cooldown:SetAllPoints(icon)
		
		local backdrop = CreateFrame("Frame", nil, icon)
		backdrop:SetPoint("TOPLEFT", icon, "TOPLEFT", -3.5, 3)
		backdrop:SetPoint("BOTTOMRIGHT", icon, "BOTTOMRIGHT", 4, -3.5)
		backdrop:SetFrameStrata("LOW")
		backdrop:SetBackdrop({
			edgeFile = config.backdropEdge, edgeSize = 5,
			insets = {left = 3, right = 3, top = 3, bottom = 3}
		})
		backdrop:SetBackdropColor(0, 0, 0, 0)
		backdrop:SetBackdropBorderColor(0, 0, 0)
		
		icon.Texture = iconTex
		icon.Overlay = overlay
		icon.Count = count
		icon.Cooldown = cooldown
		icon.Backdrop = backdrop
		
		self.DebuffIcon = icon
	end
	
	local Status = config[unit].Status
	if Status then
		local auraStatus = self:CreateFontString(nil, "OVERLAY")
		auraStatus:SetPoint("TOPLEFT", -2, 1)
		auraStatus:SetFont(config.aurafont, 6, "THINOUTLINE")
		self:Tag(auraStatus, oUF.classIndicators[class]["TL"])
		
		self.AuraStatusTopLeft = auraStatus
		
		auraStatus = self:CreateFontString(nil, "OVERLAY")
		auraStatus:SetPoint("TOPRIGHT", 3, 1)
		auraStatus:SetFont(config.aurafont, 6, "THINOUTLINE")
		self:Tag(auraStatus, oUF.classIndicators[class]["TR"])
		
		self.AuraStatusTopRight = auraStatus

		auraStatus = self:CreateFontString(nil, "OVERLAY")
		auraStatus:ClearAllPoints()
		auraStatus:SetPoint("BOTTOMLEFT", -2, 1)
		auraStatus:SetFont(config.aurafont, 6, "THINOUTLINE")
		self:Tag(auraStatus, oUF.classIndicators[class]["BL"])
		
		self.AuraStatusBottomLeft = auraStatus

		auraStatus = self:CreateFontString(nil, "OVERLAY")
		auraStatus:SetPoint("CENTER", self, "BOTTOMRIGHT", 1, 1)
		auraStatus:SetFont(config.symbolfont, 11, "THINOUTLINE")
		self:Tag(auraStatus, oUF.classIndicators[class]["BR"])
		
		self.AuraStatusBottomRight = auraStatus
	end
	
	local LFDRole = config[unit].LFDRole
	if LFDRole then
		local role = self:CreateTexture(nil, "OVERLAY")
		role:SetHeight(LFDRole.Size)
		role:SetWidth(LFDRole.Size)
		role:SetPoint(LFDRole.Point[1], self, LFDRole.Point[2], LFDRole.Point[3], LFDRole.Point[4])
		
		self.LFDRole = role
	end
	
	if unit ~= "player" and unit ~= "boss" then
		self.SpellRange = true
		self.inRangeAlpha = 1
		self.outsideRangeAlpha = .25
	end
	
	self:RegisterEvent('UNIT_NAME_UPDATE', PostCastStop)
	table.insert(self.__elements, 2, PostCastStop)
	
	local Threat = config[unit].Threat
	if Threat then
		self:RegisterEvent("UNIT_THREAT_SITUATION_UPDATE", UNIT_THREAT_SITUATION_UPDATE)
		self.ThreatColor = true
	end
	
	if unit ~= "raid" and unit ~= "boss" or self.unit and self.unit == "boss3" then
		config[unit] = nil
	end
end
 
oUF:RegisterStyle("Guardix", layout)
oUF:SetActiveStyle("Guardix")

local player = oUF:Spawn("player")
player:SetPoint("BOTTOM", UIParent, -250, 75)

local target = oUF:Spawn("target")
target:SetPoint("BOTTOM", UIParent, 250, 75)

local pet = oUF:Spawn("pet")
pet:SetPoint("BOTTOMRIGHT", player, "TOPLEFT", -15, 15)

local focus = oUF:Spawn("focus")
focus:SetPoint("LEFT", target, "RIGHT", 50, 0)

local targettarget = oUF:Spawn("targettarget")
targettarget:SetPoint("BOTTOMLEFT", target, "TOPRIGHT", 15, 15)

local raidFrame = CreateFrame("Frame", nil, UIParent)
raidFrame:SetPoint("BOTTOM", UIParent, "BOTTOM", 0, 260)
raidFrame:SetHeight(1)
raidFrame:RegisterEvent("RAID_ROSTER_UPDATE")
raidFrame:RegisterEvent("PLAYER_ENTERING_WORLD")
raidFrame:RegisterEvent("PARTY_MEMBERS_CHANGED")
raidFrame:RegisterEvent("UNIT_PET")

--[[
	List of the various configuration attributes
	======================================================
	showRaid = [BOOLEAN] -- true if the header should be shown while in a raid
	showParty = [BOOLEAN] -- true if the header should be shown while in a party and not in a raid
	showPlayer = [BOOLEAN] -- true if the header should show the player when not in a raid
	showSolo = [BOOLEAN] -- true if the header should be shown while not in a group (implies showPlayer)
	nameList = [STRING] -- a comma separated list of player names (not used if 'groupFilter' is set)
	groupFilter = [1-8, STRING] -- a comma seperated list of raid group numbers and/or uppercase class names and/or uppercase roles
	strictFiltering = [BOOLEAN] - if true, then characters must match both a group and a class from the groupFilter list
	point = [STRING] -- a valid XML anchoring point (Default: "TOP")
	xOffset = [NUMBER] -- the x-Offset to use when anchoring the unit buttons (Default: 0)
	yOffset = [NUMBER] -- the y-Offset to use when anchoring the unit buttons (Default: 0)
	sortMethod = ["INDEX", "NAME"] -- defines how the group is sorted (Default: "INDEX")
	sortDir = ["ASC", "DESC"] -- defines the sort order (Default: "ASC")
	template = [STRING] -- the XML template to use for the unit buttons
	templateType = [STRING] - specifies the frame type of the managed subframes (Default: "Button")
	groupBy = [nil, "GROUP", "CLASS", "ROLE"] - specifies a "grouping" type to apply before regular sorting (Default: nil)
	groupingOrder = [STRING] - specifies the order of the groupings (ie. "1,2,3,4,5,6,7,8")
	maxColumns = [NUMBER] - maximum number of columns the header will create (Default: 1)
	unitsPerColumn = [NUMBER or nil] - maximum units that will be displayed in a singe column, nil is infinate (Default: nil)
	startingIndex = [NUMBER] - the index in the final sorted unit list at which to start displaying units (Default: 1)
	columnSpacing = [NUMBER] - the ammount of space between the rows/columns (Default: 0)
	columnAnchorPoint = [STRING] - the anchor point of each new column (ie. use LEFT for the columns to grow to the right)
--]]

local raidHeader = oUF:Spawn("header", "oUF_Raid")
raidHeader:SetManyAttributes(
	"showPlayer", true,
	"showRaid", true,
	"ShowParty", true,
	"yOffset", 5,
	"xOffset", 5,
	"maxColumns", 8,
	"point", "BOTTOM",
	"unitsPerColumn", 5,
	"columnSpacing", 5,
	"columnAnchorPoint", "LEFT",
	"groupingOrder", "1,2,3,4,5,6,7,8",
	"groupBy", "GROUP"
)
raidHeader:SetPoint("BOTTOMLEFT", raidFrame, "BOTTOMLEFT", 0, 0)
raidHeader:Show()

local petHeader = oUF:Spawn("header", "oUF_Pets", "SecureGroupPetHeaderTemplate")
petHeader:SetManyAttributes(
	"showPlayer", true,
	"ShowParty", true,
	"yOffset", 5,
	"xOffset", 5,
	"point", "BOTTOM",
	"maxColumns", 8,
	"unitsPerColumn", 5,
	"columnSpacing", 5,
	"columnAnchorPoint", "LEFT"
)
petHeader:SetPoint("BOTTOMLEFT", raidFrame, "BOTTOMRIGHT", 5, 0)
petHeader:Show()

local resizeRaidFrame = function(self)
	if UnitAffectingCombat("player") then
		if not self:IsEventRegistered("PLAYER_REGEN_ENABLED") then
			self:RegisterEvent("PLAYER_REGEN_ENABLED")
		end
		return
	else
		if self:IsEventRegistered("PLAYER_REGEN_ENABLED") then
			self:UnregisterEvent("PLAYER_REGEN_ENABLED")
		end
	end
	
	local frameWidth = 0
	local numRaidMembers = GetNumRaidMembers()
	local numPartyMembers = GetNumPartyMembers()
	
	if numRaidMembers > 0 then
		frameWidth = math.ceil(numRaidMembers / 5) * (45 + 5) - 5
	else
		frameWidth = math.ceil(numPartyMembers / 5) * (45 + 5) - 5
	end
	
	if frameWidth < 45 then
		frameWidth = 45
	end
	
	self:SetWidth(frameWidth)
end

raidFrame:SetScript("OnEvent", resizeRaidFrame)

local prev
for i = 1, 3 do
	local boss = oUF:Spawn("boss"..i)
	if prev then
		boss:SetPoint("TOP", prev, "BOTTOM", 0, -5)
	else
		boss:SetPoint("LEFT", UIParent, "LEFT", 10, 400)
	end
	
	prev = boss
end
prev = nil