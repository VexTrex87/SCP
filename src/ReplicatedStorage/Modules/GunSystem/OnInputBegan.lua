local ReplicatedStorage = game:GetService("ReplicatedStorage")

local components = ReplicatedStorage.Modules.GunSystem
local reload = require(components.Reload)
local changeFireMode = require(components.ChangeFireMode)
local shoot = require(components.Shoot)

return function(self, input, gameProcessed)
    if gameProcessed then
        return
    end

    if input.KeyCode == self.Configuration.keybinds.reload then
        reload(self)
    elseif input.KeyCode == self.Configuration.keybinds.changeFireMode then
        changeFireMode(self)
    elseif input.UserInputType == self.Configuration.keybinds.shoot then
		if self.values.fireMode.Value == "AUTO" then
            self.temp.states.isMouseDown = true 
        elseif self.values.fireMode.Value == "SEMI" then
            shoot(self)
        end
    end
end