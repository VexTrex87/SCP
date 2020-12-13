local ServerStorage = game:GetService("ServerStorage")

local modules = ServerStorage.Modules
local fastCast = require(modules.FastCast)
local partCache = require(modules.PartCache)

local bulletDebris = workspace.Debris.Bullets

return function(self)
    -- create bullet
    self.fastCast.cosmeticBullet = Instance.new("Part")
	for propertyName, propertyValue in pairs(self.Configuration.bullet.properties) do
		self.fastCast.cosmeticBullet[propertyName] = propertyValue
    end 
    
    -- new raycast paras
	self.fastCast.castParams = RaycastParams.new()
	for propertyName, propertyValue in pairs(self.Configuration.raycastParas) do
		self.fastCast.castParams[propertyName] = propertyValue
    end

	-- data packets
	self.fastCast.castBehavior = fastCast.newBehavior()
	self.fastCast.castBehavior.RaycastParams = self.fastCast.castParams
	self.fastCast.castBehavior.MaxDistance = self.Configuration.bullet.bulletMaxDist

	-- part cache
	local cosmeticPartProvider = partCache.new(self.fastCast.cosmeticBullet, 100, bulletDebris)
	self.fastCast.castBehavior.CosmeticBulletProvider = cosmeticPartProvider
	self.fastCast.castBehavior.CosmeticBulletContainer = cosmeticPartProvider
	self.fastCast.castBehavior.Acceleration = self.Configuration.bullet.bulletGravity
	self.fastCast.castBehavior.AutoIgnoreContainer = false
    
    -- set ammo
    self.values.ammo.Value = self.Configuration.gun.maxAmmo
end