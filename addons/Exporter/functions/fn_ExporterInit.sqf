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

if (isClass(configFile >> "CfgPatches" >> "cba_settings")) then {
    ["DISExporter_var_delay", "TIME", ["Time","Time beetween each sending"], "DIS-Exporter", [1, 300, 30], 2] call CBA_fnc_addSetting;
}
else {
    if(isNil "DISExporter_var_delay") then {DISExporter_var_delay = 30;};
};

[] spawn _callInit;
