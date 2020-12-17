return function(self)
    if self.temp.states.isAiming or 
        self.temp.states.isReloading or 
        self.temp.states.currentAnimationState ~= "WALK" or 
        self.temp.states.isMouseDown or
        self.values.totalAmmo.Value <= 0
    then
        return
    end

    self.temp.states.isReloading = true
    self.remotes.ChangeState:FireServer("RELOAD")
    self.animations.reload:Play()
    self.animations.reload.Stopped:Wait()
    self.animations.hold:Play()
    self.temp.states.isReloading = false
end