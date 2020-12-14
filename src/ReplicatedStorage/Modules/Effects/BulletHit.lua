local Debris = game:GetService("Debris")

return function(effect, hitPart, CFrame, deactivationDelay, despawnDelay)
	local attachment = Instance.new("Attachment")
	attachment.CFrame = CFrame
	attachment.Parent = workspace.Terrain

	local particle = effect:Clone()
	particle.Color = ColorSequence.new({
		ColorSequenceKeypoint.new(0, hitPart.Color),
		ColorSequenceKeypoint.new(0.5, hitPart.Color),
		ColorSequenceKeypoint.new(1, hitPart.Color)
	})
	particle.Parent = attachment

	-- Deactivate particle shortly before despawning so it isn't at max power when despawning
	Debris:AddItem(attachment, despawnDelay or particle.Lifetime.Max)
	particle.Enabled = true
	wait(deactivationDelay)
	particle.Enabled = false
end