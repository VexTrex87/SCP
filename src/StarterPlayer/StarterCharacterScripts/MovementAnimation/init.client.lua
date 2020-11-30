-- // VARIABLES \\ --

-- services
local UserInputService = game:GetService("UserInputService")

-- libraries
local core = require(game.ReplicatedStorage.Modules.Core)
local newTween = core("newTween")
local disconnectConnections = core("disconnectConnections")

-- modules
local Settings = require(script:WaitForChild("Settings"))

-- objects
local camera = workspace.CurrentCamera
local character = script.Parent
local humanoid = character:WaitForChild("Humanoid")
local animator = humanoid:WaitForChild("Animator")
local sprintAnimation = animator:LoadAnimation(script:WaitForChild("Sprint"))
local crouchAnimation = animator:LoadAnimation(script:WaitForChild("Crouch"))
local rollAnimation = animator:LoadAnimation(script:WaitForChild("Roll"))

-- temp
local onInputBeganCon, onInputEndCon

-- // EVENTS \\ --

onInputBeganCon = UserInputService.InputBegan:Connect(function(input, gameProcessed)
	if gameProcessed then
		return
	end
	
	if input.KeyCode == Settings.sprintKey then
		humanoid.WalkSpeed = Settings.sprintSpeed
        newTween(camera, Settings.povTweenInfo, {FieldOfView = Settings.sprintFov})
        sprintAnimation:Play()
	elseif input.KeyCode == Settings.crouchKey then
		humanoid.WalkSpeed = Settings.crouchSpeed
		newTween(camera, Settings.povTweenInfo, {FieldOfView = Settings.crouchFov})
		crouchAnimation:Play()	
	elseif input.KeyCode == Settings.rollKey then
		rollAnimation:Play()
	end
end)

onInputEndCon = UserInputService.InputEnded:Connect(function(input, gameProcessed)
	if gameProcessed then
		return
	end

	if input.KeyCode == Settings.sprintKey or input.KeyCode == Settings.crouchKey then
		humanoid.WalkSpeed = Settings.walkSpeed
        newTween(camera, Settings.povTweenInfo, {FieldOfView = Settings.walkFov})
        sprintAnimation:Stop()
        crouchAnimation:Stop()
	end
end)

humanoid.Died:Connect(function()
    disconnectConnections({onInputBeganCon, onInputEndCon})
end)

-- // COMPILE \\ --

humanoid.WalkSpeed = Settings.walkSpeed