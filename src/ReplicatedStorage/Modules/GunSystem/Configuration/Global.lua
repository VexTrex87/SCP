return {
    gunTag = "Gun",
    gunInfo = {
        shownPosition = UDim2.new(1, -300, 1, -145),
        hiddenPosition = UDim2.new(1, -300, 1, 145),
        moveTweenInfo = {Enum.EasingDirection.In, Enum.EasingStyle.Linear, 0.3, true},
        flashTweenInfo = TweenInfo.new(0.1)
    },
    gunCrosshair = {
        showTweenInfo = TweenInfo.new(0.3),
        zoomTweenInfo =TweenInfo.new(0.1),
        M249 = {
            UnzoomedSize = UDim2.new(0, 114, 0, 114),
            ZoomedSize = UDim2.new(0, 44, 0, 44),
            NeutralColor = Color3.fromRGB(255, 255, 255),
            FriendlyColor = Color3.fromRGB(0, 255, 0),
            EnemyColor = Color3.fromRGB(255, 0, 0)
        },
        M4A1 = {
            UnzoomedSize = UDim2.new(0, 114, 0, 114),
            ZoomedSize = UDim2.new(0, 30, 0, 30),
            NeutralColor = Color3.fromRGB(255, 255, 255),
            FriendlyColor = Color3.fromRGB(0, 255, 0),
            EnemyColor = Color3.fromRGB(255, 0, 0)
        },
        ["PP-19_Bizon"] = {
            UnzoomedSize = UDim2.new(0, 114, 0, 114),
            ZoomedSize = UDim2.new(0, 44, 0, 44),
            NeutralColor = Color3.fromRGB(255, 255, 255),
            FriendlyColor = Color3.fromRGB(0, 255, 0),
            EnemyColor = Color3.fromRGB(255, 0, 0)
        },
        UMP45 = {
            UnzoomedSize = UDim2.new(0, 114, 0, 114),
            ZoomedSize = UDim2.new(0, 44, 0, 44),
            NeutralColor = Color3.fromRGB(255, 255, 255),
            FriendlyColor = Color3.fromRGB(0, 255, 0),
            EnemyColor = Color3.fromRGB(255, 0, 0)
        },
    }
}