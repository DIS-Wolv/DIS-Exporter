/*
* Auteur: Wolv
* Function qui envoie les données de la missions
* 
* Return Value:
* nil
*
*/

params ["_data",["_host","localhost"],["_port",23023]];


// systemChat format["Exporter: Sending data to %1:%2",_host,_port];
systemChat _data;

