-- handles all client related code dependent of a client's character

-- // VARIABLES \\ --

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local core = require(ReplicatedStorage.Modules.Core)
local newThread = core("newThread")
local character = script.Parent

-- // COMPILE \\ --

-- movement
newThread(function()
    local movement = require(ReplicatedStorage.Modules.Movement)
    movement.new(character)
end)

-- gun system
newThread(function()
    local gunSystem = require(ReplicatedStorage.Modules.GunSystem)
    gunSystem.new()
end)