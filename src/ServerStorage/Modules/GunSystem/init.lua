local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerStorage = game:GetService("ServerStorage")
local CollectionService = game:GetService("CollectionService")

local collection = require(ServerStorage.Modules.Core.Collection)
local gunConfigurations = ReplicatedStorage.Configuration.GunSystem
local Configuration = require(gunConfigurations.Global)
local newGun = require(ServerStorage.Modules.GunSystem.NewGun)

return function()
    collection(Configuration.gunTag, function(tool)
        if tool.Parent:IsA("Backpack") then
            local tags = CollectionService:GetTags(tool)
            for _,tag in pairs(tags) do
                if gunConfigurations:FindFirstChild(tag) then
                    newGun(tool, tag)
                    break
                end
            end
        end
    end)
end