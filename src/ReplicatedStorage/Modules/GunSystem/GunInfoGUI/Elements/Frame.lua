local createElement = require(game.ReplicatedStorage.Modules.Core.createElement)
local configuration = require(script.Parent.Parent.Configuration)

local createGunName = require(script.Parent.GunName)
local createAmmo = require(script.Parent.Ammo)
local createGunIcon = require(script.Parent.GunIcon)
local createBorder = require(script.Parent.Border)

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