local ServerStorage = game:GetService("ServerStorage")

local modules = ServerStorage.Modules
local core = modules.Core
local newThread = require(core.NewThread)
local getCharacterFromBodyPart = require(core.GetCharacterFromBodyPart)
local playBulletHit = require(modules.Effects.BulletHit)

return function(self, info)
    local damageType, damageAmount
    local hitPart = info.raycastResult.Instance
    local hitPoint = info.raycastResult.Position
    local normal = info.raycastResult.Normal
    
    -- check if ray hit a part
    if not hitPart then
        return
    end

    -- play hit effects
    newThread(
        playBulletHit, 
        self.effects.impactParticle, 
        hitPart, 
        CFrame.new(hitPoint, hitPoint + normal), 
        self.Configuration.effects.impactParticleDuration
    )

    -- check if ray hit a character
    local character = getCharacterFromBodyPart(hitPart) or hitPart.Parent:FindFirstChildWhichIsA("Humanoid") and hitPart.Parent
    if not character then
        return
    end

    -- check if the character the ray hit has a humanoid
    local humanoid = character:FindFirstChildWhichIsA("Humanoid")
    if not humanoid then
        return
    end

    -- deal damage depending on where it was hit
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

    -- deal damage & show damage dealt
    if damageType and damageAmount then
        humanoid:TakeDamage(damageAmount)
        self.remotes.DamageIndicator:FireClient(info.sender, character, damageType, damageAmount)
    end
end