local newThread = require(script.Parent.newThread)
return function(tag, func)
	local CollectionService = game:GetService("CollectionService")

	for _,obj in pairs(CollectionService:GetTagged(tag)) do
		newThread(func, obj)
	end

	local instanceAddedEvent = CollectionService:GetInstanceAddedSignal(tag):Connect(function(obj)
		newThread(func, obj)
	end)

	return instanceAddedEvent
end