local ServerStorage = game:GetService("ServerStorage")

local modules = ServerStorage.Modules
local newThread = require(modules.Core.NewThread)

local effects = modules.Effects
local playSound = require(effects.Sound)
local playLight = require(effects.Light)
local playSmoke = require(effects.Smoke)

return function(self, direction, sender)	
	-- random angles
	local directionalCF = CFrame.new(Vector3.new(), direction)
	direction = (directionalCF * CFrame.fromOrientation(0, 0, Random.new():NextNumber(0, math.pi * 2)) * CFrame.fromOrientation(math.rad(Random.new():NextNumber(self.Configuration.bullet.minBulletSpreadAngle, self.Configuration.bullet.maxBulletSpreadAngle)), 0, 0)).LookVector

	-- realistic bullet velocity
	local root = self.tool.Parent:WaitForChild("HumanoidRootPart", 1)
	local myMovementSpeed = root.Velocity
	local modifiedBulletSpeed = (direction * self.Configuration.bullet.bulletSpeed) + myMovementSpeed

	-- fire bullet
    self.fastCast.caster:Fire(self.handle.GunFirePoint.WorldPosition, direction, modifiedBulletSpeed, self.fastCast.castBehavior, sender)

    -- play effects
    newThread(playSound, self.sounds.shoot, self.handle)	
    newThread(playLight, self.effects.muzzleLight, self.handle, self.Configuration.effects.muzzleFlashTime)
	newThread(playSmoke, self.effects.muzzleSmoke, self.handle, self.Configuration.effects.smokeDuration, self.Configuration.effects.smokeDespawnDelay)
end