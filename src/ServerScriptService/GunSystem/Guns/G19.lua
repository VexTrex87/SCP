local module = {}
module.__index = module

-- // VARIABLES \\ -

-- constants
local RNG = Random.new()
local TAU = math.pi * 2	

-- services
local Debris = game:GetService("Debris")

-- modules
local Settings = require(game.ReplicatedStorage.Modules.GunSystem.Settings[script.Name])
local fastCast = require(script.Parent.Parent.FastCastRedux)
local partCache = require(script.Parent.Parent.PartCache)

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
        owner = tool.Parent.Parent,
        values = {
            fireMode = tool.Values.FireMode,
            ammo = tool.Values.Ammo,
        },
        sounds = {
            equip = tool.Sounds.Equip,
            unequip = tool.Sounds.Unequip,
            shoot = tool.Sounds.Shoot,
            reload = tool.Sounds.Reload,
        },
        effects = {
            impactParticle = tool.Handle.ImpactParticle,
            muzzleFlash = tool.Handle.MuzzleFlash,
            muzzleLight = tool.Handle.GunFirePoint.MuzzleLight,
            muzzleSmoke = tool.Handle.GunFirePoint.Smoke,
        },
        fastCast = {
			caster = fastCast.new(),
			cosmeticBullet = nil,
			castParams = nil,
			castBehavior = nil,
		},
        temp = {
            timeOfRecentFire = os.clock(),
            canFire = true,
        }
    }, module)

    -- create bullet
    self.fastCast.cosmeticBullet = Instance.new("Part")
	for propertyName, propertyValue in pairs(Settings.bullet.properties) do
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
	self.fastCast.castBehavior.MaxDistance = Settings.bullet.bulletMaxDist

	-- part cache
	local cosmeticPartProvider = partCache.new(self.fastCast.cosmeticBullet, 100, cosmeticBulletsFolder)
	self.fastCast.castBehavior.CosmeticBulletProvider = cosmeticPartProvider
	self.fastCast.castBehavior.CosmeticBulletContainer = cosmeticPartProvider
	self.fastCast.castBehavior.Acceleration = Settings.bullet.bulletGravity
	self.fastCast.castBehavior.AutoIgnoreContainer = false
    
    -- set ammo
    self.values.ammo.Value = Settings.gun.maxAmmo

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

    self.remotes.Shoot.OnServerInvoke = function(...)
        return self:shoot(...)
    end

	self.remotes.ChangeFireMode.OnServerInvoke = function(...)
		return self:onChangeFireMode(...)
	end

end

-- fast cast events

function module:onRayHit(cast, raycastResult, segmentVelocity, cosmeticBulletObject, sender)
    local damageType, damageAmount
    local hitPart = raycastResult.Instance
    local hitPoint = raycastResult.Position
    local normal = raycastResult.Normal
    
    -- check if ray hit a part
    if not hitPart then
        return
    end

    -- play hit effects
    self:playHitFX(hitPart, hitPoint, normal)

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
    for damageInfoIndex, damageInfo in pairs(Settings.gun.damageTypes) do
        if typeof(damageInfo.partNames) == "table" then
            if table.find(damageInfo.partNames, hitPart.Name) then
                damageType = damageInfoIndex
                damageAmount = damageInfo.amount
            end
        else
            damageType = damageInfoIndex
            damageAmount = damageInfo.amount
        end
    end
    humanoid:TakeDamage(damageAmount)

    -- damage indicator
    self.remotes.DamageIndicator:FireClient(sender, character, damageType, damageAmount)
end

function module:onRayUpdated(cast, segmentOrigin, segmentDirection, length, segmentVelocity, cosmeticBulletObject)
    -- check bullet still exists
	if not cosmeticBulletObject then 
		return 
	end

	-- adjust bullet size
	local bulletVelocity = (math.abs(segmentVelocity.X) + math.abs(segmentVelocity.Y) + math.abs(segmentVelocity.Z))
	cosmeticBulletObject.Size = Vector3.new(cosmeticBulletObject.Size.X, cosmeticBulletObject.Size.Y, bulletVelocity / Settings.bullet.bulletLengthMultiplier)

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
    -- check if person who fired remote is the gun owner
    if player ~= self.owner then
        player:Kick("Attempted to fire " .. self.owner.Name .. "'s remote.")
    end

    if newState == "EQUIP" or newState == "AIM_IN" then
        newThread(playSound, self.sounds.equip, self.handle)
        self.handle.Equip:Play()
    elseif newState == "UNEQUIP" or newState == "AIM_OUT" then
        newThread(playSound, self.sounds.unequip, self.handle)
    elseif newState == "RELOAD" then
        newThread(playSound, self.sounds.reload, self.handle)
        self.values.ammo.Value = Settings.gun.maxAmmo
    end
end

function module:shoot(player, mousePoint)
    -- check if person who fired remote is the gun owner
    if player ~= self.owner then
        player:Kick("Attempted to fire " .. self.owner.Name .. "'s remote.")
    end

    -- firerate debounce
    if self.temp.isMouseDown and os.clock() - self.temp.timeOfRecentFire < 60 / Settings.fireRate then
		return
    end
    self.temp.timeOfRecentFire = os.clock()

	-- check if gun is equipped
	if self.tool.Parent:IsA("Backpack") then 
        self.temp.canFire = true
        return
    end	
    self.temp.canFire = false

    -- check ammo
    if self.values.ammo.Value <= 0 then
        return false, "NO_AMMO"
    end
    self.values.ammo.Value -= 1

	-- fire gun
    local mouseDirection = (mousePoint - self.handle.GunFirePoint.WorldPosition).Unit
    self.fastCast.castParams.FilterDescendantsInstances = {player.Character}
	self:shootBullet(mouseDirection, player)

	-- end debounce
	self.temp.canFire = true
end

function module:onChangeFireMode()
	local fireModes = Settings.gun.fireMode
	local oldFireModeIndex = table.find(fireModes, self.values.fireMode.Value)
	local newFireMode

	if oldFireModeIndex == #fireModes and oldFireModeIndex ~= 1 then
		newFireMode = fireModes[1]
	elseif oldFireModeIndex < #fireModes then
		newFireMode = fireModes[oldFireModeIndex + 1]
    end
    
	if newFireMode then
		self.values.fireMode.Value = newFireMode
		return newFireMode
	end
end

-- indirect

function module:shootBullet(direction, sender)	
	-- random angles
	local directionalCF = CFrame.new(Vector3.new(), direction)
	direction = (directionalCF * CFrame.fromOrientation(0, 0, RNG:NextNumber(0, TAU)) * CFrame.fromOrientation(math.rad(RNG:NextNumber(Settings.bullet.minBulletSpreadAngle, Settings.bullet.maxBulletSpreadAngle)), 0, 0)).LookVector

	-- realistic bullet velocity
	local root = self.tool.Parent:WaitForChild("HumanoidRootPart", 1)
	local myMovementSpeed = root.Velocity
	local modifiedBulletSpeed = (direction * Settings.bullet.bulletSpeed) + myMovementSpeed

	-- fire bullet
    self.fastCast.caster:Fire(self.handle.GunFirePoint.WorldPosition, direction, modifiedBulletSpeed, self.fastCast.castBehavior, sender)

    -- play effects
    newThread(playSound, self.sounds.shoot, self.handle)	

    newThread(function()
		self:playMuzzleFlash()
	end)
	
	newThread(function()
		self:playMuzzleLight()
	end)
	
	newThread(function()
		self:playSmoke()
	end)
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

-- effects

function module:playSmoke()
	local newSmoke = self.effects.muzzleSmoke:Clone()
	newSmoke.Enabled = true
	newSmoke.Parent = self.handle
	Debris:AddItem(newSmoke, Settings.effects.smokeDespawnDelay)

	wait(Settings.effects.smokeDuration)
	newSmoke.Enabled = false
end

function module:playMuzzleLight()
	local newMuzzleLight = self.effects.muzzleLight:Clone()
	newMuzzleLight.Enabled = true
	newMuzzleLight.Parent = self.handle
	Debris:AddItem(newMuzzleLight, Settings.effects.muzzleFlashTime)
end

function module:playMuzzleFlash()
	local newMuzzleFlash = self.effects.muzzleFlash:Clone()
	newMuzzleFlash.Enabled = true
	newMuzzleFlash.Parent = self.handle
	Debris:AddItem(newMuzzleFlash, Settings.effects.muzzleFlashTime)
end

function module:playHitFX(part, position, normal)
	local attachment = Instance.new("Attachment")
	attachment.CFrame = CFrame.new(position, position + normal)
	attachment.Parent = workspace.Terrain

	local particle = self.effects.impactParticle:Clone()
	particle.Color = ColorSequence.new({
		ColorSequenceKeypoint.new(0, part.Color),
		ColorSequenceKeypoint.new(0.5, part.Color),
		ColorSequenceKeypoint.new(1, part.Color)
	})
	
	particle.Parent = attachment
	Debris:AddItem(attachment, particle.Lifetime.Max)

	particle.Enabled = true
	wait(Settings.effects.impactParticleDuration)
	particle.Enabled = false
end

return module