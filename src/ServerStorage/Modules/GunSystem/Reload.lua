local ServerStorage = game:GetService("ServerStorage")

local core = ServerStorage.Modules.Core
local newThread = require(core.NewThread)
local playSound = require(core.PlaySound)

return function(self)
    self.temp.canFire = false
    newThread(playSound, self.sounds.reload, self.handle)
    wait(self.Configuration.gun.reloadDuration)
    print(self.temp.isEquipped)
    if self.temp.isEquipped and self.values.ammo.Value ~= self.Configuration.gun.maxAmmo then
        self.values.ammo.Value = self.Configuration.gun.maxAmmo
        self.temp.canFire = true
    end
end