local ServerStorage = game:GetService("ServerStorage")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local modules = ServerStorage.Modules
local core = modules.Core
local getCharacterFromBodyPart = require(core.GetCharacterFromBodyPart)
local playEffects = require(ServerStorage.Modules.PlayEffects)
local checkTargetType = require(ReplicatedStorage.Modules.GunSystem.CheckTargetType)

return function(self, info)
    local damageType, damageAmount
    local hitPart = info.raycastResult.Instance
    local hitPoint = info.raycastResult.Position
    local normal = info.raycastResult.Normal
    
    if not hitPart then
        return
    end

    playEffects("BulletHit", self.effects.impactParticle, hitPart, CFrame.new(hitPoint, hitPoint + normal), self.Configuration.effects.impactParticleDuration)

    local character = getCharacterFromBodyPart(hitPart) or hitPart.Parent:FindFirstChildWhichIsA("Humanoid") and hitPart.Parent
    if not character or checkTargetType(character) ~= "ENEMY" then
        return
    end

    local humanoid = character:FindFirstChildWhichIsA("Humanoid")
    if not humanoid then
        return
    end

    for damageInfoIndex, damageInfo in pairs(self.Configuration.gun.damageTypes) do
        if typeof(damageInfo.partNames) == "table" then
            if table.find(damageInfo.partNames, hitPart.Name) then
                damageType = damageInfoIndex
                damageAmount = damageInfo.amount
            end
        else
            damageType = damageInfoIndex
            damageAmount = damageInfo.amount
        end
    end

    if damageType and damageAmount then
        humanoid:TakeDamage(damageAmount)
        self.remotes.DamageIndicator:FireClient(info.sender, character, damageType, damageAmount)
    end
end