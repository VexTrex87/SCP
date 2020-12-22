local RunService = game:GetService("RunService")

local module = {}
local camera = workspace.CurrentCamera
local character = game.Players.LocalPlayer.Character
local humanoidRootPart = character:WaitForChild("HumanoidRootPart")
local waist = character.UpperTorso:FindFirstChild("Waist")

local Y_OFFSET = waist.C0.Y

local CFrameNew, CFrameAngles, asin = CFrame.new, CFrame.Angles, math.asin
local onRenderStepped

function module.start()
    onRenderStepped = RunService.RenderStepped:Connect(function()
        if waist then
            local cameraDirection = humanoidRootPart.CFrame:ToObjectSpace(camera.CFrame).LookVector
            waist.C0 = CFrameNew(0, Y_OFFSET, 0) * CFrameAngles(0, -asin(cameraDirection.X), 0) * CFrameAngles(asin(cameraDirection.Y), 0, 0)
        end
    end)
end

function module.stop()
    onRenderStepped:Disconnect()
end

return module
