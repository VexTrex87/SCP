local ReplicatedStorage = game:GetService("ReplicatedStorage")

local components = ReplicatedStorage.Modules.GunSystem
local GunInfoGUI = require(components.GunInfoGUI)

return function(self)
    local initEvents = require(components.InitEvents)
    local oldFireMode = self.values.fireMode.Value
    local newFireMode = self.remotes.ChangeState:InvokeServer("FIRE_MODE")
    
    if newFireMode and newFireMode ~= oldFireMode then
        GunInfoGUI.update({
            gunName = self.Configuration.name,
            gunTag = self.Configuration.tag,
            fireMode = self.values.fireMode.Value,
            magazineAmmo = self.values.magazineAmmo.Value,
            totalAmmo = self.values.totalAmmo.Value,
        })
        initEvents(self)
    end
end