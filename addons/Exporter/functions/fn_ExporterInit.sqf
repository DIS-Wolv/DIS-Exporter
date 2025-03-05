/*
* Auteur: Wolv
* Function qui initialise l'exporter
* 
* Return Value:
* nil
*
*/
// systemChat "Exporter Init";

Private _callInit = {
    while {true} do {
        private _startCount = serverTime;
        waitUntil {
            uiSleep 1; 
            serverTime > _startCount + DISExporter_var_delay
        };
        [] call DISExporter_fnc_ExportData;
    };
};

private _defaultTime = 30;
private _defaultPath = "C:\";
private _defaultHost = "localhost:23023";

if (isClass(configFile >> "CfgPatches" >> "cba_settings")) then {
    ["DISExporter_var_delay", "TIME", ["Time","Time beetween each sending"], "DIS-Exporter", [1, 300, _defaultTime], 2] call CBA_fnc_addSetting;

    ["DISExporter_var_CSVExport", "CHECKBOX", ["Export as CSV","Enable the export at csv"], "DIS-Exporter", true, 2] call CBA_fnc_addSetting;
    ["DISExporter_var_path", "EDITBOX", ["Path","Path where the data will be stored"], "DIS-Exporter", _defaultPath, 2] call CBA_fnc_addSetting;

    ["DISExporter_var_htmlExport", "CHECKBOX", ["Export to a HTTP Host","Enable the export to a HTTP host"], "DIS-Exporter", false, 2] call CBA_fnc_addSetting;
    ["DISExporter_var_host", "EDITBOX", ["host","Addresse to send http export"], "DIS-Exporter", _defaultHost, 2] call CBA_fnc_addSetting;
}
else {
    if(isNil "DISExporter_var_delay") then {DISExporter_var_delay = _defaultTime;};
    
    if(isNil "DISExporter_var_CSVExport") then {DISExporter_var_CSVExport = true;};
    if(isNil "DISExporter_var_path") then {DISExporter_var_path = _defaultPath;};

    if(isNil "DISExporter_var_htmlExport") then {DISExporter_var_htmlExport = false;};
    if(isNil "DISExporter_var_host") then {DISExporter_var_host = _defaultHost;};
};

[] spawn _callInit;
