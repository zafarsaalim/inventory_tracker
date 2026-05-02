import threading
from app import app
import time
import webbrowser

def run_server():
    app.run(host="127.0.0.1", port=5000)

if __name__ == "__main__":
    threading.Thread(target=run_server).start()
    
    time.sleep(2)  # wait for server
    
    webbrowser.open("http://127.0.0.1:5000")
