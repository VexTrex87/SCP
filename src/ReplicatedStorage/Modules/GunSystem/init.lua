local module = {}

-- // VARIABLES \\ --

-- services
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local CollectionService = game:GetService("CollectionService")

-- modules
local Configuration = require(ReplicatedStorage.Modules.GunSystem.Configuration.Global)
local collection = require(ReplicatedStorage.Modules.Core.Collection)
local gunGui = require(game.ReplicatedStorage.Modules.GunSystem.GunInfoGUI)
local crosshair = require(game.ReplicatedStorage.Modules.GunSystem.GunCrosshair)

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
    collection(Configuration.gunTag, init)
end

-- // COMPILE \\ --

gunGui.create()
crosshair.create()

return module