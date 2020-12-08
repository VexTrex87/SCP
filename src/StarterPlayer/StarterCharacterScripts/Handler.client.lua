-- handles all client related code dependent of a client's character
local character = script.Parent
print(character)

-- movement
local movement = require(game.ReplicatedStorage.Modules.Movement)
movement.new(character)