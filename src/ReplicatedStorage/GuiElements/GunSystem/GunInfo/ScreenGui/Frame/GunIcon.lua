local ReplicatedStorage = game:GetService("ReplicatedStorage")
local createElement = require(ReplicatedStorage.Modules.Core.CreateElement)

return function()
    return createElement("ImageLabel", {
        BackgroundTransparency = 1,
        Name = "GunIcon",
        Position = UDim2.new(0, 0, 0, 30),
        Size = UDim2.new(0, 250, 0, 100),
        Image = "",
        ScaleType = Enum.ScaleType.Crop
    })
end