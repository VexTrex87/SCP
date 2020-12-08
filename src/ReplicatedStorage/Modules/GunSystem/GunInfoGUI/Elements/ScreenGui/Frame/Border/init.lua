local createElement = require(game.ReplicatedStorage.Modules.Core.createElement)
local createUICorner = require(script.UICorner)

return function()
    return createElement("Frame", {
        BackgroundColor3 = Color3.fromRGB(180, 180, 180),
        BackgroundTransparency = 0.5,
        Name = "Border",
        Position = UDim2.new(0, 0, 0, 25),
        Size = UDim2.new(0, 250, 0, 2),
    }, {
        UICorner = createUICorner()
    })
end