local ServerStorage = game:GetService("ServerStorage")
local Players = game:GetService("Players")

local components = ServerStorage.Modules.GunSystem
local onRayHit = require(components.OnRayHit)
local onRayUpdated = require(components.OnRayUpdated)
local onRayTerminated = require(components.OnRayTerminated)
local onChangeStateFired = require(components.OnChangeStateFired)
local onChangeFireMode = require(components.OnChangeFireMode)
local onMouseEventFired = require(components.OnMouseEventFired)
local onToolAncestryChanged = require(components.OnToolAncestryChanged)
local destroyGun = require(components.DestroyGun)

return function(self)
	self.temp.connections.onRayHit = self.fastCast.caster.RayHit:Connect(function(...)
		onRayHit(self, ...)
	end)
	
	self.temp.connections.onLengthChanged = self.fastCast.caster.LengthChanged:Connect(function(...)
		onRayUpdated(self, ...)
	end)
	
	self.temp.connections.onCastTerminating = self.fastCast.caster.CastTerminating:Connect(function(...)
		onRayTerminated(self, ...)
	end)

    self.remotes.ChangeState.OnServerEvent:Connect(function(...)
        onChangeStateFired(self, ...)
    end)

    self.remotes.ChangeFireMode.OnServerInvoke = function(...)
        return onChangeFireMode(self, ...)
    end

    self.remotes.MouseEvent.OnServerInvoke = function(...)
        return onMouseEventFired(self, ...)
    end
    
    self.tool.AncestryChanged:Connect(function(...)
        onToolAncestryChanged(self, ...)
    end)

    self.owner.Character.Humanoid.Died:Connect(function()
        destroyGun(self)
    end)
end