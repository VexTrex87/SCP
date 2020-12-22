local ServerStorage = game:GetService("ServerStorage")

local core = ServerStorage.Modules.Core
local newThread = require(core.NewThread)
local playSound = require(core.PlaySound)
local waitForEventOrTimeout = require(core.WaitForEventOrTimeout)

return function(self)
    if self.values.totalAmmo.Value <= 0 or self.values.magazineAmmo.Value == self.Configuration.gun.magazineAmmo then
        return
    end

    self.temp.canFire = false
    newThread(playSound, self.sounds.reload, self.handle)

    local toolWasUnequipped = waitForEventOrTimeout(self.tool.Unequipped, self.Configuration.gun.reloadDuration)
    if not toolWasUnequipped then
        local amountToGive = self.Configuration.gun.magazineAmmo - self.values.magazineAmmo.Value
        if self.values.totalAmmo.Value <= amountToGive then
            amountToGive = self.values.totalAmmo.Value
        end

        self.values.magazineAmmo.Value += amountToGive
        self.values.totalAmmo.Value -= amountToGive
        self.temp.canFire = true
    end
end