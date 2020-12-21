local ReplicatedStorage = game:GetService("ReplicatedStorage")
local disconnectConnections = require(ReplicatedStorage.Modules.Core.DisconnectConnections)

return function(self)
    print("person died on client")
    disconnectConnections(self.temp.connections)
end