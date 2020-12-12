--[[
    Handles all client related code dependent of a client's character
]]

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local modules = ReplicatedStorage.Modules
local newThread = require(modules.Core.NewThread)
local character = script.Parent

-- movement
newThread(function()
    local movement = require(modules.Movement)
    movement.new(character)
end)

-- gun system
newThread(function()
    local gunSystem = require(modules.GunSystem)
    gunSystem()
end)