local module = {}

-- // VARIABLES \\ --

local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local createScreenGui = require(ReplicatedStorage.GuiElements.GunSystem.Crosshair.ScreenGui)

-- // FUNCTIONS \\ --

-- local

local function getCrosshair(gunName)
	local crosshairGUI = game.Players.LocalPlayer.PlayerGui:WaitForChild("Crosshair")
	return crosshairGUI[gunName]
end

local function newTween(...)
	local tween = TweenService:Create(...)
	tween:Play()
	return tween
end

-- return

function module.show(gunName)
	local configuration = require(ReplicatedStorage.Configuration.GunSystem[gunName]).UI.crosshair
	UserInputService.MouseIconEnabled = false
	
	local newCrosshair = getCrosshair(gunName)
	newCrosshair.Size = UDim2.new(0, 1, 0, 1)
	newCrosshair.Visible = true
	newTween(newCrosshair, configuration.showTweenInfo, {Size = configuration.UnzoomedSize})
end

function module.hide(gunName)
	local configuration = require(ReplicatedStorage.Configuration.GunSystem[gunName]).UI.crosshair
	local newCrosshair = getCrosshair(gunName)
	newTween(newCrosshair, configuration.showTweenInfo, {Size = UDim2.new(0, 1, 0, 1)})
	newCrosshair.Visible = false
	
	UserInputService.MouseIconEnabled = true
end

function module.zoom(gunName, isZoomed)
	local configuration = require(ReplicatedStorage.Configuration.GunSystem[gunName]).UI.crosshair
	local newCrosshair = getCrosshair(gunName)
	local newSize = isZoomed and configuration.ZoomedSize or configuration.UnzoomedSize
	newTween(newCrosshair, configuration.zoomTweenInfo, {Size = newSize})
end

function module.updateTargetType(gunName, targetType)
	local configuration = require(ReplicatedStorage.Configuration.GunSystem[gunName]).UI.crosshair
	local newCrosshair = getCrosshair(gunName)
	local newColor = configuration[targetType .. "Color"]
	for _,element in pairs(newCrosshair:GetChildren()) do
		element.BackgroundColor3 = newColor
	end
end

function module.create()
	local newCrosshair = createScreenGui()
	newCrosshair.Parent = game.Players.LocalPlayer.PlayerGui
end

return module
