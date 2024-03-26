private _selection = 0;
private _selectedmember = objNull;
private _rename_controls = [521,522,523,524,525,526,527];
private _update = false;

createDialog "liberation_squad";
waitUntil { dialog };

{ ctrlShow [_x, false] } foreach _rename_controls;
GRLIB_Squad_target = "Sign_Sphere100cm_F" createVehicleLocal [ 0, 0, 0 ];
hideObject GRLIB_Squad_target;
GRLIB_Squad_camera = "camera" camCreate (getpos player);
GRLIB_Squad_camera cameraEffect ["internal","back", "rtt"];
GRLIB_Squad_camera camSetTarget GRLIB_Squad_target;
GRLIB_Squad_camera camcommit 0;
"rtt" setPiPEffect [0];

// PA LikeMeButton disabled
if (GRLIB_filter_arsenal == 4) then { ctrlEnable [ 215, false ] };

//ReplaceButton disabled
ctrlEnable [ 212, false ];

// Create unit list
lbClear 101;
private _unitname= "";
private _membercount = 0;
{
	_unitname = format ["%1. %2", [ _x ] call F_getUnitPositionId, name _x];
	lbAdd [101, _unitname];
	_membercount = _membercount + 1;
} foreach PAR_AI_bros;
lbSetCurSel [101, 0];

while { dialog && alive player && _membercount > 0 } do {
	_update = false;
	GRLIB_squadaction = -1;
	waitUntil { sleep 0.2; (!dialog || GRLIB_squadaction != -1) };
	if (!dialog) exitWith {};

	_selection = (lbCurSel 101);
	_selectedmember = PAR_AI_bros select _selection;

	// Promote
	if ( GRLIB_squadaction == 1 ) then {
		ctrlEnable [210, false];
		private _ai_rank = (GRLIB_rank_level find (rank _selectedmember));
		private _pl_rank = (GRLIB_rank_level find (rank player));
		private _ai_score = _selectedmember getVariable ["PAR_AI_score", nil];
		if (!isNil "_ai_score") then {
			if (_ai_rank < (_pl_rank - 1)) then {
				private _cost = (_ai_score * 17);
				private _msg = format ["<t align='center'>Promote %1 for %2 Ammo<br/>Are you sure ?</t>", name _selectedmember, _cost];
				private _result = [_msg, "Warning !", true, true] call BIS_fnc_guiMessage;
				if (_result) then {
					if (!([_cost] call F_pay)) exitWith {};
					_selectedmember setVariable ["PAR_AI_score", 0];
					hint localize 'STR_PROMOTE_OK';
					waitUntil {sleep 0.3; _selectedmember getVariable ["PAR_AI_score", 0] !=0 };
				};
			} else {
				hint localize 'STR_PROMOTE_KO';
			};
		};
		sleep 0.5;
		ctrlEnable [210, true];
	};

	// Delete
	if (GRLIB_squadaction == 2) then {
		ctrlEnable [211, false];
		private _msg = format ["<t align='center'>Delete %1 %2<br/>Are you sure ?</t>", rank _selectedmember, name _selectedmember];
		private _result = [_msg, "Warning !", true, true] call BIS_fnc_guiMessage;
		if (_result) then {
			private _ai_rank = 1 + (GRLIB_rank_level find (rank _selectedmember));
			private _refund = [_selectedmember] call F_loadoutPrice;
			if (_ai_rank > 1 ) then {
				_refund = round (_refund * (_ai_rank * 0.7));
			};
			[player, _refund, 0] remoteExec ["ammo_add_remote_call", 2];
			playSound "taskSucceeded";
			if (_ai_rank > 1 ) then {
				gamelogic globalChat format ["Soldier rank %2 Refund: %1, Thank you !", _refund, _ai_rank];
			} else {
				gamelogic globalChat format ["Soldier Refund: %1, Thank you !", _refund];
			};
			PAR_AI_bros = PAR_AI_bros - [_selectedmember];
			deleteVehicle _selectedmember;
			hint localize 'STR_REMOVE_OK';
			_update = true;
		};
		sleep 0.5;
		ctrlEnable [211, true];
	};

	// None!
	if (GRLIB_squadaction == 3) then {
	};

	// Like Me
	if (GRLIB_squadaction == 4) then {
		ctrlEnable [215, false];
		if ((player distance _selectedmember) < 30) then {
			private _price_ai = [_selectedmember] call F_loadoutPrice;
			private _price = [player] call F_loadoutPrice;
			private _cost = 0 max (_price - _price_ai);
			if ([_cost] call F_pay) then {
				_selectedmember setUnitLoadout (getUnitLoadout player);
				hintSilent format ["Loadout copied, Price: %1\nThank you !", _cost];
			};
		} else {
			hintSilent "Unit too far from you.";
		};
		sleep 0.5;
		ctrlEnable [215, true];
	};

	// Rename
	if (GRLIB_squadaction == 5) then {
		ctrlEnable [217, false];
		unitname = "";
		_name = name _selectedmember;
		{ ctrlShow [_x, true] } foreach _rename_controls;
		ctrlSetText [527, _name];
		waitUntil {uiSleep 0.1; ((GRLIB_squadaction == -1) || (unitname != "") || !(dialog) || !(alive player)) };

		if (unitname != "") then {
			_p2 = (unitname splitString " ") select 0;
			_p1 = (unitname splitString " ") select 1;
			if (isNil "_p1") then {_p1 = ""};
			_selectedmember setName [unitname, _p1, _p2];
			gamelogic globalChat format ["Renaming %1 to %2", _name, unitname];
		};
		{ ctrlShow [_x, false] } foreach _rename_controls;
		sleep 0.5;
		ctrlEnable [217, true];
		_update = true;
	};

	// Update unit list
	if (_update) then {
		_membercount = 0;
		lbClear 101;
		{
			_unitname = format ["%1. %2", [ _x ] call F_getUnitPositionId, name _x];
			lbAdd [101, _unitname];
			_membercount = _membercount + 1;
		} foreach PAR_AI_bros;
		lbSetCurSel [101, 0];
	} else {
		lbSetCurSel [101, _selection];
	};

	uiSleep 0.5;
};

closeDialog 0;
"spawn_marker" setMarkerPosLocal markers_reset;
GRLIB_Squad_camera cameraEffect ["terminate","back"];
camDestroy GRLIB_Squad_camera;
deleteVehicle GRLIB_Squad_target;
uiSleep 3;
hintSilent "";