local ReplicatedStorage = game:GetService("ReplicatedStorage")

local loadModules = require(ReplicatedStorage.Modules.Core.LoadModules)
local effectsModules = ReplicatedStorage.Modules.Effects:GetChildren()
local effects = loadModules(effectsModules)

local playEffectsRemote = ReplicatedStorage.Remotes.PlayEffects

return function()
    playEffectsRemote.OnClientEvent:Connect(function(effectName, ...)
        effects[effectName](...)
    end)
end