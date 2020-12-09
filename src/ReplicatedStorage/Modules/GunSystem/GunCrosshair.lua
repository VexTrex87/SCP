local module = {}

-- // VARIABLES \\ --

local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local configuration = require(ReplicatedStorage.Modules.GunSystem.Configuration.Global).gunCrosshair
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
	UserInputService.MouseIconEnabled = false
	
	local newCrosshair = getCrosshair(gunName)
	newCrosshair.Size = UDim2.new(0, 1, 0, 1)
	newCrosshair.Visible = true
	newTween(newCrosshair, configuration.showTweenInfo, {Size = configuration[gunName].UnzoomedPosition})
end

function module.hide(gunName)
	local newCrosshair = getCrosshair(gunName)
	newTween(newCrosshair, configuration.showTweenInfo, {Size = UDim2.new(0, 1, 0, 1)})
	newCrosshair.Visible = false
	
	UserInputService.MouseIconEnabled = true
end

function module.zoom(gunName, isZoomed)
	local newCrosshair = getCrosshair(gunName)
	local newSize = isZoomed and configuration[gunName].ZoomedPosition or configuration[gunName].UnzoomedPosition
	newTween(newCrosshair, configuration.zoomTweenInfo, {Size = newSize})
end

function module.updateTargetType(gunName, targetType)
	local newCrosshair = getCrosshair(gunName)
	local newColor = configuration[gunName][targetType .. "Color"]
	for _,element in pairs(newCrosshair:GetChildren()) do
		element.BackgroundColor3 = newColor
	end
end

function module.create()
	local newCrosshair = createScreenGui()
	newCrosshair.Parent = game.Players.LocalPlayer.PlayerGui
end

return module
