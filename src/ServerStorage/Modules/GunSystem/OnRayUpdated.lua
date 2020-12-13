return function(self, info)
	if not info.cosmeticBulletObject then 
		return 
	end

	local bulletVelocity = (math.abs(info.segmentVelocity.X) + math.abs(info.segmentVelocity.Y) + math.abs(info.segmentVelocity.Z))
	info.cosmeticBulletObject.Size = Vector3.new(
        info.cosmeticBulletObject.Size.X, 
        info.cosmeticBulletObject.Size.Y, 
        bulletVelocity / self.Configuration.bullet.bulletLengthMultiplier
    )

	local bulletLength = info.cosmeticBulletObject.Size.Z / 2
	local baseCFrame = CFrame.new(info.segmentOrigin, info.segmentOrigin + info.segmentDirection)
	info.cosmeticBulletObject.CFrame = baseCFrame * CFrame.new(0, 0, -(info.length - bulletLength))
end