local ReplicatedStorage = game:GetService("ReplicatedStorage")

local createElement = require(ReplicatedStorage.Modules.Core.CreateElement)
local configuration = require(ReplicatedStorage.Modules.GunSystem.GunInfoGUI.Configuration)

local createGunName = require(script.GunName)
local createAmmo = require(script.Ammo)
local createGunIcon = require(script.GunIcon)
local createBorder = require(script.Border)

return function()
    return createElement("Frame", {
        BackgroundTransparency = 1,
        Name = "Frame",
        Position = configuration.hiddenPosition,
        Size = UDim2.new(0, 250, 0, 125),
    }, {
        GunName = createGunName(),
        Ammo = createAmmo(),
        GunIcon = createGunIcon(),
        Border = createBorder()			
    })
end