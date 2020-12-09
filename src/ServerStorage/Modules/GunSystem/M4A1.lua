local module = {}
module.__index = module

-- // VARIABLES \\ -

-- services
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerStorage = game:GetService("ServerStorage")

-- modules
local modules = ServerStorage.Modules
local fastCast = require(modules.FastCastRedux)
local partCache = require(modules.PartCache)
local Settings = require(ReplicatedStorage.Modules.GunSystem.Settings[script.Name])

local effectsModules = modules.Effects
local playSmoke = require(effectsModules.smoke)
local playLight = require(effectsModules.light)
local playSound = require(effectsModules.sound)
local playBulletHit = require(effectsModules.bulletHit)

-- libraries
local coreModules = modules.Core
local newThread = require(coreModules.newThread)
local getCharacterFromHitPart = require(coreModules.getCharacterFromHitPart)
local disconnectConnections = require(coreModules.disconnectConnections)

-- objects
local debrisHolder = workspace.Debris

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
            connections = {
                onRayHit = nil,
                onLengthChanged = nil,
                onCastTerminating = nil,
            }
        }
    }, module)
    
    self:setDefaults()
    self:initEvents()
end

-- fast cast events

function module:onRayHit(info)
    local damageType, damageAmount
    local hitPart = info.raycastResult.Instance
    local hitPoint = info.raycastResult.Position
    local normal = info.raycastResult.Normal
    
    -- check if ray hit a part
    if not hitPart then
        return
    end

    -- play hit effects
    newThread(
        playBulletHit, 
        self.effects.impactParticle, 
        hitPart, 
        CFrame.new(hitPoint, hitPoint + normal), 
        Settings.effects.impactParticleDuration
    )

    -- check if ray hit a character
    local character = getCharacterFromHitPart(hitPart) or hitPart.Parent:FindFirstChildWhichIsA("Humanoid") and hitPart.Parent
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

    -- deal damage & show damage dealt
    if damageType and damageAmount then
        humanoid:TakeDamage(damageAmount)
        self.remotes.DamageIndicator:FireClient(info.sender, character, damageType, damageAmount)
    end
end

function module:onRayUpdated(info)
    -- check bullet still exists
	if not info.cosmeticBulletObject then 
		return 
	end

	-- adjust bullet size
	local bulletVelocity = (math.abs(info.segmentVelocity.X) + math.abs(info.segmentVelocity.Y) + math.abs(info.segmentVelocity.Z))
	info.cosmeticBulletObject.Size = Vector3.new(
        info.cosmeticBulletObject.Size.X, 
        info.cosmeticBulletObject.Size.Y, 
        bulletVelocity / Settings.bullet.bulletLengthMultiplier
    )

	-- adjust bullet pos
	local bulletLength = info.cosmeticBulletObject.Size.Z / 2
	local baseCFrame = CFrame.new(info.segmentOrigin, info.segmentOrigin + info.segmentDirection)
	info.cosmeticBulletObject.CFrame = baseCFrame * CFrame.new(0, 0, -(info.length - bulletLength))
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

    -- run states
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

function module:onChangeFireMode(player)
    -- check if person who fired remote is the gun owner
    if player ~= self.owner then
        player:Kick("Attempted to fire " .. self.owner.Name .. "'s remote.")
    end

	local fireModes = Settings.gun.fireMode
	local oldFireModeIndex = table.find(fireModes, self.values.fireMode.Value)
	local newFireMode

    -- get next firemode
	if oldFireModeIndex == #fireModes and oldFireModeIndex ~= 1 then
		newFireMode = fireModes[1]
	elseif oldFireModeIndex < #fireModes then
		newFireMode = fireModes[oldFireModeIndex + 1]
    end
    
    -- change firemode
	if newFireMode then
		self.values.fireMode.Value = newFireMode
		return newFireMode
	end
end

-- indirect

function module:setDefaults()
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
	local cosmeticPartProvider = partCache.new(self.fastCast.cosmeticBullet, 100, debrisHolder.Bullets)
	self.fastCast.castBehavior.CosmeticBulletProvider = cosmeticPartProvider
	self.fastCast.castBehavior.CosmeticBulletContainer = cosmeticPartProvider
	self.fastCast.castBehavior.Acceleration = Settings.bullet.bulletGravity
	self.fastCast.castBehavior.AutoIgnoreContainer = false
    
    -- set ammo
    self.values.ammo.Value = Settings.gun.maxAmmo
end

function module:initEvents()
	self.temp.connections.onRayHit = self.fastCast.caster.RayHit:Connect(function(...)
		self:onRayHit(...)
	end)
	
	self.temp.connections.onLengthChanged = self.fastCast.caster.LengthChanged:Connect(function(...)
		self:onRayUpdated(...)
	end)
	
	self.temp.connections.onCastTerminating = self.fastCast.caster.CastTerminating:Connect(function(...)
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
    
    self.tool.AncestryChanged:Connect(function(...)
        self:onToolAncestryChanged(...)
    end)
end

function module:shootBullet(direction, sender)	
	-- random angles
	local directionalCF = CFrame.new(Vector3.new(), direction)
	direction = (directionalCF * CFrame.fromOrientation(0, 0, Random.new():NextNumber(0, math.pi * 2	)) * CFrame.fromOrientation(math.rad(Random.new():NextNumber(Settings.bullet.minBulletSpreadAngle, Settings.bullet.maxBulletSpreadAngle)), 0, 0)).LookVector

	-- realistic bullet velocity
	local root = self.tool.Parent:WaitForChild("HumanoidRootPart", 1)
	local myMovementSpeed = root.Velocity
	local modifiedBulletSpeed = (direction * Settings.bullet.bulletSpeed) + myMovementSpeed

	-- fire bullet
    self.fastCast.caster:Fire(self.handle.GunFirePoint.WorldPosition, direction, modifiedBulletSpeed, self.fastCast.castBehavior, sender)

    -- play effects
    newThread(playSound, self.sounds.shoot, self.handle)	
    newThread(playLight, self.effects.muzzleLight, self.handle, Settings.effects.muzzleFlashTime)
	newThread(playSmoke, self.effects.muzzleSmoke, self.handle, Settings.effects.smokeDuration, Settings.effects.smokeDespawnDelay)
end

function module:onToolAncestryChanged(children, parent)
    if not children and not parent then
        disconnectConnections(self.temp.connections)
    end
end

return module