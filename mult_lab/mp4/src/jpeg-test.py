import cv2
from image.image import Image
from image.jpeg import Jpeg
import pickle
from image.compresser import Compresser

image = cv2.imread('peppers.jpeg', cv2.IMREAD_COLOR)
image = cv2.cvtColor(image, cv2.COLOR_BGR2RGB)

width = image.shape[0]
height = image.shape[1]
channels = image.shape[2]

total_bytes = width * height * channels

image = Image(image)

jpeg = Jpeg(image)

show_image = False
if show_image:
    image = jpeg.decode()
    image.print(False)

serialized = pickle.dumps(jpeg)
compresser = Compresser()
serialized_compressed = compresser.compress(serialized)

print(f"Raw image size: {total_bytes} bytes.")
print(f"Compressed image size: {len(serialized_compressed)} bytes.")
print(f"Compression ratio: {total_bytes/len(serialized_compressed):.2f}")

import numpy as np
rgb = np.stack(jpeg.decode().get_color_spaces("RGB"), axis=2)
# clip rgb such that it ranges from 0 to 255
rgb = np.clip(rgb, 0, 255)
rgb = np.uint8(rgb)
cv2.imwrite("compressed.jpeg", cv2.cvtColor(rgb, cv2.COLOR_RGB2BGR))