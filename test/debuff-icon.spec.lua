package.path = package.path .. ';./libs/wowmock/?.lua'

local wowmock = require('wowmock')

assert(loadfile('./test/lua.lua'))()

local env = getfenv(1)

-- Populate environment with stubs
local stubs = assert(loadfile('./test/stubs.lua'))
setfenv(stubs, env)

for k, v in next, stubs() do
    env[k] = v
end

_G.oUF = {
    RegisterStyle = function() end,
    Factory = function() end,
}

local io = require('io')

local file = io.open('oUF_Gdx.toc', 'rb')
if not file then
    return nil
end

local content = file:read('*a')
file:close()

for line in string.gmatch(content, '(libs\\.-%.lua)') do
    local path = string.gsub(line, '\\', '/')
    local f = loadfile('./' .. path)
    setfenv(f, env)
    f()
end

local addon, globals

describe("Raid frame debuff icon", function()

             addon = {}

             local f, s
             before_each(function()
                     globals = stubs()

                     globals.UnitClass.returns('Priest', 'PRIEST')
                     globals.UnitIsUnit.returns(true)
                     globals.UnitReaction.returns(5)
                     globals.DebuffTypeColor = {}

                     globals.TEST_BRIDGE = {}

                     wowmock('./src/layout.lua', globals)

                     s = spy.new(function() end)
                     f = CreateFrame('Frame')
                     f.unit = 'raid1'
                     f.DebuffIcon = {
                         Overlay = {
                             SetVertexColor = function() end,
                         },
                         Count = {
                             SetText = function() end,
                             SetParent = function() end,
                         },
                         Texture = {
                             SetTexture = function() end,
                         },
                         Show = s, Hide = function() end
                     }

             end)

             after_each(function()
                     s:clear()
             end)


             it("should show dispelable debuff for a certain class", function()
                    globals.UnitAura
                        .on_call_with('raid1', 1, 'HARMFUL')
                        .returns('Frost Nova', nil, '', 0, 'Magic', 5, 5)

                    globals.TEST_BRIDGE.UNIT_AURA(f, 'UNIT_AURA', 'raid1')

                    assert.spy(s).was.called()
             end)

             it("should show tracked debuff", function()
                    globals.UnitAura
                        .on_call_with('raid1', 1, 'HARMFUL')
                        .returns('Frost Blast', nil, '', 0, nil, 5, 5)

                    globals.TEST_BRIDGE.UNIT_AURA(f, 'UNIT_AURA', 'raid1')

                    assert.spy(s).was.called()
             end)

             it("should not show debuff that cannot be dispelled by a certain class", function()
                    globals.UnitAura
                        .on_call_with('raid1', 1, 'HARMFUL')
                        .returns('Some Poison', nil, '', 0, 'Poison', 5, 5)

                    globals.TEST_BRIDGE.UNIT_AURA(f, 'UNIT_AURA', 'raid1')

                    assert.spy(s).was_not.called()
             end)

             it("should show cooldown buffs", function()
                    globals.UnitAura
                        .on_call_with('raid1', 1)
                        .returns('Innervate', nil, '', 0, 'Magic', 5, 5)

                    local res = globals.TEST_BRIDGE.UNIT_AURA(f, 'UNIT_AURA', 'raid1')

                    assert.spy(s).was.called()
             end)
end)
