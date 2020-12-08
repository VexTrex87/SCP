local module = {}
module.__index = module

local SHOWN_POS = UDim2.new(1, -300, 1, -145)
local HIDDEN_POS = UDim2.new(1, -300, 1, 145)
local MOVE_TWEEN_INFO = {Enum.EasingDirection.In, Enum.EasingStyle.Linear, 0.3, true}
local FLASH_TWEEN_INFO = TweenInfo.new(0.1)

local createElement = require(game.ReplicatedStorage.Modules.Core.createElement)
local newTween = require(game.ReplicatedStorage.Modules.Core.newTween)
local newThread = require(game.ReplicatedStorage.Modules.Core.newThread)
local playerGui = game.Players.LocalPlayer:WaitForChild("PlayerGui")

function module.create()
	local GUI = createElement("ScreenGui", {
		Name = "GunInfo"
	}, {
		Frame = createElement("Frame", {
			BackgroundTransparency = 1,
			Name = "Frame",
			Position = HIDDEN_POS,
			Size = UDim2.new(0, 250, 0, 125),
		}, {
			GunName = createElement("TextLabel", {
				BackgroundColor3 = Color3.fromRGB(180, 180, 180),
				BackgroundTransparency = 1,
				Name = "GunName",
				Size = UDim2.new(0, 250, 0, 25),
				Font = Enum.Font.SciFi,
				RichText = true,
				Text = "GUN_NAME",
				TextColor3 = Color3.fromRGB(255, 255, 255),
				TextSize = 25,
				TextXAlignment = Enum.TextXAlignment.Left,
				TextYAlignment = Enum.TextYAlignment.Bottom
			}),
			Ammo = createElement("TextLabel", {
				BackgroundColor3 = Color3.fromRGB(180, 180, 180),
				BackgroundTransparency = 1,
				Name = "Ammo",
				Size = UDim2.new(0, 250, 0, 25),
				Font = Enum.Font.SciFi,
				RichText = true,
				Text = "AMMO",
				TextColor3 = Color3.fromRGB(255, 255, 255),
				TextSize = 25,
				TextXAlignment = Enum.TextXAlignment.Right,
				TextYAlignment = Enum.TextYAlignment.Bottom
			}),
			GunIcon = createElement("ImageLabel", {
				BackgroundTransparency = 1,
				Name = "GunIcon",
				Position = UDim2.new(0, 0, 0, 30),
				Size = UDim2.new(0, 250, 0, 100),
				Image = "",
				ScaleType = Enum.ScaleType.Crop
			}),
			Border = createElement("Frame", {
				BackgroundColor3 = Color3.fromRGB(180, 180, 180),
				BackgroundTransparency = 0.5,
				Name = "Border",
				Position = UDim2.new(0, 0, 0, 25),
				Size = UDim2.new(0, 250, 0, 2),
			}, {
				UICorner = createElement("UICorner", {
					CornerRadius = UDim.new(0, 5)
				})
			})			
		})
	})
	GUI.Parent = playerGui
end

function module.update(info)
	local GUI = playerGui:WaitForChild("GunInfo")

	newThread(function()
		local gunNameText = '<font size = "25"><font color = "rgb(255, 255, 255)">' .. info.gunName .. ': </font></font>'
		local fireModetext = '<font size = "20"><font color = "rgb(200, 200, 200)">' .. info.fireMode .. '</font></font>'
		local newText = gunNameText .. fireModetext
		local element = GUI.Frame.GunName
		if element.Text ~= newText then
			element.Text = newText
			newTween(element, FLASH_TWEEN_INFO, {TextTransparency = 0.5}).Completed:Wait()
			newTween(element, FLASH_TWEEN_INFO, {TextTransparency = 0})
		end
	end)

	newThread(function()
		local newIcon = info.gunIcon
		local element = GUI.Frame.GunIcon
		if element.Image ~= newIcon then
			element.Image = newIcon
			newTween(element, FLASH_TWEEN_INFO, {ImageTransparency = 0.5}).Completed:Wait()
			newTween(element, FLASH_TWEEN_INFO, {ImageTransparency = 0})
		end
	end)

	newThread(function()
		local currentAmmoText = '<font size = "25"><font color = "rgb(255, 255, 255)">' .. info.currentAmmo .. '</font></font>'
		local maxAmmoText = '<font size = "20"><font color = "rgb(200, 200, 200)">/' .. info.maxAmmo .. '</font></font>'
		local newText = currentAmmoText .. maxAmmoText
		local element = GUI.Frame.Ammo
		if element.Text ~= newText then
			element.Text = newText
			newTween(element, FLASH_TWEEN_INFO, {TextTransparency = 0.5}).Completed:Wait()
			newTween(element, FLASH_TWEEN_INFO, {TextTransparency = 0})
		end
	end)
end

function module.show(info)
	local GUI = playerGui:WaitForChild("GunInfo")
	module.update(info)
	GUI.Frame:TweenPosition(SHOWN_POS, table.unpack(MOVE_TWEEN_INFO))
end

function module.hide()
	local GUI = playerGui:WaitForChild("GunInfo")
	GUI.Frame:TweenPosition(HIDDEN_POS, table.unpack(MOVE_TWEEN_INFO))
end

return module