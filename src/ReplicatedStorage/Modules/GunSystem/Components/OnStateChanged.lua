return function(self, newState)
    self.temp.states.currentAnimationState = newState
    if newState == "SPRINT" then
        self.animations.hold:Stop()
        self.animations.runningHold:Play()
    elseif newState == "WALK" then
        self.animations.runningHold:Stop()
        self.animations.hold:Play()
    end
end