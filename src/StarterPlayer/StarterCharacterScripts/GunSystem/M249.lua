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
            states = {
                isEquipped = false,
                isAiming = false,
                isReloading = false,
            },
        }
    }, module)

    -- events
    self.tool.Equipped:Connect(function(...)
        self:onToolEquipped(...)
    end)

    self.tool.Unequipped:Connect(function()
        self:onToolUnequipped()
    end)

    thirdPersonCamera.ActiveCameraSettingsChanged:Connect(function(...)
        self:onActiveCameraSettingsChanged(...)
    end)

    UserInputService.InputBegan:Connect(function(...)
        self:onInputBegan(...)
    end)

end

-- direct

function module:onToolEquipped(playerMouse)
    self.temp.states.isEquipped = true

    -- start third person camera
    thirdPersonCamera:Enable()
    thirdPersonCamera:SetCharacterAlignment(true)

    -- set mouse
    self.temp.mouse = playerMouse
    self:updateMouseIcon()

    -- play hold animation
    self.animations.hold:Play()
end

function module:onToolUnequipped()
    -- disable states
    self.temp.states.isEquipped = false
    self.temp.states.isReloading = false
    self.temp.states.isAiming = false

    -- stop third person camera
    thirdPersonCamera:Disable()

    -- stop all animations
    self.animations.runningHold:Stop()
    self.animations.hold:Stop()
    self.animations.aim:Stop()
    self.animations.reload:Stop()
end

function module:onInputBegan(input, gameProcessed)
    if gameProcessed then
        return
    end

    if input.KeyCode == Settings.keybinds.reload then
        self:reload()
    end
end

function module:onActiveCameraSettingsChanged(newCameraSettings: String)
    self.temp.states.isAiming = newCameraSettings == "ZoomedShoulder"

    if newCameraSettings == "DefaultShoulder" then
        -- Stops all animations but starts holding animation
        self.animations.aim:Stop()
        self.animations.hold:Play()
    elseif newCameraSettings == "ZoomedShoulder" then
        -- Stops all animations but starts aim animation
        self.animations.aim:Play()
    end
end

-- indirect

function module:reload()   
    if self.temp.states.isAiming then
        return
    end

    self.temp.states.isReloading = true
    self.animations.reload:Play()
    self.animations.reload.Stopped:Wait()
    self.animations.hold:Play()
    self.temp.states.isReloading = false
end

function module:updateMouseIcon()
	if self.temp.mouse and not self.tool.Parent:IsA("Backpack") then
		self.temp.mouse.Icon = Settings.mouseIcon
	end
end

return module