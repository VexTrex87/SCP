return {
    mouseIcon = "rbxassetid://131581677",
    damageTypes = {
        head = {
            partNames = {"Head"},
            amount = 35
        },
        torso = {
            partNames = {"UpperTorso", "LowerTorso", "HumanoidRootPart"},
            amount = 25,
        },
        limb = {
            partNames = "ELSE",
            amount = 15,
        }
    },

    bulletSpeed = 500, -- studs/sec
    bulletMaxDist = 500, -- studs
    bulletGravity = Vector3.new(0, -workspace.Gravity, 0),
    bulletLengthMultiplier = 200,
    minBulletSpreadAngle = 0, -- between 0 and 180, in degrees
	maxBulletSpreadAngle = 0, -- between 0 and 180, in degrees
    bulletProps = {
		Material = Enum.Material.Neon,
		Color = Color3.fromRGB(255, 123, 123),
		CanCollide = false,
		Anchored = true,
		Size = Vector3.new(0.05, 0.05, 1)
    },

    raycastParas = {
		IgnoreWater = true,
		FilterType = Enum.RaycastFilterType.Blacklist,
		FilterDescendantsInstances = {}
    },
    
    keybinds = {
        reload = Enum.KeyCode.R,
    },
}