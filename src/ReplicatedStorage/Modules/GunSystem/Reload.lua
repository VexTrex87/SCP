local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Aim = require(ReplicatedStorage.Modules.GunSystem.Aim)

return function(self)
    if self.temp.states.isAiming then
        Aim(self, false, false)
    end

    print(self.temp.states.isReloading )
    print(self.temp.states.currentAnimationState ~= "WALK" )
    print(self.temp.states.isMouseDown)
    print(self.values.totalAmmo.Value <= 0)
    warn("-----------------")

    if self.temp.states.isReloading or 
        self.temp.states.currentAnimationState ~= "WALK" or 
        self.temp.states.isMouseDown or
        self.values.totalAmmo.Value <= 0
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