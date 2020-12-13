local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ThirdPersonCamera = require(ReplicatedStorage.Modules.ThirdPersonCamera)
local Crosshair = require(ReplicatedStorage.Modules.GunSystem.Crosshair)

return function(self, willAim: boolean)
    if self.temp.states.isReloading then
        return
    end

    ThirdPersonCamera:SetActiveCameraSettings(willAim and "ZoomedShoulder" or "DefaultShoulder")
    Crosshair.zoom(self.Configuration.tag, willAim)
    self.temp.states.isAiming = willAim

    if willAim then
        self.animations.aim:Play()
        self.remotes.ChangeState:FireServer("AIM_IN")
    else
        self.animations.aim:Stop()
        self.animations.hold:Play()
        self.remotes.ChangeState:FireServer("AIM_OUT")
    end
end