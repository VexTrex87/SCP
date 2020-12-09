local ReplicatedStorage = game:GetService("ReplicatedStorage")
local CreateElement = require(ReplicatedStorage.Modules.Core.CreateElement)

return function(cornerRadius: UDim): instance
	return CreateElement("UICorner", {
		CornerRadius = cornerRadius
	})
end