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

    disconnectConnections(self.temp.connections)
    ThirdPersonCamera:Disable()
    self.remotes.ChangeState:FireServer("UNEQUIP")

    -- stop all animations
    self.animations.aim:Stop()
    self.animations.reload:Stop()
    self.animations.hold:Stop()
    if self.animations.runningHold then
        self.animations.runningHold:Stop()
    end

    Crosshair.hide(self.Configuration.tag)
    GunInfoGUI.hide({
        gunName = self.Configuration.name,
        gunTag = self.Configuration.tag,
        fireMode = self.values.fireMode.Value,
        currentAmmo = self.values.ammo.Value,
        maxAmmo = self.Configuration.gun.maxAmmo,
    })
end