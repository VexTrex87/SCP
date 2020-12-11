local ReplicatedStorage = game:GetService("ReplicatedStorage")

local createElement = require(ReplicatedStorage.Modules.Core.CreateElement)

local createGunName = require(script.GunName)
local createAmmo = require(script.Ammo)
local createGunIcon = require(script.GunIcon)
local createBorder = require(script.Border)

return function(info)
    return createElement("Frame", {
        BackgroundTransparency = 1,
        Name = "Frame",
        Position = UDim2.new(1, -300, 1, 145),
        Size = UDim2.new(0, 250, 0, 125),
    }, {
        GunName = createGunName(),
        Ammo = createAmmo(),
        GunIcon = createGunIcon(),
        Border = createBorder()			
    })
end