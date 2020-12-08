local roact = require(game.ReplicatedStorage.Modules.Roact)

return function()
	return roact.createElement("UICorner", {
		CornerRadius = UDim.new(0, 5)
	})
end