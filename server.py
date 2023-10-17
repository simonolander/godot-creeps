from http.server import SimpleHTTPRequestHandler
import socketserver

class CustomHandler(SimpleHTTPRequestHandler):
    def translate_path(self, path):
        return super().translate_path("./build/web/" + path)

    def end_headers(self):
        self.send_header("Cross-Origin-Embedder-Policy", "require-corp")
        self.send_header("Cross-Origin-Opener-Policy", "same-origin")
        super().end_headers()

if __name__ == "__main__":
    with socketserver.TCPServer(("", 8080), CustomHandler) as httpd:
        print(f"Serving at http://localhost:8080")
        httpd.serve_forever()

