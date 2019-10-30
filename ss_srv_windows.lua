if ss_enable_door_window_sync then
  RegisterServerEvent( "ServerSync:SetVehicleWindow" )
  AddEventHandler( "ServerSync:SetVehicleWindow", function( windowsDown )
  	TriggerClientEvent( "VehicleWindow", -1, source, windowsDown )
  end)
end