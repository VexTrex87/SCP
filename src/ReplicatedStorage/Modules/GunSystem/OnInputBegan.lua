local ReplicatedStorage = game:GetService("ReplicatedStorage")

local ThirdPersonCamera = require(ReplicatedStorage.Modules.ThirdPersonCamera)

local components = ReplicatedStorage.Modules.GunSystem
local reload = require(components.Reload)
local changeFireMode = require(components.ChangeFireMode)
local shoot = require(components.Shoot)
local aim = require(components.Aim)

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
    elseif input.UserInputType == self.Configuration.keybinds.aim then
        aim(self, true)
    elseif input.KeyCode == self.Configuration.keybinds.leanLeft then
        ThirdPersonCamera:SetShoulderDirection(-1)
    elseif input.KeyCode == self.Configuration.keybinds.leanRight then
        ThirdPersonCamera:SetShoulderDirection(1)
    end
end