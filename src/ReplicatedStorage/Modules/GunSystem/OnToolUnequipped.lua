local ReplicatedStorage = game:GetService("ReplicatedStorage")

local disconnectConnections = require(ReplicatedStorage.Modules.Core.DisconnectConnections)
local newThread = require(ReplicatedStorage.Modules.Core.NewThread)
local ThirdPersonCamera = require(ReplicatedStorage.Modules.ThirdPersonCamera)

local gunComponents = ReplicatedStorage.Modules.GunSystem
local Crosshair = require(gunComponents.Crosshair)
local GunInfoGUI = require(gunComponents.GunInfoGUI)
local waistMovement = require(gunComponents.WaistMovement)

return function(self)
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

    self.animations.aim:Stop()
    self.animations.reload:Stop()
    self.animations.hold:Stop()
    if self.animations.runningHold then
        self.animations.runningHold:Stop()
    end

    local handle = self.tool:FindFirstChild("Handle")
    if handle then
        for _,sound in pairs(self.tool.Handle:GetChildren()) do
            if sound:IsA("Sound") then
                sound:Destroy()
            end
        end
    end

    waistMovement.stop()
    newThread(Crosshair.hide, self.Configuration.tag)
    newThread(GunInfoGUI.hide, {
        gunName = self.Configuration.name,
        gunTag = self.Configuration.tag,
        fireMode = self.values.fireMode.Value,
        magazineAmmo = self.values.magazineAmmo.Value,
        totalAmmo = self.values.totalAmmo.Value,
    })

end