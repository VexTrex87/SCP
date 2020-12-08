local module = {}
module.__index = module

-- // VARIABLES \\ --

-- services
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Debris = game:GetService("Debris")

-- modules
local assets = require(game.ReplicatedStorage.Modules.Assets)
local Settings = require(script.Parent.Parent.Settings[script.Name])
local thirdPersonCamera = require(game.ReplicatedStorage.Modules.ThirdPersonCamera)
local updateGUI = require(script.Parent.Parent.GunInfoGUI)

-- libraries
local waitForPath = require(ReplicatedStorage.Modules.Core.waitForPath)
local disconnectConnections = require(ReplicatedStorage.Modules.Core.disconnectConnections)
local playSound = require(ReplicatedStorage.Modules.Core.playSound)
local randomNumber = require(ReplicatedStorage.Modules.Core.randomNumber)
local newTween = require(ReplicatedStorage.Modules.Core.newTween)

-- objects
local player = game.Players.LocalPlayer
local character = player.Character
local humanoid = character:WaitForChild("Humanoid")

-- // FUNCTIONS \\ --

function module.new(tool)

    -- create vars for metatable
    local animator = humanoid:WaitForChild("Animator")

    -- create metatable
    local self = setmetatable({
        tool = tool,
        remotes = tool:WaitForChild("Remotes"),
        stateChangedEvent = game.ReplicatedStorage.Objects.Remotes.Movement.StateChanged,
        animations = {
            hold = animator:LoadAnimation(waitForPath(tool, "Animations.Hold")),
            runningHold = animator:LoadAnimation(waitForPath(tool, "Animations.RunningHold")),
            aim = animator:LoadAnimation(waitForPath(tool, "Animations.Aim")),
            reload = animator:LoadAnimation(waitForPath(tool, "Animations.Reload")),
        },
        values = {
            fireMode = waitForPath(tool, "Values.FireMode"),
            ammo = waitForPath(tool, "Values.Ammo"),
        },
        sounds = {
            hit = waitForPath(tool, "Sounds.Hit"),
            jam = waitForPath(tool, "Sounds.Jam"),
        },
        temp = {
            mouse = nil,
            timeOfRecentFire = os.clock(),
            states = {
                isEquipped = false,
                isAiming = false,
                isReloading = false,
                isMouseDown = false,
                currentAnimationState = "WALK"
            },
            connections = {
                activeCameraSettingsChanged = nil,
                inputBegan = nil,
                inputEnded = nil,
                stepped = nil,
                damageIndicatorFired = nil,
                stateChanged = nil,
                ammoChanged = nil,
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

    self.remotes.DamageIndicator.OnClientEvent:Connect(function(...)
        self:indicateDamage(...)
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

    -- play sound
    self.remotes.ChangeState:FireServer("EQUIP")

    -- update GUI
    updateGUI({
        gunName = Settings.gun.name,
        fireMode = self.values.fireMode.Value,
        currentAmmo = self.values.ammo.Value,
        maxAmmo = Settings.gun.maxAmmo,
        gunIcon = assets[string.lower(script.Name)],
    })

    -- init events
    self:initEvents()
end

function module:onToolUnequipped()
    -- disable states
    self.temp.states.isEquipped = false
    self.temp.states.isReloading = false
    self.temp.states.isAiming = false

    -- disconnect connections
    disconnectConnections(self.temp.connections)

    -- stop third person camera
    thirdPersonCamera:Disable()

    -- stop all animations
    self.animations.runningHold:Stop()
    self.animations.hold:Stop()
    self.animations.aim:Stop()
    self.animations.reload:Stop()

    -- play sound
    self.remotes.ChangeState:FireServer("UNEQUIP")

    -- update GUI
    updateGUI()
end

function module:onInputBegan(input, gameProcessed)
    if gameProcessed then
        return
    end

    if input.KeyCode == Settings.keybinds.reload then
        self:reload()
    elseif input.KeyCode == Settings.keybinds.changeFireMode then
        self:changeFireMode()
    elseif input.UserInputType == Enum.UserInputType.MouseButton1 then
		if self.values.fireMode.Value == "AUTO" then
            self.temp.states.isMouseDown = true 
	elseif self.values.fireMode.Value == "SEMI" then
		self:shoot()
		end	
    end
end

function module:onInputEnded(input, gameProcessed)
    if gameProcessed or input.UserInputType == Enum.UserInputType.MouseButton1 then
        self.temp.states.isMouseDown = false
    end
end

function module:onStepped()
    if self.temp.states.isMouseDown then
		self:shoot()
	end
end

function module:onActiveCameraSettingsChanged(newCameraSettings: String)
    self.temp.states.isAiming = newCameraSettings == "ZoomedShoulder"

    if newCameraSettings == "DefaultShoulder" then
        self.animations.aim:Stop()
        self.animations.hold:Play()
        self.remotes.ChangeState:FireServer("AIM_OUT")
    elseif newCameraSettings == "ZoomedShoulder" then
        self.animations.aim:Play()
        self.remotes.ChangeState:FireServer("AIM_IN")
    end
end

function module:indicateDamage(targetCharacter, damageType, damageAmount)
    -- find humanoid root part
    local root = targetCharacter:FindFirstChild("HumanoidRootPart")
    if not root then
        return
    end

    -- create new indicator
    local newIndicator = self.tool.UI.DamageIndicator:Clone()
    newIndicator.TextLabel.Text = damageAmount

    -- set properties for GUI
    for propertyName, propertyValue in pairs(Settings.UI.damageIndicator[damageType]) do
        newIndicator.TextLabel[propertyName] = propertyValue
    end

    newIndicator.Enabled = true
    newIndicator.Parent = root 
    Debris:AddItem(newIndicator, Settings.UI.damageIndicator.maxduration)
    playSound(self.sounds.hit, self.tool.Handle)

    -- set position of GUI
    local minOffset = Settings.UI.damageIndicator.minOffset
    local maxOffset = Settings.UI.damageIndicator.minOffset
    newIndicator.StudsOffset = Vector3.new(
        randomNumber(minOffset.X, maxOffset.X, 10),
        randomNumber(minOffset.Y, maxOffset.Y, 10), 
        0
    )   
    newTween(newIndicator.TextLabel, Settings.UI.damageIndicator.tweenInfo, {TextTransparency = 0}).Completed:Wait()
    newTween(newIndicator.TextLabel, Settings.UI.damageIndicator.tweenInfo, {TextTransparency = 1})
end

function module:stateChanged(newState)
    self.temp.states.currentAnimationState = newState
    if newState == "SPRINT" then
        self.animations.hold:Stop()
        self.animations.runningHold:Play()
    elseif newState == "WALK" then
        self.animations.runningHold:Stop()
        self.animations.hold:Play()
    end
end

-- indirect

function module:initEvents()
    disconnectConnections(self.temp.connections)

    self.temp.connections.stateChanged = self.stateChangedEvent.Event:Connect(function(...)
        self:stateChanged(...)
    end)

    self.temp.connections.ammoChanged = self.values.ammo.Changed:Connect(function()
    updateGUI({
        gunName = Settings.gun.name,
        fireMode = self.values.fireMode.Value,
        currentAmmo = self.values.ammo.Value,
        maxAmmo = Settings.gun.maxAmmo,
        gunIcon = assets[string.lower(script.Name)],
    })
    end)

    self.temp.connections.activeCameraSettingsChanged = thirdPersonCamera.ActiveCameraSettingsChanged:Connect(function(...)
        self:onActiveCameraSettingsChanged(...)
    end)

    self.temp.connections.inputBegan = UserInputService.InputBegan:Connect(function(...)
        self:onInputBegan(...)
    end)

    if self.values.fireMode.Value == "AUTO" then	
        self.temp.connections.inputEnded = UserInputService.InputEnded:Connect(function(...)
            self:onInputEnded(...)
        end)
    
        self.temp.connections.stepped = RunService.Stepped:Connect(function()
            self:onStepped()
        end)
    end
end

function module:changeFireMode()
    local oldFireMode = self.values.fireMode.Value
    local newFireMode = self.remotes.ChangeFireMode:InvokeServer()
    if newFireMode and newFireMode ~= oldFireMode then
    updateGUI({
        gunName = Settings.gun.name,
        fireMode = self.values.fireMode.Value,
        currentAmmo = self.values.ammo.Value,
        maxAmmo = Settings.gun.maxAmmo,
        gunIcon = assets[string.lower(script.Name)],
    })
        self:initEvents()
    end
end

function module:reload()   
    if self.temp.states.isAiming or self.temp.states.isReloading or self.temp.states.currentAnimationState ~= "WALK" or self.temp.states.isMouseDown then
        return
    end

    self.temp.states.isReloading = true
    self.remotes.ChangeState:FireServer("RELOAD")
    self.animations.reload:Play()
    self.animations.reload.Stopped:Wait()
    self.animations.hold:Play()
    self.temp.states.isReloading = false
end

function module:shoot()
    if self.temp.states.isReloading then
        return
    end

    if os.clock() - self.temp.timeOfRecentFire >= 60 / Settings.gun.fireRate then
        self.temp.timeOfRecentFire = os.clock()
        local success, errorMessage = self.remotes.Shoot:InvokeServer(self.temp.mouse.Hit.Position)
        if not success and errorMessage == "NO_AMMO" then
            self.sounds.jam:Play()
        end
    end
end

function module:updateMouseIcon()
	if self.temp.mouse and not self.tool.Parent:IsA("Backpack") then
		self.temp.mouse.Icon = Settings.mouseIcon
	end
end

return module