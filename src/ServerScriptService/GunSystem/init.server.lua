-- // VARIABLES \\ --

-- services
local CollectionService = game:GetService("CollectionService")

-- modules
local controller = require(script.Controller)
local Settings = require(game.ReplicatedStorage.GunSystem.Settings.Global)

-- libraries
local core = require(game.ReplicatedStorage.Modules.Core)
local collection = core("collection")

-- // FUNCTIONS \\ --

function init(tool)
    if tool.Parent:IsA("Backpack") then
        local tags = CollectionService:GetTags(tool)
        for _,tag in pairs(tags) do
            local module = script:WaitForChild(tag, 1)
            if module then
                require(module).new(tool)
            end
        end
    end
end

-- // COMPILE \\ --

game.Players.PlayerAdded:Connect(function(player)
    player.CharacterAdded:Connect(controller.createAnimator)
end)

collection(Settings.gunTag, init)