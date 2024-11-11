from decoding.video_decoder import VideoDecoder
from encoding.video_encoder import VideoEncoder
import multiprocessing

def encode():
    encoder = VideoEncoder("super_fast_test.mp4")
    print("Encoding started...")
    while encoder.send_next_frame():
        pass
    encoder.close()
    print("Encoding finished.")

def decode():
    VideoDecoder()
    print("Decoding finished.")

if __name__ == "__main__":
    try:
        encoder_process = multiprocessing.Process(target=encode)
        decoder_process = multiprocessing.Process(target=decode)

        encoder_process.start()
        decoder_process.start()

        decoder_process.join()
        encoder_process.join()
        
    except KeyboardInterrupt as e:
        print("Exiting...")
        encoder_process.terminate()
        decoder_process.terminate()
