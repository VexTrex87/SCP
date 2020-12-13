return function(self, cast)
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