--[[
    Creates the GunGui & Crosshair.
    Runs a specific gun controller when a tool is added.
]]

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local CollectionService = game:GetService("CollectionService")
local Players = game:GetService("Players")

local GlobalConfiguration = require(ReplicatedStorage.Configuration.GunSystem.Global)
local collection = require(ReplicatedStorage.Modules.Core.Collection)
local GunInfoGUI = require(ReplicatedStorage.Modules.GunSystem.Components.GunInfoGUI)
local Crosshair = require(ReplicatedStorage.Modules.GunSystem.Components.Crosshair)

GunInfoGUI.create()
Crosshair.create()

return function()
    collection(GlobalConfiguration.gunTag, function(tool)
        -- check if tool is in a player's backpack
        local backpack = Players.LocalPlayer:WaitForChild("Backpack")
        if not tool:IsDescendantOf(backpack) then
            return
        end

        -- find module
        local tags = CollectionService:GetTags(tool)
        for _,tag in pairs(tags) do
            local controller = script.Controllers:FindFirstChild(tag)
            if controller then
                require(controller)(tool)
                break
            end
        end
    end)
end