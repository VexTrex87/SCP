local NPC_TAG = "NPC"
local collection = require(game.ServerStorage.Modules.Core.collection)

return function()
    collection(NPC_TAG, function(NPC)
        local newNPC = NPC:Clone()
        NPC.Humanoid.Died:Connect(function()
            NPC:Destroy()
            wait(2)
            newNPC.Parent = workspace
        end)
    end)
end