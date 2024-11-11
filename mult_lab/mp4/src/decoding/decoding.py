from image.image import Image
from image.jpeg import Jpeg
from motion.motion import MotionVectors, compute_motion_compensation

class Decoder:
    def __init__(self, block_size: int = 16) -> None:
        self.last_key_frame = None
        self.block_size = block_size

    def decode_intra_frame(self, frame: Jpeg) -> Image:
        print("Decoding intra frame...")
        decoded_frame = frame.decode()
        self.last_key_frame = decoded_frame
        return decoded_frame

    def decode_predicted_frame(self, err_frame: Jpeg, mvs: MotionVectors) -> Image:
        print("Decoding predicted frame...")
        err = err_frame.decode()
        mc = compute_motion_compensation(self.last_key_frame, mvs, self.block_size)
        mc.switch_color_space("RGB")
        decoded_frame = err + mc
        self.last_key_frame = decoded_frame
        return decoded_frame

    def decode_bidirectional_frame(self, err_frame: Jpeg, mvs: MotionVectors) -> Image:
        print("Decoding bidirectional frame...")
        err = err_frame.decode()
        mc = compute_motion_compensation(self.last_key_frame, mvs, self.block_size)
        mc.switch_color_space("RGB")
        decoded_frame = err + mc
        return decoded_frame