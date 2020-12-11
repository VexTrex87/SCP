local ReplicatedStorage = game:GetService("ReplicatedStorage")
local CreateElement = require(ReplicatedStorage.Modules.Core.CreateElement)

local Configuration = require(ReplicatedStorage.Configuration.GunSystem[script.Parent.Name])
local createUICorner = require(ReplicatedStorage.GuiElements.UICorner)

return function(): instance
	return CreateElement("Frame", {
		AnchorPoint = Vector2.new(0.5, 0.5),
		BackgroundColor3 = Configuration.NeutralColor,
		Name = "Center",
		Position = UDim2.new(0.5, 0, 0.5, 0),
		Size = UDim2.new(0, 4, 0, 4),
	}, {
		UICorner = createUICorner(UDim.new(0, 2))
	})
end