local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local Configuration = require(ReplicatedStorage.Configuration.WaistMovement)
local updateWaistRemote = ReplicatedStorage.Objects.GunSystem.Remotes.UpdateWaist

return function()
    updateWaistRemote.OnServerEvent:Connect(function(otherPlayer, neckCFrame)
        for _,player in pairs(Players:GetPlayers()) do
            if player ~= otherPlayer and (player.Character.Head.Position - otherPlayer.Character.Head.Position).Magnitude < Configuration.minUpdateDistance then
                updateWaistRemote:FireClient(player, otherPlayer, neckCFrame)
            end
        end
    end)
end