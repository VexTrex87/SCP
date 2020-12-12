local ReplicatedStorage = game:GetService("ReplicatedStorage")
local shoot = require(ReplicatedStorage.Modules.GunSystem.Shoot)

return function(self)
    if self.temp.states.isMouseDown then
		shoot(self)
	end
end