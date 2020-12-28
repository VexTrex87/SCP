local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Aim = require(ReplicatedStorage.Modules.GunSystem.Aim)

return function(self)
    if self.temp.states.isAiming then
        Aim(self, false, false)
    end

    if self.temp.states.isReloading or 
        self.temp.states.currentAnimationState ~= "WALK" or 
        self.temp.states.isMouseDown
    then
        return
    end

    self.temp.states.isReloading = true
    self.remotes.ChangeState:FireServer("RELOAD")
    self.animations.reload:Play()
    self.animations.reload.Stopped:Wait()
    self.animations.hold:Play()
    self.temp.states.isReloading = false
end