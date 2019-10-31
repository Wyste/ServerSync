local currentWeather = ss_default_weather
local blackout = false
local weatherTimer = ss_weather_timer * 60 -- 60 Seconds times whatever config minutes are.
local rainTimer = ss_rain_timeout * 60
local rainPossible = false

RegisterServerEvent( "changeWeather" )
AddEventHandler( "changeWeather", function(startup)
	if startup then
	TriggerClientEvent( 'changeWeather',source,currentWeather, blackout, startup )
	else
	TriggerClientEvent( 'changeWeather',-1,currentWeather, blackout, startup )
	end
end)

RegisterServerEvent( "addWeatherChatSuggests" )
AddEventHandler( "addWeatherChatSuggests", function()
    if IsPlayerAceAllowed(source, "changeWeather") then
        TriggerClientEvent ("addWeatherChatSuggests",source)
    end
end)

Citizen.CreateThread(function()
	TraceMsg("initialized.")
    while true do
        weatherTimer = weatherTimer - 1
        if rainPossible == true then
            rainTimer = -1
        else
            rainTimer = rainTimer - 1
        end
        Citizen.Wait(1000) -- one second wait time
        if weatherTimer == 0 then
			if ss_enable_dynamic_weather then
                PushNextWeather()
            end
            weatherTimer = ss_weather_timer * 60
        end

        if rainTimer == 0 then
            rainPossible = true   
        end
    end
end)

function PushNextWeather()
    -- We need to find the current weather, selection a transistion weather, then push that to the clients via changeWeather
    local reduced = false
    local reducedW = ""
	math.randomseed(GetGameTimer())
	local count = getTableLength(ss_weather_Transition)
    local tableKeys = getTableKeys(ss_weather_Transition)
	local currentOptions = ss_weather_Transition[currentWeather]
    currentWeather = currentOptions[math.random(1,getTableLength(currentOptions))]
    
    -- Reduce the chance of rainy weather being selected. (You get a free roll to try and get away)
    if ss_reduce_rain_chance == true then
        for i,wtype in ipairs(currentOptions) do
            if wtype == string.upper("THUNDER") or wtype == string.upper("CLEARING") then
                currentWeather = currentOptions[math.random(1,getTableLength(currentOptions))]
                reduced = true
                reducedW = wtype
            end
        end
    end

    if rainPossible == false then 
        while currentWeather == "THUNDER" or currentWeather == "CLEARING" do
            currentWeather = currentOptions[math.random(1,getTableLength(currentOptions))]
        end
    end

    if string.upper(currentWeather) == string.upper("THUNDER") or string.upper(currentWeather) == string.upper("CLEARING") then
        rainTimer = ss_rain_timeout * 60
        rainPossible = false
    end

    if ss_show_console_output then
        TraceMsg("New Weather: "..currentWeather.." (Tried to reduce: "..tostring(reduced).." from "..reducedW..") PossibleRain: ".. tostring(rainPossible) .. " | rainTimer: " .. tostring(rainTimer))
    end
	TriggerEvent("changeWeather",false)
end

RegisterCommand('weather', function(source, args)
    if source == 0 then
        local validWeatherType = false
        if args[1] == nil then
            TraceMsg("Invalid /weather syntax, correct syntax is: /weather <weathertype>\nCurrent Weather: "..currentWeather)
            return
		else
			local tableKeys = getTableKeys(ss_weather_Transition)
			for i,wtype in ipairs(tableKeys) do
                if wtype == string.upper(args[1]) then
                    validWeatherType = true
                end
            end
            if validWeatherType then
				currentWeather = string.upper(args[1])
				TraceMsg("Console updated weather to "..currentWeather)
                weatherTimer = ss_weather_timer * 60
                TriggerEvent('changeWeather',false)
            else
                TraceMsg("Invalid weather Type, valid weather types are: \nEXTRASUNNY CLEAR SMOG FOGGY OVERCAST CLOUDS CLEARING\nRAIN THUNDER SNOW BLIZZARD SNOWLIGHT XMAS",true)
            end
        end
	else
        if IsPlayerAceAllowed(source, "changeWeather") then
            local validWeatherType = false
            if args[1] == nil then
                TriggerClientEvent('chatMessage', source, '', {255,255,255}, '^1Error: Invalid syntax, use ^0/weather <weatherType> ^1instead!')
                TriggerClientEvent('chatMessage', source, '', {255,255,255}, '^7Current Weather: '..currentWeather)
                
            else
                local tableKeys = getTableKeys(ss_weather_Transition)
			    for i,wtype in ipairs(tableKeys) do
                    if wtype == string.upper(args[1]) then
                        validWeatherType = true
                    end
                end
                if validWeatherType then
                    currentWeather = string.upper(args[1])
                    weatherTimer = ss_weather_timer * 60
                    if args[2] == "1" then
                        TriggerEvent('changeWeather',true)
                    else
                        TriggerEvent("changeWeather",false)
                        TraceMsg(GetPlayerName(source).." has changed weather to "..currentWeather)
                    end
                else
                    TriggerClientEvent('chatMessage', source, '', {255,255,255}, '^1Error: Invalid weather type, valid weather types are: ^0\nEXTRASUNNY CLEAR NEUTRAL SMOG FOGGY OVERCAST CLOUDS CLEARING\nRAIN THUNDER SNOW BLIZZARD SNOWLIGHT XMAS')
                end
            end
        else
            TraceMsg('Access for command /weather denied for player: '.. GetPlayerName(source),true)
		end

    end
end, true)