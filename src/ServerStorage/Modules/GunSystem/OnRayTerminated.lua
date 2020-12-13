return function(self, cast)
    local cosmeticBullet = cast.RayInfo.CosmeticBulletObject
    if not cosmeticBullet then
        return
    end    

    local bulletProvider = self.fastCast.castBehavior.CosmeticBulletProvider
    if bulletProvider then
        bulletProvider:ReturnPart(cosmeticBullet)
    else
        cosmeticBullet:Destroy()
    end
end