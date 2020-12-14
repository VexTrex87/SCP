local Debris = game:GetService("Debris")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local gunFlashImages = require(ReplicatedStorage.Configuration.Images).gunFlash

return function(flashParent, despawnDelay)
    local newMuzzleFlash0 = flashParent.MuzzleFlash0:Clone()
    newMuzzleFlash0.Parent = flashParent
    
    local newMuzzleFlash1 = flashParent.MuzzleFlash1:Clone()
    newMuzzleFlash1.Parent = flashParent

    local newMuzzleFlash = flashParent.MuzzleFlash:Clone()
    newMuzzleFlash.Parent = flashParent
    newMuzzleFlash.Attachment0 = newMuzzleFlash0
    newMuzzleFlash.Attachment1 = newMuzzleFlash1
    newMuzzleFlash.Enabled = true
	Debris:AddItem(newMuzzleFlash, despawnDelay)
end