local ServerStorage = game:GetService("ServerStorage")
local disconnectConnections = require(ServerStorage.Modules.Core.DisconnectConnections)

return function(self, children, parent)
    if not children and not parent then
        disconnectConnections(self.temp.connections)
    end
end