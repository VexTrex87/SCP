local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Configuration = require(ReplicatedStorage.Configuration.CharacterAnimation)

return function(character)
    local humanoid = character.Humanoid
    local animateScript = character:WaitForChild("Animate")

    -- stop animations
	for _, playingTracks in pairs(humanoid:GetPlayingAnimationTracks()) do
		playingTracks:Stop(0)
	end

    -- override animations
	animateScript.run.RunAnim.AnimationId = Configuration.run
	animateScript.walk.WalkAnim.AnimationId = Configuration.walk
	animateScript.jump.JumpAnim.AnimationId = Configuration.jump
	animateScript.idle.Animation1.AnimationId = Configuration.idle1
	animateScript.idle.Animation2.AnimationId = Configuration.idle2
	animateScript.fall.FallAnim.AnimationId = Configuration.fall
	animateScript.swim.Swim.AnimationId = Configuration.swim
	animateScript.swimidle.SwimIdle.AnimationId = Configuration.swimIdle
	animateScript.climb.ClimbAnim.AnimationId = Configuration.climb
end