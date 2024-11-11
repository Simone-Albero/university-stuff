import cv2 as cv
from image.image import Image

class VideoReader:
    def __init__(self, path: str) -> None:
        self.path = path
        self.video = cv.VideoCapture(self.path)
        if not self.video.isOpened():
            raise ValueError(f"Unable to open video file: {self.path}")

    def next_frame(self) -> Image:
        success, frame = self.video.read()
        if not success:
            return None
        return Image(frame)

    def close(self):
        self.video.release()