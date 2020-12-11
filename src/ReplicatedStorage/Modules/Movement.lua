local module = {}
module.__index = module

-- // VARIABLES \\ --

-- services
local UserInputService = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- modules
local Configuration = require(ReplicatedStorage.Configuration.Movement)
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
	self.humanoid.WalkSpeed = Configuration.speeds.walk

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
	
	if input.KeyCode == Configuration.keybinds.sprint then
		self.humanoid.WalkSpeed = Configuration.speeds.sprint
		newTween(self.camera, Configuration.povTweenInfo, {FieldOfView = Configuration.fov.sprint})
		self.animations.sprint:Play()
		stateChanged:Fire("SPRINT")
	elseif input.KeyCode == Configuration.keybinds.crouch then
		self.humanoid.WalkSpeed = Configuration.speeds.crouch
		newTween(self.camera, Configuration.povTweenInfo, {FieldOfView = Configuration.fov.crouch})
		self.animations.crouch:Play()	
		stateChanged:Fire("CROUCH")
	elseif input.KeyCode == Configuration.keybinds.roll then
		self.animations.roll:Play()
		stateChanged:Fire("ROLL")
	end
end

function module:onInputEnded(input, gameProcessed)
	if gameProcessed then
		return
	end

	if input.KeyCode == Configuration.keybinds.sprint or input.KeyCode == Configuration.keybinds.crouch then
		self.humanoid.WalkSpeed = Configuration.speeds.walk
		newTween(self.camera, Configuration.povTweenInfo, {FieldOfView = Configuration.fov.walk})
		self.animations.sprint:Stop()
		self.animations.crouch:Stop()
		stateChanged:Fire("WALK")
	end
end

function module:onHumanoidDied()
	disconnectConnections(self.connections)
end

return module