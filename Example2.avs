LoadPlugin("ffms2.dll")
Import("ImageSourceMul.avsi")
audio=FFAudioSource("bgm.mp3")
video=ImageSourceMul("pic(*).jpg", 1, 19, 60) # Load the picture from "bomb (1).jpg" to "bomb (19).jpg", and each picture has a length of 60 frames.
AudioTrimDub(video, audio)  # AudioTrim audio based on video length and AudioDub them.
ConvertToYV12()