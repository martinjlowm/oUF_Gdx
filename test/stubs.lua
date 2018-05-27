local globals = {}

globals.UnitClass = stub()
globals.UnitIsUnit = stub()
globals.UnitReaction = stub()
globals.UnitAura = stub()
globals.CooldownFrame_SetTimer = stub()
globals.GetBuildInfo = stub().returns('1.0')
globals.GetAddOnInfo = stub().returns('')
globals.GetNumAddOns = stub().returns(1)
globals.GetAddOnMetadata = stub()
globals.geterrorhandler = stub().returns(function() end)
globals.CreateFrame = stub().returns({})

return globals
