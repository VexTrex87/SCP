local createElement = require(game.ReplicatedStorage.Modules.Core.CreateElement)
local createFrame = require(script.Frame)

return function()
    return createElement("ScreenGui", {
		Name = "GunInfo"
	}, {
		Frame = createFrame()
	})
end