local roact = require(game.ReplicatedStorage.Modules.Roact)

return function (gunName, fireMode)
	local gunNameText = '<font size = "25"><font color = "rgb(255, 255, 255)">' .. gunName .. ': </font></font>'
	local fireModetext = '<font size = "20"><font color = "rgb(200, 200, 200)">' .. fireMode .. '</font></font>'
	return roact.createElement("TextLabel", {
		BackgroundColor3 = Color3.fromRGB(180, 180, 180),
		BackgroundTransparency = 1,
		Position = UDim2.new(1, -300, 1, -147),
		Size = UDim2.new(0, 250, 0, 25),
		Font = Enum.Font.SciFi,
		RichText = true,
		Text = gunNameText .. fireModetext,
		TextColor3 = Color3.fromRGB(255, 255, 255),
		TextSize = 25,
		TextXAlignment = Enum.TextXAlignment.Left,
		TextYAlignment = Enum.TextYAlignment.Bottom
	})
end