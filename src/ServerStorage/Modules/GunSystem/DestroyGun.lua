local ReplicatedStorage = game:GetService("ReplicatedStorage")
local disconnectConnections = require(ReplicatedStorage.Modules.Core.DisconnectConnections)

return function(self)
    print("player died on server")
    disconnectConnections(self.temp.connections)
end