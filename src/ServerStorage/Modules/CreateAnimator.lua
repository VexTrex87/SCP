return function(character)
    local humanoid = character:WaitForChild("Humanoid")
    local newAnimator = Instance.new("Animator")
    newAnimator.Parent = humanoid
end