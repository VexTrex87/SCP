return {
    name = "M249",
    tag = "M249",
    gun = {
        fireRate = 900, -- rounds per minute
        magazineAmmo = 30,
        totalAmmo = 120,
        reloadDuration = 5,
        damageTypes = {
            head = {partNames = {"Head"}, amount = 35},
            torso = {partNames = {"UpperTorso", "LowerTorso", "HumanoidRootPart"}, amount = 28},
            limb = {partNames = "ELSE", amount = 22, }
        },
        fireMode = {"AUTO"}
    },
    bullet = {
        bulletSpeed = 2800, -- studs/sec
        bulletMaxDist = 165, -- studs
        bulletGravity = Vector3.new(0, -workspace.Gravity, 0),
        bulletLengthMultiplier = 200,
        spread = {
            ADSMin = 0,
            ADSMax = 0.9,
            unaimedMin = 0.9,
            unaimedMax = 1.8,
            currentMin = 0,
            currentMax = 0,
        },
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
            enemyColor = Color3.fromRGB(255, 0, 0),
            damageDoneBodyColor = Color3.fromRGB(255, 0, 0),
            damageDoneHeadColor = Color3.fromRGB(255, 255, 0),
            damageDoneShowDuration = 0.2,
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