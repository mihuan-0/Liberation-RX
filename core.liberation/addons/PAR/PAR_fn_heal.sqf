params ["_medic", "_wnded"];

_wnded setVariable ["PAR_heal", true];

if (_wnded == _medic) exitWith {
	_wnded playMoveNow 'ainvpknlmstpslaywrfldnon_medicother';
	sleep 7;
	if (lifeState _wnded != "INCAPACITATED") then {
		_wnded setDamage 0;
	};
	sleep 2;
	_wnded setVariable ["PAR_heal", nil];
};

_medic groupchat format [localize "STR_PAR_CW_01", name _wnded];
_medic setVariable ["PAR_heal", true];

private ["_wnded_hit", "_medic_hit", "_medic_busy", "_wnded_healed", "_in_vehicle"];
private _timer = time + 60;
private _exit = false;
waitUntil {
	_wnded stop true;
	_medic doMove (getPosATL _wnded);
	sleep 3;
	_wnded_healed = damage _wnded == 0;
	_in_vehicle = !(isNull objectParent _wnded && isNull objectParent _medic);
	_wnded_hit = lifeState _wnded == "INCAPACITATED";
	_medic_hit = lifeState _medic == "INCAPACITATED";
	_medic_busy = _medic getVariable ["PAR_busy", false];
	_exit = (time > _timer || _medic_busy || _medic_hit || _wnded_hit || _wnded_healed || _in_vehicle);
	(_exit || _medic distance2D _wnded <= 3)
};

if (_exit) exitWith {
	_wnded stop false;
	_wnded setVariable ["PAR_heal", nil];
	_medic setVariable ["PAR_heal", nil];
};

_medic setDir (_medic getDir _wnded);
if (stance _medic == 'PRONE') then {
	_medic playMoveNow 'ainvppnemstpslaywrfldnon_medicother';
} else {
	_medic playMoveNow 'ainvpknlmstpslaywrfldnon_medicother';
};
sleep 7;
if (lifeState _medic != "INCAPACITATED" && lifeState _wnded != "INCAPACITATED" && (_medic distance2D _wnded) <= 3) then {
	_wnded setDamage 0;
};
[[_medic, _wnded]] call PAR_fn_fixPos;

sleep 2;
_wnded stop false;
_wnded setVariable ["PAR_heal", nil];
_medic setVariable ["PAR_heal", nil];
[_medic, _wnded] doFollow (leader group player);
