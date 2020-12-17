local ServerStorage = game:GetService("ServerStorage")

local modules = ServerStorage.Modules
local fastCast = require(modules.FastCast)
local partCache = require(modules.PartCache)

local bulletDebris = workspace.Debris.Bullets

return function(self)
    self.fastCast.cosmeticBullet = Instance.new("Part")
	for propertyName, propertyValue in pairs(self.Configuration.bullet.properties) do
		self.fastCast.cosmeticBullet[propertyName] = propertyValue
    end 
    
	self.fastCast.castParams = RaycastParams.new()
	for propertyName, propertyValue in pairs(self.Configuration.raycastParas) do
		self.fastCast.castParams[propertyName] = propertyValue
    end

	self.fastCast.castBehavior = fastCast.newBehavior()
	self.fastCast.castBehavior.RaycastParams = self.fastCast.castParams
	self.fastCast.castBehavior.MaxDistance = self.Configuration.bullet.bulletMaxDist

	local cosmeticPartProvider = partCache.new(self.fastCast.cosmeticBullet, 100, bulletDebris)
	self.fastCast.castBehavior.CosmeticBulletProvider = cosmeticPartProvider
	self.fastCast.castBehavior.CosmeticBulletContainer = cosmeticPartProvider
	self.fastCast.castBehavior.Acceleration = self.Configuration.bullet.bulletGravity
	self.fastCast.castBehavior.AutoIgnoreContainer = false
    
	self.values.totalAmmo.Value = self.Configuration.gun.totalAmmo
	self.values.totalAmmo.Value -= self.Configuration.gun.magazineAmmo
	self.values.magazineAmmo.Value = self.Configuration.gun.magazineAmmo

	self.Configuration.bullet.spread.currentMin = self.Configuration.bullet.spread.unaimedMin
	self.Configuration.bullet.spread.currentMax = self.Configuration.bullet.spread.unaimedMax
end