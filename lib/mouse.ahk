; 判断当前鼠标相对于屏幕的坐标是否匹配传入的坐标
; 不传X时仅判断Y是否匹配，Y同理
isMouseAtPos(x := unset, y := unset) {
    local mouseX := 0
    local mouseY := 0
    CoordMode("Mouse", "Screen")
    MouseGetPos(&mouseX, &mouseY)	; 获取鼠标相对于屏幕的坐标

    if (!IsSet(x)) {
        return y == mouseY
    } else if (!IsSet(y)) {
        return x == mouseX
    } else {
        return x == mouseX && y == mouseY
    }
}

; 滚轮在屏幕右上角滚动调节音量
#HotIf isMouseAtPos(A_ScreenWidth - 1, 0)
MButton:: Volume_Mute
WheelUp:: Volume_Up
WheelDown:: Volume_Down
#HotIf

; 滚轮在屏幕下边缘切换虚拟桌面
#HotIf isMouseAtPos(, A_ScreenHeight - 1)
WheelUp:: Send("^#{Left}")
WheelDown:: Send("^#{Right}")
#HotIf

; 在屏幕下边缘按下滚轮调出虚拟桌面管理
#HotIf isMouseAtPos(, A_ScreenHeight - 1)
MButton:: Send("#{Tab}")
#HotIf

; 在屏幕右边缘按下前进键发送Ctrl + Alt +z，后退键发送Ctrl + Alt +w
#HotIf isMouseAtPos(A_ScreenWidth - 1)
XButton2:: Send("^!z")
XButton1:: Send("^!w")
#HotIf
