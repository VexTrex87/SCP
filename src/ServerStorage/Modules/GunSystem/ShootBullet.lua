local ServerStorage = game:GetService("ServerStorage")
local playEffects = require(ServerStorage.Modules.PlayEffects)

return function(self, direction, sender)	
	local directionalCF = CFrame.new(Vector3.new(), direction)
	direction = (directionalCF * CFrame.fromOrientation(0, 0, Random.new():NextNumber(0, math.pi * 2)) * CFrame.fromOrientation(math.rad(Random.new():NextNumber(self.Configuration.bullet.spread.currentMin, self.Configuration.bullet.spread.currentMax)), 0, 0)).LookVector

	local root = self.tool.Parent:WaitForChild("HumanoidRootPart", 1)
	local myMovementSpeed = root.Velocity
	local modifiedBulletSpeed = (direction * self.Configuration.bullet.bulletSpeed) + myMovementSpeed

    self.fastCast.caster:Fire(self.handle.GunFirePoint.WorldPosition, direction, modifiedBulletSpeed, self.fastCast.castBehavior, sender)

	playEffects("Sound", self.sounds.shoot, self.handle)
	playEffects("Light", self.effects.muzzleLight, self.handle, self.Configuration.effects.muzzleFlashTime)
	playEffects("MuzzleFlash", self.handle, self.Configuration.effects.muzzleFlashTime)
	playEffects("Smoke", self.effects.muzzleSmoke, self.handle, self.Configuration.effects.smokeDuration, self.Configuration.effects.smokeDespawnDelay)
end