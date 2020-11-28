local module = {}
module.__index = module

-- // VARIABLES \\ --

-- services
local UserInputService = game:GetService("UserInputService")

-- modules
local Settings = require(game.ReplicatedStorage.GunSystem.Settings.M249)
local core = require(game.ReplicatedStorage.Modules.Core)
local waitForPath = core("waitForPath")
local thirdPersonCamera = require(game.ReplicatedStorage.GunSystem.Modules.ThirdPersonCamera)

-- objects
local player = game.Players.LocalPlayer
local character = player.Character

-- // FUNCTIONS \\ --

-- indirect

function module:updateMouseIcon()
	if self.temp.mouse and not self.tool.Parent:IsA("Backpack") then
		self.temp.mouse.Icon = Settings.mouseIcon
	end
end

-- module direct

function module:onActiveCameraSettingsChanged(newCameraSettings: String)
    if newCameraSettings == "DefaultShoulder" then
        -- Stops all animations but starts holding animation
        self.animations.hold:Play()
        self.animations.runningHold:Stop()
        self.animations.aim:Stop()
    elseif newCameraSettings == "ZoomedShoulder" then
        -- Stops all animations but starts aim animation
        self.animations.hold:Stop()
        self.animations.runningHold:Stop()
        self.animations.aim:Play()
    end
end

-- service direct

function module:onInputBegan(input, gameProcessed)
    if gameProcessed then
        return
    end

    if input.KeyCode == Settings.keybinds.reload then
        self.animations.hold:Stop()
        self.animations.runningHold:Stop()
        self.animations.aim:Stop()
        self.animations.reload:Play()
    end
end

-- object direct

function module:onToolEquipped(playerMouse)
    -- play hold animation
    self.animations.hold:Play()

    -- start third person camera
    thirdPersonCamera:Enable()
    thirdPersonCamera:SetCharacterAlignment(true)

    -- set mouse
    self.temp.mouse = playerMouse
    self:updateMouseIcon()

end

function module:onToolUnequipped()
    -- stop all animations
    self.animations.hold:Stop()
    self.animations.runningHold:Stop()
    self.animations.aim:Stop()
    self.animations.reload:Stop()

    -- stop third person camera
    thirdPersonCamera:Disable()
end

-- init

function module.new(tool)

    -- create vars for metatable
    local humanoid = character:WaitForChild("Humanoid")
    local animator = humanoid:WaitForChild("Animator")

    -- create metatable
    local self = setmetatable({
        tool = tool,
        animations = {
            hold = animator:LoadAnimation(waitForPath(tool, "Animations.Hold")),
            runningHold = animator:LoadAnimation(waitForPath(tool, "Animations.RunningHold")),
            aim = animator:LoadAnimation(waitForPath(tool, "Animations.Aim")),
            reload = animator:LoadAnimation(waitForPath(tool, "Animations.Reload")),
        },
        temp = {
            mouse = nil,
            connections = {
                activeCameraSettingsChanged = nil,
                inputBegan = nil,
            }
        }
    }, module)

    -- events
    self.tool.Equipped:Connect(function(...)
        self:onToolEquipped(...)
    end)

    self.tool.Unequipped:Connect(function()
        self:onToolUnequipped()
    end)

    self.temp.connections.activeCameraSettingsChanged = thirdPersonCamera.ActiveCameraSettingsChanged:Connect(function(...)
        self:onActiveCameraSettingsChanged(...)
    end)

    self.temp.connections.inputBegan = UserInputService.InputBegan:Connect(function(...)
        self:onInputBegan(...)
    end)

end

return module