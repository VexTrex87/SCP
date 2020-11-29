local module = {}
module.__index = module

function module.new(tool)
    local self = setmetatable({
        tool = tool,
        handle = tool.Handle,
        remotes = tool.Remotes,
    }, module)

    -- insert sounds into tool handle
    local soundStorage = tool.Sounds
    for _,sound in pairs(soundStorage:GetChildren()) do
        sound.Parent = tool.Handle
    end

    -- events
    self.remotes.ChangeState.OnServerEvent:Connect(function(...)
        self:onChangeStateFired(...)
    end)

    self.remotes.Shoot.OnServerEvent:Connect(function(...)
        self:shoot(...)
    end)

end

function module:onChangeStateFired(player, newState)
    if newState == "EQUIP" or newState == "AIM_IN" then
        self.handle.Equip:Play()
    elseif newState == "UNEQUIP" or newState == "AIM_OUT" then
        self.handle.Unequip:Play()
    elseif newState == "RELOAD" then
        self.handle.Reload:Play()
    end
end

function module:shoot(player)
    self.handle.Shoot:Play()
end

return module