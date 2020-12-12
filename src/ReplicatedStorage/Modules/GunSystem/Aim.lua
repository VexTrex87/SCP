local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ThirdPersonCamera = require(ReplicatedStorage.Modules.ThirdPersonCamera)
local Crosshair = require(ReplicatedStorage.Modules.GunSystem.Crosshair)

return function(self, willAim: boolean)
    if self.temp.states.isReloading then
        return
    end

    ThirdPersonCamera:SetActiveCameraSettings(willAim and "ZoomedShoulder" or "DefaultShoulder")
    self.temp.states.isAiming = willAim

    if willAim then
        self.animations.aim:Play()
        Crosshair.zoom(self.Configuration.tag, true)
        self.remotes.ChangeState:FireServer("AIM_IN")
    else
        self.animations.aim:Stop()
        self.animations.hold:Play()
        Crosshair.zoom(self.Configuration.tag, false)
        self.remotes.ChangeState:FireServer("AIM_OUT")
    end
end