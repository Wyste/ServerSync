if ss_enable_turn_signal_sync then
	RegisterServerEvent( "ServerSync:SetVehicleIndicator" )
	AddEventHandler( "ServerSync:SetVehicleIndicator", function( dir, state )
		TriggerClientEvent( "VehicleIndicator", -1, source, dir, state )
	end)
end
