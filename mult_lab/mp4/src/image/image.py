import numpy as np
import matplotlib.pyplot as plt

def RGB_to_YCbCr(image: np.ndarray) -> np.ndarray:
    transform_matrix = np.array([[0.299, 0.587, 0.114],
                                 [-0.168736, -0.331264, 0.5],
                                 [0.5, -0.418688, -0.081312]])
    offset = np.array([0, 128, 128])
    ycbcr_image = image @ transform_matrix.T + offset
    return np.int32(ycbcr_image)

def YCbCr_to_RGB(image: np.ndarray) -> np.ndarray:
    transform_matrix = np.array([[1.0, 0.0, 1.402],
                                 [1.0, -0.344136, -0.714136],
                                 [1.0, 1.772, 0.0]])
    offset = np.array([0, 128, 128])
    rgb_image = (image - offset) @ transform_matrix.T
    return np.int32(rgb_image)

class Image:
    COLOR_CONVERSIONS = {
        "RGB": {
            "YCbCr": RGB_to_YCbCr
        },
        "YCbCr": {
            "RGB": YCbCr_to_RGB
        }
    }

    def __init__(self, image: np.ndarray, color_space: str = "RGB") -> None:
        if color_space not in Image.COLOR_CONVERSIONS:
            raise ValueError(f"Unsupported color space: {color_space}")
        self.image = np.int32(image)
        self.color_space = color_space

    def get_color_spaces(self, target_space: str) -> tuple[np.ndarray, np.ndarray, np.ndarray]:
        if self.color_space == target_space:
            return self.image[:, :, 0], self.image[:, :, 1], self.image[:, :, 2]
        if target_space not in Image.COLOR_CONVERSIONS[self.color_space]:
            raise ValueError(f"Cannot convert from {self.color_space} to {target_space}")
        image = Image.COLOR_CONVERSIONS[self.color_space][target_space](self.image)
        return image[:, :, 0], image[:, :, 1], image[:, :, 2]

    def switch_color_space(self, target_space: str) -> None:
        if self.color_space == target_space:
            return
        if target_space not in Image.COLOR_CONVERSIONS[self.color_space]:
            raise ValueError(f"Cannot convert from {self.color_space} to {target_space}")
        if self.color_space != target_space:
            self.image = Image.COLOR_CONVERSIONS[self.color_space][target_space](self.image)
            self.color_space = target_space
    
    def print(self, close_on_key_press = True) -> None:
        rgb = np.stack(self.get_color_spaces("RGB"), axis=-1)
        rgb = np.clip(rgb, 0, 255).astype(np.uint8)
        def on_key(_):
            print(f"Key pressed, closing frame plot.")
            plt.close()
        fig, ax = plt.subplots()
        ax.imshow(rgb)
        ax.axis('off')
        if close_on_key_press:
            fig.canvas.mpl_connect('key_press_event', on_key)
        plt.show()

    def __add__(self, other: 'Image') -> 'Image':
        if self.color_space != other.color_space:
            raise ValueError("Images must have the same color space.")

        summed_image = self.image + other.image
        return Image(summed_image, color_space=self.color_space)
    
    def __sub__(self, other: 'Image') -> 'Image':
        if self.color_space != other.color_space:
            raise ValueError("Images must have the same color space.")

        subtracted_image = self.image - other.image
        return Image(subtracted_image, color_space=self.color_space)