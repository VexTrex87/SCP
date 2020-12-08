local module = {}

local CollectionService = game:GetService("CollectionService")
local Settings = require(script.Settings.Global)
local core = require(game.ReplicatedStorage.Modules.Core)
local collection = core("collection")
local player = game.Players.LocalPlayer

function init(tool)
    -- check if tool is in a player's backpack
    local backpack = player:WaitForChild("Backpack")
    if not tool:IsDescendantOf(backpack) then
        return
    end

    -- find module
    local tags = CollectionService:GetTags(tool)
    for _,tag in pairs(tags) do
        local gunModule = script.Guns:FindFirstChild(tag)
        if gunModule then
            require(gunModule).new(tool)
            break
        end
    end
end

function module.new()
    collection(Settings.gunTag, init)
end

return module