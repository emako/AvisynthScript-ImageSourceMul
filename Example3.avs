Import("ImageSourceMul.avsi")
LoadPlugin("LSMASHSource.dll")
LWLibavAudioSource("bgm.mp3")
ImageSourceSingle("pic.jpg", fps=1)