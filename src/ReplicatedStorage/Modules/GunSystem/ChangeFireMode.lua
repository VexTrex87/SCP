local ReplicatedStorage = game:GetService("ReplicatedStorage")

local components = ReplicatedStorage.Modules.GunSystem
local GunInfoGUI = require(components.GunInfoGUI)

return function(self)
    local initEvents = require(components.InitEvents)
    local oldFireMode = self.values.fireMode.Value
    local newFireMode = self.remotes.ChangeFireMode:InvokeServer()
    
    if newFireMode and newFireMode ~= oldFireMode then
        GunInfoGUI.update({
            gunName = self.Configuration.name,
            gunTag = self.Configuration.tag,
            fireMode = self.values.fireMode.Value,
            ammo = self.values.Ammo.Value,
        })
        initEvents(self)
    end
end