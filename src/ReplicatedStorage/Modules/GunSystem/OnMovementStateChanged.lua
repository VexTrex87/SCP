return function(self, newState)
    self.temp.states.currentAnimationState = newState
    if newState == "SPRINT" then
        self.animations.hold:Stop()
        if self.animations.runningHold then
            self.animations.runningHold:Play()
        end
    elseif newState == "WALK" then
        if self.animations.runningHold then
            self.animations.runningHold:Stop()
        end
        self.animations.hold:Play()
    end
end