local Debris = game:GetService("Debris")

return function(light, lightParent, despawnDelay)
	local newMuzzleLight = light:Clone()
	newMuzzleLight.Enabled = true
	newMuzzleLight.Parent = lightParent
	Debris:AddItem(newMuzzleLight, despawnDelay)
end