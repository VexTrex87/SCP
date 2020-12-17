local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerStorage = game:GetService("ServerStorage")

local modules = ServerStorage.Modules
local fastCast = require(ServerStorage.Modules.FastCast)

local components = modules.GunSystem
local setDefaults = require(components.SetDefaults)
local initEvents = require(components.InitEvents)

return function(tool, gunTag)
    local self = {
        tool = tool,
        handle = tool.Handle,
        remotes = tool.Remotes,
        owner = tool.Parent.Parent,
        Configuration = require(ReplicatedStorage.Configuration.GunSystem[gunTag]),
        values = {
            fireMode = tool.Values.FireMode,
            magazineAmmo = tool.Values.MagazineAmmo,
            totalAmmo = tool.Values.TotalAmmo,
        },
        sounds = {
            equip = tool.Sounds.Equip,
            unequip = tool.Sounds.Unequip,
            shoot = tool.Sounds.Shoot,
            reload = tool.Sounds.Reload,
        },
        effects = {
            impactParticle = tool.Handle.ImpactParticle,
            muzzleLight = tool.Handle.GunFirePoint.MuzzleLight,
            muzzleSmoke = tool.Handle.GunFirePoint.Smoke,
        },
        fastCast = {
			caster = fastCast.new(),
			cosmeticBullet = nil,
			castParams = nil,
			castBehavior = nil,
		},
        temp = {
            timeOfRecentFire = os.clock(),
            canFire = true,
            connections = {
                onRayHit = nil,
                onLengthChanged = nil,
                onCastTerminating = nil,
            }
        }
    }
    
    setDefaults(self)
    initEvents(self)
end