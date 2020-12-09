return function(func, ...)
	local newThread = coroutine.wrap(func)
	newThread(...)
end