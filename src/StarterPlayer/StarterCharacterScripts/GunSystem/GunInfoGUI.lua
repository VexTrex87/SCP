-- // VARIABLES \\ --

local roact = require(game.ReplicatedStorage.Modules.Roact)
local currentGUI

-- // FUNCTIONS \\ --

local function createAmmoGUI(currentAmmo, maxAmmo)
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
		TextYAlignment = Enum.TextYAlignment.Bottom
	})
    
end

local function createGunNameGUI(gunName, fireMode)
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

local function createIconGUI(icon)
	return roact.createElement("ImageLabel", {
		BackgroundColor3 = Color3.fromRGB(100, 100, 100),
		BackgroundTransparency = 1,
		Position = UDim2.new(1, -300, 1, -120),
		Size = UDim2.new(0, 250, 0, 100),
		Image = icon,
		ScaleType = Enum.ScaleType.Fit
	})
end

local function createUiCorner()
	return roact.createElement("UICorner", {
		CornerRadius = UDim.new(0, 5)
	})
end

local function createBorderGUI()
	return roact.createElement("Frame", {
		BackgroundColor3 = Color3.fromRGB(180, 180, 180),
		BackgroundTransparency = 0.5,
		Position = UDim2.new(1, -300, 1, -120),
		Size = UDim2.new(0, 250, 0, 2),

	}, {
		UICorner = createUiCorner()
	})
end

local function createScreenGUI(info)
	return roact.createElement("ScreenGui", {}, {
		GunName = createGunNameGUI(info.gunName, info.fireMode),
		Ammo = createAmmoGUI(info.currentAmmo, info.maxAmmo),
		GunIcon = createIconGUI(info.gunIcon),
		Border = createBorderGUI()
	})
end

return function(info)
	if currentGUI and info then
		-- create GUI
		roact.update(currentGUI, createScreenGUI(info))
	elseif currentGUI then
		-- destroy GUI
		roact.unmount(currentGUI)
		currentGUI = nil
	else
		-- update GUI
		currentGUI = roact.mount(createScreenGUI(info), game.Players.LocalPlayer.PlayerGui, "GunInfo")
	end
end