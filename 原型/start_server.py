#!/usr/bin/env python3
import http.server
import socketserver
import os
import webbrowser
import threading
import time

PORT = 8000

class MyHTTPRequestHandler(http.server.SimpleHTTPRequestHandler):
    def end_headers(self):
        self.send_header('Access-Control-Allow-Origin', '*')
        super().end_headers()

def start_server():
    os.chdir(os.path.dirname(os.path.abspath(__file__)))
    
    with socketserver.TCPServer(("", PORT), MyHTTPRequestHandler) as httpd:
        print("EventHub Prototype Server started at http://localhost:{0}".format(PORT))
        print("Serving files from: {0}".format(os.getcwd()))
        print("Press Ctrl+C to stop the server")
        httpd.serve_forever()

def open_browser():
    time.sleep(1)
    webbrowser.open('http://localhost:{0}'.format(PORT))

if __name__ == "__main__":
    server_thread = threading.Thread(target=start_server)
    server_thread.daemon = True
    server_thread.start()
    
    open_browser()
    
    try:
        while True:
            time.sleep(1)
    except KeyboardInterrupt:
        print("\nServer stopped")