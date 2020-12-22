local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ThirdPersonCamera = require(ReplicatedStorage.Modules.ThirdPersonCamera)
local Crosshair = require(ReplicatedStorage.Modules.GunSystem.Crosshair)

return function(self, willAim: boolean, willZoom: boolean)

    if self.temp.states.isReloading then
        return
    end

    ThirdPersonCamera:SetActiveCameraSettings(willAim and willZoom and "ZoomedShoulder" or "DefaultShoulder")
    Crosshair.zoom(self.Configuration.tag, willAim and willZoom)
    
    self.temp.states.isAiming = willAim
    self.temp.states.isZoomed = willZoom

    if willAim then
        self.animations.hold:Stop()
        self.animations.aim:Play()
    else
        self.animations.aim:Stop()
        self.animations.hold:Play()
    end
    
    self.remotes.ChangeState:FireServer(willAim and "AIM_IN" or "AIM_OUT", willAim, willZoom)
end