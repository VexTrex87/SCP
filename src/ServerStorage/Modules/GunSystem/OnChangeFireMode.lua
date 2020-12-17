return function(self, player)
    if player ~= self.owner then
        player:Kick("It looks like you tried to change the fire mode of " .. self.owner.Name .. "'s gun. (Attempted to fire " .. self.owner.Name .. "'s remote.)")
    end

    local fireModes = self.Configuration.gun.fireMode
    local oldFireModeIndex = table.find(fireModes, self.values.fireMode.Value)
    local newFireMode
    
    -- get next firemode
    if oldFireModeIndex == #fireModes and oldFireModeIndex ~= 1 then
        newFireMode = fireModes[1]
    elseif oldFireModeIndex < #fireModes then
        newFireMode = fireModes[oldFireModeIndex + 1]
    end
    
    if newFireMode then
        self.values.fireMode.Value = newFireMode
        return newFireMode
    end
end