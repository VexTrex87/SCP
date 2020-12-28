local ReplicatedStorage = game:GetService("ReplicatedStorage")

local modules = ReplicatedStorage.Modules
local ThirdPersonCamera = require(modules.ThirdPersonCamera)
local waistMovement = require(modules.WaistMovement)
local newThread = require(modules.Core.NewThread)

local components = modules.GunSystem
local Crosshair = require(components.Crosshair)
local GunInfoGUI = require(components.GunInfoGUI)
local initEquipEvents = require(components.InitEquipEvents)

return function(self, mouse)
    self.temp.states.isEquipped = true
    self.temp.mouse = mouse
    self.animations.hold:Play()
    self.remotes.ChangeState:FireServer("EQUIP")
    
    if not ThirdPersonCamera.IsEnabled then
        ThirdPersonCamera:Enable()
        ThirdPersonCamera:SetCharacterAlignment(true)
    end

    newThread(waistMovement.start)
    newThread(Crosshair.show, self.Configuration.tag)
    newThread(GunInfoGUI.show, {
        gunName = self.Configuration.name,
        gunTag = self.Configuration.tag,
        fireMode = self.values.fireMode.Value,
        ammo = self.values.ammo.Value,
        totalAmmo = self.Configuration.gun.ammo,
    })

    initEquipEvents(self)
end