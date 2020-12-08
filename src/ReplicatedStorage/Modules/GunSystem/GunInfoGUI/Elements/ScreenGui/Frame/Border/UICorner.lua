local createElement = require(game.ReplicatedStorage.Modules.Core.createElement)

return function()
    return createElement("UICorner", {
        CornerRadius = UDim.new(0, 5)
    })
end