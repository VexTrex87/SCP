local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local waitForPath = require(ReplicatedStorage.Modules.Core.WaitForPath)
local initEvents = require(ReplicatedStorage.Modules.GunSystem.InitEvents)
local loadAnimation = require(ReplicatedStorage.Modules.Core.LoadAnimation)

return function(tool, gunTag)
    local objectStorage = ReplicatedStorage.Objects.GunSystem
    local animationStorage = objectStorage.Animations[gunTag]
    local soundStorage = objectStorage.Sounds[gunTag]

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
        GUI = {
            damageIndicator = objectStorage.GUI[gunTag].DamageIndicator
        },
        animations = {
            hold = loadAnimation(animator, animationStorage.Hold),
            runningHold = loadAnimation(animator, animationStorage:FindFirstChild("RunningHold")),
            aim = loadAnimation(animator, animationStorage.Aim),
            reload = loadAnimation(animator, animationStorage.Reload),
        },
        values = {
            fireMode = waitForPath(tool, "Values.FireMode"),
            ammo = waitForPath(tool, "Values.Ammo"),
        },
        sounds = {
            headHit = soundStorage.HeadHit,
            bodyHit = soundStorage.BodyHit,
            jam = soundStorage.Jam,
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
                ammoChanged = nil,
            },
            crosshair = {
                currentTarget = nil,
                currentTargetType = nil,
            }
        }
    }

    initEvents(self)
end