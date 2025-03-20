from http.server import BaseHTTPRequestHandler, HTTPServer

file_path = './test.csv'

class SimpleHTTPRequestHandler(BaseHTTPRequestHandler):
	def do_GET(self):
		# Envoyer une réponse HTTP avec le statut 200
		self.send_response(200)

		
		# Terminer les en-têtes de la réponse
		self.end_headers()
		# Optionnel : envoyer un message dans le corps de la réponse
		self.wfile.write(b'OK')

	def do_POST(self):
		# Lire la longueur du contenu de la requête
		content_length = int(self.headers['Content-Length'])
		# Lire les données POST
		post_data = self.rfile.read(content_length)

		# Convertir les données POST en dictionnaire (si c'est du JSON)
		print(post_data)
		with open(file_path, 'ab') as file:
			file.write(post_data + b'\n')

		# Envoyer une réponse HTTP avec le statut 200
		self.send_response(200)
		self.end_headers()
		self.wfile.write(b'Data received')

def run(server_class=HTTPServer, handler_class=SimpleHTTPRequestHandler, port=23023):
	server_address = ('', port)
	httpd = server_class(server_address, handler_class)
	print(f'Serveur démarré sur http://localhost:{port}/')
	httpd.serve_forever()

# Démarrer le serveur
run()





