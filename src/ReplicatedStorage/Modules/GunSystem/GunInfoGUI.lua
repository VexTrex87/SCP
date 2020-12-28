local module = {}
module.__index = module


local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Images = require(ReplicatedStorage.Configuration.Images).gunIcons
local newTween = require(game.ReplicatedStorage.Modules.Core.NewTween)
local newThread = require(game.ReplicatedStorage.Modules.Core.NewThread)
local createScreenGui = require(ReplicatedStorage.GuiElements.GunSystem.GunInfo.ScreenGui)

local playerGui = game.Players.LocalPlayer:WaitForChild("PlayerGui")

function module.create()
	local GUI = createScreenGui()
	GUI.Parent = playerGui
end

function module.update(info)
	local configuration = require(ReplicatedStorage.Configuration.GunSystem[info.gunTag]).UI.gunInfo
	local GUI = playerGui:WaitForChild("GunInfo")

	newThread(function()
		local gunNameText = '<font size = "25"><font color = "rgb(255, 255, 255)">' .. info.gunName .. ': </font></font>'
		local fireModetext = '<font size = "20"><font color = "rgb(200, 200, 200)">' .. info.fireMode .. '</font></font>'
		local newText = gunNameText .. fireModetext
		local element = GUI.Frame.GunName
		if element.Text ~= newText then
			element.Text = newText
			newTween(element, configuration.flashTweenInfo, {TextTransparency = 0.5}).Completed:Wait()
			newTween(element, configuration.flashTweenInfo, {TextTransparency = 0})
		end
	end)

	newThread(function()
		local newIcon = Images[info.gunTag:lower()]
		local element = GUI.Frame.GunIcon
		if element.Image ~= newIcon then
			element.Image = newIcon
			newTween(element, configuration.flashTweenInfo, {ImageTransparency = 0.5}).Completed:Wait()
			newTween(element, configuration.flashTweenInfo, {ImageTransparency = 0})
		end
	end)

	newThread(function()
		local ammoText = '<font size = "25"><font color = "rgb(255, 255, 255)">' .. info.ammo .. '</font></font>'
		local totalAmmoText = '<font size = "20"><font color = "rgb(200, 200, 200)">/' .. info.totalAmmo .. '</font></font>'
		local newText = ammoText .. totalAmmoText
		local element = GUI.Frame.Ammo
		if element.Text ~= newText then
			element.Text = newText
			newTween(element, configuration.flashTweenInfo, {TextTransparency = 0.5}).Completed:Wait()
			newTween(element, configuration.flashTweenInfo, {TextTransparency = 0})
		end
	end)
end

function module.show(info)
	local configuration = require(ReplicatedStorage.Configuration.GunSystem[info.gunTag]).UI.gunInfo
	local GUI = playerGui:WaitForChild("GunInfo")
	module.update(info)
	GUI.Frame:TweenPosition(configuration.shownPosition, table.unpack(configuration.moveTweenInfo))
end

function module.hide(info)
	local configuration = require(ReplicatedStorage.Configuration.GunSystem[info.gunTag]).UI.gunInfo
	local GUI = playerGui:WaitForChild("GunInfo")
	GUI.Frame:TweenPosition(configuration.hiddenPosition, table.unpack(configuration.moveTweenInfo))
end

return module