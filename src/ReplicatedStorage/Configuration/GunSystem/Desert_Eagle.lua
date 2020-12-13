return {
    name = "Desert Eagle",
    tag = "Desert_Eagle",
    gun = {
        fireRate = 400, -- rounds per minute
        maxAmmo = 8,
        reloadDuration = 2.5,
        damageTypes = {
            head = {partNames = {"Head"}, amount = 56},
            torso = {partNames = {"UpperTorso", "LowerTorso", "HumanoidRootPart"}, amount = 48},
            limb = {partNames = "ELSE", amount = 32}
        },
        fireMode = {"SEMI"}
    },
    bullet = {
        bulletSpeed = 1700, -- studs/sec
        bulletMaxDist = 80, -- studs
        bulletGravity = Vector3.new(0, -workspace.Gravity, 0),
        bulletLengthMultiplier = 200,
        minBulletSpreadAngle = 0, -- between 0 and 180, in degrees
        maxBulletSpreadAngle = 1.6, -- between 0 and 180, in degrees
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
        gunInfo = {
            shownPosition = UDim2.new(1, -300, 1, -145),
            hiddenPosition = UDim2.new(1, -300, 1, 145),
            moveTweenInfo = {Enum.EasingDirection.In, Enum.EasingStyle.Linear, 0.3, true},
            flashTweenInfo = TweenInfo.new(0.1)
        },
        crosshair = {
            showTweenInfo = TweenInfo.new(0.3),
            zoomTweenInfo = TweenInfo.new(0.1),
            unzoomedSize = UDim2.new(0, 114, 0, 114),
            zoomedSize = UDim2.new(0, 44, 0, 44),
            neutralColor = Color3.fromRGB(255, 255, 255),
            friendlyColor = Color3.fromRGB(0, 255, 0),
            enemyColor = Color3.fromRGB(255, 0, 0)
        }
	},
    effects = {
        muzzleFlashTime = 0.1,
        impactParticleDuration = 0.05,
        smokeDuration = 0.5,
        smokeDespawnDelay = 1.5,
    },
    raycastParas = {
		IgnoreWater = true,
		FilterType = Enum.RaycastFilterType.Blacklist,
		FilterDescendantsInstances = {}
    },
    keybinds = {
        reload = Enum.KeyCode.R,
        changeFireMode = Enum.KeyCode.V,
        shoot = Enum.UserInputType.MouseButton1,
        aim = Enum.UserInputType.MouseButton2,
        leanLeft = Enum.KeyCode.Q,
        leanRight = Enum.KeyCode.E,
    },
}