if ss_enable_door_window_sync then

  local vehicleState = { windowsDown = false }

  RegisterNetEvent('VehicleWindow')
  AddEventHandler( "VehicleWindow", function( playerID, windowsDown )
    local vehicle = GetVehiclePedIsIn( GetPlayerPed( GetPlayerFromServerId( playerID ) ), false )
    if windowsDown then
      RollDownWindow( vehicle, 0 )
      RollDownWindow( vehicle, 1 )
    else
      RollUpWindow( vehicle, 0 )
      RollUpWindow( vehicle, 1 )
    end
  end)

  Citizen.CreateThread( function()
    while true do
      Citizen.Wait(10)
      if IsPedInAnyVehicle( GetPlayerPed( -1 ), false ) then
        local pressedUp   =  IsControlJustPressed( keybinds.windows.inputGroup, keybinds.windows.up ) or false
        local pressedDown =  IsControlJustPressed( keybinds.windows.inputGroup, keybinds.windows.down ) or false
        if pressedUp or pressedDown then
          local vehicle = GetVehiclePedIsIn( GetPlayerPed( -1 ), false )
          if GetPedInVehicleSeat( vehicle, - 1 ) == GetPlayerPed( -1 ) then
            if pressedUp then
              vehicleState.windowsDown = false
              TriggerServerEvent( "ServerSync:SetVehicleWindow", vehicleState.windowsDown )
            end
            if pressedDown then
              vehicleState.windowsDown = true
              TriggerServerEvent( "ServerSync:SetVehicleWindow", vehicleState.windowsDown )
            end
          end
        end
      end
    end
  end)

end