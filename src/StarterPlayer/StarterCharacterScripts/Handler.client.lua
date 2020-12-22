--[[
    Handles all client related code dependent of a client's character
]]

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local modules = ReplicatedStorage.Modules
local newThread = require(modules.Core.NewThread)
local character = script.Parent

newThread(function()
    local movement = require(modules.Movement)
    movement.new(character)
end)

newThread(function()
    local gunSystem = require(modules.GunSystem)
    gunSystem()
end)

newThread(function()
    local effectsListener = require(modules.EffectsListener)
    effectsListener()
end)

newThread(function()
    local waistMovement = require(modules.WaistMovement)
    waistMovement.init()
end)