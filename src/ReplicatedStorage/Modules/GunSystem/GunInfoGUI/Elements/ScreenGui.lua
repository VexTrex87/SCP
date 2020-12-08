local createElement = require(game.ReplicatedStorage.Modules.Core.createElement)
local createFrame = require(script.Parent.Frame)

return function()
    return createElement("ScreenGui", {
		Name = "GunInfo"
	}, {
		Frame = createFrame()
	})
end