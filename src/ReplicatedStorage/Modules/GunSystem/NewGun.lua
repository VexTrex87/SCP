local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local waitForPath = require(ReplicatedStorage.Modules.Core.WaitForPath)
local initEvents = require(ReplicatedStorage.Modules.GunSystem.InitEvents)
local loadAnimation = require(ReplicatedStorage.Modules.Core.LoadAnimation)

return function(tool, gunTag)
    local player = Players.LocalPlayer
    local character = player.Character
    local humanoid = character:WaitForChild("Humanoid")
    local animator = humanoid:WaitForChild("Animator")

    local self = {
        humanoid = humanoid,
        tool = tool,
        remotes = tool:WaitForChild("Remotes"),
        movementStateChanged = ReplicatedStorage.Objects.Movement.Remotes.StateChanged,
        Configuration = require(ReplicatedStorage.Configuration.GunSystem[gunTag]),
        animations = {
            hold = loadAnimation(animator, waitForPath(tool, "Animations.Hold")),
            runningHold = loadAnimation(animator, waitForPath(tool, "Animations.RunningHold", 1)),
            aim = loadAnimation(animator, waitForPath(tool, "Animations.Aim")),
            reload = loadAnimation(animator, waitForPath(tool, "Animations.Reload")),
        },
        values = {
            fireMode = waitForPath(tool, "Values.FireMode"),
            magazineAmmo = waitForPath(tool, "Values.MagazineAmmo"),
            totalAmmo = waitForPath(tool, "Values.TotalAmmo"),
        },
        sounds = {
            headHit = waitForPath(tool, "Sounds.HeadHit"),
            bodyHit = waitForPath(tool, "Sounds.BodyHit"),
            jam = waitForPath(tool, "Sounds.Jam"),
        },
        temp = {
            mouse = nil,
            timeOfRecentFire = os.clock(),
            states = {
                isEquipped = false,
                isAiming = false,
                isZoomed = false,
                isReloading = false,
                isMouseDown = false,
                currentAnimationState = "WALK"
            },
            connections = {
                inputBegan = nil,
                inputEnded = nil,
                mouseMove = nil,
                stepped = nil,
                damageIndicatorFired = nil,
                movementStateChanged = nil,
                magazineAmmoChanged = nil,
                totalAmmoChanged = nil,
            },
            crosshair = {
                currentTarget = nil,
                currentTargetType = nil,
            }
        }
    }

    initEvents(self)
end