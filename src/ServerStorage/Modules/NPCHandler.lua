local NPC_TAG = "NPC"
local ServerStorage = game:GetService("ServerStorage")
local collection = require(ServerStorage.Modules.Core.collection)

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