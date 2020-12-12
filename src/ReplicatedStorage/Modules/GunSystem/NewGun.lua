local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local waitForPath = require(ReplicatedStorage.Modules.Core.WaitForPath)
local initEvents = require(ReplicatedStorage.Modules.GunSystem.InitEvents)
local loadAnimation = require(ReplicatedStorage.Modules.Core.LoadAnimation)

return function(tool, gunName)
    local player = Players.LocalPlayer
    local character = player.Character
    local humanoid = character:WaitForChild("Humanoid")
    local animator = humanoid:WaitForChild("Animator")

    local self = {
        tool = tool,
        remotes = tool:WaitForChild("Remotes"),
        stateChangedEvent = ReplicatedStorage.Objects.Remotes.Movement.StateChanged,
        Configuration = require(ReplicatedStorage.Configuration.GunSystem[gunName]),
        animations = {
            hold = loadAnimation(animator, waitForPath(tool, "Animations.Hold")),
            runningHold = loadAnimation(animator, waitForPath(tool, "Animations.RunningHold", 1)),
            aim = loadAnimation(animator, waitForPath(tool, "Animations.Aim")),
            reload = loadAnimation(animator, waitForPath(tool, "Animations.Reload")),
        },
        values = {
            fireMode = waitForPath(tool, "Values.FireMode"),
            ammo = waitForPath(tool, "Values.Ammo"),
        },
        sounds = {
            hit = waitForPath(tool, "Sounds.Hit"),
            jam = waitForPath(tool, "Sounds.Jam"),
        },
        temp = {
            mouse = nil,
            timeOfRecentFire = os.clock(),
            states = {
                isEquipped = false,
                isAiming = false,
                isReloading = false,
                isMouseDown = false,
                currentAnimationState = "WALK"
            },
            connections = {
                activeCameraSettingsChanged = nil,
                inputBegan = nil,
                inputEnded = nil,
                mouseMove = nil,
                stepped = nil,
                damageIndicatorFired = nil,
                stateChanged = nil,
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