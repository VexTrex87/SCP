-- // VARIABLES \\ --

-- services
local CollectionService = game:GetService("CollectionService")

-- modules
local Settings = require(game.ReplicatedStorage.GunSystem.Settings.Global)

-- libraries
local core = require(game.ReplicatedStorage.Modules.Core)
local collection = core("collection")

-- objects
local player = game.Players.LocalPlayer
local gunModules = script:WaitForChild("Guns")

-- // FUNCTIONS \\ --

function init(tool)
    -- check if tool is in a player's backpack
    local backpack = player:WaitForChild("Backpack")
    if not tool:IsDescendantOf(backpack) then
        return
    end

    -- find module
    local tags = CollectionService:GetTags(tool)
    for _,tag in pairs(tags) do
        local module = gunModules:WaitForChild(tag, 1)
        if module then
            require(module).new(tool)
            break
        end
    end
end

-- // COMPILE \\ --

collection(Settings.gunTag, init)