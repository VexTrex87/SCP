local ServerStorage = game:GetService("ServerStorage")

local components = ServerStorage.Modules.GunSystem
local aim = require(components.Aim)
local reload = require(components.Reload)

return function(self, player, newState, ...)
    if player ~= self.owner then
        player:Kick("It looks like you tried to control " .. self.owner.Name .. "'s gun. (Attempted to fire " .. self.owner.Name .. "'s remote.)")
    end

    if newState == "EQUIP" or newState == "AIM_IN" then
        aim(self, true, ...)
    elseif newState == "UNEQUIP" or newState == "AIM_OUT" then
        aim(self, false, ...)
    elseif newState == "RELOAD" and self.temp.canFire then
        reload(self)
    end
end