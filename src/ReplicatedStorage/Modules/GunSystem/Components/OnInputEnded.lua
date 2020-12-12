return function(self, input, gameProcessed)
    if gameProcessed or input.UserInputType == self.Configuration.keybinds.shoot then
        self.temp.states.isMouseDown = false
    end
end