return {
    speeds = {
        sprint = 18,
        walk = 8,
        crouch = 4,
    },
    fov = {
        sprint = 70 + (16 / 5),
        walk = 70,
        crouch = 70 - (2 / 5),
    },
    keybinds = {
        sprint = Enum.KeyCode.LeftShift,
        crouch = Enum.KeyCode.LeftControl,
        roll = Enum.KeyCode.C,
    },
    povTweenInfo = TweenInfo.new(0.4, Enum.EasingStyle.Sine)
}