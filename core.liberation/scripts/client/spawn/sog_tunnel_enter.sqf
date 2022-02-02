params ["_tunnelName"];

private _ai_follow = true;
private _ai_follow_max = 2;
private _unit_list_redep = [];
private _tunnel = missionNameSpace getVariable [_tunnelName, "error_no_tunnel"];
if (str _tunnel == "error_no_tunnel") exitWith {};

// Enter SoG tunnel with AI
if (_ai_follow) then {
    _unit_list_redep = ([(units group player), { !(isPlayer _x) && vehicle _x == _x && (_x distance2D (getPosATL _tunnel)) < 40 && lifestate _x != 'INCAPACITATED' }] call BIS_fnc_conditionalSelect) select [0,_ai_follow_max];
    [_unit_list_redep] spawn {
        sleep 1;
        params ["_list"];
        {
            _x setpos ([getPosATL player, 1, random 360] call BIS_fnc_relPos);
            _x doFollow leader player;
            sleep 0.3;
        } forEach _list;
    };
};

private _position = _tunnel getVariable ["tunnel_position", 0];
private _msg = format ["You enter in the <t color='#008f00'>Guerrilla</t> tunnel no <t color='#008f00'>%1</t> !<br/><br/>
Expect NO <t color='#00008f'>Support</t>, NO <t color='#00008f'>Help</t>. <br/>
Expect NO <t color='#8f0000'>Mercy</t> !<br/><br/>
You are on your own....", _position];
[_msg, 0, 0, 10, 0, 0, 90] spawn BIS_fnc_dynamicText;

player setVariable ["SOG_enter_tunnel", round (time)];
player setVariable ["SOG_unit_list", _unit_list_redep];
showMap false;
[player, _tunnelName] remoteExec [ "sog_tunnel_enter_remotecall", 2 ];

//diag_log format ["DBG: enter tunnel %1 %2", _tunnelName, allVariables _tunnel];