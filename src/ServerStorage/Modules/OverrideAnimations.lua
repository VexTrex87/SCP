return function(character)
    local humanoid = character.Humanoid
    local animateScript = character:WaitForChild("Animate")

    -- stop animations
	for _, playingTracks in pairs(humanoid:GetPlayingAnimationTracks()) do
		playingTracks:Stop(0)
	end

    -- override animations
	animateScript.run.RunAnim.AnimationId = "rbxassetid://6017465551"        -- Run
	animateScript.walk.WalkAnim.AnimationId = "rbxassetid://6017464754"      -- Walk
	animateScript.jump.JumpAnim.AnimationId = "rbxassetid://6017467008"      -- Jump
	animateScript.idle.Animation1.AnimationId = "rbxassetid://6017469099"    -- Idle (Variation 1)
	animateScript.idle.Animation2.AnimationId = "rbxassetid://616160636"    -- Idle (Variation 2)
	animateScript.fall.FallAnim.AnimationId = "rbxassetid://6017467677"      -- Fall
	animateScript.swim.Swim.AnimationId = "rbxassetid://616165109"          -- Swim (Active)
	animateScript.swimidle.SwimIdle.AnimationId = "rbxassetid://616166655"  -- Swim (Idle)
	animateScript.climb.ClimbAnim.AnimationId = "rbxassetid://6017466326"    -- Climb
end