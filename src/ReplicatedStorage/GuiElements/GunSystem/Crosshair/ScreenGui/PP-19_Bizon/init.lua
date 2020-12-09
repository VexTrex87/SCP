local ReplicatedStorage = game:GetService("ReplicatedStorage")
local CreateElement = require(ReplicatedStorage.Modules.Core.CreateElement)

local createSide = require(script.Side)
local createCenter = require(script.Center)

return function(): instance
	return CreateElement("Frame", {
		AnchorPoint = Vector2.new(0.5, 0.5),
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		Name = script.Name,
		Position = UDim2.new(0.5, 0, 0.5, 0),
		Size = UDim2.new(0, 114, 0, 114),
		Visible = false,
	}, {
		bottom = createSide(Vector2.new(0.5, 0), "Bottom", UDim2.new(0.5, 0, 1, -12), UDim2.new(0, 2, 0, 12)),
		top = createSide(Vector2.new(0.5, 0), "Top", UDim2.new(0.5, 0, 0, 0), UDim2.new(0, 2, 0, 12)),
		left = createSide(Vector2.new(0, 0.5), "Left", UDim2.new(0, 0, 0.5, 0), UDim2.new(0, 12, 0, 2)),
		right = createSide(Vector2.new(0, 0.5), "Right", UDim2.new(1, -12, 0.5, 0), UDim2.new(0, 12, 0, 2)),
		center = createCenter(),
	})
end