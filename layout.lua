local BANZAI = AceLibrary('Banzai-1.0')

local gxMedia = gxMedia or {
    auraFont = 'Fonts/FRIZQT__.TTF',
    bgFile = 'Interface/ChatFrame/ChatFrameBackground',
    buttonOverlay = 'Interface/Buttons/UI-ActionButton-Border',
    edgeFile = 'Interface/Tooltips/UI-Tooltip-Border',
    font = 'Fonts/FRIZQT__.TTF',
    statusBar = 'Interface/TargetingFrame/UI-StatusBar',
    symbolFont = 'Fonts/FRIZQT__.TTF', }

local sformat = string.format
local sgsub = string.gsub
local CreateFrame = CreateFrame
local UnitMana, UnitManaMax = UnitMana, UnitManaMax
local UnitHealth, UnitHealthMax = UnitHealth, UnitHealthMax
local UnitAura = UnitAura
local UnitIsConnected = UnitIsConnected
local UnitReaction = UnitReaction
local UnitClass = UnitClass
local UnitIsConnected = UnitIsConnected
local UnitIsUnit = UnitIsUnit
local UnitIsTapped, UnitIsTappedByPlayer = UnitIsTapped, UnitIsTappedByPlayer

local units = {}
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
        ["HUNTER"] = {},
        ["ROGUE"] = {},
        ["WARLOCK"] = {},
        ["WARRIOR"] = {},
    }
    if t[class] then
        dispellClass = {}
        for k, v in next, t[class] do
            dispellClass[k] = v
        end
    end

    t = nil
end

local dispellPriority = setmetatable(
    {
        ["Magic"] = 4,
        ["Poison"] = 3,
        ["Disease"] = 1,
        ["Curse"] = 2,
    },
    { __index = function() return 0 end }
)

local debuffs = setmetatable(
    {
	--------------
	--  Onyxia  --
	--------------
        ['Engulfing Flames'] = 10,

	-------------------
	--  Molten Core  --
	-------------------
        -- Gehennas
        ["Gehennas' Curse"] = 10,

	----------------------
	--  Blackwing Lair  --
	----------------------
        -- Vaelastrasz
        ['Burning Adrenaline'] = 10,


	---------------------------
	--  Temple of Ahn'Qiraj  --
	---------------------------
	-- The Prophet Skeram
	['True Fulfillment'] = 10,
        ['Cause Insanity'] = 10,


	------------------
	--  Naxxramas   --
	------------------
	-- Kel'thuzad
	['Frost Blast'] = 8,


	--------------------------
	--  Player vs. Player   --
	--------------------------
	-- Health reduction
	['Wound Poison'] = 8,
	['Mortal Strike'] = 8,
        ['Blood Fury'] = 8,

	-- Silence
        ['Silenced - Improved Counterspell'] = 9,
        ['Counterspell'] = 8,

	-- Disoriented
        ['Blind'] = 7,
        ['Scatter Shot'] = 7,	-- Scatter Shot

	-- Crowd control effects
        ['Polymorph'] = 8,

 	-- Root effects
        ['Entangling Roots'] = 7,
        ['Freezing Trap Effect'] = 7,	--

	-- Slow effects
	['Crippling Poison'] = 1,
	['Hamstring'] = 1,
	['Wing Clip'] = 1,

	-- Fear effects
	['Fear'] = 8,
 	['Howl of Terror'] = 8,
    },
    { __index = function() return 0 end }
)

local cdBuffs = {
    --------------------------
    --	Survival Cooldowns	--
    --------------------------
    -- Druid
    ['Barkskin'] = true,

    -- Mage
    ['Ice Block'] = true,

    -- Druid
    ['Innervate'] = true,

    -- Warrior
    ['Last Stand'] = true,	-- Last Stand
    ['Shield Wall'] = true,     -- Shield Wall
}

local function UNIT_AURA(frame, event, unit)
    if not UnitIsUnit(frame.unit, unit) then
        return
    end

    local name, icon, count, auraType, duration, expire

    for i = 1, 32 do
        local nextName, _, nextIcon, nextCount, nextDebuffType, nextDuration, nextExpire =
            UnitAura(unit, i, 'HARMFUL')

        if not nextName then
            break
        end

        -- print(debuffs['Frost Blast'] > 0 and debuffs['Frost Blast'] >= debuffs[name or 1])
        local isHigherPriority = debuffs[nextName] > 0 and debuffs[nextName] >= debuffs[name or 1]
        isHigherPriority = dispellPriority[nextDebuffType] > dispellPriority[auraType] or isHigherPriority

        if not isHigherPriority then
            nextName, _, nextIcon, nextCount, nextDebuffType, nextDuration, nextExpire =
                UnitAura(unit, i)
            isHigherPriority = cdBuffs[nextName]
        end

        if isHigherPriority then
            name = nextName
            icon = nextIcon
            auraType = nextDebuffType or 'none'
            expire = nextExpire
            duration = nextDuration
            count = nextCount > 1 and nextCount or ''
        end
    end

    duration = duration or 0

    -- TODO: Debuffs in `debuffs' aren't shown
    if auraType then
        if (dispellClass[auraType]) and (UnitReaction(unit, 'player') or 0) > 4 then
            local col = not cdBuffs[name] and DebuffTypeColor[auraType] or
                { r = 1, g = 1, b = 0 }
            frame.DebuffIcon.Overlay:SetVertexColor(col.r, col.g, col.b)
            frame.Dispell = true
            frame.DebuffIcon.Count:SetText(count)
            frame.DebuffIcon.Texture:SetTexture(icon)
            frame.DebuffIcon:Show()

            if duration > 0 then
                CooldownFrame_SetTimer(frame.DebuffIcon.Cooldown, expire - duration, duration, 1)
            end
        elseif frame.Dispell then
            frame.Dispell = false
            frame.DebuffIcon:Hide()
        end
    else
        -- CooldownFrame_SetTimer(frame.DebuffIcon.Cooldown, 0, 0, 0)
        -- frame.DebuffIcon.Count:SetText()
        frame.DebuffIcon:Hide()
    end
end

local castOnUpdate = function()
    if this.casting then
        local duration = this.Reverse and this.duration - arg1 or this.duration + arg1
        local durText = this.Reverse and this.durText + arg1

        if this.Reverse and duration <= 0 or duration >= this.max then
            this.casting = nil
            this:Hide()

            return
        end

        if this.Time then
            if this.delay ~= 0 then
                this.Time:SetText(sformat('%.1f|cffff0000-%.1f|r', this.Reverse and durText or duration, this.delay))
            else
                this.Time:SetText(sformat('%.1f', this.Reverse and durText or duration))
            end
        end

        this.durText = durText
        this.duration = duration
        this:SetValue(duration)
    elseif this.channeling then
        local duration = this.Reverse and this.duration + arg1 or this.duration - arg1
        local durText = this.Reverse and this.durText - arg1
        if this.Reverse and duration >= this.max or duration < 0 then
            this.channeling = nil
            this:Hide()

            return
        end

        if this.Time then
            if this.delay ~= 0 then
                this.Time:SetText(sformat('%.1f|cffff0000-%.1f|r', this.Reverse and durText or duration, this.delay))
            else
                this.Time:SetText(sformat('%.1f', this.Reverse and durText or duration))
            end
        end

        this.durText = durText
        this.duration = duration
        this:SetValue(duration)
    else
        this.unitName = nil
        this.channeling = nil
        if this.Reverse then
            this:SetValue(0)
        else
            this:SetValue(1)
        end
        this:Hide()
    end
end

local PostCastStart = function(castBar, unit, name, rank)
    if castBar.Reverse then
        local _, _, _, _, startTime, endTime = UnitCastingInfo(unit)

        startTime = startTime / 1e3
        endTime = endTime / 1e3

        castBar.durText = GetTime() - startTime
        castBar.duration = endTime - GetTime()
        castBar:SetValue(castBar.duration)
    end
end

local PostChannelStart = function(castBar, unit, name, rank)
    if castBar.Reverse then
        local _, _, _, _, startTime, endTime = UnitChannelInfo(unit)

        startTime = startTime / 1e3
        endTime = endTime / 1e3

        castBar.durText = endTime - GetTime()
        castBar.duration = GetTime() - startTime
        castBar:SetValue(0)
    end
end

local PostCastDelayed = function(castBar, unit, name, rank)
    if castBar.Reverse then
        local _, _, _, _, startTime, endTime = UnitCastingInfo(unit)

        local duration = endTime / 1e3 - GetTime()

        if duration < 0 then
            duration = 0
        end

        castBar.delay = castBar.delay + castBar.duration + duration

        castBar.duration = duration

        castBar:SetValue(duration)
    end
end

local healthUpdate = function(self, event, unit)
    if not unit or self.unit ~= unit then
        return
    end

    local health = self.Health
    local min, max = UnitHealth(unit), UnitHealthMax(unit)
    local disconnected = not UnitIsConnected(unit)

    if disconnected then
        if health.Reverse then
            max = max == 0 and 100 or max
        end

        min = 0
    end

    health:SetMinMaxValues(0, max)

    health.disconnected = disconnected
    health.unit = unit

    local r, g, b
    if self.ThreatColor then
        local aggro = BANZAI:GetUnitAggroByUnitId(unit)
        if aggro then
            r, g, b = 153 / 255, 85 / 255, 85 / 255
        end
    end

    if not b then
        r, g, b = self.ColorGradient(min, max,
                                         .7, .15, .15,
                                         .85, .8, .45,
                                         .25, .25, .25)
    end

    if b then
        if health.Reverse then
            health:SetValue(max - min)
            health.bg:SetVertexColor(r, g, b)
        else
            health:SetValue(min)
            health:SetStatusBarColor(r, g, b)
        end
    end
end

local powerUpdate = function(self, event, unit)
    if not unit or self.unit ~= unit then
        return
    end

    local power = self.Power
    local min, max = UnitMana(unit), UnitManaMax(unit)
    local disconnected = not UnitIsConnected(unit)

    if disconnected and power.Reverse then
        max = max == 0 and 100 or max
    end
    power:SetMinMaxValues(0, max)

    power.disconnected = disconnected
    power.unit = unit

    local r, g, b, t
    if power.colorTapping and UnitIsTapped(unit) and not UnitIsTappedByPlayer(unit) then
        t = self.colors.tapped
    elseif power.colorDisconnected and not UnitIsConnected(unit) then
        t = self.colors.disconnected
    elseif power.colorClass and UnitIsPlayer(unit) then
        local _, class = UnitClass(unit)
        t = self.colors.class[class]
    elseif power.colorReaction and UnitReaction(unit, 'player') then
        t = self.colors.reaction[UnitReaction(unit, 'player')]
    end

    if t then
        r, g, b = t[1], t[2], t[3]
    end

    if b then
        if power.Reverse then
            power:SetValue(max - min)
            power.bg:SetVertexColor(r, g, b)
        else
            power:SetValue(min)
            power:SetStatusBarColor(r, g, b)
        end
    end
end

local auraPostUpdate = function(icons, unit)
    local buffs, debuffs = icons:GetParent().Buffs, icons:GetParent().Debuffs

    if buffs then
        local visibleBuffs = buffs.visibleBuffs
        local size = buffs.size
        local width = buffs:GetWidth()

        local cols = math.floor(width / size + .5)
        local height = math.floor(visibleBuffs / cols + .1)

        buffs:SetHeight(size * (height + 1))

        local point, relativeTo, relativePoint, xOfs = debuffs:GetPoint()

        debuffs:ClearAllPoints()
        if visibleBuffs > 0 then
            debuffs:SetPoint(point, relativeTo, relativePoint, xOfs, (size + 2) * (height + 1) + 3)
        else
            debuffs:SetPoint(point, relativeTo, relativePoint, xOfs, 3)
        end
    end
end

local PostUpdateIcon = function(self, unit, icon, index, n)
    local reaction = UnitReaction(unit, 'player')
    local color = { r = .6, g = .6, b = .6 }
    if reaction and reaction < 5 then
        local _, _, _, _, auraType = UnitAura(unit, index)
        color = DebuffTypeColor[auraType] or color
    end

    icon.overlay:SetVertexColor(color.r, color.g, color.b)
end

local auraPostCreateIcon = function(icons, button, enchantArg)
    if icons.Enchant == enchantArg and enchantArg then
        icons = enchantArg -- ugly fix
    end

    local backdrop = CreateFrame("Frame", nil, button)
    backdrop:SetPoint("TOPLEFT", button, -5, 5)
    backdrop:SetPoint("BOTTOMRIGHT", button, 5, -5)
    backdrop:SetFrameStrata("BACKGROUND")
    backdrop:SetBackdrop({
            bgFile = gxMedia.bgFile,
            edgeFile = gxMedia.edgeFile,
            edgeSize = 16,
            insets = {
                left = 5,
                right = 5,
                top = 5,
                bottom = 5
            }
    })
    backdrop:SetBackdropColor(.15,.15,.15)
    backdrop:SetBackdropBorderColor(.15,.15,.15,.5)

    button.Backdrop = backdrop

    button.icon:SetTexCoord(0.1, 0.9, 0.1, 0.9)

    -- button.cd:ClearAllPoints()
    button.cd:SetPoint("TOPLEFT", 3, -2)
    button.cd:SetPoint("BOTTOMRIGHT", -2, 2)
    button.cd:SetWidth(button.cd:GetWidth() - 6)
    button.cd:SetHeight(button.cd:GetHeight() - 4)
    button.cd.reverse = true

    button.count:SetParent(button)
    button.count:SetPoint("BOTTOMRIGHT", 0, 1)
    button.count:SetJustifyH("RIGHT")
    button.count:SetFont(gxMedia.font, 10, "OUTLINE")
    button.count:SetTextColor(0.84, 0.75, 0.65)

    icons.showDebuffType = true

    button.overlay:SetTexture(gxMedia.buttonOverlay)
    button.overlay:SetPoint("TOPLEFT", -1, 1)
    button.overlay:SetPoint("BOTTOMRIGHT", 1, -1)
    button.overlay:SetVertexColor(.6,.6,.6)
    button.overlay:SetTexCoord(0, 0.98, 0, 0.98)
    button.overlay.Hide = NOOP

    if icons == icons:GetParent().Enchant then
        button.overlay:SetVertexColor(0.33, 0.59, 0.33)
    end
end

local shared = function(self, unit, isSingle)
    self:SetScript("OnEnter", UnitFrame_OnEnter)
    self:SetScript("OnLeave", UnitFrame_OnLeave)

    local backdrop = CreateFrame("Frame", nil, self)
    backdrop:SetPoint("TOPLEFT", self, -5, 5)
    backdrop:SetPoint("BOTTOMRIGHT", self, 5, -5)
    backdrop:SetFrameStrata("BACKGROUND")
    backdrop:SetBackdrop({
            bgFile = gxMedia.bgFile,
            edgeFile = gxMedia.edgeFile,
            edgeSize = 16,
            insets = {
                left = 5,
                right = 5,
                top = 5,
                bottom = 5
            }
    })
    backdrop:SetBackdropColor(.15,.15,.15)
    backdrop:SetBackdropBorderColor(.15,.15,.15,.5)
    self.backdrop = backdrop

    if unit ~= 'raid' then
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

        if unit == 'target' or unit == 'targettarget' or unit == 'pet' then
            local info = self.Panel:CreateFontString(nil, "OVERLAY")
            info:SetFont(gxMedia.font, 12)
            info:SetShadowColor(0, 0, 0)
            info:SetShadowOffset(1.25, -1.25)
            info:SetTextColor(0.84, 0.75, 0.65)

            self.Panel.Info = info
        end

        if unit == 'player' or unit == 'target' then
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
            icon:SetHeight(28)
            icon:SetWidth(28)
            icon:SetTexCoord(0.1, 0.9, 0.1, 0.9)

            local overlay = cb:CreateTexture(nil, "OVERLAY")
            overlay:SetPoint("TOPLEFT", icon, -1.5, 1)
            overlay:SetPoint("BOTTOMRIGHT", icon, 1, -1)
            overlay:SetTexture(gxMedia.buttonOverlay)
            overlay:SetVertexColor(.25, .25, .25)

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
    end

    local hp = CreateFrame("StatusBar", nil, self)
    hp:SetStatusBarTexture(gxMedia.statusBar)
    hp.Smooth = true
    hp:SetFrameStrata("LOW")
    hp:SetPoint("TOPLEFT", self)
    hp:SetPoint("TOPRIGHT", self)
    hp.frequentUpdates = true

    local bg = hp:CreateTexture(nil, "BACKGROUND")
    bg:SetAllPoints(hp)
    bg:SetTexture(gxMedia.statusBar)

    if unit == "target" or unit == "targettarget" then
        hp.Reverse = true
        hp:SetStatusBarColor(.1,.1,.1)
    else
        bg:SetVertexColor(.1,.1,.1)
    end

    if unit == "player" or unit == "target" then
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

    if unit == 'player' or unit == 'target' then
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
        pp:SetPoint("LEFT", self)
        pp:SetPoint("RIGHT", self)
        pp:SetPoint("TOP", self.Health, "BOTTOM", 0, 0)

        local bg = pp:CreateTexture(nil, "BACKGROUND")
        bg:SetAllPoints(pp)
        bg:SetTexture(gxMedia.statusBar)

        if unit ~= "target" then
            bg:SetVertexColor(.1,.1,.1)
        else
            pp:SetStatusBarColor(.1, .1, .1)
        end

        if unit == "player" or unit == "target" then
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

    if unit == "player" or unit == "target" then
        local buffs = CreateFrame("Frame", nil, self)
        buffs:SetHeight(27)
        buffs:SetWidth(230)
        buffs.size = 27
        buffs.spacing = 2
        buffs["growth-y"] = "UP"
        buffs.PostCreateIcon = auraPostCreateIcon
        buffs.PostUpdate = auraPostUpdate

        if unit == 'target' then
            buffs.PostUpdateIcon = PostUpdateIcon
        end

        self.Buffs = buffs
    end

    if unit == "player" or unit == "target" or unit == "pet" or unit == "targettarget" then
        local debuffs = CreateFrame("Frame", nil, self)
        debuffs:SetHeight(27)
        debuffs:SetWidth(230)
        debuffs.size = 27
        debuffs.spacing = 2
        debuffs["growth-y"] = "UP"
        debuffs.PostCreateIcon = auraPostCreateIcon
        debuffs.PostUpdate = auraPostUpdate

        self.Debuffs = debuffs
    end

    if unit == "player" or unit == "target" or unit == "raid" or unit == "raidpet" or unit == "party" then
        local leader = self:CreateTexture(nil, "OVERLAY")
        self.Leader = leader

        local masterlooter = self:CreateTexture(nil, "OVERLAY")
        self.MasterLooter = masterlooter
    end

    local raidIcon = self:CreateTexture(nil, "OVERLAY")
    self.RaidIcon = raidIcon

    if unit ~= "player" and unit ~= "boss" then
        if IsAddOnLoaded('oUF_SpellRange') then
            self.SpellRange = {
                insideAlpha = 1,
                outsideAlpha = .25
            }
        else
            if unit == 'party' or unit == 'raid' or unit == 'raidpet' then
                self.Range = {
                    insideAlpha = 1,
                    outsideAlpha = .25
                }
            end
        end
    end

    if unit == 'player' or unit == 'raid' or unit == 'raidpet' then
        self.ThreatColor = true
    end
end

local function HealPredictionPostUpdate(hp, unit, overAbsorb, overHealAbsorb)
    local health, maxHealth = UnitHealth(unit), UnitHealthMax(unit)
    local relativePoint, frame, point = hp.otherBar:GetPoint()

    local yOffset = frame:GetParent():GetHeight() * (health / maxHealth)

    hp.myBar:ClearAllPoints()
    hp.myBar:SetPoint(relativePoint, frame, point, 0, yOffset)

    yOffset = yOffset + frame:GetParent():GetHeight() * (hp.myBar:GetValue() / maxHealth)

    hp.otherBar:ClearAllPoints()
    hp.otherBar:SetPoint(relativePoint, frame, point, 0, yOffset)
end

local StartSwingTimer
do
    local mainHandHitTime, offHandHitTime
    local lastMainHandHitTime, lastOffHandHitTime
    local numMainHits, numOffHits = 0, 0
    local mabs = math.abs
    function StartSwingTimer(self)
        if string.match(arg1, 'You fall') then
            return
        end

        local mainHandSpeed, offHandSpeed = UnitAttackSpeed('player')
        offHandSpeed = offHandSpeed or -1
        local hitTime = GetTime()

        local mainHandDelay = mabs((hitTime - (lastMainHandHitTime or hitTime)) - mainHandSpeed)
        local offHandDelay = mabs((hitTime - (lastOffHandHitTime or hitTime)) - offHandSpeed)
        if ((mainHandDelay <= offHandDelay and (numMainHits < offHandSpeed / mainHandSpeed)) or
            numOffHits >= mainHandSpeed / offHandSpeed) then
            lastMainHandHitTime = hitTime
            numOffHits = 0
            numMainHits = numMainHits + 1
            self.swingPulse.mainHand.speed = mainHandSpeed
            self.swingPulse.mainHand:Show()
        else
            lastOffHandHitTime = hitTime
            numMainHits = 0
            numOffHits = numOffHits + 1
            self.swingPulse.offHand.speed = offHandSpeed
            self.swingPulse.offHand:Show()
        end
    end
end

local function swingPulseOnUpdate()
    this.elapsed = this.elapsed + arg1

    local progress = this.elapsed / (this.speed or -1)

    if progress > 1 then
        this.elapsed = 0
        this.texture:ClearAllPoints()
        this.texture:SetPoint('CENTER', this, 'BOTTOMLEFT')
        this:Hide()
    else
        this.texture:ClearAllPoints()
        this.texture:SetPoint('CENTER', this, 'BOTTOMLEFT',
                              (this:GetWidth() / this:GetEffectiveScale()) * progress, 0)
    end
end

local unitSpecific = {
    player = function(self, unit, ...)
        self:SetWidth(230)
        self:SetHeight(55)

        shared(self, unit, unpack(arg))

        local health = self.Health
        health:SetHeight(27)
        health.Text:SetPoint("BOTTOMRIGHT", self, -5, 4)
        health.Text:SetJustifyH("RIGHT")

        local tex
        local mainHandSwingPulse = CreateFrame('Frame', nil, health)
        mainHandSwingPulse:SetPoint('TOPLEFT', health, 'TOPLEFT', 0, 0)
        mainHandSwingPulse:SetPoint('BOTTOMRIGHT', health, 'TOPRIGHT', 0, -1)
        mainHandSwingPulse:EnableMouse(nil)
        mainHandSwingPulse:SetScript('OnUpdate', swingPulseOnUpdate)
        mainHandSwingPulse:Hide()


        tex = mainHandSwingPulse:CreateTexture(nil, 'OVERLAY')
        tex:SetPoint('CENTER', mainHandSwingPulse, 'LEFT', 0, 0)
        tex:SetHeight(20)
        tex:SetWidth(30)
        tex:SetTexture('Interface\\CastingBar\\UI-CastingBar-Spark')
        tex:SetBlendMode('ADD')
        tex:SetVertexColor(0, 1, 0)
        tex:Show()

        mainHandSwingPulse.elapsed = 0
        mainHandSwingPulse.speed = 0
        mainHandSwingPulse.texture = tex

        local offHandSwingPulse = CreateFrame('Frame', nil, health)
        offHandSwingPulse:SetPoint('TOPLEFT', health, 'BOTTOMLEFT', 0, 1)
        offHandSwingPulse:SetPoint('BOTTOMRIGHT', health, 'BOTTOMRIGHT', 0, 0)
        offHandSwingPulse:EnableMouse(nil)
        offHandSwingPulse:SetScript('OnUpdate', swingPulseOnUpdate)
        offHandSwingPulse:Hide()

        tex = offHandSwingPulse:CreateTexture(nil, 'OVERLAY')
        tex:SetPoint('CENTER', offHandSwingPulse, 'LEFT')
        tex:SetHeight(20)
        tex:SetWidth(30)
        tex:SetTexture('Interface\\CastingBar\\UI-CastingBar-Spark')
        tex:SetBlendMode('ADD')
        tex:SetVertexColor(0, 0, 1)

        offHandSwingPulse.elapsed = 0
        offHandSwingPulse.speed = 0
        offHandSwingPulse.texture = tex


        self.swingPulse = {
            mainHand = mainHandSwingPulse,
            offHand = offHandSwingPulse,
        }

        self:RegisterEvent('CHAT_MSG_COMBAT_SELF_HITS', StartSwingTimer)
        self:RegisterEvent('CHAT_MSG_COMBAT_SELF_MISSES', StartSwingTimer)

        local power = self.Power
        power:SetHeight(8)
        power.Text:SetPoint("BOTTOMLEFT", self, 5, 4)
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
        raidIcon:SetWidth(24)
        raidIcon:SetHeight(24)
        raidIcon:SetPoint("RIGHT", health, "RIGHT", -1, 1)

        if IsAddOnLoaded('oUF_WeaponEnchant') then
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

        if IsAddOnLoaded('oUF_Experience') then
            local xp = CreateFrame("StatusBar", nil, self)
            xp:SetStatusBarTexture(gxMedia.statusBar)
            xp:SetPoint("TOPLEFT", self.Panel, 1, -1)
            xp:SetPoint("BOTTOMRIGHT", self.Panel, -1, 1)
            xp:SetHeight(18)
            xp:SetFrameStrata("HIGH")
            xp:SetAlpha(0)
            xp:EnableMouse(false)
            xp:RegisterEvent('CHAT_MSG_COMBAT_XP_GAIN')
            xp:SetScript('OnEvent', function(event)
                             local beg_pos, end_pos = string.find(arg1, "%d+")
                             xp.mtnl:SetText(math.ceil((UnitXPMax("player") - UnitXP('player')) / tonumber(string.sub(arg1, beg_pos, end_pos))))
            end)

            local mtnl = xp:CreateFontString(nil, "OVERLAY")
            mtnl:SetFont(gxMedia.font, 12)
            mtnl:SetShadowColor(0, 0, 0)
            mtnl:SetShadowOffset(1.25, -1.25)
            mtnl:SetPoint("BOTTOM", self, 0, 5)
            mtnl:SetTextColor(0.84, 0.75, 0.65)

            xp.mtnl = mtnl

            local bg = xp:CreateTexture(nil, "BACKGROUND")
            bg:SetAllPoints(xp)
            bg:SetTexture(gxMedia.statusBar)

            xp:SetStatusBarColor(.8, .2, .8)
            bg:SetVertexColor(.1, .1, .1)
            bg:SetTexture(gxMedia.bgFile)

            self:SetScript("OnEnter", function()
                               UnitFrame_OnEnter()
                               this.Experience:SetAlpha(.5)
            end)
            self:SetScript("OnLeave", function()
                               UnitFrame_OnLeave()
                               this.Experience:SetAlpha(0)
            end)

            xp.bg = bg
            self.Experience = xp
        end
    end,
    pet = function(self, unit, ...)
        self:SetWidth(115)
        self:SetHeight(35)

        shared(self, unit, unpack(arg))

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
        raidIcon:SetWidth(16)
        raidIcon:SetHeight(16)
        raidIcon:SetPoint("CENTER", health, "CENTER", 0, 1)
    end,
    target = function(self, unit, ...)
        self:SetWidth(230)
        self:SetHeight(55)

        shared(self, unit, unpack(arg))

        local health = self.Health
        health:SetHeight(27)
        health.Text:SetPoint("BOTTOMLEFT", self, 5, 4)
        health.Text:SetJustifyH("LEFT")

        local power = self.Power
        power:SetHeight(8)
        power.Reverse = true
        power:SetStatusBarColor(.1,.1,.1)
        power.Text:SetPoint("BOTTOMRIGHT", self, -5, 4)
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
        self:Tag(panel.Info, "[nameColor][longName] [diffColor][level] [shortclassification][cpoints]")

        local castBar = self.Castbar
        castBar.Icon:SetPoint("TOPLEFT", self, "RIGHT", 10, 10)

        local leader = self.Leader
        leader:SetWidth(16)
        leader:SetHeight(16)
        leader:SetPoint("CENTER", self, "TOPRIGHT")

        local masterLooter = self.MasterLooter
        masterLooter:SetWidth(16)
        masterLooter:SetHeight(16)
        masterLooter:SetPoint("CENTER", self, "TOPRIGHT", -16, 0)

        local raidIcon = self.RaidIcon
        raidIcon:SetWidth(24)
        raidIcon:SetHeight(24)
        raidIcon:SetPoint("LEFT", health, "LEFT", 1, 1)
    end,
    targettarget = function(self, unit, ...)
        self:SetWidth(115)
        self:SetHeight(35)

        shared(self, unit, unpack(arg))

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
        raidIcon:SetWidth(16)
        raidIcon:SetHeight(16)
        raidIcon:SetPoint("CENTER", health, "CENTER", 0, 1)
    end,
    raid = function(self, unit, ...)
        self:SetWidth(48)
        self:SetHeight(32)

        self:RegisterEvent('UNIT_AURA', UNIT_AURA)
        self:RegisterEvent('PLAYER_AURAS_CHANGED', function() UNIT_AURA(this, event, 'player') end)

        shared(self, unit, unpack(arg))

        local health = self.Health
        health:ClearAllPoints()
        health:SetAllPoints(self)
        health.Smooth = nil
        health:SetOrientation("VERTICAL")

        local myHeal = CreateFrame('StatusBar', nil, health)
        myHeal:SetHeight(32)
        myHeal:SetWidth(48)
        myHeal:SetOrientation('VERTICAL')
        myHeal:SetStatusBarTexture(gxMedia.statusBar)
        myHeal:SetStatusBarColor(255/255, 246/255, 88/255, 0.4)
        myHeal:SetPoint('BOTTOM', health, 'BOTTOM')

        local heal = CreateFrame('StatusBar', nil, health)
        heal:SetHeight(32)
        heal:SetWidth(48)
        heal:SetOrientation('VERTICAL')
        heal:SetStatusBarTexture(gxMedia.statusBar)
        heal:SetStatusBarColor(0, 1, 0, 0.4)
        heal:SetPoint('BOTTOM', health, 'BOTTOM')

        self.HealPrediction = {
            myBar = myHeal,
            otherBar = heal,
            maxOverflow = 1.25,
            PostUpdate = HealPredictionPostUpdate,
        }

        local resIcon = self:CreateTexture(nil, 'ARTWORK')
        resIcon:SetTexture('Interface/Icons/Spell_Holy_Resurrection')
        resIcon:SetAllPoints(self)
        resIcon:SetAlpha(.25)
        resIcon:SetTexCoord(0.07, 0.93, 0.07, 0.93)

        self.ResurrectIcon = resIcon

        local icon = CreateFrame('Frame', nil, self)
        icon:SetPoint('CENTER', self, 'CENTER')
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

        local cooldown = CreateFrame('Model', '$parentCooldown', icon, 'CooldownFrameTemplate')
        cooldown:SetAllPoints(icon)
        cooldown:SetWidth(22)
        cooldown:SetHeight(22)
        cooldown:SetPosition(-0.005, -0.005, 0)

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
        leader:SetWidth(8)
        leader:SetHeight(8)
        leader:SetPoint("CENTER", self, "TOPLEFT")

        local masterLooter = self.MasterLooter
        masterLooter:SetWidth(8)
        masterLooter:SetHeight(8)
        masterLooter:SetPoint("CENTER", self, "TOPLEFT", 8, 0)

        local raidIcon = self.RaidIcon
        raidIcon:SetWidth(16)
        raidIcon:SetHeight(16)
        raidIcon:SetPoint("CENTER", health, "TOP")

        if oUF.Indicators then
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
    end,
}

oUF:RegisterStyle("Gdx", shared)

for unit, layoutFunc in next, unitSpecific do
    oUF:RegisterStyle('Gdx - ' .. sgsub(unit, "^%l", string.upper), layoutFunc)
end

local spawnHelper = function(self, unit, ...)
    local object
    if unitSpecific[unit] then
        self:SetActiveStyle("Gdx - " .. sgsub(unit, "^%l", string.upper))
        object = self:Spawn(unit)
        object:SetPoint(unpack(arg))
    else
        self:SetActiveStyle("Gdx")
        object = self:Spawn(unit)
        object:SetPoint(unpack(arg))
    end

    return object
end

oUF:Factory(function(self)
        self:InitializeTags()

	local player = spawnHelper(self, 'player', 'BOTTOM', UIParent, -235, 60)
	local target = spawnHelper(self, 'target', 'BOTTOM', UIParent, 235, 60)
	local pet = spawnHelper(self, 'pet', 'BOTTOMRIGHT', player, 'TOPLEFT', -15, 15)
	local targettarget = spawnHelper(self, 'targettarget', 'BOTTOMLEFT', target, 'TOPRIGHT', 15, 15)

	self:SetActiveStyle('Gdx - Raid')
	local group = self:SpawnHeader(
            nil,
            nil, 'raid,party',
            'showPlayer', true,
            'showRaid', true,
            'showParty', true,
            'yOffset', 5,
            'xOffset', 5,
            'maxColumns', 8,
            'point', 'BOTTOM',
            'unitsPerColumn', 5,
            'columnSpacing', 5,
            'columnAnchorPoint', 'LEFT',
            'groupingOrder', '1,2,3,4,5,6,7,8',
            'groupBy', 'GROUP',
            'oUF-initialConfigFunction',
            function(self)
                self:SetWidth(48)
                self:SetHeight(32)
            end
	)
	group:SetPoint('CENTER', UIParent, 'CENTER', 0, -275)
	group:EnableMouse(nil)

	local groupPets = self:SpawnHeader(
            nil, nil, 'raid,party',
            'showPlayer', true,
            'showRaid', true,
            'showParty', true,
            'yOffset', 5,
            'xOffset', 5,
            'point', 'BOTTOM',
            'maxColumns', 8,
            'unitsPerColumn', 5,
            'columnSpacing', 5,
            'columnAnchorPoint', 'LEFT',
            'petHeader', true,
            'oUF-initialConfigFunction',
            function()
                self:SetWidth(48)
                self:SetHeight(32)
            end
	)
	groupPets:SetPoint('BOTTOMLEFT', group, 'BOTTOMRIGHT', 5, 0)
	groupPets:EnableMouse(nil)

	BuffFrame:UnregisterAllEvents()
	TemporaryEnchantFrame:Hide()
	BuffFrame:Hide()
end)

if TEST_BRIDGE then
    TEST_BRIDGE.UNIT_AURA = UNIT_AURA
end
