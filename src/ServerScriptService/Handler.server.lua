-- handles all server related code

-- // VARIABLES \\ --

local ServerStorage = game:GetService("ServerStorage")
local Players = game:GetService("Players")

local modules = ServerStorage.Modules
local newThread = require(ServerStorage.Modules.Core.newThread)

local createAnimator = require(modules.CreateAnimator)
local overrideAnimations = require(modules.OverrideAnimations)
local gunSystem = require(modules.GunSystem)
local npcHandler = require(modules.NPCHandler)

-- // EVENTS \\ --

Players.PlayerAdded:Connect(function(player)
    player.CharacterAdded:Connect(createAnimator)
    player.CharacterAppearanceLoaded:Connect(overrideAnimations)
end)

-- // COMPILE \\ --

newThread(gunSystem)
newThread(npcHandler)