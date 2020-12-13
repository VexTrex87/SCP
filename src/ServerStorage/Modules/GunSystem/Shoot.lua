local ServerStorage = game:GetService("ServerStorage")
local shootBullet = require(ServerStorage.Modules.GunSystem.ShootBullet)

return function(self, player, mousePoint)
    -- check if person who fired remote is the gun owner
    if player ~= self.owner then
        player:Kick("It looks like you tried to shoot " .. self.owner.Name .. "'s gun. (Attempted to fire " .. self.owner.Name .. "'s remote.)")
    end

    -- firerate debounce
    if not self.temp.canFire or self.temp.isMouseDown and os.clock() - self.temp.timeOfRecentFire < 60 / self.Configuration.fireRate then
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
	shootBullet(self, mouseDirection, player)
	self.temp.canFire = true
end