local ReplicatedStorage = game:GetService("ReplicatedStorage")
local createElement = require(ReplicatedStorage.Modules.Core.CreateElement)

return function()
    return createElement("UICorner", {
        CornerRadius = UDim.new(0, 5)
    })
end