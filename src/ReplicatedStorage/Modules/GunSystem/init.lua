--[[
    Creates the GunGui & Crosshair.
    Runs a specific gun controller when a tool is added.
]]

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local CollectionService = game:GetService("CollectionService")
local Players = game:GetService("Players")

local gunConfigurations = ReplicatedStorage.Configuration.GunSystem
local GlobalConfiguration = require(gunConfigurations.Global)
local collection = require(ReplicatedStorage.Modules.Core.Collection)

local components = ReplicatedStorage.Modules.GunSystem
local GunInfoGUI = require(components.GunInfoGUI)
local Crosshair = require(components.Crosshair)
local newGun = require(components.NewGun)

return function()
    GunInfoGUI.create()
    Crosshair.create()

    collection(GlobalConfiguration.gunTag, function(tool)
        -- check if tool is in a player's backpack
        local backpack = Players.LocalPlayer:WaitForChild("Backpack")
        if not tool:IsDescendantOf(backpack) then
            return
        end

        -- run controller
        local tags = CollectionService:GetTags(tool)
        for _,tag in pairs(tags) do
            if gunConfigurations:FindFirstChild(tag) then
                newGun(tool, tag)
                break
            end
        end
    end)
end