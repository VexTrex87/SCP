local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerStorage = game:GetService("ServerStorage")
local Configuration = require(ReplicatedStorage.Configuration.NPCHandler)
local collection = require(ServerStorage.Modules.Core.Collection)

return function()
    collection(Configuration.tag, function(NPC)
        local newNPC = NPC:Clone()
        NPC.Humanoid.Died:Connect(function()
            NPC:Destroy()
            wait(Configuration.respawnDelay)
            newNPC.Parent = workspace.Debris.NPC
        end)
    end)
end