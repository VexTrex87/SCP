local Debris = game:GetService("Debris")

return function(smoke, newSmokeParent, deactivateDelay, despawnDelay)
	local newSmoke = smoke:Clone()
	newSmoke.Enabled = true
	newSmoke.Parent = newSmokeParent
	Debris:AddItem(newSmoke, despawnDelay)

	wait(deactivateDelay)
	newSmoke.Enabled = false
end