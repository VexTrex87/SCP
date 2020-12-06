local roact = require(game.ReplicatedStorage.Modules.Roact)
local flash = require(script.parent.Parent.Controllers.Flash)

return function(currentAmmo, maxAmmo)
	local currentAmmoText = '<font size = "25"><font color = "rgb(255, 255, 255)">' .. currentAmmo .. '</font></font>'
	local maxAmmoText = '<font size = "20"><font color = "rgb(200, 200, 200)">/' .. maxAmmo .. '</font></font>'
	return roact.createElement("TextLabel", {
		BackgroundColor3 = Color3.fromRGB(180, 180, 180),
		BackgroundTransparency = 1,
		Position = UDim2.new(1, -300, 1, -147),
		Size = UDim2.new(0, 250, 0, 25),
		Font = Enum.Font.SciFi,
		RichText = true,
		Text = currentAmmoText .. maxAmmoText,
		TextSize = 25,
		TextXAlignment = Enum.TextXAlignment.Right,
		TextYAlignment = Enum.TextYAlignment.Bottom,
		[roact.Change.Text] = flash
	}) 
end