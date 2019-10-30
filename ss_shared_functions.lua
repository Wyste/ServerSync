--server
function getTableLength(T)
	local count = 0
	for _ in pairs(T) do
		count = count + 1
	end
	return count
end

--server
function getTableKeys(T)
	local keys = {}
	for k,v in pairs(T) do
		table.insert(keys,k)
	end
	return keys
end

function TraceMsg(msg,error)
	error = error or false
	e = "^2["
	if error then e = "^1[" end
    Citizen.Trace(e..GetCurrentResourceName().."] "..msg.."\n^7")
end

function round( n, precision )
	if precision then
		return math.floor( (n * 10^precision) + 0.5 ) / (10^precision)
	end
	return math.floor( n + 0.5 )
end