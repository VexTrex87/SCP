local ServerStorage = game:GetService("ServerStorage")

local core = ServerStorage.Modules.Core
local newThread = require(core.NewThread)
local playSound = require(core.PlaySound)
local waitForEventOrTimeout = require(core.WaitForEventOrTimeout)

return function(self)
    self.temp.canFire = false
    newThread(playSound, self.sounds.reload, self.handle)

    local toolWasUnequipped = waitForEventOrTimeout(self.tool.Unequipped, self.Configuration.gun.reloadDuration)
    if not toolWasUnequipped then
        self.values.ammo.Value = self.Configuration.gun.maxAmmo
        self.temp.canFire = true
    end
end