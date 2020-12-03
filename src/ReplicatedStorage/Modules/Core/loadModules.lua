return function(moduleDirectory, moduleDictionary)
    for _,module in pairs(moduleDirectory) do
        moduleDictionary[module.Name] = require(module)
    end
end