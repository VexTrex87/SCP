local ReplicatedStorage = game:GetService("ReplicatedStorage")
local remote = ReplicatedStorage.Remotes.PlayEffects

return function(...)
    remote:FireAllClients(...)
end