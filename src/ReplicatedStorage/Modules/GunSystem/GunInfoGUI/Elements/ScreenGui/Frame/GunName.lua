local createElement = require(game.ReplicatedStorage.Modules.Core.createElement)

return function()
    return createElement("TextLabel", {
        BackgroundColor3 = Color3.fromRGB(180, 180, 180),
        BackgroundTransparency = 1,
        Name = "GunName",
        Size = UDim2.new(0, 250, 0, 25),
        Font = Enum.Font.SciFi,
        RichText = true,
        Text = "GUN_NAME",
        TextColor3 = Color3.fromRGB(255, 255, 255),
        TextSize = 25,
        TextXAlignment = Enum.TextXAlignment.Left,
        TextYAlignment = Enum.TextYAlignment.Bottom
    })
end