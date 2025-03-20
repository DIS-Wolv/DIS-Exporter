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

private _unitsCiv = (count units civilian);

private _unitsComa = {_x getVariable ["ACE_isUnconscious", false]} count allUnits;
private _vl = {alive _x} count vehicles; 

private _deadMen = count allDeadMen;
private _deadVh = (count allDead) - _deadMen; // count allDeadVehicles and dead agents

Private _data = format[
	"%1;'%2';'%3';%4;%5;%6;%7;%8;%9;%10;%11;%12;%13",
	_sysTime, _servName, _briefName, _avergaeFPS, _player, _unitsBlue, _unitsRed, _unitsInd, _unitsCiv, _unitsComa, _vl, _deadMen, _deadVh
];

[_data] call DISExporter_fnc_SendData;

