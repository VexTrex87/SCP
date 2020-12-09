local ReplicatedStorage = game:GetService("ReplicatedStorage")
local createElement = require(ReplicatedStorage.Modules.Core.CreateElement)

return function()
    return createElement("TextLabel", {
        BackgroundColor3 = Color3.fromRGB(180, 180, 180),
        BackgroundTransparency = 1,
        Name = "Ammo",
        Size = UDim2.new(0, 250, 0, 25),
        Font = Enum.Font.SciFi,
        RichText = true,
        Text = "AMMO",
        TextColor3 = Color3.fromRGB(255, 255, 255),
        TextSize = 25,
        TextXAlignment = Enum.TextXAlignment.Right,
        TextYAlignment = Enum.TextYAlignment.Bottom
    })
end