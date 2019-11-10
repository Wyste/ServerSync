local cv = GetConvarInt('sv_maxclients', 64) -- Future Proofing for oneSync
local onlinePlayers = 1

local ncrowd = ss_crowd_max_density   - ( onlinePlayers / cv / ( 2 / ss_crowd_max_density   ) )

if ss_enable_traffic_density then
  local ntraff = ss_traffic_max_density - ( onlinePlayers / cv / ( 2 / ss_traffic_max_density ) )
end

if ss_enable_traffic_density or ss_enable_crowd_density then
  Citizen.CreateThread(function()
    while true do
      Citizen.Wait(10000) -- Check every ten seconds

      local playerpos = GetEntityCoords(GetPlayerPed(-1),false)
      if playerpos['z'] < -100.0 then
        --Citizen.Trace("Setting Traffic/Ped Density to 0.0 - you are underground, and this be crazy.")
        if ss_enable_crowd_density then ncrowd = 0.0 end
        if ss_enable_traffic_density and ss_enable_traffic_density then ntraff = 0.0 end -- Can't set absolute zero on floats, so we go REALLY low
      else
        if ss_enable_traffic_density or ss_enable_crowd_density then
          if ss_enable_crowd_scaling or ss_enable_traffic_scaling then
            onlinePlayers = 0
            for i = 0, 63 do
                if NetworkIsPlayerActive(i) then
                    onlinePlayers = onlinePlayers + 1
                end
            end
            if ss_enable_crowd_density   then ncrowd = ss_crowd_max_density   - ( onlinePlayers / cv / ( 2 / ss_crowd_max_density   ) ) end
            if ss_enable_traffic_density then ntraff = ss_traffic_max_density - ( onlinePlayers / cv / ( 2 / ss_traffic_max_density ) ) end
          end
        end
      end
    end
  end)
end
  
Citizen.CreateThread(function()
  local player = GetPlayerPed( -1 )
  while true do
    Citizen.Wait(0)   
    
    if ss_enable_police_ignore_player then SetPoliceIgnorePlayer(player, true) end

    if ss_enable_no_wanted_level then 
      SetMaxWantedLevel(0)
      ClearPlayerWantedLevel(player)
    end

    if ss_enable_everyone_ignores_player then
      SetEveryoneIgnorePlayer(player, true)
      SetPlayerCanBeHassledByGangs(player, false)
      SetIgnoreLowPriorityShockingEvents(player, true)
    end
    
    if ss_enable_random_cop_spawn then
      SetCreateRandomCopsNotOnScenarios(false)
      SetCreateRandomCops(false)
    end

    if ss_enable_random_boat_spawn then SetRandomBoats(true) end
    if ss_enable_garbage_truck_spawn then SetGarbageTrucks(true) end

    
    if ss_enable_crowd_density then 
      if ss_enable_crowd_scaling then
        SetPedDensityMultiplierThisFrame( ncrowd )  
        SetScenarioPedDensityMultiplierThisFrame(ncrowd, ncrowd)
      else 
        SetPedDensityMultiplierThisFrame( ss_crowd_max_density )
        SetScenarioPedDensityMultiplierThisFrame(ss_crowd_max_density, ss_crowd_max_density)
      end
    end

    --Traffic
    if ss_enable_traffic_density then
      if ss_enable_traffic_scaling then
        SetVehicleDensityMultiplierThisFrame( ntraff )
        SetRandomVehicleDensityMultiplierThisFrame( ntraff )
        SetParkedVehicleDensityMultiplierThisFrame( ntraff )
      else
        SetVehicleDensityMultiplierThisFrame( ss_traffic_max_density )
        SetRandomVehicleDensityMultiplierThisFrame( ss_traffic_max_density )
        SetParkedVehicleDensityMultiplierThisFrame( ss_traffic_max_density )
      end
    end

  end
end)
