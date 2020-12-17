local ServerStorage = game:GetService("ServerStorage")

local core = ServerStorage.Modules.Core
local newThread = require(core.NewThread)
local playSound = require(core.PlaySound)
local waitForEventOrTimeout = require(core.WaitForEventOrTimeout)

return function(self)
    if self.values.totalAmmo.Value <= 0 then
        return
    end

    self.temp.canFire = false
    newThread(playSound, self.sounds.reload, self.handle)

    local toolWasUnequipped = waitForEventOrTimeout(self.tool.Unequipped, self.Configuration.gun.reloadDuration)
    if not toolWasUnequipped then
        self.values.totalAmmo.Value -= self.Configuration.gun.magazineAmmo - self.values.magazineAmmo.Value
        self.values.magazineAmmo.Value = self.Configuration.gun.magazineAmmo
        self.temp.canFire = true
    end
end