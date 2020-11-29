local module = {}

function module.createAnimator(character)
    local newAnimator = Instance.new("Animator")
    newAnimator.Parent = character.Humanoid
end

return module