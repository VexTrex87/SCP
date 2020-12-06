local roact = require(game.ReplicatedStorage.Modules.Roact)
local createUICorner = require(script.Parent.UICorner)

return function()
	return roact.createElement("Frame", {
		BackgroundColor3 = Color3.fromRGB(180, 180, 180),
		BackgroundTransparency = 0.5,
		Position = UDim2.new(1, -300, 1, -120),
		Size = UDim2.new(0, 250, 0, 2),
	}, {
		UICorner = createUICorner()
	})
end