local module = {}
module.__index = module

-- // VARIABLES \\ -

-- constants
local RNG = Random.new()
local TAU = math.pi * 2	

-- modules
local Settings = require(game.ReplicatedStorage.GunSystem.Settings[script.Name])
local fastCast = require(script.Parent.FastCastRedux)
local partCache = require(script.Parent.PartCache)

-- libraries
local core = require(game.ServerStorage.Modules.Core)
local newThread = core("newThread")
local playSound = core("playSound")

-- objects
local cosmeticBulletsFolder = workspace:FindFirstChild("CosmeticBulletsFolder") or Instance.new("Folder")
cosmeticBulletsFolder.Name = "CosmeticBulletsFolder"
cosmeticBulletsFolder.Parent = workspace

-- // FUNCTIONS \\ --

function module.new(tool)

    -- create metatable
    local self = setmetatable({
        tool = tool,
        handle = tool.Handle,
        remotes = tool.Remotes,
        sounds = tool.Sounds,
        fastCast = {
			caster = fastCast.new(),
			cosmeticBullet = nil,
			castParams = nil,
			castBehavior = nil,
		},
        temp = {
            canFire = true,
        }
    }, module)

    -- create bullet
    self.fastCast.cosmeticBullet = Instance.new("Part")
	for propertyName, propertyValue in pairs(Settings.bulletProps) do
		self.fastCast.cosmeticBullet[propertyName] = propertyValue
    end 
    
    -- new raycast paras
	self.fastCast.castParams = RaycastParams.new()
	for propertyName, propertyValue in pairs(Settings.raycastParas) do
		self.fastCast.castParams[propertyName] = propertyValue
	end

	-- data packets
	self.fastCast.castBehavior = fastCast.newBehavior()
	self.fastCast.castBehavior.RaycastParams = self.fastCast.castParams
	self.fastCast.castBehavior.MaxDistance = Settings.bulletMaxDist

	-- part cache
	local cosmeticPartProvider = partCache.new(self.fastCast.cosmeticBullet, 100, cosmeticBulletsFolder)
	self.fastCast.castBehavior.CosmeticBulletProvider = cosmeticPartProvider
	self.fastCast.castBehavior.CosmeticBulletContainer = cosmeticPartProvider
	self.fastCast.castBehavior.Acceleration = Settings.bulletGravity
	self.fastCast.castBehavior.AutoIgnoreContainer = false
	
	-- events
	
	self.fastCast.caster.RayHit:Connect(function(...)
		self:onRayHit(...)
	end)
	
	self.fastCast.caster.LengthChanged:Connect(function(...)
		self:onRayUpdated(...)
	end)
	
	self.fastCast.caster.CastTerminating:Connect(function(...)
		self:onRayTerminated(...)
	end)

    self.remotes.ChangeState.OnServerEvent:Connect(function(...)
        self:onChangeStateFired(...)
    end)

    self.remotes.Shoot.OnServerEvent:Connect(function(...)
        self:shoot(...)
    end)

end

-- fast cast events

function module:onRayHit(cast, raycastResult, segmentVelocity, cosmeticBulletObject, sender)
    -- check if ray hit a part
    local hitPart = raycastResult.Instance
    if not hitPart then
        return
    end

    -- check if ray hit a character
    local character = self:getCharacterFromHitPart(hitPart) or hitPart.Parent:FindFirstChildWhichIsA("Humanoid") and hitPart.Parent
    if not character then
        return
    end

    -- check if the character the ray hit has a humanoid
    local humanoid = character:FindFirstChildWhichIsA("Humanoid")
    if not humanoid then
        return
    end

    -- deal damage depending on where it was hit
    for _, damageInfo in pairs(Settings.damageTypes) do
        if typeof(damageInfo.partNames) == "table" then
            if table.find(damageInfo.partNames, hitPart.Name) then
                humanoid:TakeDamage(damageInfo.amount)
            end
        else
            humanoid:TakeDamage(damageInfo.amount)
        end
    end
end

function module:onRayUpdated(cast, segmentOrigin, segmentDirection, length, segmentVelocity, cosmeticBulletObject)
    -- check bullet still exists
	if not cosmeticBulletObject then 
		return 
	end

	-- adjust bullet size
	local bulletVelocity = (math.abs(segmentVelocity.X) + math.abs(segmentVelocity.Y) + math.abs(segmentVelocity.Z))
	cosmeticBulletObject.Size = Vector3.new(cosmeticBulletObject.Size.X, cosmeticBulletObject.Size.Y, bulletVelocity / Settings.bulletLengthMultiplier)

	-- adjust bullet pos
	local bulletLength = cosmeticBulletObject.Size.Z / 2
	local baseCFrame = CFrame.new(segmentOrigin, segmentOrigin + segmentDirection)
	cosmeticBulletObject.CFrame = baseCFrame * CFrame.new(0, 0, -(length - bulletLength))
end

function module:onRayTerminated(cast)
    -- check if bullet exists
    local cosmeticBullet = cast.RayInfo.CosmeticBulletObject
    if not cosmeticBullet then
        return
    end    

    if self.fastCast.castBehavior.CosmeticBulletProvider then
        self.fastCast.castBehavior.CosmeticBulletProvider:ReturnPart(cosmeticBullet)
    else
        cosmeticBullet:Destroy()
    end
end

-- remotes

function module:onChangeStateFired(player, newState)
    if newState == "EQUIP" or newState == "AIM_IN" then
        newThread(playSound, self.sounds.Equip, self.handle)
        self.handle.Equip:Play()
    elseif newState == "UNEQUIP" or newState == "AIM_OUT" then
        newThread(playSound, self.sounds.Unequip, self.handle)
    elseif newState == "RELOAD" then
        newThread(playSound, self.sounds.Reload, self.handle)
    end
end

function module:shoot(player, mousePoint)

	-- check if gun is equipped
	if self.tool.Parent:IsA("Backpack") then 
        self.temp.canFire = true
        return
    end	
    self.temp.canFire = false

	-- fire gun
	local mouseDirection = (mousePoint - self.handle.GunFirePoint.WorldPosition).Unit
	self:shootBullet(mouseDirection, player)

	-- end debounce
	self.temp.canFire = true
end

-- indirect

function module:shootBullet(direction, sender)	
	-- random angles
	local directionalCF = CFrame.new(Vector3.new(), direction)
	direction = (directionalCF * CFrame.fromOrientation(0, 0, RNG:NextNumber(0, TAU)) * CFrame.fromOrientation(math.rad(RNG:NextNumber(Settings.minBulletSpreadAngle, Settings.maxBulletSpreadAngle)), 0, 0)).LookVector

	-- realistic bullet velocity
	local root = self.tool.Parent:WaitForChild("HumanoidRootPart", 1)
	local myMovementSpeed = root.Velocity
	local modifiedBulletSpeed = (direction * Settings.bulletSpeed) + myMovementSpeed

	-- fire bullet
    self.fastCast.caster:Fire(self.handle.GunFirePoint.WorldPosition, direction, modifiedBulletSpeed, self.fastCast.castBehavior, sender)
	newThread(playSound, self.sounds.Shoot, self.handle)	
end

function module:getCharacterFromHitPart(part)
	local currentInstance = part
	repeat
		if currentInstance:FindFirstChildWhichIsA("Humanoid") then
			return currentInstance
		else
			currentInstance = currentInstance.Parent
		end
	until currentInstance:IsA("Workspace")
end

return module