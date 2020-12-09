local NPC_TAG = "NPC"
local RESPAWN_DELAY = 2
local ServerStorage = game:GetService("ServerStorage")
local collection = require(ServerStorage.Modules.Core.Collection)

return function()
    collection(NPC_TAG, function(NPC)
        local newNPC = NPC:Clone()
        NPC.Humanoid.Died:Connect(function()
            NPC:Destroy()
            wait(RESPAWN_DELAY)
            newNPC.Parent = workspace.Debris.NPC
        end)
    end)
end