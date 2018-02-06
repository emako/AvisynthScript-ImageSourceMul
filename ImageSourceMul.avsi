#############################################
# Version : v0.1 (2017.07.15)
# Designer : ema
# Bug : http://weibo.com/egosub
#############################################
# 
# Equipment : GScript.dll
# 
#############################################

function ImageSourceMul(string path, int start, int end, int every, float "fps", bool "blank", int "w", int "h", int "color", bool "dslv", int "dslv_f")
{
    fps = Default(fps, 29.970)
    blank = Default(blank, True)
    w = Default(w, 1280)
    h = Default(h, 720)
    color = Default(color, $000000)
    dslv = Default(dslv, True)
    dslv_f = Default(dslv_f, (Floor(every/2.5) < Floor(fps/2.5)) ? Floor(every/2.5) : Floor(fps/2.5))
    every = every + ((dslv) ? Ceil(dslv_f/2) : 0)
    pos = FindStr(path, "*")
    path_prev = LeftStr(path, pos - 1)
    path_next = RightStr(path, StrLen(path) - pos)
    src = ImageSource(path_prev + String(start) + path_next, fps=fps, start=0, end=every)
    video = (blank) ? src.OverlayM(w, h, color=color) : src
    i = start + 1
    GScript("""
        while ( i <= end ) {
            path_full = path_prev + String(i) + path_next
            read_source = ImageSource(path_full, fps=fps, start=0, end=every)
            read_source = (blank) ? read_source.OverlayM(w, h, color=color) : read_source
            video = (dslv) ? Dissolve(video, read_source, dslv_f) : AlignedSplice(video, read_source)
            i = i + 1
        }
    """)
    return video
}

#############################################
###     Comment :
###     Resize Target
###     src_w : src_h = w_target : h
###     src_w : src_h = w : h_target
#############################################
function OverlayM(clip src, int w, int h, int "color", bool "showa")
{
    showa = Default(showa, False)
    color = Default(color, $000000)
    blank = BlankClip(length=src.FrameCount(), fps=src.FrameRate(), width=w, height=h, color=color).KillAudio()
    src_w = src.Width()
    src_h = src.Height()
    src_sar = src_w / src_h
    sar = w / h
    isRW = (src_sar > sar) ? True : False
    w_target = (isRW) ? w : (Round(src_w * h / src_h))
    h_target = (isRW) ? (Round(src_h * w / src_w)) : h
    src = src.LanczosResize(w_target, h_target)
    src = (showa) ? src.ShowAlpha() : src
    x = (isRW) ? 0 : (w / 2 - w_target / 2)
    y = (isRW) ? (h / 2 - h_target / 2) : 0
    return Overlay(blank, src, x=x, y=y)
}

function AudioTrimDub(clip video, clip audio)
{ 
    audio = audio.AudioTrim(0, (video.FrameCount() / video.FrameRate()) ).FadeOut(Ceil(video.FrameRate()), fps=video.FrameRate())
    return AudioDub(video, audio)
}

function ImageSourceSingle(clip src, string si, float "fps", bool "mux")
{
    mux = Default(mux, True)
    fps = Default(fps, 24)
    src = src.KillVideo()
    clp = ImageSource(si, start=0, end=Ceil(src.AudioLengthF()/src.AudioRate()*fps), fps=fps, pixel_type="RGB32")
    return (mux == True) ? AudioDub(clp, src) : clp
}