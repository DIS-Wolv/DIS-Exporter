// dllmain.cpp : Définit le point d'entrée de l'application DLL.
#include "pch.h"
#include <string>
#include <vector>
#include <iterator>
#include <sstream>
#include <iomanip>
#include <fstream>
//#include <socketapi.h>

BOOL APIENTRY DllMain(HMODULE hModule,
	DWORD ul_reason_for_call,
	LPVOID lpReserved)
{
	switch (ul_reason_for_call)
	{
	case DLL_PROCESS_ATTACH:
	case DLL_THREAD_ATTACH:
	case DLL_THREAD_DETACH:
	case DLL_PROCESS_DETACH:
		break;
	}
	return TRUE;
}

std::vector<std::string> contextInfo;

extern "C"
{	// depending of the syntax : https://community.bistudio.com/wiki/callExtension
	//--- Engine called on extension load	=> "myExtension" callExtension ""
	__declspec (dllexport) void __stdcall RVExtensionVersion(char* output, int outputSize);
	//--- STRING callExtension STRING		=> "myExtension" callExtension "myFunction"
	__declspec (dllexport) void __stdcall RVExtension(char* output, int outputSize, const char* function);
	//--- STRING callExtension ARRAY		=> "myExtension" callExtension ["myFunction", ["arg1", "arg2"]]
	__declspec (dllexport) int __stdcall RVExtensionArgs(char* output, int outputSize, const char* function, const char** args, int argsCnt);
}

//--- name callExtension function
int __stdcall RVExtensionArgs(char* output, int outputSize, const char* function, const char** args, int argsCnt)
{

	if (strcmp(function, "Send") == 0) {

		std::string str = "";

		//*
		if (argsCnt >= 2) {
			std::ofstream outfile;
			outfile.open(args[1], std::ios_base::app); // append instead of overwrite
			outfile << args[0] << std::endl;
			outfile.close();

			str += args[0];
			str += "|";
			str += args[1];

		} //*/

		//==========Test==========
		//--- Manually assemble output array
		//int i = 0;
		//std::string str = "[";

		////--- Each argument can be accessed via args[n]
		//if (argsCnt > 0)
		//	str += args[i++];

		//while (i < argsCnt)
		//{
		//	str += ",";
		//	str += args[i++];
		//}

		//str += "]";

		//--- Extension result
		strncpy_s(output, outputSize, str.c_str(), _TRUNCATE);

		//--- Extension return code
		return 100;
	}
	else {
		strncpy_s(output, outputSize, "Function incorrect", _TRUNCATE);
		return 200;
	}
	// Exemple print context
	//if (!contextInfo.empty())
	//{
	//	std::ostringstream oss;
	//	const char qt = '"';

	//	for (auto it = contextInfo.begin(); it != contextInfo.end() - 1; ++it)
	//		oss << std::quoted(*it, qt, qt) << ",";
	//	oss << std::quoted(contextInfo.back(), qt, qt);

	//	//--- Send context info back
	//	strncpy_s(output, outputSize, ("[" + oss.str() + "]").c_str(), _TRUNCATE);
	//}
}

//--- Context is executed first, copy it
void __stdcall RVExtensionContext(const char** args, int argsCnt)
{
	contextInfo.assign(args, std::next(args, argsCnt));
}

