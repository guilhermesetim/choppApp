import serial
import json
from http.server import BaseHTTPRequestHandler, HTTPServer

# Configuração da porta serial
ser = serial.Serial('/dev/ttyUSB0', 9600)  # Defina a porta correta para o seu ESP32

class RequestHandler(BaseHTTPRequestHandler):
    def do_POST(self):
        content_length = int(self.headers['Content-Length'])
        post_data = self.rfile.read(content_length)
        try:
            # Parse do JSON recebido
            data = json.loads(post_data)
            
            # Envia os dados pela serial
            ser.write(json.dumps(data).encode())

            # Responde com sucesso
            self.send_response(200)
            self.end_headers()
            self.wfile.write(b'Success')
        except Exception as e:
            self.send_response(500)
            self.end_headers()
            self.wfile.write(f'Error: {str(e)}'.encode())

# Configuração do servidor HTTP
server_address = ('', 5000)
httpd = HTTPServer(server_address, RequestHandler)

print('Servidor rodando...')
httpd.serve_forever()

