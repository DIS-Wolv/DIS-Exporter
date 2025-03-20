// dllmain.cpp : Définit le point d'entrée de l'application DLL.
#include <string>
#include <vector>
#include <iterator>
#include <sstream>
#include <iomanip>
#include <fstream>

// Socket 
#pragma comment(lib, "Ws2_32.lib")
#include <winsock2.h>
#include <ws2tcpip.h>

const int INCORRECT_FUNCTION = 200;
const int INCORRECT_ARG = 201;
const int ERROR_UNDIFINED = 199;

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

		}

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
	else if (strcmp(function, "SendHTTP") == 0) {
		if (argsCnt >= 3) {

			WSADATA wsaData;
			SOCKET ConnectSocket = INVALID_SOCKET;
			struct sockaddr_in serverInfo;
			std::string request;
			std::string data = args[2];
			int port = atoi(args[1]);
			char address[20]; 
			strncpy_s(address, 20, args[0], _TRUNCATE);
			

			size_t length = std::strlen(address);

			// Vérifiez si la chaîne a au moins 2 caractères et commence et finit par des guillemets
			if (length > 1 && address[0] == '"' && address[length - 1] == '"') {
				// Déplacez les caractères pour enlever les guillemets
				for (size_t i = 1; i < length - 1; ++i) {
					address[i - 1] = address[i];
				}
				// Ajoutez le caractère de fin de chaîne
				address[length - 2] = '\0';
			}

			// Initialiser Winsock
			int result = WSAStartup(MAKEWORD(2, 2), &wsaData);
			if (result != 0) {
				//std::cerr << "Erreur lors de l'initialisation de Winsock: " << result << std::endl;
				strncpy_s(output, outputSize, "Socket initialisation error", _TRUNCATE);
				return ERROR_UNDIFINED;
			}

			// Créer un socket
			ConnectSocket = socket(AF_INET, SOCK_STREAM, IPPROTO_TCP);
			if (ConnectSocket == INVALID_SOCKET) {
				//std::cerr << "Erreur lors de la création du socket: " << WSAGetLastError() << std::endl;
				WSACleanup();
				strncpy_s(output, outputSize, "Socket creation error", _TRUNCATE);
				return ERROR_UNDIFINED;
			}

			// Configurer les informations du serveur
			serverInfo.sin_family = AF_INET;
			serverInfo.sin_port = htons(port);
			inet_pton(AF_INET, address, &serverInfo.sin_addr);

			// Se connecter au serveur
			result = connect(ConnectSocket, (struct sockaddr*)&serverInfo, sizeof(serverInfo));
			if (result == SOCKET_ERROR) {
				//std::cerr << "Erreur lors de la connexion au serveur: " << WSAGetLastError() << std::endl;
				closesocket(ConnectSocket);
				WSACleanup();
				strncpy_s(output, outputSize, "Server creation error", _TRUNCATE);
				return ERROR_UNDIFINED;
			}

			// Construire la requête HTTP POST
			request = "POST / HTTP/1.1\r\n";
			request += "Content-Type: text/plain\r\n";
			request += "Content-Length: " + std::to_string(data.length()) + "\r\n";
			request += "\r\n";
			request += data;

			// Envoyer la requête HTTP POST
			result = send(ConnectSocket, request.c_str(), static_cast<int>(request.length()), 0);
			if (result == SOCKET_ERROR) {
				//std::cerr << "Erreur lors de l'envoi de la requête HTTP: " << WSAGetLastError() << std::endl;
				closesocket(ConnectSocket);
				WSACleanup();
				strncpy_s(output, outputSize, "Data send error", _TRUNCATE);
				return ERROR_UNDIFINED;
			}

			////std::cout << "Requête HTTP POST envoyée au serveur." << std::endl;

			char buff[512];
			recv(ConnectSocket, buff, 512, 0);
			//*/

			// Fermer le socket
			closesocket(ConnectSocket);
			WSACleanup(); 

			strncpy_s(output, outputSize, "DataSend", _TRUNCATE);
			return 200;
		}
		else {
			strncpy_s(output, outputSize, "Argument incorrect", _TRUNCATE);
			return INCORRECT_ARG;
		}
	}
	else {
		strncpy_s(output, outputSize, "Function incorrect", _TRUNCATE);
		return INCORRECT_FUNCTION;
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

