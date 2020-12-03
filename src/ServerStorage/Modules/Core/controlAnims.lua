return function(animations: table)
    for x = 1, #animations, 2 do
        local currentAnimation = animations[x]
        local currentAnimationState = animations[x + 1]
        local willYield = true

        -- start/stop animation
        if currentAnimationState:lower():match("start") then
            currentAnimation:Play()
        elseif currentAnimationState:lower():match("stop") and currentAnimation.IsPlaying then
            currentAnimation:Stop()
        else
            willYield = false
        end

        -- yield until animation finishes
        if not currentAnimationState:lower():match("async") and willYield then
            if currentAnimationState.Looped then
                currentAnimation.DidLoop:Wait()
            else
                currentAnimation.Stopped:Wait()
            end
        end
    end
end