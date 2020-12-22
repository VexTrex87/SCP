local Debris = game:GetService("Debris")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local modules = ReplicatedStorage.Modules
local core = modules.Core
local playSound = require(core.PlaySound)
local randomNumber = require(core.RandomNumber)
local newTween = require(core.NewTween)
local Crosshair = require(modules.GunSystem.Crosshair)

return function(self, targetCharacter, damageType, damageAmount)
    -- find humanoid root part
    local root = targetCharacter:FindFirstChild("HumanoidRootPart")
    if not root then
        return
    end

    Crosshair.showDamageDone(self.Configuration.tag, damageType:upper())

    -- create new indicator
    local newIndicator = self.GUI.damageIndicator:Clone()
    newIndicator.TextLabel.Text = damageAmount

    for propertyName, propertyValue in pairs(self.Configuration.UI.damageIndicator[damageType]) do
        newIndicator.TextLabel[propertyName] = propertyValue
    end

    newIndicator.Enabled = true
    newIndicator.Parent = root 
    Debris:AddItem(newIndicator, self.Configuration.UI.damageIndicator.maxduration)
    playSound(damageType == "head" and self.sounds.headHit or self.sounds.bodyHit, self.tool.Handle)

    local minOffset = self.Configuration.UI.damageIndicator.minOffset
    local maxOffset = self.Configuration.UI.damageIndicator.minOffset
    newIndicator.StudsOffset = Vector3.new(
        randomNumber(minOffset.X, maxOffset.X, 10),
        randomNumber(minOffset.Y, maxOffset.Y, 10), 
        0
    )   
    newTween(newIndicator.TextLabel, self.Configuration.UI.damageIndicator.tweenInfo, {TextTransparency = 0}).Completed:Wait()
    newTween(newIndicator.TextLabel, self.Configuration.UI.damageIndicator.tweenInfo, {TextTransparency = 1})
end