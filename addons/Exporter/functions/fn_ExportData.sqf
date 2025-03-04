/*
* Auteur: Wolv
* Function qui export les données de la missions
* 
* Return Value:
* nil
*
*/

private _sysTime = systemTime;

private _servName = serverName;

private _worldName = worldName;
private _briefName = briefingName; // or missionName ?

private _player = count allPlayers;
private _unitsBlue = count units west;
private _unitsRed = count units east;
private _unitsInd = count units independent;
private _unitsCiv = count units civilian;

private _vl = {alive _x} count vehicles;

private _deadMen = count allDeadMen;
private _deadVh = (count allDead) - _deadMen; // count allDeadVehicles and dead agents

Private _data = format[
	"Time:%1;	Server:%2;	Mission:%3;	player:%4;	Blue:%5;	Red:%6;		Ind:%7;		Civ:%8;		Vl:%9;	DeadMen:%10;	DeadVh:%11",
	_sysTime,	_servName,	_briefName,	_player, 	_unitsBlue,	_unitsRed,	_unitsInd,	_unitsCiv,	_vl,	_deadMen,	_deadVh
];

[_data] call DISExporter_fnc_SendData;

