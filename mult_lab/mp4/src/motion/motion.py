import numpy as np
from image.image import Image
import concurrent.futures

class MotionVectors:
    def __init__(self, height: int = None, width: int = None, vectors: any = None) -> None:
        if vectors is not None:
            self.motion_vectors = vectors
        else:
            self.motion_vectors = np.zeros((height, width, 2), dtype=int)

    def set_vector(self, block_x: int, block_y: int, x_value: int, y_value: int) -> None:
        self.motion_vectors[block_x, block_y] = [x_value, y_value]

    def get_vector(self, block_x: int, block_y: int) -> np.ndarray:
        return self.motion_vectors[block_x, block_y]
    
    def __add__(self, other: 'MotionVectors') -> 'MotionVectors':
        if self.motion_vectors.shape != other.motion_vectors.shape:
            raise ValueError("Motion Vectors must have the same shape.")
        summed_vectors = self.motion_vectors + other.motion_vectors
        return MotionVectors(vectors=summed_vectors)
    
    def __sub__(self, other: 'MotionVectors') -> 'MotionVectors':
        if self.motion_vectors.shape != other.motion_vectors.shape:
            raise ValueError("Motion Vectors must have the same shape.")
        subtracted_vectors = self.motion_vectors - other.motion_vectors
        return MotionVectors(vectors=subtracted_vectors)

    def __mul__(self, scalar: float) -> 'MotionVectors':
        multiplied_vectors = self.motion_vectors * scalar
        return MotionVectors(vectors=multiplied_vectors)

    def __truediv__(self, scalar: float) -> 'MotionVectors':
        if scalar == 0:
            raise ValueError("Division by zero is not allowed.")
        divided_vectors = self.motion_vectors // scalar
        return MotionVectors(vectors=divided_vectors)

def _process_block_row(i, prev_Y, next_Y, height, width, block_size, window_size):
    motion_vectors_row = []
    for j in range(0, width, block_size):
        current_block = next_Y[i:i + block_size, j:j + block_size]

        x_start = max(0, i - window_size)
        y_start = max(0, j - window_size)
        x_end = min(height - block_size, i + window_size)
        y_end = min(width - block_size, j + window_size)

        min_sad = float('inf')
        best_match = (0, 0)
        for x in range(x_start, x_end + 1):
            for y in range(y_start, y_end + 1):
                candidate_block = prev_Y[x:x + block_size, y:y + block_size]
                sad = np.sum(np.abs(current_block - candidate_block))
                if sad < min_sad:
                    min_sad = sad
                    best_match = (x - i, y - j)
        motion_vectors_row.append((i // block_size, j // block_size, best_match[0], best_match[1]))
    return motion_vectors_row

def compute_motion_estimation(prev_frame: Image, next_frame: Image, block_size: int, window_size: int) -> MotionVectors:
    prev_Y = prev_frame.get_color_spaces("YCbCr")[0]
    next_Y = next_frame.get_color_spaces("YCbCr")[0]
    height, width = prev_Y.shape
    motion_vectors = MotionVectors(height = height // block_size, width = width // block_size)
    with concurrent.futures.ProcessPoolExecutor() as executor:
        futures = [executor.submit(_process_block_row, i, prev_Y, next_Y, height, width, block_size, window_size)
                   for i in range(0, height, block_size)]
        for future in concurrent.futures.as_completed(futures):
            motion_vectors_row = future.result()
            for mv in motion_vectors_row:
                motion_vectors.set_vector(mv[0], mv[1], mv[2], mv[3])
    return motion_vectors

def compute_motion_compensation(prev_frame: Image, motion_vectors: MotionVectors, block_size: int) -> Image:
    prev_Y, prev_Cb, prev_Cr = prev_frame.get_color_spaces("YCbCr")
    compensated_Y = np.zeros_like(prev_Y)

    vec_height, vec_width = motion_vectors.motion_vectors.shape[:2]
    for i in range(vec_height):
        for j in range(vec_width):
            mv_x, mv_y = motion_vectors.get_vector(i, j)
            block_x, block_y = i * block_size, j * block_size
            ref_x, ref_y = block_x + mv_x, block_y + mv_y

            compensated_Y[block_x:block_x + block_size, block_y:block_y + block_size] = prev_Y[ref_x:ref_x + block_size, ref_y:ref_y + block_size]
    image_YCbCr = np.stack((compensated_Y, prev_Cb, prev_Cr), axis=-1)
    return Image(image_YCbCr, "YCbCr")