local ReplicatedStorage = game:GetService("ReplicatedStorage")
local CreateElement = require(ReplicatedStorage.Modules.Core.CreateElement)

return function(): instance
	local children = {}
	for _,frame in pairs(script:GetChildren()) do
		children[frame.Name] = require(frame)()
	end

	return CreateElement("ScreenGui", {
		Name = "Crosshair"
	}, children)
end