local gxMedia = gxMedia or {
	auraFont = [=[Fonts\FRIZQT__.TTF]=],
	bgFile = [=[Interface\ChatFrame\ChatFrameBackground]=],
	buttonOverlay = [=[Interface\Buttons\UI-ActionButton-Border]=],
	edgeFile = [=[Interface\Tooltips\UI-Tooltip-Border]=],
	font = [=[Fonts\FRIZQT__.TTF]=],
	statusBar = [=[Interface\TargetingFrame\UI-StatusBar]=],
	symbolFont = [=[Fonts\FRIZQT__.TTF]=]
}

local emptyFunc = function() end

local dispellClass
local _, class = UnitClass("player")
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
	if (t[class]) then
		dispellClass = {}
		for k, v in pairs(t[class]) do
			dispellClass[k] = v
		end
		t = nil
	end
end

local dispellPriority = {
	["Magic"] = 4,
	["Poison"] = 3,
	["Disease"] = 1,
	["Curse"] = 2,
	["none"] = 0,
}

local debuffs = setmetatable({
	------------------------------
	--	The Bastion of Twilight	--
	------------------------------
	-- Twilight Ascendant Council
	[GetSpellInfo(92486)] = 10,	-- Gravity Crush
	[GetSpellInfo(83099)] = 10,	-- Lightning Rod
	
	-- Valiona & Theralion
	[GetSpellInfo(95639)] = 10,	-- Engulfing Magic
	[GetSpellInfo(92864)] = 7,	-- Twilight Meteorite
	
	--------------------------
	--	Blackwing Decent	--
	--------------------------
	-- Chimaeron
	[GetSpellInfo(89084)] = 10,	-- Low Health
	
	-- Maloriak
	[GetSpellInfo(92971)] = 10,	-- Consuming Flames
	
	-- Omnotron Defense System
	[GetSpellInfo(92036)] = 5,	-- Acquiring Target
	[GetSpellInfo(79889)] = 3,	-- Lightning Conductor
	
	----------------------
	--	Shadowfang Keep	--
	----------------------
	-- Lord Godfrey
	[GetSpellInfo(93761)] = 10,	-- Cursed Bullets
	
	------------------
	--	Deadmines	--
	------------------
	-- Oaf Lackey
	[GetSpellInfo(91016)] = 10,	-- Axe to the Head
	
	--------------------------
	--	Icecrown Citadel	--
	--------------------------
	-- The Lich King
	[GetSpellInfo(73799)] = 10,	-- Soul Reaper
	[GetSpellInfo(69242)] = 8,	-- Soul Shriek
	[GetSpellInfo(73781)] = 3,	-- Infest
	[GetSpellInfo(73912)] = 7,	-- Necrotic Plague
	[GetSpellInfo(72133)] = 5,	-- Pain and Suffering
	[GetSpellInfo(74325)] = 9,	-- Harvest Soul
	
	-- Sindragosa
	[GetSpellInfo(69762)] = 7,	-- Unchained Magic
	[GetSpellInfo(69766)] = 5,	-- Instability
	[GetSpellInfo(70126)] = 10,	-- Frost Beacon
	
	-- Valithria Dreamwalker
	[GetSpellInfo(70873)] = 10,	-- Emerald Vigor
	
	-- Blood-Queen Lana'thel
	[GetSpellInfo(72649)] = 7,	-- Frenzied Bloodthirst
	[GetSpellInfo(71473)] = 5,	-- Essence of the Blood Queen
	[GetSpellInfo(71265)] = 10,	-- Swarming Shadows
	[GetSpellInfo(71341)] = 10,	-- Pact of the Darkfallen
	
	-- Professor Putricide
	[GetSpellInfo(70447)] = 7,	-- Volatile Ooze Adhesive
	[GetSpellInfo(70672)] = 7,	-- Gaseous Bloat
	[GetSpellInfo(72854)] = 10,	-- Unbound Plague
	[GetSpellInfo(70953)] = 5,	-- Plague Sickness
	
	-- Rotface
	[GetSpellInfo(69674)] = 10,	-- Mutated Infection
	[GetSpellInfo(72272)] = 7,	-- Vile Gas
	
	-- Festergut
	[GetSpellInfo(69279)] = 10,	-- Gas Spore
	
	-- Precious & Stinky
	[GetSpellInfo(25646)] = 10, -- Mortal Wound
	
	-- Deathbringer Saurfang
	[GetSpellInfo(72293)] = 10,	-- Mark of the Fallen Champion
	[GetSpellInfo(72385)] = 7,	-- Boiling Blood
	
	-- Rotting Frost Giant
	[GetSpellInfo(72865)] = 10,	-- Death Plague
	[GetSpellInfo(72884)] = 7,	-- Recently Infected
	
	-- Lady Deathwhisper
	[GetSpellInfo(71001)] = 10,	-- Death and Decay
	
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
	[GetSpellInfo(64157)] = 10,	-- Curse of Doom
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
	
	
	------------------
	--	Naxxramas	--
	------------------
	-- Kel'thuzad
	[GetSpellInfo(27808)] = 8,	-- Frost Blast
	
	
	--------------------------
	--	Player vs. Player	--
	--------------------------
	-- Do not dispel
	[GetSpellInfo(34914)] = 9,	-- Vampiric Touch
	[GetSpellInfo(30108)] = 10,	-- Unstable Affliction
	
	-- Health reduction
	[GetSpellInfo(13219)] = 8,	-- Wound Poison
	[GetSpellInfo(12294)] = 8,	-- Mortal Strike
	[GetSpellInfo(19434)] = 8,	-- Aimed Shot
	
	-- Silence
	[GetSpellInfo(18469)] = 9,	-- Silenced - Improved Counterspell
	[GetSpellInfo(2139)] = 8,	-- Counterspell
	
	-- Disoriented
	[GetSpellInfo(2094)] = 7,	-- Blind
	[GetSpellInfo(33786)] = 7,	-- Cyclone
	[GetSpellInfo(19503)] = 7,	-- Scatter Shot
	
	-- Crowd control effects
	[GetSpellInfo(118)] = 8,	-- Polymorph
	
	-- Root effects
	[GetSpellInfo(339)] = 7,	-- Entangling Roots
	[GetSpellInfo(55041)] = 7,	-- Freezing Trap Effect
	[GetSpellInfo(45524)] = 7,	-- Chains of Ice
	
	-- Slow effects
	[GetSpellInfo(3409)] = 1,	-- Crippling Poison
	[GetSpellInfo(1715)] = 1,	-- Hamstring
	[GetSpellInfo(2974)] = 1,	-- Wing Clip
	
	-- Fear effects
	[GetSpellInfo(5782)] = 8,	-- Fear
	[GetSpellInfo(8122)] = 8,	-- Psychic Scream
	[GetSpellInfo(5484)] = 8,	-- Howl of Terror
}, { __index = function() return 0 end })


local f = CreateFrame("Frame")
f:SetScript("OnEvent", function(self, event, ...)
	return self[event](self, ...)
end)

f.UNIT_AURA = function(self, unit)
	local frame = oUF.units[unit]
	if (not frame or frame.unit ~= unit or not frame.DebuffIcon) then
		return
	end
	
	if (frame:GetAttribute('unitsuffix') == 'pet' or frame:GetAttribute('unitsuffix') == 'target') then
		return
	end
	local cur, tex, dis, timeLeft, Duration, stack
	local name, rank, buffTexture, count, duration, expire, dtype, isPlayer
	for i = 1, 40 do
		name, rank, buffTexture, count, dtype, duration, expire, isPlayer = UnitAura(unit, i, "HARMFUL")
		if (not name) then
			break
		end
		
		if (not cur or (debuffs[name] >= debuffs[cur])) then
			if (debuffs[name] > 0 and debuffs[name] > debuffs[cur or 1]) then
				cur = name
				tex = buffTexture
				dis = dtype or "none"
				timeLeft = expire
				Duration = duration
				stack = count > 1 and count or ""
			elseif (dtype and dtype ~= "none") then
				if (not dis or (dispellPriority[dtype] > dispellPriority[dis])) then
					tex = buffTexture
					dis = dtype
					timeLeft = expire
					Duration = duration
					stack = count > 1 and count or ""
				end
			end	
		end
	end
	
	if (dis) then
		if (dispellClass[dis] or cur) then
			local col = DebuffTypeColor[dis]
			frame.DebuffIcon.Overlay:SetVertexColor(col.r, col.g, col.b)
			frame.Dispell = true
			frame.DebuffIcon.Count:SetText(stack)
			frame.DebuffIcon.Texture:SetTexture(tex)
			frame.DebuffIcon:Show()
			frame.RaidInfo:Hide()
			
			if (Duration > 0) then
				frame.DebuffIcon.Cooldown:SetCooldown(timeLeft - Duration, Duration)
			end
		elseif (frame.Dispell) then
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

local menu = function(self)
	local unit = self.unit:sub(1, -2)
	local cunit = self.unit:gsub("^%l", string.upper)
	
	if (cunit == "Vehicle") then
		cunit = "Pet"
	end
	
	if (unit == "party" or unit == "partypet") then
		ToggleDropDownMenu(1, nil, _G["PartyMemberFrame"..self.id.."DropDown"], "cursor", 0, 0)
	elseif (_G[cunit.."FrameDropDown"]) then
		ToggleDropDownMenu(1, nil, _G[cunit.."FrameDropDown"], "cursor", 0, 0)
	end
end

local castOnUpdate = function(self, elapsed)
	if (self.casting) then
		local duration = self.Reverse and self.duration - elapsed or self.duration + elapsed
		local durText = self.Reverse and self.durText + elapsed
		
		if (self.Reverse and duration <= 0 or duration >= self.max) then
			self.casting = nil
			self:Hide()
			
			return
		end
		
		if (self.Time) then
			if (self.delay ~= 0) then
				self.Time:SetFormattedText("%.1f|cffff0000-%.1f|r", self.Reverse and durText or duration, self.delay)
			else
				self.Time:SetFormattedText("%.1f", self.Reverse and durText or duration)
			end
		end
		
		self.durText = durText
		self.duration = duration
		self:SetValue(duration)
	elseif (self.channeling) then
		local duration = self.Reverse and self.duration + elapsed or self.duration - elapsed
		local durText = self.Reverse and self.durText - elapsed
		
		if (self.Reverse and duration >= self.max or duration <= 0) then
			self.channeling = nil
			self:Hide()
			
			return
		end
		
		if (self.Time) then
			if (self.delay ~= 0) then
				self.Time:SetFormattedText("%.1f|cffff0000-%.1f|r", self.Reverse and durText or duration, self.delay)
			else
				self.Time:SetFormattedText("%.1f", self.Reverse and durText or duration)
			end
		end
		
		self.durText = durText
		self.duration = duration
		self:SetValue(duration)
	else
		self.unitName = nil
		self.channeling = nil
		if (self.Reverse) then
			self:SetValue(0)
		else
			self:SetValue(1)
		end
		self:Hide()
	end
end

local PostCastStart = function(castBar, unit, name, rank)
	if (castBar.Reverse) then
		local _, _, _, _, startTime, endTime = UnitCastingInfo(unit)
		
		startTime = startTime / 1e3
		endTime = endTime / 1e3
		
		castBar.durText = GetTime() - startTime
		castBar.duration = endTime - GetTime()
		castBar:SetValue(castBar.duration)
	end
end

local PostChannelStart = function(castBar, unit, name, rank)
	if (castBar.Reverse) then
		local _, _, _, _, startTime, endTime = UnitChannelInfo(unit)
		
		startTime = startTime / 1e3
		endTime = endTime / 1e3
		
		castBar.durText = endTime - GetTime()
		castBar.duration = GetTime() - startTime
		castBar:SetValue(0)
	end
end

local PostCastDelayed = function(castBar, unit, name, rank)
	if (castBar.Reverse) then
		local _, _, _, _, startTime, endTime = UnitCastingInfo(unit)
		
		local duration = endTime / 1e3 - GetTime()
		
		if (duration < 0) then
			duration = 0
		end
		
		castBar.delay = castBar.delay + castBar.duration + duration
		
		castBar.duration = duration
		
		castBar:SetValue(duration)
	end
end

local healthUpdate = function(self, event, unit)
	if (self.unit ~= unit) then
		return
	end
	local health = self.Health
	local min, max = UnitHealth(unit), UnitHealthMax(unit)
	local disconnected = not UnitIsConnected(unit)
	
	health:SetMinMaxValues(0, max)
	
	health.disconnected = disconnected
	health.unit = unit
	
	local r, g, b
	if (self.ThreatColor) then
		local threat = UnitThreatSituation(unit)
		if (threat == 2 or threat == 3) then
			r, g, b = 153/255, 85/255, 85/255
		end
	end
	
	if (not b) then
		r, g, b = self.ColorGradient(min / max, .7, .15, .15, .85, .8, .45, .25, .25, .25)
	end
	
	if (b) then
		if (health.Reverse) then
			health:SetValue(max - min)
			health.bg:SetVertexColor(r, g, b)
		else
			health:SetValue(min)
			health:SetStatusBarColor(r, g, b)
		end
	end
end

local powerUpdate = function(self, event, unit)
	if (self.unit ~= unit) then
		return
	end
	local power = self.Power
	local min, max = UnitPower(unit), UnitPowerMax(unit)
	local disconnected = not UnitIsConnected(unit)
	
	power:SetMinMaxValues(0, max)
	
	power.disconnected = disconnected
	power.unit = unit
	
	local r, g, b, t
	if (power.colorTapping and UnitIsTapped(unit) and not UnitIsTappedByPlayer(unit)) then
		t = self.colors.tapped
	elseif (power.colorDisconnected and not UnitIsConnected(unit)) then
		t = self.colors.disconnected
	elseif (power.colorClass and UnitIsPlayer(unit)) then
		local _, class = UnitClass(unit)
		t = self.colors.class[class]
	elseif (power.colorReaction and UnitReaction(unit, "player")) then
		t = self.colors.reaction[UnitReaction(unit, "player")]
	end
	
	if (t) then
		r, g, b = t[1], t[2], t[3]
	end
	
	if (b) then
		if (power.Reverse) then
			power:SetValue(max - min)
			power.bg:SetVertexColor(r, g, b)
		else
			power:SetValue(min)
			power:SetStatusBarColor(r, g, b)
		end
	end
end

local auraPostUpdateIcon = function(icons, unit, icon, index, offset)
	if (unit == "player" or unit == "pet" or unit == "vehicle") then
		return
	end
	
	local _, _, _, _, _, _, _, unitCaster = UnitAura(unit, index, icon.filter)
	
	if (unitCaster ~= "player" and unitCaster ~= "pet" and unitCaster ~= "vehicle") then
		if (not UnitIsFriend("player", unit)) then
			if (icon.debuff) then
				icon.icon:SetDesaturated(true)
				icon.overlay:SetVertexColor(.6, .6, .6)
				
				return
			end
		else
			if (not icon.debuff) then
				icon.overlay:SetVertexColor(.6, .6, .6)
			end
		end
	else
		if (UnitIsFriend("player", unit)) then
			if (not icon.debuff) then
				icon.overlay:SetVertexColor(.3, .6, .3)
			end
		end
	end
	
	icon.icon:SetDesaturated(false)
end

local auraPostUpdate = function(icons, unit)
	local buffs, debuffs = icons:GetParent().Buffs, icons:GetParent().Debuffs
	
	if (buffs) then
		local visibleBuffs = buffs.visibleBuffs
		local size = buffs.size
		local width = buffs:GetWidth()
		
		local cols = math.floor(width / size + .5)
		local height = math.floor(visibleBuffs / cols + .1)
		
		buffs:SetHeight(size*(height + 1))

		local point, relativeTo, relativePoint, xOfs = debuffs:GetPoint()
		
		debuffs:ClearAllPoints()
		if (visibleBuffs > 0) then
			debuffs:SetPoint(point, relativeTo, relativePoint, xOfs, (size + 2)*(height + 1) + 3)
		else
			debuffs:SetPoint(point, relativeTo, relativePoint, xOfs, 3)
		end
	end
end

local auraPostCreateIcon = function(icons, button, enchantArg)
	if (icons.Enchant == enchantArg and enchantArg) then
		icons = enchantArg -- ugly fix
	end
	local backdrop = CreateFrame("Frame", nil, button)
	backdrop:SetPoint("TOPLEFT", button, -3.5, 3)
	backdrop:SetPoint("BOTTOMRIGHT", button, 4, -3.5)
	backdrop:SetFrameStrata("BACKGROUND")
	backdrop:SetBackdrop({
		edgeFile = gxMedia.edgeFile,
		edgeSize = 5,
		insets = {
			left = 3,
			right = 3,
			top = 3,
			bottom = 3
		}
	})
	backdrop:SetBackdropColor(0, 0, 0, 0)
	backdrop:SetBackdropBorderColor(0, 0, 0)
	
	button.Backdrop = backdrop
	
	button.cd:ClearAllPoints()
	button.cd:SetPoint("TOPLEFT", 2, -2)
	button.cd:SetPoint("BOTTOMRIGHT", -2, 2)
	button.cd:SetReverse(true)
	
	button.count:SetParent(button.cd)
	button.count:SetPoint("BOTTOMRIGHT", 2, -1)
	button.count:SetJustifyH("RIGHT")
	button.count:SetFont(gxMedia.font, 10, "OUTLINE")
	button.count:SetTextColor(0.84, 0.75, 0.65)
	
	icons.showDebuffType = true
	
	button.overlay:SetTexture(gxMedia.buttonOverlay)
	button.overlay:SetPoint("TOPLEFT", button, -1, 1)
	button.overlay:SetPoint("BOTTOMRIGHT", button, 1, -1)
	button.overlay:SetVertexColor(.6,.6,.6)
	button.overlay:SetTexCoord(0, 0.98, 0, 0.98)
	button.overlay.Hide = emptyFunc
	
	if (icons == icons:GetParent().Enchant) then
		button.overlay:SetVertexColor(0.33, 0.59, 0.33)
	end
end

local UNIT_THREAT_SITUATION_UPDATE = function(self)
	local health = self.Health
	local threat = UnitThreatSituation(self.unit)
	if (threat == 2 or threat == 3) then
		if (health.Reverse) then
			health.bg:SetVertexColor(153/255, 85/255, 85/255)
		else
			health:SetStatusBarColor(153/255, 85/255, 85/255)
		end
	else
		healthUpdate(self, nil, self.unit)
	end
end

local time, sumElapsed, dps, hps, damagetotal, healingtotal, pName = 0, 0, 0, 0, 0, 0, UnitName("player")
local damage = {
	SWING_DAMAGE = true,
	RANGE_DAMAGE = true,
	SPELL_DAMAGE = true,
	SPELL_PERIODIC_DAMAGE = true,
	DAMAGE_SHIELD = true,
	DAMAGE_SPLIT = true
}
local heal = {
	SWING_HEAL = true,
	RANGE_HEAL = true,
	SPELL_HEAL = true,
	SPELL_PERIODIC_HEAL = true,
}

local amount, over
local COMBAT_LOG_EVENT_UNFILTERED = function(self, _, _, eventType, _, name, _, _, _, _, ...)
	if (not damage[eventType] and not heal[eventType] or name ~= pName) then
		return
	end
	
	if (eventType == "SWING_DAMAGE") then
		amount = ...
	else
		_, _, _, amount, over = ...
	end
	
	if (damage[eventType]) then
		damagetotal = (damagetotal or 0) + amount
	elseif (heal[eventType]) then
		healingtotal = (healingtotal or 0) + (amount - over)
	end
	
	if (UnitAffectingCombat("player") and not self.Panel.DPS.start and (damagetotal ~= 0 or healingtotal ~= 0)) then
		self.Panel.DPS.start = true
	end
end

local PLAYER_REGEN_ENABLED = function(self)
	self.Panel.DPS:SetText()
	
	damagetotal = 0
	healingtotal = 0
	time = 0
	self.Panel.DPS.start = nil
end

local calculateDPSandHPS = function(self, elapsed)
	if (self.Panel.DPS.start) then
		time = (time or 0) + elapsed
		
		sumElapsed = sumElapsed + elapsed
		if (sumElapsed > 1) then
			dps = (damagetotal or 0) / (time or 1)
			hps = (healingtotal or 0) / (time or 1)
			
			if (dps > (hps * .5)) then
				self.Panel.DPS:SetText(string.format("%.1f DPS", dps))
				self.Panel.DPS:SetTextColor(153/255, 85/255, 85/255)
			elseif ((hps * .5) > dps) then
				self.Panel.DPS:SetText(string.format("%.1f HPS", hps))
				self.Panel.DPS:SetTextColor(80/255, 150/255, 80/255)
			end
			
			sumElapsed = 0
		end
	end
end

local shared = function(self, unit, isSingle)
	unit = unit:find("boss%d") and "boss" or unit:find("arena%d") and "arena" or unit
	
	self.menu = menu
	
	self:SetScript("OnEnter", UnitFrame_OnEnter)
	self:SetScript("OnLeave", UnitFrame_OnLeave)
	
	local backdrop = CreateFrame("Frame", nil, self)
	backdrop:SetPoint("TOPLEFT", self, -5, 5)
	backdrop:SetPoint("BOTTOMRIGHT", self, 5, -5)
	backdrop:SetFrameStrata("BACKGROUND")
	backdrop:SetBackdrop({
		bgFile = gxMedia.bgFile,
		edgeFile = gxMedia.edgeFile,
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
	
	self:RegisterForClicks("AnyDown")
	
	if (unit ~= "raid") then
		local panel = CreateFrame("Frame", nil, self)
		panel:SetFrameStrata("LOW")
		panel:SetPoint("BOTTOMLEFT", self)
		panel:SetPoint("BOTTOMRIGHT", self)
		panel:SetBackdrop({
			bgFile = gxMedia.bgFile,
			edgeFile = gxMedia.bgFile, 
			edgeSize = 1,
		})
		panel:SetBackdropColor(0.1, 0.1, 0.1, 1)
		panel:SetBackdropBorderColor(0.4, 0.4, 0.4, 1)
		
		self.Panel = panel
		
		if (unit == "target" or unit == "targettarget" or unit == "pet" or unit == "boss" or unit == "focus") then
			local info = self.Panel:CreateFontString(nil, "OVERLAY")
			info:SetFont(gxMedia.font, 12)
			info:SetShadowColor(0, 0, 0)
			info:SetShadowOffset(1.25, -1.25)
			info:SetTextColor(0.84, 0.75, 0.65)
			
			self.Panel.Info = info
		end
		
		if (unit == "player" or unit == "target" or unit == "boss" or unit == "focus" or unit == "arena") then
			local cb = CreateFrame("StatusBar", nil, self)
			cb:SetStatusBarTexture(gxMedia.statusBar)
			cb:SetPoint("TOPLEFT", self.Panel, 1, -1)
			cb:SetPoint("BOTTOMRIGHT", self.Panel, -1, 1)
			cb:SetFrameStrata("HIGH")
			
			local bg = cb:CreateTexture(nil, "BACKGROUND")
			bg:SetAllPoints(cb)
			bg:SetTexture(gxMedia.statusBar)
			
			local time = cb:CreateFontString(nil, "OVERLAY")
			time:SetFont(gxMedia.font, 12)
			time:SetShadowColor(0, 0, 0)
			time:SetShadowOffset(1.25, -1.25)
			time:SetTextColor(0.84, 0.75, 0.65)
			time:SetJustifyH("RIGHT")
			
			if (unit == "target" or unit == "focus" or unit == "boss") then
				cb.Reverse = true
				cb:SetStatusBarColor(.1, .1, .1)
				cb:SetStatusBarTexture(gxMedia.bgFile)
				bg:SetVertexColor(.2, 1, 1)
				time:SetPoint("LEFT", 3, .5)
			else
				cb:SetStatusBarColor(.2, 1, 1)
				bg:SetVertexColor(.1, .1, .1)
				bg:SetTexture(gxMedia.bgFile)
				time:SetPoint("RIGHT", -3, .5)
			end
			
			local text = cb:CreateFontString(nil, "OVERLAY")
			text:SetFont(gxMedia.font, 12)
			text:SetShadowColor(0, 0, 0)
			text:SetShadowOffset(1.25, -1.25)
			text:SetPoint("CENTER", 0, .5)
			text:SetTextColor(0.84, 0.75, 0.65)
			
			local icon = cb:CreateTexture(nil, "ARTWORK")
			icon:SetHeight(28.5)
			icon:SetWidth(28.5)
			icon:SetTexCoord(0, 1, 0, 1)
			
			local overlay = cb:CreateTexture(nil, "OVERLAY")
			overlay:SetPoint("TOPLEFT", icon, -1.5, 1)
			overlay:SetPoint("BOTTOMRIGHT", icon, 1, -1)
			overlay:SetTexture(gxMedia.buttonOverlay)
			overlay:SetVertexColor(.6, .6, .6)
			
			local backdrop = CreateFrame("Frame", nil, self)
			backdrop:SetPoint("TOPLEFT", icon, -4, 3)
			backdrop:SetPoint("BOTTOMRIGHT", icon, 3, -3.5)
			backdrop:SetParent(cb)
			backdrop:SetBackdrop({
				edgeFile = gxMedia.edgeFile,
				edgeSize = 4,
				insets = {
					left = 3,
					right = 3,
					top = 3,
					bottom = 3
				}
			})
			backdrop:SetBackdropColor(0, 0, 0, 0)
			backdrop:SetBackdropBorderColor(0, 0, 0, 0.7)
			
			icon.Backdrop = backdrop
			icon.Overlay = overlay
			cb.Icon = icon
			
			cb.Text = text
			cb.Time = time
			cb.bg = bg
			
			cb.PostChannelStart = PostChannelStart
			cb.PostCastStart = PostCastStart
			cb.PostCastDelayed = PostCastDelayed
			cb.OnUpdate = castOnUpdate
			
			self.Castbar = cb
		end
		
		if (unit == "pet" and not self.Castbar) then
			PetCastingBarFrame:UnregisterAllEvents()
			PetCastingBarFrame.Show = emptyFunc
			PetCastingBarFrame:Hide()
		end
	end
	
	local hp = CreateFrame("StatusBar", nil, self)
	hp:SetStatusBarTexture(gxMedia.statusBar)
	hp.Smooth = true
	hp:SetFrameStrata("LOW")
	hp:SetPoint("TOPLEFT")
	hp:SetPoint("TOPRIGHT")
	hp.frequentUpdates = true
	
	local bg = hp:CreateTexture(nil, "BACKGROUND")
	bg:SetAllPoints(hp)
	bg:SetTexture(gxMedia.statusBar)
	
	if (unit == "target" or unit == "targettarget" or unit == "focus" or unit == "boss") then
		hp.Reverse = true
		hp:SetStatusBarColor(.1,.1,.1)
	else
		bg:SetVertexColor(.1,.1,.1)
	end
	
	if (unit == "player" or unit == "target" or unit == "boss") then
		local text = hp:CreateFontString(nil, "OVERLAY")
		text:SetFont(gxMedia.font, 12)
		text:SetShadowColor(0, 0, 0)
		text:SetShadowOffset(1.25, -1.25)
		self:Tag(text, "[healthText]")
		
		hp.Text = text
	end
	
	hp.bg = bg
	hp.Override = healthUpdate
	
	self.Health = hp
	
	if (unit == "player" or unit == "target" or unit == "boss" or unit == "focus") then
		local pp = CreateFrame("StatusBar", nil, self)
		pp.Smooth = true
		pp:SetStatusBarTexture(gxMedia.statusBar)
		pp:SetFrameStrata("LOW")
		
		pp.frequentUpdates = true
		pp.colorTapping = true
		pp.colorDisconnected = true
		pp.colorClass = true
		pp.colorReaction = true
		
		pp:SetParent(self)
		pp:SetPoint("LEFT")
		pp:SetPoint("RIGHT")
		pp:SetPoint("TOP", self.Health, "BOTTOM", 0, 0)
		
		local bg = pp:CreateTexture(nil, "BACKGROUND")
		bg:SetAllPoints(pp)
		bg:SetTexture(gxMedia.statusBar)
		
		if (unit ~= "target" and unit ~= "boss") then
			bg:SetVertexColor(.1,.1,.1)
		end
		
		if (unit == "player" or unit == "target" or unit == "boss") then
			local text = pp:CreateFontString(nil, "OVERLAY")
			text:SetFont(gxMedia.font, 12)
			text:SetShadowColor(0, 0, 0)
			text:SetShadowOffset(1.25, -1.25)
			self:Tag(text, "[powerText]")
			
			pp.Text = text
		end
		
		pp.bg = bg
		pp.Override = powerUpdate
		
		self.Power = pp
	end
	
	if (unit == "player" or unit == "target") then
		local buffs = CreateFrame("Frame", nil, self)
		buffs:SetHeight(27)
		buffs:SetWidth(230)
		buffs.size = 27
		buffs.spacing = 2
		buffs["growth-y"] = "UP"
		buffs.PostCreateIcon = auraPostCreateIcon
		buffs.PostUpdate = auraPostUpdate
		buffs.PostUpdateIcon = auraPostUpdateIcon
		
		self.Buffs = buffs
	end
	
	if (unit == "player" or unit == "target" or unit == "pet" or unit == "targettarget") then
		local debuffs = CreateFrame("Frame", nil, self)
		debuffs:SetHeight(27)
		debuffs:SetWidth(230)
		debuffs.size = 27
		debuffs.spacing = 2
		debuffs["growth-y"] = "UP"
		debuffs.PostCreateIcon = auraPostCreateIcon
		debuffs.PostUpdate = auraPostUpdate
		debuffs.PostUpdateIcon = auraPostUpdateIcon
		
		self.Debuffs = debuffs
	end
	
	if (unit == "player" or unit == "target" or unit == "raid" or unit == "raidpet" or unit == "party") then
		local leader = self:CreateTexture(nil, "OVERLAY")
		self.Leader = leader
		
		local masterlooter = self:CreateTexture(nil, "OVERLAY")
		self.MasterLooter = masterlooter
	end
	
	local raidIcon = self:CreateTexture(nil, "OVERLAY")
	self.RaidIcon = raidIcon
	
	if (unit ~= "player" and unit ~= "boss") then
		if (IsAddOnLoaded("oUF_SpellRange")) then
			self.SpellRange = {
				insideAlpha = 1,
				outsideAlpha = .25
			}
		else
			if (unit == "party" or unit == "raid") then
				self.Range = {
					insideAlpha = 1,
					outsideAlpha = .25
				}
			end
		end
	end
	
	if (unit == "player" or unit == "raid") then
		self:RegisterEvent("UNIT_THREAT_SITUATION_UPDATE", UNIT_THREAT_SITUATION_UPDATE)
		self.ThreatColor = true
	end
end

local unitSpecific = {
	player = function(self, unit, ...)
		self:SetSize(230, 55)
		
		shared(self, unit, ...)
		
		local health = self.Health
		health:SetHeight(27)
		health.Text:SetPoint("BOTTOMRIGHT", self, -5, 5)
		health.Text:SetJustifyH("RIGHT")
		
		local power = self.Power
		power:SetHeight(8)
		power.Text:SetPoint("BOTTOMLEFT", self, 5, 5)
		power.Text:SetJustifyH("LEFT")
		
		local buffs = self.Buffs
		buffs.num = 24
		buffs:SetPoint("BOTTOMLEFT", self, "TOPLEFT", 0, 3)
		buffs.initialAnchor = "BOTTOMLEFT"
		buffs["growth-x"] = "RIGHT"
		
		local debuffs = self.Debuffs
		debuffs.num = 8
		debuffs:SetPoint("BOTTOMRIGHT", self, "TOPRIGHT", 0, 3)
		debuffs.initialAnchor = "BOTTOMRIGHT"
		debuffs["growth-x"] = "LEFT"
		
		self.Panel:SetHeight(20)
		
		local castBar = self.Castbar
		castBar.Icon:SetPoint("TOPRIGHT", self, "LEFT", -10, 10)
		
		local dps = self.Panel:CreateFontString(nil, "OVERLAY")
		dps:SetFont(gxMedia.font, 12)
		dps:SetShadowColor(0, 0, 0)
		dps:SetShadowOffset(1.25, -1.25)
		dps:SetPoint("BOTTOM", self, 0, 5)
		dps:SetTextColor(0.84, 0.75, 0.65)
		
		self:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED", COMBAT_LOG_EVENT_UNFILTERED)
		self:RegisterEvent("PLAYER_REGEN_ENABLED", PLAYER_REGEN_ENABLED)
		self:SetScript("OnUpdate", calculateDPSandHPS)
		
		self.Panel.DPS = dps
		PLAYER_REGEN_ENABLED(self)
		
		local combat = self:CreateTexture(nil, "OVERLAY")
		combat:SetVertexColor(.7, .15, .15)
		combat:SetHeight(32)
		combat:SetWidth(32)
		combat:SetPoint("CENTER", self, 0, 15)
		
		self.Combat = combat
		
		local leader = self.Leader
		leader:SetHeight(16)
		leader:SetWidth(16)
		leader:SetPoint("CENTER", self, "TOPLEFT")
		
		local masterLooter = self.MasterLooter
		masterLooter:SetHeight(16)
		masterLooter:SetWidth(16)
		masterLooter:SetPoint("CENTER", self, "TOPLEFT", 16, 0)
		
		local raidIcon = self.RaidIcon
		raidIcon:SetSize(24, 24)
		raidIcon:SetPoint("RIGHT", health, "RIGHT", -1, 1)
		
		if (IsAddOnLoaded("oUF_WeaponEnchant")) then
			local enchant = CreateFrame("Frame", nil, self)
			enchant:SetHeight(27)
			enchant:SetWidth(27 * 2)
			enchant:SetPoint("TOP", self, "BOTTOM", 0, -3)
			enchant.size = 27
			enchant.spacing = 2
			enchant.initialAnchor = "BOTTOMLEFT"
			enchant["growth-x"] = "RIGHT"
			
			self.Enchant = enchant
			
			self.PostCreateEnchantIcon = auraPostCreateIcon
		end
		
		if (IsAddOnLoaded("oUF_Experience")) then
			local xp = CreateFrame("StatusBar", nil, self)
			xp:SetStatusBarTexture(gxMedia.statusBar)
			xp:SetPoint("TOPLEFT", self.Panel, 1, -1)
			xp:SetPoint("BOTTOMRIGHT", self.Panel, -1, 1)
			xp:SetHeight(18)
			xp:SetFrameStrata("HIGH")
			xp:SetAlpha(0)
			xp:EnableMouse(true)
			xp.Tooltip = true
			
			local bg = xp:CreateTexture(nil, "BACKGROUND")
			bg:SetAllPoints(xp)
			bg:SetTexture(gxMedia.statusBar)
			
			xp:SetStatusBarColor(.8, .2, .8)
			bg:SetVertexColor(.1, .1, .1)
			bg:SetTexture(gxMedia.bgFile)
			
			xp:SetScript("OnEnter", function(self)
				self:SetAlpha(.5)
			end)
			xp:SetScript("OnLeave", function(self)
				self:SetAlpha(0)
			end)
			
			xp.bg = bg
			self.Experience = xp
		end
	end,
	pet = function(self, unit, ...)
		self:SetSize(115, 35)
		
		shared(self, unit, ...)
		
		local health = self.Health
		health:SetHeight(18)
		
		self.Panel:SetHeight(17)
		
		self.Panel.Info:SetPoint("BOTTOM", self, 0, 3.5)
		self:Tag(self.Panel.Info, "[nameColor][longName] [diffColor][level] [shortclassification]")
		
		local debuffs = self.Debuffs
		debuffs.num = 4
		debuffs:SetPoint("BOTTOMLEFT", self, "TOPLEFT", 0, 3)
		debuffs.initialAnchor = "BOTTOMLEFT"
		debuffs["growth-x"] = "RIGHT"
		
		local raidIcon = self.RaidIcon
		raidIcon:SetSize(16, 16)
		raidIcon:SetPoint("CENTER", health, "CENTER", 0, 1)
	end,
	target = function(self, unit, ...)
		self:SetSize(230, 55)
		
		shared(self, unit, ...)
		
		local health = self.Health
		health:SetHeight(27)
		health.Text:SetPoint("BOTTOMLEFT", self, 5, 5)
		health.Text:SetJustifyH("LEFT")
		
		local power = self.Power
		power:SetHeight(8)
		power.Reverse = true
		power:SetStatusBarColor(.1,.1,.1)
		power.Text:SetPoint("BOTTOMRIGHT", self, -5, 5)
		power.Text:SetJustifyH("RIGHT")
		
		local buffs = self.Buffs
		buffs.num = 8
		buffs:SetPoint("BOTTOMRIGHT", self, "TOPRIGHT", 0, 3)
		buffs.initialAnchor = "BOTTOMRIGHT"
		buffs["growth-x"] = "LEFT"
		
		local debuffs = self.Debuffs
		debuffs.num = 24
		debuffs:SetPoint("BOTTOMLEFT", self, "TOPLEFT", 0, 3)
		debuffs.initialAnchor = "BOTTOMLEFT"
		debuffs["growth-x"] = "RIGHT"
		
		local panel = self.Panel
		panel:SetHeight(20)
		panel.Info:SetPoint("BOTTOM", self, 0, 5)
		self:Tag(panel.Info, "[nameColor][longName] [diffColor][level] [shortclassification]")
		
		local castBar = self.Castbar
		castBar.Icon:SetPoint("TOPLEFT", self, "RIGHT", 10, 10)
		
		local leader = self.Leader
		leader:SetSize(16, 16)
		leader:SetPoint("CENTER", self, "TOPRIGHT")
		
		local masterLooter = self.MasterLooter
		masterLooter:SetSize(16, 16)
		masterLooter:SetPoint("CENTER", self, "TOPRIGHT", -16, 0)
		
		local raidIcon = self.RaidIcon
		raidIcon:SetSize(24, 24)
		raidIcon:SetPoint("LEFT", health, "LEFT", 1, 1)
	end,
	targettarget = function(self, unit, ...)
		self:SetSize(115, 35)
		
		shared(self, unit, ...)
		
		self.Panel:SetHeight(17)
		
		self.Panel.Info:SetPoint("BOTTOM", self, 0, 3.5)
		self:Tag(self.Panel.Info, "[nameColor][mediumName]")
		
		local health = self.Health
		health:SetHeight(18)
		
		local debuffs = self.Debuffs
		debuffs.num = 4
		debuffs:SetPoint("BOTTOMRIGHT", self, "TOPRIGHT", 0, 3)
		debuffs.initialAnchor = "BOTTOMRIGHT"
		debuffs["growth-x"] = "LEFT"
		
		local raidIcon = self.RaidIcon
		raidIcon:SetSize(16, 16)
		raidIcon:SetPoint("CENTER", health, "CENTER", 0, 1)
	end,
	focus = function(self, unit, ...)
		self:SetSize(115, 35)
		
		shared(self, unit, ...)
		
		self.Panel:SetHeight(17)
		
		self.Panel.Info:SetPoint("BOTTOM", self, 0, 3.5)
		self:Tag(self.Panel.Info, "[nameColor][mediumName]")
		
		local castBar = self.Castbar
		castBar.Icon:SetPoint("TOPLEFT", self, "RIGHT", 10, 10)
		
		local health = self.Health
		health:SetHeight(16)
		
		local power = self.Power
		power:SetHeight(2)
		power:SetStatusBarColor(.1,.1,.1)
		power.Reverse = true
		
		local raidIcon = self.RaidIcon
		raidIcon:SetSize(16, 16)
		raidIcon:SetPoint("CENTER", health, "CENTER", 0, 1)
	end,
	boss = function(self, unit, ...)
		self:SetSize(200, 40)
		
		shared(self, unit, ...)
		
		self.Panel:SetHeight(15)
		
		self.Panel.Info:SetPoint("BOTTOM", self, 0, 1)
		self:Tag(self.Panel.Info, "[nameColor][mediumName]")
		
		local castBar = self.Castbar
		castBar.Icon:SetPoint("TOPLEFT", self, "RIGHT", 10, 10)
		
		local health = self.Health
		health:SetHeight(22)
		health.Text:SetPoint("BOTTOMRIGHT", self, -5, 1)
		health.Text:SetJustifyH("RIGHT")
		
		local power = self.Power
		power:SetHeight(5)
		power.Text:SetPoint("BOTTOMLEFT", self, 5, 1)
		power.Text:SetJustifyH("LEFT")
		
		local raidIcon = self.RaidIcon
		raidIcon:SetSize(24, 24)
		raidIcon:SetPoint("CENTER", health, "CENTER")
	end,
	raid = function(self, unit, ...)
		self:SetSize(48, 32)
		
		shared(self, unit, ...)
		
		local health = self.Health
		health:ClearAllPoints()
		health:SetAllPoints(self)
		health.Smooth = nil
		health:SetOrientation("VERTICAL")
		
		local healthTex = health:GetStatusBarTexture()
		local heal = CreateFrame('StatusBar', nil, health)
		heal:SetHeight(32)
		heal:SetWidth(48)
		heal:SetOrientation("VERTICAL")
		heal:SetStatusBarTexture(gxMedia.statusBar)
		heal:SetStatusBarColor(0, 1, 0, 0.4)
		heal:SetPoint("BOTTOM", healthTex, "TOP")
		
		self.HealPrediction = {
			otherBar = heal,
			maxOverflow = 1,
		}
		
		if (IsAddOnLoaded("oUF_ResComm")) then
			local rescomm = CreateFrame("StatusBar", nil, self)
			rescomm:SetStatusBarTexture([=[Interface\Icons\Spell_Holy_Resurrection]=])
			rescomm:SetAllPoints(self)
			rescomm:SetAlpha(.25)
			
			local texObject = rescomm:GetStatusBarTexture()
			texObject:SetTexCoord(0.07, 0.93, 0.07, 0.93)
			
			--rescomm.OthersOnly = true
			self.ResComm = rescomm
		end
		
		local icon = CreateFrame("Frame", nil, self)
		icon:SetPoint("CENTER")
		icon:SetHeight(22)
		icon:SetWidth(22)
		icon:Hide()
		
		local iconTex = icon:CreateTexture(nil, "ARTWORK")
		iconTex:SetAllPoints(icon)
		iconTex:SetTexCoord(0.07, 0.93, 0.07, 0.93)
		
		local overlay = icon:CreateTexture(nil, "OVERLAY")
		overlay:SetTexture(gxMedia.buttonOverlay)
		overlay:SetPoint("TOPLEFT", icon, -1, 1)
		overlay:SetPoint("BOTTOMRIGHT", icon, 1, -1)
		
		local cooldown = CreateFrame("Cooldown", nil, icon)
		cooldown:SetPoint("TOPLEFT", icon, 2, -2)
		cooldown:SetPoint("BOTTOMRIGHT", icon, -1, 1)
		
		local count = cooldown:CreateFontString(nil, "OVERLAY")
		count:SetPoint("BOTTOMRIGHT", 0, 0)
		count:SetJustifyH("RIGHT")
		count:SetFont(gxMedia.font, 10, "OUTLINE")
		count:SetTextColor(0.84, 0.75, 0.65)
		
		local backdrop = CreateFrame("Frame", nil, icon)
		backdrop:SetPoint("TOPLEFT", icon, "TOPLEFT", -3.5, 3)
		backdrop:SetPoint("BOTTOMRIGHT", icon, "BOTTOMRIGHT", 4, -3.5)
		backdrop:SetFrameStrata("LOW")
		backdrop:SetBackdrop({
			edgeFile = gxMedia.edgeFile, edgeSize = 5,
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
		
		local raidInfo = self:CreateFontString(nil, "OVERLAY")
		raidInfo:SetFont(gxMedia.font, 14)
		raidInfo:SetShadowColor(0, 0, 0)
		raidInfo:SetShadowOffset(1.25, -1.25)
		raidInfo:SetPoint("CENTER", self)
		raidInfo:SetTextColor(0.84, 0.75, 0.65)
		self:Tag(raidInfo, "[nameColor][raidHP]")
		
		self.RaidInfo = raidInfo
		
		local leader = self.Leader
		leader:SetSize(8, 8)
		leader:SetPoint("CENTER", self, "TOPLEFT")
		
		local masterLooter = self.MasterLooter
		masterLooter:SetSize(8, 8)
		masterLooter:SetPoint("CENTER", self, "TOPLEFT", 8, 0)
		
		local raidIcon = self.RaidIcon
		raidIcon:SetSize(16, 16)
		raidIcon:SetPoint("CENTER", health, "TOP")
		
		if (oUF.Indicators) then
			local auraStatus
			
			auraStatus = self:CreateFontString(nil, "ARTWORK")
			auraStatus:SetPoint("TOPLEFT", -2, 1)
			auraStatus:SetFont(gxMedia.auraFont, 6, "THINOUTLINE")
			self:Tag(auraStatus, oUF.Indicators["TL"])
			
			self.AuraStatusTopLeft = auraStatus
			
			auraStatus = self:CreateFontString(nil, "ARTWORK")
			auraStatus:SetPoint("TOPRIGHT", 3, 1)
			auraStatus:SetFont(gxMedia.auraFont, 6, "THINOUTLINE")
			self:Tag(auraStatus, oUF.Indicators["TR"])
			
			self.AuraStatusTopRight = auraStatus
			
			auraStatus = self:CreateFontString(nil, "ARTWORK")
			auraStatus:ClearAllPoints()
			auraStatus:SetPoint("BOTTOMLEFT", -2, 1)
			auraStatus:SetFont(gxMedia.auraFont, 6, "THINOUTLINE")
			self:Tag(auraStatus, oUF.Indicators["BL"])
			
			self.AuraStatusBottomLeft = auraStatus
			
			auraStatus = self:CreateFontString(nil, "ARTWORK")
			auraStatus:SetPoint("CENTER", self, "BOTTOMRIGHT", 1, 1)
			auraStatus:SetFont(gxMedia.symbolFont, 11, "THINOUTLINE")
			self:Tag(auraStatus, oUF.Indicators["BR"])
			
			self.AuraStatusBottomRight = auraStatus
		end
		
		local role = self:CreateTexture(nil, "OVERLAY")
		role:SetSize(8, 8)
		role:SetPoint("CENTER", self, "TOPRIGHT")
		
		self.LFDRole = role
	end,
}

oUF:RegisterStyle("Gdx", shared)

for unit, layoutFunc in next, unitSpecific do
	oUF:RegisterStyle('Gdx - ' .. unit:gsub("^%l", string.upper), layoutFunc)
end

local spawnHelper = function(self, unit, ...)
	if (unitSpecific[unit]) then
		self:SetActiveStyle("Gdx - " .. unit:gsub("^%l", string.upper))
		local object = self:Spawn(unit)
		object:SetPoint(...)
		return object
	else
		self:SetActiveStyle("Gdx")
		local object = self:Spawn(unit)
		object:SetPoint(...)
		return object
	end
end

oUF:Factory(function(self)
	local player = spawnHelper(self, "player", "BOTTOM", UIParent, -235, 35)
	local target = spawnHelper(self, "target", "BOTTOM", UIParent, 235, 35)
	spawnHelper(self, "pet", "BOTTOMRIGHT", player, "TOPLEFT", -15, 15)
	spawnHelper(self, "targettarget", "BOTTOMLEFT", target, "TOPRIGHT", 15, 15)
	spawnHelper(self, "focus", "LEFT", target, "RIGHT", 50, 0)
	
	self:SetActiveStyle("Gdx - Raid")
	local group = self:SpawnHeader(nil, nil, "raid,party",
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
		"groupBy", "GROUP",
		'oUF-initialConfigFunction', [[
			self:SetWidth(48)
			self:SetHeight(32)
		]]
	)
	group:SetPoint("CENTER", UIParent, "CENTER", 0, -275)
	group:EnableMouse(nil)
	
	local groupPets = self:SpawnHeader(nil, "SecureGroupPetHeaderTemplate", "raid,party",
		"showPlayer", true,
		"showRaid", true,
		"ShowParty", true,
		"yOffset", 5,
		"xOffset", 5,
		"point", "BOTTOM",
		"maxColumns", 8,
		"unitsPerColumn", 5,
		"columnSpacing", 5,
		"columnAnchorPoint", "LEFT",
		'oUF-initialConfigFunction', [[
			self:SetWidth(48)
			self:SetHeight(32)
		]]
	)
	groupPets:SetPoint("BOTTOMLEFT", group, "BOTTOMRIGHT", 5, 0)
	groupPets:EnableMouse(nil)
	
	self:SetActiveStyle("Gdx - Boss")
	local prev
	for i = 1, MAX_BOSS_FRAMES do
		local boss = self:Spawn("boss"..i)
		
		if (prev) then
			boss:SetPoint("TOP", prev, "BOTTOM", 0, -10)
		else
			boss:SetPoint("TOPRIGHT", UIParent, -25, -25)
		end
		
		prev = boss
	end
	
	BuffFrame:UnregisterEvent("UNIT_AURA")
	TemporaryEnchantFrame:Hide()
	BuffFrame:Hide()
end)