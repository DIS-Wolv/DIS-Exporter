/*
* Auteur: Wolv
* Function qui envoie les données de la missions
* 
* Return Value:
* nil
*
*/

params ["_data"];


private _host = DISExporter_var_host;
private _port = [DISExporter_var_port] call DISExporter_fnc_strToInt;

// systemChat format["Exporter: Sending data to %1:%2",_host,_port];
// systemChat _data;

if (DISExporter_var_httpExport) then {
    "DllTest1" callExtension ["SendHTTP", [_host, _port, _data]];

};


