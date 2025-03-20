

params ["_str"];

_str = _str splitString '';

private _number = [0,1,2,3,4,5,6,7,8,9];

private _strValue = 0;
private _strParts = (count _str) - 1;

{
	private _strPart = _x;
	private _strIndex = _forEachIndex;
	{
		if (_strPart == format["%1", _x]) then {
			_str set [_strIndex, _x];
			
			_strValue = _strValue + _x * (10 ^ (_strParts-_strIndex));
		};
	}foreach _number;
} foreach _str;

_strValue;
