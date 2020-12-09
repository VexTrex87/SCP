local module = {}
module.__index = module

-- // VARIABLES \\ --

-- services
local UserInputService = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- modules
local configuration = require(script.Configuration)
local newTween = require(ReplicatedStorage.Modules.Core.NewTween)
local disconnectConnections = require(ReplicatedStorage.Modules.Core.DisconnectConnections)

-- objects
local animationStorage = ReplicatedStorage.Objects.Animations.Movement
local stateChanged = ReplicatedStorage.Objects.Remotes.Movement.StateChanged

-- objects

function module.new(character)
	-- variables
	local humanoid = character:WaitForChild("Humanoid")
	local animator = humanoid:WaitForChild("Animator")

	-- create class
	local self = setmetatable({
		character = character,
		humanoid = humanoid,
		camera = workspace.CurrentCamera,
		animations = {
			sprint = animator:LoadAnimation(animationStorage.Sprint),
			crouch = animator:LoadAnimation(animationStorage.Crouch),
			roll = animator:LoadAnimation(animationStorage.Roll),
		},
		connections = {
			inputBegan = nil,
			inputEnded = nil,
		}
	}, module)

	-- set defaults
	self.humanoid.WalkSpeed = configuration.speeds.walk

	-- events
	self.connections.inputBegan = UserInputService.InputBegan:Connect(function(...)
		self:onInputBegan(...)
	end)
	
	self.connections.inputEnded = UserInputService.InputEnded:Connect(function(...)
		self:onInputEnded(...)
	end)
	
	humanoid.Died:Connect(function()
		self:onHumanoidDied()
	end)
end

function module:onInputBegan(input, gameProcessed)
	if gameProcessed then
		return
	end
	
	if input.KeyCode == configuration.keybinds.sprint then
		self.humanoid.WalkSpeed = configuration.speeds.sprint
		newTween(self.camera, configuration.povTweenInfo, {FieldOfView = configuration.fov.sprint})
		self.animations.sprint:Play()
		stateChanged:Fire("SPRINT")
	elseif input.KeyCode == configuration.keybinds.crouch then
		self.humanoid.WalkSpeed = configuration.speeds.crouch
		newTween(self.camera, configuration.povTweenInfo, {FieldOfView = configuration.fov.crouch})
		self.animations.crouch:Play()	
		stateChanged:Fire("CROUCH")
	elseif input.KeyCode == configuration.keybinds.roll then
		self.animations.roll:Play()
		stateChanged:Fire("ROLL")
	end
end

function module:onInputEnded(input, gameProcessed)
	if gameProcessed then
		return
	end

	if input.KeyCode == configuration.keybinds.sprint or input.KeyCode == configuration.keybinds.crouch then
		self.humanoid.WalkSpeed = configuration.speeds.walk
		newTween(self.camera, configuration.povTweenInfo, {FieldOfView = configuration.fov.walk})
		self.animations.sprint:Stop()
		self.animations.crouch:Stop()
		stateChanged:Fire("WALK")
	end
end

function module:onHumanoidDied()
	disconnectConnections(self.connections)
end

return module