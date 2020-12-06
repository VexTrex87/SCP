local roact = require(game.ReplicatedStorage.Modules.Roact)
local createScreenGUI = require(script.Components.ScreenGUI)
local currentGUI

return function(info)
	if currentGUI and info then
		-- update GUI
		roact.update(currentGUI, createScreenGUI(info))
	elseif currentGUI then
		-- destroy GUI
		roact.unmount(currentGUI)
		currentGUI = nil
	else
		-- create GUI
		currentGUI = roact.mount(createScreenGUI(info), game.Players.LocalPlayer.PlayerGui, "GunInfo")
	end
end