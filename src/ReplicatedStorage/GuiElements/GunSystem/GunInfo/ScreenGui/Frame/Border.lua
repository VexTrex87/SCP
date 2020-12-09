local ReplicatedStorage = game:GetService("ReplicatedStorage")
local createElement = require(ReplicatedStorage.Modules.Core.CreateElement)

local createUICorner = require(ReplicatedStorage.GuiElements.UICorner)

return function()
    return createElement("Frame", {
        BackgroundColor3 = Color3.fromRGB(180, 180, 180),
        BackgroundTransparency = 0.5,
        Name = "Border",
        Position = UDim2.new(0, 0, 0, 25),
        Size = UDim2.new(0, 250, 0, 2),
    }, {
        UICorner = createUICorner(UDim.new(0, 5))
    })
end