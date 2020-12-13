local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local modules = ReplicatedStorage.Modules
local disconnectConnections = require(modules.Core.DisconnectConnections)

local components = modules.GunSystem
local GunInfoGUI = require(components.GunInfoGUI)
local onMouseMove = require(components.OnMouseMove)
local onMovementStateChanged = require(components.OnMovementStateChanged)
local onInputBegan = require(components.OnInputBegan)
local onInputEnded = require(components.OnInputEnded)
local onStepped = require(components.OnStepped)

return function(self)
    disconnectConnections(self.temp.connections)

    self.temp.connections.mouseMove = self.temp.mouse.Move:Connect(function()
        onMouseMove(self)
    end)

    self.temp.connections.movementStateChanged = self.movementStateChanged.Event:Connect(function(...)
        onMovementStateChanged(self, ...)
    end)

    self.temp.connections.ammoChanged = self.values.ammo.Changed:Connect(function()
        GunInfoGUI.update({
            gunName = self.Configuration.name,
            gunTag = self.Configuration.tag,
            fireMode = self.values.fireMode.Value,
            currentAmmo = self.values.ammo.Value,
            maxAmmo = self.Configuration.gun.maxAmmo,
        })
    end)

    self.temp.connections.inputBegan = UserInputService.InputBegan:Connect(function(...)
        onInputBegan(self, ...)
    end)

    self.temp.connections.inputEnded = UserInputService.InputEnded:Connect(function(...)
        onInputEnded(self, ...)
    end)

    if self.values.fireMode.Value == "AUTO" then	
        self.temp.connections.stepped = RunService.Stepped:Connect(function()
            onStepped(self)
        end)
    end
end