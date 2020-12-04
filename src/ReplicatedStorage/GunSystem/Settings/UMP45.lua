return {
    mouseIcon = "rbxassetid://131581677",
    gun = {
        fireRate = 600, -- rounds per minute
        damageTypes = {
            head = {
                partNames = {"Head"},
                amount = 38
            },
            torso = {
                partNames = {"UpperTorso", "LowerTorso", "HumanoidRootPart"},
                amount = 30,
            },
            limb = {
                partNames = "ELSE",
                amount = 21,
            }
        },
        fireMode = {"AUTO", "SEMI"}
    },
    bullet = {
        bulletSpeed = 1500, -- studs/sec
        bulletMaxDist = 100, -- studs
        bulletGravity = Vector3.new(0, -workspace.Gravity, 0),
        bulletLengthMultiplier = 200,
        minBulletSpreadAngle = 0, -- between 0 and 180, in degrees
        maxBulletSpreadAngle = 0, -- between 0 and 180, in degrees
        properties = {
            Material = Enum.Material.Neon,
            Color = Color3.fromRGB(255, 123, 123),
            CanCollide = false,
            Anchored = true,
            Size = Vector3.new(0.05, 0.05, 1)
        },
    },

	UI = {
		damageIndicator = {
			head = {
				TextColor3 = Color3.fromRGB(255, 255, 150),
				TextStrokeColor3 = Color3.fromRGB(55, 45, 0),
				TextStrokeTransparency = 0.7,
				TextTransparency = 1
			},
			torso = {
				TextColor3 = Color3.fromRGB(255, 255, 255),
				TextStrokeColor3 = Color3.fromRGB(0, 0, 0),
				TextStrokeTransparency = 0.7,
				TextTransparency = 1
			},
			limb = {
				TextColor3 = Color3.fromRGB(255, 255, 255),
				TextStrokeColor3 = Color3.fromRGB(0, 0, 0),
				TextStrokeTransparency = 0.7,
				TextTransparency = 1
			},
			maxduration = 2,
			tweenInfo = TweenInfo.new(0.5),
			minOffset = Vector3.new(-6, -6, 0),
			maxOffset = Vector3.new(6, 6, 0)
		},
	},

    effects = {
        muzzleFlashTime = 0.1,
        impactParticleDuration = 0.05,
        smokeDuration = 2,
        smokeDespawnDelay = 3.5,
    },

    raycastParas = {
		IgnoreWater = true,
		FilterType = Enum.RaycastFilterType.Blacklist,
		FilterDescendantsInstances = {}
    },
    
    keybinds = {
        reload = Enum.KeyCode.R,
        changeFireMode = Enum.KeyCode.V,
    },
}