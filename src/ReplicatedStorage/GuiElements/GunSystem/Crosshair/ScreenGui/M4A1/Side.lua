local ReplicatedStorage = game:GetService("ReplicatedStorage")
local CreateElement = require(ReplicatedStorage.Modules.Core.CreateElement)

local Configuration = require(ReplicatedStorage.Modules.GunSystem.Configuration.Global).gunCrosshair[script.Parent.Name]
local createUICorner = require(ReplicatedStorage.GuiElements.UICorner)

return function(anchorPoint: UDim, Name: String, Position: UDim2, Size: UDim2): instance
	return CreateElement("Frame", {
		AnchorPoint = anchorPoint,
		BackgroundColor3 = Configuration.NeutralColor,
		Name = Name,
		Position = Position,
		Size = Size,
	}, {
		UICorner = createUICorner(UDim.new(0, 2))
	})
end