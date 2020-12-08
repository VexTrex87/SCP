local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerStorage = game:GetService("ServerStorage")
local CollectionService = game:GetService("CollectionService")

local configuration = require(ReplicatedStorage.Modules.GunSystem.Settings.Global)
local collection = require(ServerStorage.Modules.Core.collection)

return function()
    collection(configuration.gunTag, function(tool)
        if tool.Parent:IsA("Backpack") then
            local tags = CollectionService:GetTags(tool)
            for _,tag in pairs(tags) do
                local module = script:FindFirstChild(tag)
                if module then
                    require(module).new(tool)
                end
            end
        end
    end)
end