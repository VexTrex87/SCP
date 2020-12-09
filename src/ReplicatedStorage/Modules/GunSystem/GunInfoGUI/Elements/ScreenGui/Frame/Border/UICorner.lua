local createElement = require(game.ReplicatedStorage.Modules.Core.CreateElement)

return function()
    return createElement("UICorner", {
        CornerRadius = UDim.new(0, 5)
    })
end