local ReplicatedStorage = game:GetService("ReplicatedStorage")

local disconnectConnections = require(ReplicatedStorage.Modules.Core.DisconnectConnections)
local ThirdPersonCamera = require(ReplicatedStorage.Modules.ThirdPersonCamera)

local Crosshair = require(ReplicatedStorage.Modules.GunSystem.Components.Crosshair)
local GunInfoGUI = require(ReplicatedStorage.Modules.GunSystem.Components.GunInfoGUI)

return function(self)
    -- disable states
    self.temp.states.isEquipped = false
    self.temp.states.isReloading = false
    self.temp.states.isAiming = false

    disconnectConnections(self.temp.connections)
    ThirdPersonCamera:Disable()
    self.remotes.ChangeState:FireServer("UNEQUIP")

    -- stop all animations
    self.animations.runningHold:Stop()
    self.animations.hold:Stop()
    self.animations.aim:Stop()
    self.animations.reload:Stop()

    Crosshair.hide(self.Configuration.name)
    GunInfoGUI.hide({
        gunName = self.Configuration.name,
        gunIdentifier = self.Configuration.tag,
        fireMode = self.values.fireMode.Value,
        currentAmmo = self.values.ammo.Value,
        maxAmmo = self.Configuration.gun.maxAmmo,
    })
end