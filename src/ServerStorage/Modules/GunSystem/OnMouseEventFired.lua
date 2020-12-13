local ServerStorage = game:GetService("ServerStorage")
local shootBullet = require(ServerStorage.Modules.GunSystem.ShootBullet)

return function(self, player, mousePoint)
    if player ~= self.owner then
        player:Kick("It looks like you tried to shoot " .. self.owner.Name .. "'s gun. (Attempted to fire " .. self.owner.Name .. "'s remote.)")
    end

    if not self.temp.canFire or self.temp.isMouseDown and os.clock() - self.temp.timeOfRecentFire < 60 / self.Configuration.fireRate then
		return
    end

	if self.tool.Parent:IsA("Backpack") then 
        self.temp.canFire = true
        return
    end	

    if self.values.ammo.Value <= 0 then
        return false, "NO_AMMO"
    end
    
    local mouseDirection = (mousePoint - self.handle.GunFirePoint.WorldPosition).Unit
    self.fastCast.castParams.FilterDescendantsInstances = {player.Character}
    self.temp.canFire = false
    self.temp.timeOfRecentFire = os.clock()
    self.values.ammo.Value -= 1
	shootBullet(self, mouseDirection, player)
	self.temp.canFire = true
end