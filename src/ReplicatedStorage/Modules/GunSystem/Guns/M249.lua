local module = {}
module.__index = module

-- // VARIABLES \\ --

-- services
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Debris = game:GetService("Debris")

-- modules
local gunName = script.Name
local modules = ReplicatedStorage.Modules
local Assets = require(modules.Assets)
local Configuration = require(modules.GunSystem.Configuration[gunName])
local ThirdPersonCamera = require(modules.ThirdPersonCamera)
local GunGui = require(modules.GunSystem.GunInfoGUI)

-- libraries
local coreModules = modules.Core
local waitForPath = require(coreModules.WaitForPath)
local disconnectConnections = require(coreModules.DisconnectConnections)
local playSound = require(coreModules.PlaySound)
local randomNumber = require(coreModules.RandomNumber)
local newTween = require(coreModules.NewTween)

-- objects
local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")

-- // FUNCTIONS \\ --

function module.new(tool)
    local animator = humanoid:WaitForChild("Animator")
    local self = setmetatable({
        tool = tool,
        remotes = tool:WaitForChild("Remotes"),
        stateChangedEvent = ReplicatedStorage.Objects.Remotes.Movement.StateChanged,
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

    self:initEvents()
end

-- direct

function module:onToolEquipped(playerMouse)
    self.temp.states.isEquipped = true

    -- start third person camera
    ThirdPersonCamera:Enable()
    ThirdPersonCamera:SetCharacterAlignment(true)

    self.temp.mouse = playerMouse
    self:updateMouseIcon()
    self.animations.hold:Play()
    self.remotes.ChangeState:FireServer("EQUIP")

    -- update GUI
    GunGui.show({
        gunName = Configuration.gun.name,
        fireMode = self.values.fireMode.Value,
        currentAmmo = self.values.ammo.Value,
        maxAmmo = Configuration.gun.maxAmmo,
        gunIcon = Assets[string.lower(gunName)],
    })

    self:initEquipEvents()
end

function module:onToolUnequipped()
    -- disable states
    self.temp.states.isEquipped = false
    self.temp.states.isReloading = false
    self.temp.states.isAiming = false

    disconnectConnections(self.temp.connections)
    ThirdPersonCamera:Disable()
    self.remotes.ChangeState:FireServer("UNEQUIP")

    -- stop all animations
    self.animations.runningHold:Stop()
    self.animations.hold:Stop()
    self.animations.aim:Stop()
    self.animations.reload:Stop()

    GunGui.hide()
end

function module:onInputBegan(input, gameProcessed)
    if gameProcessed then
        return
    end

    if input.KeyCode == Configuration.keybinds.reload then
        self:reload()
    elseif input.KeyCode == Configuration.keybinds.changeFireMode then
        self:changeFireMode()
    elseif input.UserInputType == Enum.UserInputType.MouseButton1 then
		if self.values.fireMode.Value == "AUTO" then
            self.temp.states.isMouseDown = true 
        end
	elseif self.values.fireMode.Value == "SEMI" then
		self:shoot()
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

    for propertyName, propertyValue in pairs(Configuration.UI.damageIndicator[damageType]) do
        newIndicator.TextLabel[propertyName] = propertyValue
    end

    newIndicator.Enabled = true
    newIndicator.Parent = root 
    Debris:AddItem(newIndicator, Configuration.UI.damageIndicator.maxduration)
    playSound(self.sounds.hit, self.tool.Handle)

    local minOffset = Configuration.UI.damageIndicator.minOffset
    local maxOffset = Configuration.UI.damageIndicator.minOffset
    newIndicator.StudsOffset = Vector3.new(
        randomNumber(minOffset.X, maxOffset.X, 10),
        randomNumber(minOffset.Y, maxOffset.Y, 10), 
        0
    )   
    newTween(newIndicator.TextLabel, Configuration.UI.damageIndicator.tweenInfo, {TextTransparency = 0}).Completed:Wait()
    newTween(newIndicator.TextLabel, Configuration.UI.damageIndicator.tweenInfo, {TextTransparency = 1})
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

function module:initEquipEvents()
    disconnectConnections(self.temp.connections)

    self.temp.connections.stateChanged = self.stateChangedEvent.Event:Connect(function(...)
        self:stateChanged(...)
    end)

    self.temp.connections.ammoChanged = self.values.ammo.Changed:Connect(function()
        GunGui.update({
            gunName = Configuration.gun.name,
            fireMode = self.values.fireMode.Value,
            currentAmmo = self.values.ammo.Value,
            maxAmmo = Configuration.gun.maxAmmo,
            gunIcon = Assets[string.lower(gunName)],
        })
    end)

    self.temp.connections.activeCameraSettingsChanged = ThirdPersonCamera.ActiveCameraSettingsChanged:Connect(function(...)
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
        GunGui.update({
            gunName = Configuration.gun.name,
            fireMode = self.values.fireMode.Value,
            currentAmmo = self.values.ammo.Value,
            maxAmmo = Configuration.gun.maxAmmo,
            gunIcon = Assets[string.lower(gunName)],
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

    if os.clock() - self.temp.timeOfRecentFire >= 60 / Configuration.gun.fireRate then
        self.temp.timeOfRecentFire = os.clock()
        local success, errorMessage = self.remotes.Shoot:InvokeServer(self.temp.mouse.Hit.Position)
        if not success and errorMessage == "NO_AMMO" then
            self.sounds.jam:Play()
        end
    end
end

function module:updateMouseIcon()
	if self.temp.mouse and not self.tool.Parent:IsA("Backpack") then
		self.temp.mouse.Icon = Configuration.mouseIcon
	end
end

return module