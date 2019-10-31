local date = os.date('*t')
local secondOfDay = (7 * 3600) + (30 * 60) + 0
local frozen = false

RegisterServerEvent( "freezeTime" )
AddEventHandler( "freezeTime", function()
	frozen = not frozen
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(2000) -- Every Second, we check these idiots via a time sync with clients.
        TriggerClientEvent("updateFromServerTime",-1,secondOfDay,date,frozen)
        h = math.floor( secondOfDay / 3600 )
		m = math.floor( (secondOfDay - (h * 3600)) / 60 )
        s = secondOfDay - (h * 3600) - (m * 60)
        --TraceMsg("CurrentTime: "..h..":"..m..":"..s)
    end
end)

RegisterServerEvent( "addTimeChatSuggests" )
AddEventHandler( "addTimeChatSuggests", function()
    if IsPlayerAceAllowed(source, "changeTime") then
        TriggerClientEvent ("addTimeChatSuggests",source)
    end
end)


Citizen.CreateThread( function()
    local timeBuffer = 0.0
    local h = 0
    local m = 0
    local s = 0
	while true do
        Citizen.Wait(33) -- (int)(GetMillisecondsPerGameMinute() / 60)
        date = os.date('*t') -- Update the in-game date data.
        if not frozen then
			local gameSecond = 33.33 / ss_night_time_speed_mult
			if secondOfDay >= 19800 and secondOfDay <= 75600 then
				gameSecond = 33.333 / ss_day_time_speed_mult
			end
            timeBuffer = timeBuffer + round( 33.0 / gameSecond, 4 )
			if timeBuffer >= 1.0 then
				local skipSeconds = math.floor( timeBuffer )
				timeBuffer = timeBuffer - skipSeconds
				secondOfDay = secondOfDay + skipSeconds
				if secondOfDay >= 86400 then
					secondOfDay = secondOfDay % 86400
                end
			end
        end
        h = math.floor( secondOfDay / 3600 )
		m = math.floor( (secondOfDay - (h * 3600)) / 60 )
        s = secondOfDay - (h * 3600) - (m * 60)
        secondOfDay = (h * 3600) + (m * 60) + s
	end
end)

RegisterCommand('time', function(source,args,rawCommand)
    
    if source == 0 then
        if tonumber(args[1]) ~= nil and tonumber(args[2]) ~= nil then
            ProcessTimeCommand(args[1],args[2])
            h = math.floor( secondOfDay / 3600 )
	        m = math.floor( (secondOfDay - (h * 3600)) / 60 )
            TraceMsg("CONSOLE has changed time to " ..string.format("%02d", h)..":"..string.format("%02d",m))
        else
            TraceMsg("Invalid syntax, correct syntax is: time <hour> <minute>.",true)
        end
    else
        if IsPlayerAceAllowed(source, "changeTime") then
            if tonumber(args[1]) ~= nil and tonumber(args[2]) ~= nil then
                ProcessTimeCommand(args[1],args[2])
                h = math.floor( secondOfDay / 3600 )
	            m = math.floor( (secondOfDay - (h * 3600)) / 60 )
                TraceMsg(GetPlayerName(source).." has changed time to " ..string.format("%02d", h)..":"..string.format("%02d",m))
            else
                TraceMsg("Invalid syntax, correct syntax is: time <hour> <minute>.",true)
            end
        else
            TraceMsg('Access for command /time denied for player: '.. GetPlayerName(source),true)
		end
    end
end, true)

RegisterCommand('freezetime', function(source,args,rawCommand)
    h = math.floor( secondOfDay / 3600 )
    m = math.floor( (secondOfDay - (h * 3600)) / 60 )
 
    if source == 0 then
        TriggerEvent("freezeTime")
        TraceMsg("CONSOLE has frozen("..tostring(frozen)..") time at " .. string.format("%02d", h) .. ":" .. string.format("%02d", m))
    else
        if IsPlayerAceAllowed(source, "freezeTime") then
            TriggerEvent("freezeTime")
            TraceMsg(GetPlayerName(source).." has frozen("..tostring(frozen)..") time at " .. string.format("%02d", h) .. ":" .. string.format("%02d", m) .. ".")
        else
            TraceMsg('Access for command /freezetime denied for player: '.. GetPlayerName(source),true)
		end
    end
end, true)


function ProcessTimeCommand(arg1,arg2)
    local h = 0
    local m = 0
    local argh = tonumber(arg1)
    local argm = tonumber(arg2)
    if argh < 24 and argh ~= nil then
        h = argh 
    else
        h = 0
    end
    if argm < 60 and arm ~= nil then
        m = argm 
    else
        m = 0
    end
    secondOfDay = (tonumber(h)*3600) + (tonumber(m)*60) + 0
end