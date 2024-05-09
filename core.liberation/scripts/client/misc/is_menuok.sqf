private _alive = alive player;
private _on_foot = isNull objectParent player;
private _no_uav = ((UAVControl (getConnectedUAV player)) select 1 == "");
private _R3F_move = isNull R3F_LOG_joueur_deplace_objet;
private _no_flight = (isTouchingGround player || getPos player select 2 <= 1);
private _no_tunnel = !(player getVariable ["SOG_player_in_tunnel", false]);
private _no_selection = (count (groupSelectedUnits player) == 0);

(_alive && _on_foot && _R3F_move && _no_flight && _no_tunnel && _no_uav && _no_selection && build_confirmed == 0);