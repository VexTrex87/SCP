local ReplicatedStorage = game:GetService("ReplicatedStorage")
local aim = require(ReplicatedStorage.Modules.GunSystem.Aim)
local newThread = require(ReplicatedStorage.Modules.Core.NewThread)

return function(self)
    if self.temp.states.isReloading then
        return
    end
    
    if not self.temp.states.isAiming then
        newThread(aim, self, true)
    end

    if os.clock() - self.temp.timeOfRecentFire >= 60 / self.Configuration.gun.fireRate then
        self.temp.timeOfRecentFire = os.clock()
        local success, errorMessage = self.remotes.MouseEvent:InvokeServer(self.temp.mouse.Hit.Position)
        if not success and errorMessage == "NO_AMMO" then
            self.sounds.jam:Play()
        end
    end
end