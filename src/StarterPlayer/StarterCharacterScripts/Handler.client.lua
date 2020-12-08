-- handles all client related code dependent of a client's character

-- // VARIABLES \\ --

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local newThread = require(ReplicatedStorage.Modules.Core.newThread)
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