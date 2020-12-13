local ReplicatedStorage = game:GetService("ReplicatedStorage")

local modules = ReplicatedStorage.Modules
local ThirdPersonCamera = require(modules.ThirdPersonCamera)

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

    Crosshair.show(self.Configuration.tag)
    GunInfoGUI.show({
        gunName = self.Configuration.name,
        gunTag = self.Configuration.tag,
        fireMode = self.values.fireMode.Value,
        currentAmmo = self.values.ammo.Value,
        maxAmmo = self.Configuration.gun.maxAmmo,
    })

    initEquipEvents(self)
end