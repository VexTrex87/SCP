local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Crosshair = require(ReplicatedStorage.Modules.GunSystem.Components.Crosshair)

return function(self, newCameraSettings: String)
    self.temp.states.isAiming = newCameraSettings == "ZoomedShoulder"

    if newCameraSettings == "DefaultShoulder" then
        self.animations.aim:Stop()
        self.animations.hold:Play()
        Crosshair.zoom(self.Configuration.name, false)
        self.remotes.ChangeState:FireServer("AIM_OUT")
    elseif newCameraSettings == "ZoomedShoulder" then
        self.animations.aim:Play()
        Crosshair.zoom(self.Configuration.name, true)
        self.remotes.ChangeState:FireServer("AIM_IN")
    end
end