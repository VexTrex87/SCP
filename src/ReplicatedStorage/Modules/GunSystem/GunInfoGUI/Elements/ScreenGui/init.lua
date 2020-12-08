local createElement = require(game.ReplicatedStorage.Modules.Core.createElement)
local createFrame = require(script.Frame)

return function()
    return createElement("ScreenGui", {
		Name = "GunInfo"
	}, {
		Frame = createFrame()
	})
end