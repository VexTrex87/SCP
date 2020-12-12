local Debris = game:GetService("Debris")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local playSound = require(ReplicatedStorage.Modules.Core.PlaySound)
local randomNumber = require(ReplicatedStorage.Modules.Core.RandomNumber)
local newTween = require(ReplicatedStorage.Modules.Core.NewTween)

return function(self, targetCharacter, damageType, damageAmount)
    -- find humanoid root part
    local root = targetCharacter:FindFirstChild("HumanoidRootPart")
    if not root then
        return
    end

    -- create new indicator
    local newIndicator = self.tool.UI.DamageIndicator:Clone()
    newIndicator.TextLabel.Text = damageAmount

    for propertyName, propertyValue in pairs(self.Configuration.UI.damageIndicator[damageType]) do
        newIndicator.TextLabel[propertyName] = propertyValue
    end

    newIndicator.Enabled = true
    newIndicator.Parent = root 
    Debris:AddItem(newIndicator, self.Configuration.UI.damageIndicator.maxduration)
    playSound(self.sounds.hit, self.tool.Handle)

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