-- handles all server related code

-- add animator to humanoid & overrides animations
local createAnimator = require(game.ServerStorage.Modules.CreateAnimator)
local overrideAnimations = require(game.ServerStorage.Modules.OverrideAnimations)

game.Players.PlayerAdded:Connect(function(player)
    player.CharacterAdded:Connect(createAnimator)
    player.CharacterAppearanceLoaded:Connect(overrideAnimations)
end)

-- gun system
local gunSystem = require(game.ServerStorage.Modules.GunSystem)
gunSystem()