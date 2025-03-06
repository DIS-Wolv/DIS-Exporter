/*
* Auteur: Wolv
* Function qui export les données de la missions
* 
* Return Value:
* nil
*
*/

// only server can export data
if (!isServer) exitWith {};

private _sysTime = systemTime;

private _servName = serverName;

private _worldName = worldName;
private _briefName = briefingName; // or missionName ?
private _avergaeFPS = diag_fps;

private _player = count allPlayers;
private _unitsBlue = count units west;
private _unitsRed = count units east;
private _unitsInd = count units independent;
private _unitsCiv = count units civilian;

private _vl = {alive _x} count vehicles;

private _deadMen = count allDeadMen;
private _deadVh = (count allDead) - _deadMen; // count allDeadVehicles and dead agents

Private _data = format[
	"Time:%1;	Server:%2;	Mission:%3;	FPS:%4;		player:%5;	Blue:%6;	Red:%7;		Ind:%8;		Civ:%9;		Vl:%10;	DeadMen:%11;	DeadVh:%12",
	_sysTime,	_servName,	_briefName,	_avergaeFPS,_player, 	_unitsBlue,	_unitsRed,	_unitsInd,	_unitsCiv,	_vl,	_deadMen,	_deadVh
];

[_data] call DISExporter_fnc_SendData;

