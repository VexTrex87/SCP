local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Crosshair = require(ReplicatedStorage.Modules.GunSystem.Crosshair)
local checkTargetType = require(ReplicatedStorage.Modules.GunSystem.CheckTargetType)
local getCharacterFromBodyPart = require(ReplicatedStorage.Modules.Core.GetCharacterFromBodyPart)

return function(self)
    -- check if target
    local target = self.temp.mouse.Target
    if not target then
        return
    end
    
    -- get the target type & update crosshair
    local targetAncestor = getCharacterFromBodyPart(target) -- dynamic target type checking
    local targetType = checkTargetType(targetAncestor)
    if targetAncestor ~= self.temp.crosshair.currentTarget and targetType ~= self.temp.crosshair.currentTargetType then
        self.temp.crosshair.currentTarget = targetAncestor
        self.temp.crosshair.currentTargetType = targetType
        Crosshair.updateTargetType(self.Configuration.tag, targetType)
    end
end