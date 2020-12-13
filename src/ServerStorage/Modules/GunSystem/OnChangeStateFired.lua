local ServerStorage = game:GetService("ServerStorage")

local core = ServerStorage.Modules.Core
local newThread = require(core.NewThread)
local playSound = require(core.PlaySound)

return function(self, player, newState)
    -- check if person who fired remote is the gun owner
    if player ~= self.owner then
        player:Kick("It looks like you tried to control " .. self.owner.Name .. "'s gun. (Attempted to fire " .. self.owner.Name .. "'s remote.)")
    end

    -- run states
    if newState == "EQUIP" or newState == "AIM_IN" then
        newThread(playSound, self.sounds.equip, self.handle)
        self.handle.Equip:Play()
    elseif newState == "UNEQUIP" or newState == "AIM_OUT" then
        newThread(playSound, self.sounds.unequip, self.handle)
    elseif newState == "RELOAD" and self.temp.canFire then
        self.temp.canFire = false
        newThread(playSound, self.sounds.reload, self.handle)
        wait(self.Configuration.gun.reloadDuration)
        self.values.ammo.Value = self.Configuration.gun.maxAmmo
        self.temp.canFire = true
    end
end