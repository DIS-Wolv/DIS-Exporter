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
        uisleep DISExporter_var_delay;
        [] call DISExporter_fnc_ExportData;
    };
};

if(isNil "DISExporter_var_delay") then {DISExporter_var_delay = 5;};
[] spawn _callInit;