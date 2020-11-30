return {
    sprintSpeed = 16,
    walkSpeed = 5,
    crouchSpeed = 2,

    sprintFov = 70 + (16 / 5),
    walkFov = 70,
    crouchFov = 70 - (2 / 5),

    sprintKey = Enum.KeyCode.LeftShift,
    crouchKey = Enum.KeyCode.LeftControl,
    rollKey = Enum.KeyCode.C,

    povTweenInfo = TweenInfo.new(0.4, Enum.EasingStyle.Sine)
}