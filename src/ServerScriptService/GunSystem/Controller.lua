local module = {}

function module.createAnimatorOnPlayerJoin()
    game.Players.PlayerAdded:Connect(function(player)
        player.CharacterAdded:Connect(function(character)
            local newAnimator = Instance.new("Animator")
            newAnimator.Parent = character.Humanoid
        end)
    end)
end

return module