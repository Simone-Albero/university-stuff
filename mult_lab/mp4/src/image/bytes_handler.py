class BytesHandler:
    @staticmethod
    def write_bytes(bytes, file_name):
        with open(file_name, 'wb') as file:
            file.write(bytes)

    @staticmethod
    def read_bytes(file_name):
        with open(file_name, 'rb') as file:
            bytes = file.read()
            return bytes