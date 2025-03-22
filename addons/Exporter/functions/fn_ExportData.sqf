/*
* Auteur: Wolv
* Function qui export les données de la missions
* 
* Return Value:
* nil
*
*/

params [["_headerMode", false], ["_force", false]];
// only server can export data

if (!_force and !isServer) exitWith {};
if (!_force and !_headerMode and ((count allPlayers) == 0)) exitWith {};


private _sysTime = systemTime;

private _servName = serverName;

private _worldName = worldName;
private _briefName = briefingName; // or missionName ?
private _avergaeFPS = diag_fps;

private _allUnits = count allUnits;
private _player = count allPlayers;
private _unitsBlue = count units west;
private _unitsRed = count units east;
private _unitsInd = count units independent;

private _unitsCiv = (count units civilian);

private _unitsComa = {_x getVariable ["ACE_isUnconscious", false]} count allUnits;
// get only alive vehicles
private _vl = {alive _x and _x isKindOf "AllVehicles"} count vehicles;
private _deadvl = {!(alive _x) and _x isKindOf "AllVehicles"} count vehicles;


private _deadMen = count allDeadMen;
private _deadObj = (count allDead) - _deadMen - _deadvl; // count allDeadVehicles and dead agents

Private _data = [];

if (_headerMode) then {
	_data = "'SysTime';'ServerName';'BriefingName';'AverageFPS';'AllUnits';'Players';'UnitsBlue';'UnitsRed';'UnitsInd';'UnitsCiv';'UnitsComa';'Vehicles';'DeadMen';'DeadVehicles';'DeadObjects'";
}
else {
	_data = format[
		"%1;'%2';'%3';%4;%5;%6;%7;%8;%9;%10;%11;%12;%13;%14;%15",
		_sysTime, _servName, _briefName, _avergaeFPS, _allUnits, _player, _unitsBlue, _unitsRed, _unitsInd, _unitsCiv, _unitsComa, _vl, _deadMen, _deadvl, _deadObj
	];
};


[_data] call DISExporter_fnc_SendData;

