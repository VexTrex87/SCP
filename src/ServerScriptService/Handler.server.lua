-- handles all server related code

-- // VARIABLES \\ --

-- services
local ServerStorage = game:GetService("ServerStorage")
local Players = game:GetService("Players")

-- libraries
local modules = ServerStorage.Modules
local newThread = require(modules.Core.NewThread)

-- modules
local createAnimator = require(modules.CreateAnimator)
local overrideAnimations = require(modules.OverrideAnimations)
local gunSystem = require(modules.GunSystem)
local npcHandler = require(modules.NPCHandler)

-- // EVENTS \\ --

Players.PlayerAdded:Connect(function(player)
    player.CharacterAdded:Connect(createAnimator)
    -- player.CharacterAppearanceLoaded:Connect(overrideAnimations)
end)

-- // COMPILE \\ --

newThread(gunSystem)
newThread(npcHandler)