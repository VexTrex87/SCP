local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local modules = ReplicatedStorage.Modules
local disconnectConnections = require(modules.Core.DisconnectConnections)
local ThirdPersonCamera = require(modules.ThirdPersonCamera)

local components = modules.GunSystem.Components
local GunInfoGUI = require(components.GunInfoGUI)
local onMouseMove = require(components.OnMouseMove)
local onStateChanged = require(components.OnStateChanged)
local onActiveCameraSettingsChanged = require(components.OnActiveCameraSettingsChanged)
local onInputBegan = require(components.OnInputBegan)
local onInputEnded = require(components.OnInputEnded)
local onStepped = require(components.OnStepped)

return function(self)
    disconnectConnections(self.temp.connections)

    self.temp.connections.mouseMove = self.temp.mouse.Move:Connect(function()
        onMouseMove(self)
    end)

    self.temp.connections.stateChanged = self.stateChangedEvent.Event:Connect(function(...)
        onStateChanged(self, ...)
    end)

    self.temp.connections.ammoChanged = self.values.ammo.Changed:Connect(function()
        GunInfoGUI.update({
            gunName = self.Configuration.name,
            gunIdentifier = self.Configuration.tag,
            fireMode = self.values.fireMode.Value,
            currentAmmo = self.values.ammo.Value,
            maxAmmo = self.Configuration.gun.maxAmmo,
        })
    end)

    self.temp.connections.activeCameraSettingsChanged = ThirdPersonCamera.ActiveCameraSettingsChanged:Connect(function(...)
        onActiveCameraSettingsChanged(self, ...)
    end)

    self.temp.connections.inputBegan = UserInputService.InputBegan:Connect(function(...)
        onInputBegan(self, ...)
    end)

    if self.values.fireMode.Value == "AUTO" then	
        self.temp.connections.inputEnded = UserInputService.InputEnded:Connect(function(...)
            onInputEnded(self, ...)
        end)
    
        self.temp.connections.stepped = RunService.Stepped:Connect(function()
            onStepped(self)
        end)
    end
end