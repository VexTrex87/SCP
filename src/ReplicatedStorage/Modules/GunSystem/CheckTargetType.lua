return function(character)
    if not character then
        return "NEUTRAL"
    elseif character.Name == "Friendly" then
        return "FRIENDLY"
    elseif character.Name == "Enemy" then
        return "ENEMY"
    end
end