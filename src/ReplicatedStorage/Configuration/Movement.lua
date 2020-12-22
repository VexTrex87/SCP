return {
    speeds = {
        sprint = 16,
        walk = 5,
        crouch = 2,
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