local ServerStorage = game:GetService("ServerStorage")

local core = ServerStorage.Modules.Core
local newThread = require(core.NewThread)
local playSound = require(core.PlaySound)

return function(self, willAim)
    newThread(playSound, willAim and self.sounds.equip or self.sounds.unequip, self.handle)
    if not willAim then
        self.temp.canFire = true
        for _,sound in pairs(self.handle:GetChildren()) do
            if sound:IsA("Sound") then
                sound:Destroy()
            end
        end
    end
end