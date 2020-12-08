local core = require(game.ReplicatedStorage.Modules.Core)
local newTween = core("newTween")

return function(component)
    newTween(component, TweenInfo.new(0.1), {TextTransparency = 1}).Completed:Wait()
    newTween(component, TweenInfo.new(0.1), {TextTransparency = 0}).Completed:Wait()
end