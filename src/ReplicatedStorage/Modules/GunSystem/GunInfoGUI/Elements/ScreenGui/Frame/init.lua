local createElement = require(game.ReplicatedStorage.Modules.Core.CreateElement)
local configuration = require(script.Parent.Parent.Parent.Configuration)

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