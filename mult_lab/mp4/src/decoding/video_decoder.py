from decoding.decoding import Decoder
from decoding.receiver import Receiver

class VideoDecoder:
    def __init__(self, print_frames = False) -> None:
        self.decoder = Decoder()
        self.frame_counter = 0
        self.print_frames = print_frames
        self.receiver = Receiver(self.process_frame)

    def process_frame(self, data) -> bool:
        if data:
            error, motion, frame_type = data
            print("Decoding frame number:", self.frame_counter)
            self.frame_counter += 1
            if frame_type == "I":
                frame = self.decoder.decode_intra_frame(error)
            if frame_type == "P":
                frame = self.decoder.decode_predicted_frame(error, motion)
            if frame_type == "B":
                frame = self.decoder.decode_bidirectional_frame(error, motion)
            if self.print_frames:
                frame.print()