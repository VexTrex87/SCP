local roact = require(game.ReplicatedStorage.Modules.Roact)
local createGunNameGUI = require(script.parent.GunName)
local createAmmoGUI = require(script.parent.Ammo)
local createGunIcon = require(script.parent.GunIcon)
local createBorderGUI = require(script.parent.Border)

return function(info)
	return roact.createElement("ScreenGui", {}, {
		GunName = createGunNameGUI(info.gunName, info.fireMode),
		Ammo = createAmmoGUI(info.currentAmmo, info.maxAmmo),
		GunIcon = createGunIcon(info.gunIcon),
		Border = createBorderGUI()
	})
end