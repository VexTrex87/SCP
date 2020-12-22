local ReplicatedStorage = game:GetService("ReplicatedStorage")
local disconnectConnections = require(ReplicatedStorage.Modules.Core.DisconnectConnections)

return function(self)
    disconnectConnections(self.temp.connections)
end