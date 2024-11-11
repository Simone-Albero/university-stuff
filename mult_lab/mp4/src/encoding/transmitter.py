import socket
import pickle
import struct
from image.compresser import Compresser

class Transmitter:
    def __init__(self):
        self.total_sent = 0
        self.compresser = Compresser()
        self.client_socket = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
        self.client_socket.connect(('localhost', 9999))
    
    def send(self, obj: any) -> None:
        try:
            serialized = pickle.dumps(obj)
            serialized_compressed = self.compresser.compress(serialized)
            compression_ratio = self.compresser.compute_compression_ratio(serialized, serialized_compressed)
            print(f"VLC compression ratio: {compression_ratio:.2f}")
            self.total_sent += len(serialized_compressed)
            message = struct.pack("Q", len(serialized_compressed)) + serialized_compressed
            self.client_socket.sendall(message)
            print(f"Sent {len(serialized_compressed)} bytes")
            print(f"Total sent: {self.total_sent} bytes.")
        except (socket.error, pickle.PicklingError) as e:
            raise ConnectionError("Failed to send data") from e
    
    def close(self) -> None:
        if self.client_socket:
            print("Closing transmitter connection...")
            try:
                self.client_socket.close()
                print("Connection closed.")
            except socket.error as e:
                raise ConnectionError("Failed to close the connection.") from e