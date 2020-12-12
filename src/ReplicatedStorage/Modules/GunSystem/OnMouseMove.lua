local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Crosshair = require(ReplicatedStorage.Modules.GunSystem.Crosshair)

return function(self)
    -- check if target
    local target = self.temp.mouse.Target
    if not target then
        return
    end
    
    -- get the target type & update crosshair
    local targetAncestor = target:FindFirstAncestor("Friendly") or target:FindFirstAncestor("Enemy") -- dynamic target type checking
    if not targetAncestor then
        if targetAncestor ~= self.temp.crosshair.currentTarget and self.temp.crosshair.currentTargetType ~= "Neutral" then
            self.temp.crosshair.currentTarget = targetAncestor
            self.temp.crosshair.currentTargetType = "Neutral"
            Crosshair.updateTargetType(self.Configuration.tag, "Neutral")
        end
    elseif targetAncestor.Name == "Friendly" and targetAncestor ~= self.temp.crosshair.currentTarget and self.temp.crosshair.currentTargetType ~= "Friendly" then
        self.temp.crosshair.currentTarget = targetAncestor
        self.temp.crosshair.currentTargetType = "Friendly"
        Crosshair.updateTargetType(self.Configuration.tag, "Friendly")
    elseif targetAncestor.Name == "Enemy" and targetAncestor ~= self.temp.crosshair.currentTarget and self.temp.crosshair.currentTargetType ~= "Enemy" then
        self.temp.crosshair.currentTarget = targetAncestor
        self.temp.crosshair.currentTargetType = "Enemy"
        Crosshair.updateTargetType(self.Configuration.tag, "Enemy")
    end
end