local ReplicatedStorage = game:GetService("ReplicatedStorage")

local disconnectConnections = require(ReplicatedStorage.Modules.Core.DisconnectConnections)
local ThirdPersonCamera = require(ReplicatedStorage.Modules.ThirdPersonCamera)

local Crosshair = require(ReplicatedStorage.Modules.GunSystem.Crosshair)
local GunInfoGUI = require(ReplicatedStorage.Modules.GunSystem.GunInfoGUI)

return function(self)
    -- disable states
    self.temp.states.isEquipped = false
    self.temp.states.isReloading = false
    self.temp.states.isAiming = false
    self.temp.states.isMouseDown = false
    self.temp.states.currentAnimationState = "WALK"

    disconnectConnections(self.temp.connections)
    self.remotes.ChangeState:FireServer("UNEQUIP")
    if ThirdPersonCamera.IsEnabled then
        ThirdPersonCamera:Disable()
    end

    -- stop all animations
    self.animations.aim:Stop()
    self.animations.reload:Stop()
    self.animations.hold:Stop()
    if self.animations.runningHold then
        self.animations.runningHold:Stop()
    end

    -- stop all sounds
    for _,sound in pairs(self.tool.Handle:GetChildren()) do
        if sound:IsA("Sound") then
            sound:Destroy()
        end
    end

    -- hide GUI
    Crosshair.hide(self.Configuration.tag)
    GunInfoGUI.hide({
        gunName = self.Configuration.name,
        gunTag = self.Configuration.tag,
        fireMode = self.values.fireMode.Value,
        magazineAmmo = self.values.magazineAmmo.Value,
        totalAmmo = self.values.totalAmmo.Value,
    })
end