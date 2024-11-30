waitUntil {sleep 1; GRLIB_player_spawned};

while { true } do {
	waitUntil { sleep 1; alive player };

	// Renegade
	private _side = side player;
	if (!captive player && _side in [GRLIB_side_friendly, GRLIB_side_civilian]) then {
		player setcaptive true;
		player addrating 3000;
		if (isNull GRLIB_player_group) then {
			GRLIB_player_group = createGroup [GRLIB_side_friendly, true];
		};
		[player] joinSilent GRLIB_player_group;
		GRLIB_player_group selectLeader player;
		player setcaptive false;
		player addrating 3000;
		gamelogic globalChat format ["--- LRX info: Player %1 wrong side - (%2)", name player, _side];
	};

	// Leadership
	if (!captive player && count units GRLIB_player_group > 1 && leader GRLIB_player_group != player && local GRLIB_player_group) then {
		player addrating 3000;
		GRLIB_player_group selectLeader player;
		gamelogic globalChat format ["-- LRX info: Player %1 (re)take Leadership.", name player];		
	};
	sleep 5;
};
