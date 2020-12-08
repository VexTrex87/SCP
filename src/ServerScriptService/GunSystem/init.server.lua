-- // VARIABLES \\ --

-- services
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerStorage = game:GetService("ServerStorage")
local CollectionService = game:GetService("CollectionService")

-- modules
local controller = require(script.Controller)
local Settings = require(game.ReplicatedStorage.Modules.GunSystem.Settings.Global)

-- libraries
local collection = require(game.ServerStorage.Modules.Core.collection)

-- objects
local gunModules = script.Guns

-- // FUNCTIONS \\ --

function init(tool)
    if tool.Parent:IsA("Backpack") then
        local tags = CollectionService:GetTags(tool)
        for _,tag in pairs(tags) do
            local module = gunModules:FindFirstChild(tag)
            if module then
                require(module).new(tool)
            end
        end
    end
end

-- // COMPILE \\ --

game.Players.PlayerAdded:Connect(function(player)
    player.CharacterAdded:Connect(controller.createAnimator)
    player.CharacterAppearanceLoaded:Connect(controller.overrideAnimations)
end)

collection(Settings.gunTag, init)