local CLASS = {}

local UPDATE_UNIQUE_KEY = "OTS_CAMERA_SYSTEM_UPDATE"

local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Configuration = require(ReplicatedStorage.Configuration.Camera)

local player = game.Players.LocalPlayer

function CLASS.new()
	
	--// Events //--
	local activeCameraSettingsChangedEvent = Instance.new("BindableEvent")
	local characterAlignmentChangedEvent = Instance.new("BindableEvent")
	local mouseStepChangedEvent = Instance.new("BindableEvent")
	local shoulderDirectionChangedEvent = Instance.new("BindableEvent")
	local enabledEvent = Instance.new("BindableEvent")
	local disabledEvent = Instance.new("BindableEvent")
	----
	
	local dataTable = setmetatable(
		{
			
			--// Properties //--
			SavedCameraSettings = nil,
			SavedMouseBehavior = nil,
			ActiveCameraSettings = nil,
			HorizontalAngle = 0,
			VerticalAngle = 0,
			ShoulderDirection = 1,
			----
			
			--// Flags //--
			IsCharacterAligned = false,
			IsMouseSteppedIn = false,
			IsEnabled = false,
			----
			
			--// Events //--
			ActiveCameraSettingsChangedEvent = activeCameraSettingsChangedEvent,
			ActiveCameraSettingsChanged = activeCameraSettingsChangedEvent.Event,
			CharacterAlignmentChangedEvent = characterAlignmentChangedEvent,
			CharacterAlignmentChanged = characterAlignmentChangedEvent.Event,
			MouseStepChangedEvent = mouseStepChangedEvent,
			MouseStepChanged = mouseStepChangedEvent.Event,
			ShoulderDirectionChangedEvent = shoulderDirectionChangedEvent,
			ShoulderDirectionChanged = shoulderDirectionChangedEvent.Event,
			EnabledEvent = enabledEvent,
			Enabled = enabledEvent.Event,
			DisabledEvent = disabledEvent,
			Disabled = disabledEvent.Event,
			----
			
			--// Configurations //--
			VerticalAngleLimits = NumberRange.new(-45, 45),
			----
			
			--// Camera Settings //--
			CameraSettings = Configuration
			----
			
		},
		CLASS
	)
	local proxyTable = setmetatable(
		{
			
		},
		{
			__index = function(self, index)
				return dataTable[index]
			end,
			__newindex = function(self, index, newValue)
				dataTable[index] = newValue
			end
		}
	)
	
	return proxyTable
end

--// FUNCTIONS //--

local function Lerp(x, y, a)
	return x + (y - x) * a
end

--// METHODS //--

--// //--
function CLASS:SetActiveCameraSettings(cameraSettings)
	assert(cameraSettings ~= nil, "OTS Camera System Argument Error: Argument 1 nil or missing")
	assert(typeof(cameraSettings) == "string", "OTS Camera System Argument Error: string expected, got " .. typeof(cameraSettings))
	assert(self.CameraSettings[cameraSettings] ~= nil, "OTS Camera System Argument Error: Attempt to set unrecognized camera settings " .. cameraSettings)
	if self.IsEnabled == false then
		warn("OTS Camera System Logic Warning: Attempt to change active camera settings without enabling OTS camera system")
		return
	end

	self.ActiveCameraSettings = cameraSettings
	self.ActiveCameraSettingsChangedEvent:Fire(cameraSettings)
end

function CLASS:SetCharacterAlignment(aligned)
	assert(aligned ~= nil, "OTS Camera System Argument Error: Argument 1 nil or missing")
	assert(typeof(aligned) == "boolean", "OTS Camera System Argument Error: boolean expected, got " .. typeof(aligned))
	if self.IsEnabled == false then
		warn("OTS Camera System Logic Warning: Attempt to change character alignment without enabling OTS camera system")
		return
	end
	
	self.IsCharacterAligned = aligned
	self.CharacterAlignmentChangedEvent:Fire(aligned)
end

function CLASS:SetMouseStep(steppedIn)
	assert(steppedIn ~= nil, "OTS Camera System Argument Error: Argument 1 nil or missing")
	assert(typeof(steppedIn) == "boolean", "OTS Camera System Argument Error: boolean expected, got " .. typeof(steppedIn))
	if self.IsEnabled == false then
		warn("OTS Camera System Logic Warning: Attempt to change mouse step without enabling OTS camera system")
		return
	end
	
	self.IsMouseSteppedIn = steppedIn
	self.MouseStepChangedEvent:Fire(steppedIn)
	if steppedIn == true then
		UserInputService.MouseBehavior = Enum.MouseBehavior.LockCenter
	else
		UserInputService.MouseBehavior = Enum.MouseBehavior.Default
	end
end

function CLASS:SetShoulderDirection(shoulderDirection)
	assert(shoulderDirection ~= nil, "OTS Camera System Argument Error: Argument 1 nil or missing")
	assert(typeof(shoulderDirection) == "number", "OTS Camera System Argument Error: number expected, got " .. typeof(shoulderDirection))
	assert(math.abs(shoulderDirection) == 1, "OTS Camera System Argument Error: Attempt to set unrecognized shoulder direction " .. shoulderDirection)
	if self.IsEnabled == false then
		warn("OTS Camera System Logic Warning: Attempt to change shoulder direction without enabling OTS camera system")
		return
	end
	
	self.ShoulderDirection = shoulderDirection
	self.ShoulderDirectionChangedEvent:Fire(shoulderDirection)
end
----

--// //--
function CLASS:SaveCameraSettings()
	local currentCamera = workspace.CurrentCamera
	self.SavedCameraSettings = {
		FieldOfView = currentCamera.FieldOfView,
		CameraSubject = currentCamera.CameraSubject,
		CameraType = currentCamera.CameraType
	}
end

function CLASS:LoadCameraSettings()
	local currentCamera = workspace.CurrentCamera
	for setting, value in pairs(self.SavedCameraSettings) do
		currentCamera[setting] = value
	end
end
----

--// //--
function CLASS:Update()
	local currentCamera = workspace.CurrentCamera
	local activeCameraSettings = self.CameraSettings[self.ActiveCameraSettings]
	
	--// Address mouse behavior and camera type //--
	if self.IsMouseSteppedIn == true then
		UserInputService.MouseBehavior = Enum.MouseBehavior.LockCenter
	else
		UserInputService.MouseBehavior = Enum.MouseBehavior.Default
	end
	currentCamera.CameraType = Enum.CameraType.Scriptable
	---
	
	--// Address mouse input //--
	local mouseDelta = UserInputService:GetMouseDelta() * activeCameraSettings.Sensitivity
	self.HorizontalAngle -= mouseDelta.X/currentCamera.ViewportSize.X
	self.VerticalAngle -= mouseDelta.Y/currentCamera.ViewportSize.Y
	self.VerticalAngle = math.rad(math.clamp(math.deg(self.VerticalAngle), self.VerticalAngleLimits.Min, self.VerticalAngleLimits.Max))
	----
	
	local character = player.Character or player.CharacterAdded:Wait()
	local humanoidRootPart = character:WaitForChild("HumanoidRootPart")
	if humanoidRootPart ~= nil then
		
		--// Lerp field of view //--
		currentCamera.FieldOfView = Lerp(
			currentCamera.FieldOfView, 
			activeCameraSettings.FieldOfView, 
			activeCameraSettings.LerpSpeed
		)
		----
		
		--// Address shoulder direction //--
		local offset = activeCameraSettings.Offset
		offset = Vector3.new(offset.X * self.ShoulderDirection, offset.Y, offset.Z)
		----
		
		--// Calculate new camera cframe //--
		local newCameraCFrame = CFrame.new(humanoidRootPart.Position) *
			CFrame.Angles(0, self.HorizontalAngle, 0) *
			CFrame.Angles(self.VerticalAngle, 0, 0) *
			CFrame.new(offset)
		
		newCameraCFrame = currentCamera.CFrame:Lerp(newCameraCFrame, activeCameraSettings.LerpSpeed)
		----
		
		--// Raycast for obstructions //--
		local raycastParams = RaycastParams.new()
		raycastParams.FilterDescendantsInstances = {character}
		raycastParams.FilterType = Enum.RaycastFilterType.Blacklist
		local raycastResult = workspace:Raycast(
			humanoidRootPart.Position,
			newCameraCFrame.Position - humanoidRootPart.Position,
			raycastParams
		)
		----
		
		--// Address obstructions if any //--
		if raycastResult ~= nil then
			local obstructionDisplacement = (raycastResult.Position - humanoidRootPart.Position)
            local obstructionPosition = humanoidRootPart.Position + (obstructionDisplacement.Unit * (obstructionDisplacement.Magnitude - 0.1))
            local cFrameComponents = table.pack(newCameraCFrame:GetComponents())
			newCameraCFrame = CFrame.new(
                obstructionPosition.X or 0,
                obstructionPosition.Y or 0,
                obstructionPosition.Z or 0,
                cFrameComponents[4] or 0,
                cFrameComponents[5] or 0,
                cFrameComponents[6] or 0,
                cFrameComponents[7] or 0,
                cFrameComponents[8] or 0,
                cFrameComponents[9] or 0,
                cFrameComponents[10] or 0,
                cFrameComponents[11] or 0,
                cFrameComponents[12] or 0
            )
		end
		----
		
		--// Address character alignment //--
		if self.IsCharacterAligned == true then
			local newHumanoidRootPartCFrame = CFrame.new(humanoidRootPart.Position) *
				CFrame.Angles(0, self.HorizontalAngle, 0)
			humanoidRootPart.CFrame = humanoidRootPart.CFrame:Lerp(newHumanoidRootPartCFrame, activeCameraSettings.LerpSpeed/2)
		end
		----
		
		currentCamera.CFrame = newCameraCFrame
		
	else
		self:Disable()
	end
end

function CLASS:ConfigureStateForEnabled()
	self:SaveCameraSettings()
	self.SavedMouseBehavior = UserInputService.MouseBehavior
	self:SetActiveCameraSettings("DefaultShoulder")
	self:SetCharacterAlignment(false)
	self:SetMouseStep(true)
	self:SetShoulderDirection(1)
	
	--// Calculate angles //--
	local cameraCFrame = workspace.CurrentCamera.CFrame
	local x, y = cameraCFrame:ToOrientation()
	local horizontalAngle = y
	local verticalAngle = x
	----
	
	self.HorizontalAngle = horizontalAngle
	self.VerticalAngle = verticalAngle
end

function CLASS:ConfigureStateForDisabled()
	self:LoadCameraSettings()
	UserInputService.MouseBehavior = self.SavedMouseBehavior
	self:SetActiveCameraSettings("DefaultShoulder")
	self:SetCharacterAlignment(false)
	self:SetMouseStep(false)
	self:SetShoulderDirection(1)
	self.HorizontalAngle = 0
	self.VerticalAngle = 0
end

function CLASS:Enable()
	assert(self.IsEnabled == false, "OTS Camera System Logic Error: Attempt to enable without disabling")
	
	self.IsEnabled = true
	self.EnabledEvent:Fire()
	self:ConfigureStateForEnabled()
	
	RunService:BindToRenderStep(
		UPDATE_UNIQUE_KEY,
		Enum.RenderPriority.Camera.Value - 10,
		function()
			if self.IsEnabled == true then
				self:Update()
			end
		end
	)
end

function CLASS:Disable()
	assert(self.IsEnabled == true, "OTS Camera System Logic Error: Attempt to disable without enabling")
	
	self:ConfigureStateForDisabled()
	self.IsEnabled = false
	self.DisabledEvent:Fire()
	
	RunService:UnbindFromRenderStep(UPDATE_UNIQUE_KEY)
end
----

--// INSTRUCTIONS //--

CLASS.__index = CLASS

local singleton = CLASS.new()

return singleton