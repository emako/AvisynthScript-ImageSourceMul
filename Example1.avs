Import("ImageSourceMul.avsi")
ImageSourceMul("pic(*).jpg", 1, 10, 30, fps=15) # Load the picture from "bomb (1).jpg" to "bomb (10).jpg", and each picture has a length of 30 frames (fps = 15).
ConvertToYV12()