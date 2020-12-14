local module = {}

-- // VARIABLES \\ --

local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Debris = game:GetService("Debris")
local createScreenGui = require(ReplicatedStorage.GuiElements.GunSystem.Crosshair.ScreenGui)

-- // FUNCTIONS \\ --

-- local

local function getCrosshair(gunTag)
	local crosshairGUI = game.Players.LocalPlayer.PlayerGui:WaitForChild("Crosshair")
	return crosshairGUI[gunTag]
end

local function newTween(...)
	local tween = TweenService:Create(...)
	tween:Play()
	return tween
end

-- return

function module.show(gunTag)
	local configuration = require(ReplicatedStorage.Configuration.GunSystem[gunTag]).UI.crosshair
	UserInputService.MouseIconEnabled = false
	
	local newCrosshair = getCrosshair(gunTag)
	newCrosshair.Size = UDim2.new(0, 1, 0, 1)
	newCrosshair.Visible = true
	newTween(newCrosshair, configuration.showTweenInfo, {Size = configuration.unzoomedSize})
end

function module.hide(gunTag)
	local configuration = require(ReplicatedStorage.Configuration.GunSystem[gunTag]).UI.crosshair
	local newCrosshair = getCrosshair(gunTag)
	newTween(newCrosshair, configuration.showTweenInfo, {Size = UDim2.new(0, 1, 0, 1)}).Completed:Wait()
	newCrosshair.Visible = false
	UserInputService.MouseIconEnabled = true
end

function module.zoom(gunTag, isZoomed)
	local Configuration = require(ReplicatedStorage.Configuration.GunSystem[gunTag]).UI.crosshair
	local newCrosshair = getCrosshair(gunTag)
	local newSize = isZoomed and Configuration.zoomedSize or Configuration.unzoomedSize
	newTween(newCrosshair, Configuration.zoomTweenInfo, {Size = newSize})
end

function module.updateTargetType(gunTag, targetType)
	local configuration = require(ReplicatedStorage.Configuration.GunSystem[gunTag]).UI.crosshair
	local newCrosshair = getCrosshair(gunTag)
	local newColor = configuration[targetType:lower() .. "Color"]
	for _,element in pairs(newCrosshair:GetChildren()) do
		element.BackgroundColor3 = newColor
	end
end

function module.showDamageDone(gunTag, damageType)
	local Configuration = require(ReplicatedStorage.Configuration.GunSystem[gunTag]).UI.crosshair
	local newCrosshair = getCrosshair(gunTag).Parent

	-- create damage done GUI clone
	local newDamageDoneGUI = newCrosshair.DamageDone:Clone()
	newDamageDoneGUI.Parent = newCrosshair

	local newColor = damageType == "HEAD" and Configuration.damageDoneHeadColor or Configuration.damageDoneBodyColor
	for _,element in pairs(newDamageDoneGUI:GetChildren()) do
		element.BackgroundColor3 = newColor
	end

	newDamageDoneGUI.Visible = true
	Debris:AddItem(newDamageDoneGUI, Configuration.damageDoneShowDuration)
end

function module.create()
	local newCrosshair = createScreenGui()
	newCrosshair.Parent = game.Players.LocalPlayer.PlayerGui
end

return module
