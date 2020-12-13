local ReplicatedStorage = game:GetService("ReplicatedStorage")
local aim = require(ReplicatedStorage.Modules.GunSystem.Aim)

return function(self, input, gameProcessed)
    if self.values.fireMode.Value == "AUTO" and gameProcessed or input.UserInputType == self.Configuration.keybinds.shoot then
        self.temp.states.isMouseDown = false
    elseif input.UserInputType == self.Configuration.keybinds.aim then
        aim(self, false)
    end
end