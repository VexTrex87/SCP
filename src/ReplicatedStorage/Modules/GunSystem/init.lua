local module = {}

-- // VARIABLES \\ --

-- services
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local CollectionService = game:GetService("CollectionService")

-- modules
local Settings = require(script.Settings.Global)
local collection = require(ReplicatedStorage.Modules.Core.collection)
local gunGui = require(game.ReplicatedStorage.Modules.GunSystem.GunInfoGUI)

-- objects
local player = game.Players.LocalPlayer

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
        local gunModule = script.Guns:FindFirstChild(tag)
        if gunModule then
            require(gunModule).new(tool)
            break
        end
    end
end

function module.new()
    collection(Settings.gunTag, init)
end

-- // COMPILE \\ --

gunGui.create()

return module