params ["_fobpos"];

private _classnames_to_destroy = [
	FOB_typename,
	FOB_outpost,
	FOB_carrier,
	FOB_sign,
	Warehouse_desk_typename,
	"Land_RepairDepot_01_civ_F",
	"Land_MedicalTent_01_MTP_closed_F",
	"Helipad_base_F",
	"FlagCarrier",
	"Land_Destroyer_01_hull_base_F",
	"Land_Carrier_01_hull_base_F"
];
_classnames_to_destroy append all_buildings_classnames + fob_buildings_classnames + list_static_weapons;

private _sleep = 0.5;
if (surfaceIsWater _fobpos) then {
	{ _classnames_to_destroy pushback (_x select 0) } foreach support_vehicles;
	_sleep = 0;
};

private _all_buildings_to_destroy = [];
_all_buildings_to_destroy = (_fobpos nearObjects (GRLIB_fob_range * 2)) select { getObjectType _x >= 8 && ([_x, _classnames_to_destroy] call F_itemIsInClass) };

if (count _all_buildings_to_destroy > 100 && _sleep > 0) then {
	_sleep = 0.1;
};

{
	_building = _x;
	if (typeOf _building == Warehouse_typename) then {
		{
			if ((getPosATL _x) distance2D (getPosATL _building) < GRLIB_fob_range) then { deleteVehicle _x };
		} foreach allSimpleObjects [waterbarrel_typename,fuelbarrel_typename,foodbarrel_typename,basic_weapon_typename];

		private _owner = _building getVariable ["GRLIB_WarehouseOwner", objNull];
		deleteVehicle _owner;
	};

	if (typeOf _building == FOB_typename) then {
		deleteVehicle (_building getVariable ["GRLIB_FOB_Officer", objNull]);
		{ deleteVehicle _x } forEach (_building getVariable ["GRLIB_FOB_Objects", []]);
	};
	deleteVehicle _building;
	sleep _sleep;
} foreach _all_buildings_to_destroy;


_all_buildings_to_destroy = (_fobpos nearObjects (GRLIB_fob_range * 2)) select { getObjectType _x >= 8 && (getPos _x select 2) >= 2 };
{ _x setPos (getPos _x)} forEach _all_buildings_to_destroy;

GRLIB_all_fobs = GRLIB_all_fobs - [_fobpos];
publicVariable "GRLIB_all_fobs";
GRLIB_all_outposts = GRLIB_all_outposts - [_fobpos];
publicVariable "GRLIB_all_outposts";

stats_fobs_lost = stats_fobs_lost + 1;
