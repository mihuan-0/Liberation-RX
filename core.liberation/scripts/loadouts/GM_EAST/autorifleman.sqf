_unit = _this select 0;

removeAllWeapons _unit;
removeAllItems _unit;
removeAllAssignedItems _unit;
removeVest _unit;
removeBackpack _unit;
removeHeadgear _unit;
removeGoggles _unit;

sleep 0.5;

_unit addUniform "gm_gc_civ_uniform_man_04_80_gry";
for "_i" from 1 to 2 do {_unit addItemToUniform "gm_gc_army_gauzeBandage";};
for "_i" from 1 to 2 do {_unit addItemToUniform "gm_handgrenade_frag_dm51";};
for "_i" from 1 to 3 do {_unit addItemToUniform "gm_8rnd_9x18mm_b_pst_pm_blk";};
for "_i" from 1 to 2 do {_unit addItemToUniform "SmokeShell";};
for "_i" from 1 to 2 do {_unit addItemToUniform "gm_75rnd_762x39mm_b_m43_ak47_blk";};

_unit addVest "gm_dk_army_vest_54_machinegunner";
for "_i" from 1 to 4 do {_unit addItemToVest "gm_75rnd_762x39mm_b_m43_ak47_blk";};

_unit addHeadgear "gm_ge_headgear_hat_80_gry";
_unit addWeapon "gm_rpk_wud";
_unit addWeapon "gm_pm_blk";
_unit linkItem "ItemMap";
_unit linkItem "gm_ge_army_conat2";