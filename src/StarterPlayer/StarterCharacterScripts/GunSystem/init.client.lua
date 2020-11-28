-- // VARIABLES \\ --

-- services
local CollectionService = game:GetService("CollectionService")

-- modules
local Settings = require(game.ReplicatedStorage.GunSystem.Settings.Global)
local core = require(game.ReplicatedStorage.Modules.Core)
local collection = core("collection")

-- objects
local player = game.Players.LocalPlayer

-- // FUNCTIONS \\ --

function init(tool)
    local backpack = player:WaitForChild("Backpack")
    if tool:IsDescendantOf(backpack) then
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

collection(Settings.gunTag, init)