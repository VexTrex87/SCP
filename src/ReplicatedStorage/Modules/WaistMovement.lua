local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")

local Configuration = require(ReplicatedStorage.Configuration.WaistMovement)
local disconnectConnections = require(ReplicatedStorage.Modules.Core.DisconnectConnections)
local newTween = require(ReplicatedStorage.Modules.Core.NewTween)

local updateWaistRemote = ReplicatedStorage.Objects.GunSystem.Remotes.UpdateWaist
local camera = workspace.CurrentCamera
local character = Players.LocalPlayer.Character
local humanoidRootPart = character.HumanoidRootPart
local waist = character.UpperTorso.Waist

local module = {}
local yOffset = waist.C0.Y
local CFrameNew, CFrameAngles, asin = CFrame.new, CFrame.Angles, math.asin
local isRunning, onRenderSteppedConnection

function onRenderStepped()
    local cameraDirection = humanoidRootPart.CFrame:ToObjectSpace(camera.CFrame).LookVector
    if waist then
        waist.C0 = CFrameNew(0, yOffset, 0) * CFrameAngles(0, -asin(cameraDirection.X), 0) * CFrameAngles(asin(cameraDirection.Y), 0, 0)
    end
end

function updateClientWaistOnServer()
    while true do
        if not isRunning then
            break
        end

        updateWaistRemote:FireServer(waist.C0)
        wait(Configuration.updateDelay)
    end
end

function module.start()
    isRunning = true
    onRenderSteppedConnection = RunService.RenderStepped:Connect(onRenderStepped)
    updateClientWaistOnServer()
end

function module.stop()
    isRunning = false
    disconnectConnections({onRenderSteppedConnection})
end

function module.init()
    updateWaistRemote.OnClientEvent:Connect(function(otherPlayer, waistCFrame)
        local otherPlayerWaist = otherPlayer.Character.UpperTorso.Waist
        if otherPlayerWaist then
            newTween(otherPlayerWaist, Configuration.turnWaistTweenInfo, {C0 = waistCFrame})
        end
    end)
end

return module