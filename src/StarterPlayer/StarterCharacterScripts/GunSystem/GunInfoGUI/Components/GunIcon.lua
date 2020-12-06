local roact = require(game.ReplicatedStorage.Modules.Roact)

return function(icon)
	return roact.createElement("ImageLabel", {
		BackgroundColor3 = Color3.fromRGB(100, 100, 100),
		BackgroundTransparency = 1,
		Position = UDim2.new(1, -300, 1, -120),
		Size = UDim2.new(0, 250, 0, 100),
		Image = icon,
		ScaleType = Enum.ScaleType.Fit
	})
end