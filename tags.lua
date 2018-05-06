if not oUF then
    return
end


local GetPetHappiness = GetPetHappiness
local GetQuestGreenRange = GetQuestGreenRange
local UnitAura = UnitAura
local UnitHealth = UnitHealth
local UnitIsConnected = UnitIsConnected
-- Hooked in ModernizrLib - this one would point to the original function
-- local UnitIsDead = UnitIsDead
local UnitIsGhost = UnitIsGhost
local UnitLevel = UnitLevel
local UnitName = UnitName
local UnitReaction = UnitReaction
local colorGradient = oUF.ColorGradient
local missingHealth = oUF.Tags.Methods['missinghp']
local percentHealth = oUF.Tags.Methods['perhp']
local sbyte = string.byte
local sformat = string.format
local sgsub = string.gsub
local slen = string.len
local ssub = string.sub


local function InitializeTags(self)
    local level = UnitLevel('player')

    self.Tags.Methods['diffColor'] = function(unit)
        local r, g, b
        local level = UnitLevel(unit)
        if level < 1 then
            r, g, b = 0.69, 0.31, 0.31
        else
            local levelDiff = level - UnitLevel("player")
            if levelDiff >= 5 then
                r, g, b = 0.69, 0.31, 0.31
            elseif levelDiff >= 3 then
                r, g, b = 0.71, 0.43, 0.27
            elseif levelDiff >= -2 then
                r, g, b = 0.84, 0.75, 0.65
            elseif -levelDiff <= GetQuestGreenRange() then
                r, g, b = 0.33, 0.59, 0.33
            else
                r, g, b = 0.55, 0.57, 0.61
            end
        end

        return sformat('|cff%02x%02x%02x', r * 255, g * 255, b * 255)
    end

    self.Tags.Events['diffColor'] = 'UNIT_LEVEL'

    self.Tags.Methods['nameColor'] = function(unit)
        local reaction = UnitReaction(unit, 'player')
        if unit == 'pet' and GetPetHappiness() then
            local c = self.colors.happiness[GetPetHappiness()]
            return sformat('|cff%02x%02x%02x', c[1] * 255, c[2] * 255, c[3] * 255)
        elseif UnitIsPlayer(unit) then
            return self.Tags.Methods['raidcolor'](unit)
        elseif reaction then
            local c = self.colors.reaction[reaction]
            return sformat('|cff%02x%02x%02x', c[1] * 255, c[2] * 255, c[3] * 255)
        else
            r, g, b = .84,.75,.65
            return sformat('|cff%02x%02x%02x', r * 255, g * 255, b * 255)
        end
    end
    self.Tags.Events['nameColor'] = 'UNIT_HAPPINESS'

    local numberize = function(value)
        if value >= 1e6 then
            return sformat('%.1fm', value / 1e6)
        elseif value >= 1e3 then
            return sformat('%.1fk', value / 1e3)
        else
            return sformat('%d', value)
        end
    end

    local utf8sub = function(str, i, dots)
        local bytes = slen(str)
        if bytes <= i then
            return str
        else
            local len, pos = 0, 1
            for it = 1, i do
                len = len + 1

                if pos > bytes then
                    break
                end

                local c = sbyte(str, pos)
                if c > 0 and c <= 127 then
                    pos = pos + 1
                elseif c >= 192 and c <= 223 then
                    pos = pos + 2
                elseif c >= 224 and c <= 239 then
                    pos = pos + 3
                elseif c >= 240 and c <= 247 then
                    pos = pos + 4
                end
            end

            if len == i and pos <= bytes then
                return ssub(str, 1, pos - 1) .. (dots and '...' or '')
            else
                return str
            end
        end
    end


    self.Tags.Methods['shortName'] = function(unit)
        local name = UnitName(unit)
        if name then
            return utf8sub(name, 6, false)
        end
    end
    self.Tags.Events['shortName'] = 'UNIT_NAME_UPDATE'

    self.Tags.Methods['mediumName'] = function(unit)
        local name = UnitName(unit)
        if not name then
            return
        end

        if unit == 'pet' and name == 'Unknown' then
            return 'Pet'
        else
            return utf8sub(name, 18, true)
        end
    end
    self.Tags.Events['mediumName'] = 'UNIT_NAME_UPDATE'

    self.Tags.Methods['longName'] = function(unit)
        local name = UnitName(unit)
        if name then
            return utf8sub(name, 36, true)
        end
    end
    self.Tags.Events['longName'] = 'UNIT_NAME_UPDATE'

    self.Tags.Methods['raidHP'] = function(unit)
        local cur = UnitHealth(unit)
        local def = missingHealth(unit)
        local per = percentHealth(unit)
        local result

        if UnitAura(unit, 'Feign Death') then
            result = 'FD'
        elseif UnitIsDead(unit) then
            result = 'Dead'
        elseif UnitIsGhost(unit) then
            result = 'Ghost'
        elseif not UnitIsConnected(unit) then
            result = 'D/C'
        elseif per < 90 and def then
            result = sformat('-%s', numberize(def))
        else
            result = utf8sub(UnitName(unit), 4) or 'N/A'
        end

        return result
    end
    self.Tags.Events['raidHP'] = 'UNIT_NAME_UPDATE UNIT_HEALTH UNIT_MAXHEALTH'

    local shortValue = function(value)
        if value >= 1e6 then
            return sgsub(sformat('%.1fm', value / 1e6), '%.?0+([km])$', '%1')
        elseif value >= 1e3 or value <= -1e3 then
            return sgsub(sformat('%.1fk', value / 1e3), '%.?0+([km])$', '%1')
        else
            return value
        end
    end

    self.Tags.Methods['healthText'] = function(unit)
        local cur, max = UnitHealth(unit), UnitHealthMax(unit)

        local result

        if not UnitIsConnected(unit) then
            result = '|cffD7BEA5Offline|r'
        elseif UnitIsDead(unit) then
            result = '|cffD7BEA5Dead|r'
        elseif UnitIsGhost(unit) then
            result = '|cffD7BEA5Ghost|r'
        else
            if cur ~= max then
                local r, g, b = colorGradient(cur, max,
                                              0.69, 0.31, 0.31,
                                              0.65, 0.63, 0.35,
                                              0.33, 0.59, 0.33)
                local short = shortValue(cur)
                local perc = floor(cur / max * 100)
                if unit == 'player' then
                    result = sformat('|cffAF5050%s|r |cffD7BEA5-|r |cff%02x%02x%02x%d%%|r',
                                     short, r * 255, g * 255, b * 255, perc)
                else
                    result = sformat('|cff%02x%02x%02x%d%%|r |cffD7BEA5-|r |cffAF5050%s|r',
                                     r * 255, g * 255, b * 255, perc, short)
                end
            else
                result = sformat('|cff559655%d|r', max)
            end
        end

        return result
    end

    self.Tags.Events['healthText'] = 'UNIT_HEALTH UNIT_MAXHEALTH'

    local power = {
        ['MANA'] = {0.31, 0.45, 0.63},
        ['RAGE'] = {0.69, 0.31, 0.31},
        ['ENERGY'] = {0.65, 0.63, 0.35},
    }

    self.Tags.Methods['powerText'] = function(unit)
        local r, g, b, t
        local cur, max = UnitMana(unit), UnitManaMax(unit)
        local pType, pToken = UnitPowerType(unit)
        local t = power[pToken]

        if t then
            r, g, b = t[1], t[2], t[3]
        else
            r, g, b = .6, .6, .6
        end

        local result

        if cur == 0 then
            result = ''
        elseif not UnitIsPlayer(unit) and not UnitPlayerControlled(unit) or not UnitIsConnected(unit) then
            result = ''
        elseif UnitIsDead(unit) or UnitIsGhost(unit) then
            result = ''
        elseif cur == max and pType == 2 then
            result = ''
        else
            if cur ~= max and pType == 0 then
                local short = shortValue(max - (max - cur))
                local perc = floor(cur / max * 100)
                if unit == 'player' then
                    result = format('|cff%02x%02x%02x%d%% - %s|r',
                                    r * 255, g * 255, b * 255, perc, short)
                else
                    result = format('|cff%02x%02x%02x%s - %d%%|r',
                                    r * 255, g * 255, b * 255, short, perc)
                end
            else
                result = format('|cff%02x%02x%02x%s|r', r*255, g*255, b*255, cur)
            end
        end

        return result
    end
    self.Tags.Events['powerText'] = 'UNIT_MAXMANA UNIT_MANA UPDATE_SHAPESHIFT_FORM'

    local _, class = UnitClass('player')
    local UnitIsConnected = UnitIsConnected

    self.Indicators = {
        ['TL'] = '',
        ['TR'] = '',
        ['BL'] = '',
        ['BR'] = ''
    }

    if class == 'DRUID' then
        self.Tags.Methods['Rejuvenation'] = function(unit)
            if not UnitIsConnected(unit) then return '' end

            if UnitAura(unit, 'Rejuvenation') then
                return '|cff00FEBFM|r'
            end
        end
        self.Tags.Events['Rejuvenation'] = 'UNIT_AURA PLAYER_AURAS_CHANGED'

        self.Tags.Methods['Regrowth'] = function(unit)
            if not UnitIsConnected(unit) then return '' end

            if UnitAura(unit, 'Regrowth') then
                return '|cff00FF10M|r'
            end
        end
        self.Tags.Events['Regrowth'] = 'UNIT_AURA PLAYER_AURAS_CHANGED'

        self.Indicators['TR'] = '[MotW]'
        self.Indicators['BL'] = '[Regrowth]'
    elseif class == 'MAGE' then
        self.Tags.Methods['AI'] = function(unit)
            if not UnitIsConnected(unit) then return '' end

            if not (UnitAura(unit, 'Arcane Brilliance') or
                    UnitAura(unit, 'Arcane Intellect')) then
                return '|cffffff00M|r'
            end
        end
        self.Tags.Events['AI'] = 'UNIT_AURA PLAYER_AURAS_CHANGED'

        self.Indicators['TR'] = '[AI]'
    elseif class == 'PRIEST' then
        self.Tags.Methods['FW'] = function(unit)
            if not UnitIsConnected(unit) or UnitIsDead(unit) then return '' end

            if UnitAura(unit, 'Fear Ward') then
                return '|cff8B4513M|r'
            end
        end
        self.Tags.Events['FW'] = 'UNIT_AURA PLAYER_AURAS_CHANGED'

        self.Tags.Methods['PW:S'] = function(unit)
            if not UnitIsConnected(unit) or UnitIsDead(unit) then return '' end

            if UnitAura(unit, 'Power Word: Shield') then
                return '|cff33FF33M|r'
            end
        end
        self.Tags.Events['PW:S'] = 'UNIT_AURA PLAYER_AURAS_CHANGED'

        self.Tags.Methods['PW:F'] = function(unit)
            if not UnitIsConnected(unit) or UnitIsDead(unit) then return '' end

            if not (UnitAura(unit, 'Prayer of Fortitude') or
                    UnitAura(unit, 'Power Word: Fortitude')) then
                return '|cff00A1DEM|r'
            end
        end
        self.Tags.Events['PW:F'] = 'UNIT_AURA PLAYER_AURAS_CHANGED'

        if level >= 30 then
            self.Tags.Methods['SP'] = function(unit)
                if not UnitIsConnected(unit) then return '' end

                if not (UnitAura(unit, 'Prayer of Shadow Protection') or
                        UnitAura(unit, 'Shadow Protection')) then
                    return '|cff9900FFM|r'
                end
            end
            self.Tags.Events['SP'] = 'UNIT_AURA PLAYER_AURAS_CHANGED'
        end

        if level >= 30 then
            self.Tags.Methods['DS'] = function(unit)
                if not UnitIsConnected(unit) then return '' end

                if not (UnitAura(unit, 'Prayer of Spirit') or
                        UnitAura(unit, 'Divine Spirit')) then
                    return '|cffFF9900M|r'
                end
            end
            self.Tags.Events['DS'] = 'UNIT_AURA PLAYER_AURAS_CHANGED'
        end

        self.Tags.Methods['Renew'] = function(unit)
            if not UnitIsConnected(unit) then return '' end

            if UnitAura(unit, 'Renew') then
                return '|cff33FF33M|r'
            end
        end
        self.Tags.Events['Renew'] = 'UNIT_AURA PLAYER_AURAS_CHANGED'

        self.Tags.Methods['Greater Heal'] = function(unit)
            if not UnitIsConnected(unit) then return '' end

            if UnitAura(unit, 'Greater Heal') then
                return '|cff559955M|r'
            end
        end
        self.Tags.Events['Greater Heal'] = 'UNIT_AURA PLAYER_AURAS_CHANGED'

        self.Tags.Methods['Abolish Disease'] = function(unit)
            if not UnitIsConnected(unit) then return '' end

            if UnitAura(unit, 'Abolish Disease') then
                return '|cffAAFF33M|r'
            end
        end
        self.Tags.Events['Abolish Disease'] = 'UNIT_AURA PLAYER_AURAS_CHANGED'

        self.Tags.Methods['WS'] = function(unit)
            if not UnitIsConnected(unit) then return '' end

            if UnitAura(unit, 'Weakened Soul', 'HARMFUL') then
                return '|cffFF9900M|r'
            end
        end
        self.Tags.Events['WS'] = 'UNIT_AURA PLAYER_AURAS_CHANGED'

        self.Indicators['TL'] = '[PW:S][WS]'
        self.Indicators['TR'] = '[PW:F][FW]'

        self.Indicators['TR'] = self.Indicators['TR'] .. '[DS][SP]'

        self.Indicators['BL'] = '[Renew][Greater Heal][Abolish Disease]'
    elseif class == 'WARRIOR' then
        self.Tags.Methods['BS'] = function(unit)
            if not UnitIsConnected(unit) then return '' end

            if UnitAura(unit, 'Battle Shout') then
                return '|cffff0000M|r'
            end
        end
        self.Tags.Events['BS'] = 'UNIT_AURA PLAYER_AURAS_CHANGED'

        self.Indicators['TR'] = '[BS]'
    end
end

oUF.InitializeTags = InitializeTags
