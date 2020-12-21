local ReplicatedStorage = game:GetService("ReplicatedStorage")

local components = ReplicatedStorage.Modules.GunSystem
local onToolEquipped = require(components.OnToolEquipped)
local onToolUnequipped = require(components.OnToolUnequipped)
local indicateDamage = require(components.IndicateDamage)
local destroyGun = require(components.DestroyGun)

return function(self)
    self.tool.Equipped:Connect(function(...)
        onToolEquipped(self, ...)
    end)

    self.tool.Unequipped:Connect(function(...)
        onToolUnequipped(self, ...)
    end)

    self.remotes.DamageIndicator.OnClientEvent:Connect(function(...)
        indicateDamage(self, ...)
    end)

    self.humanoid.Died:Connect(function()
        destroyGun(self)
    end)
end