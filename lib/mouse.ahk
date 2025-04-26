; 判断当前鼠标是否在当前屏幕的边缘
isMouseAtEdges(edges?) {
    if (!IsSet(edges)) {
        edges := []
    }

    local pos := getMousePos()
    local rect := Monitor.getRectByIndex(Monitor.getIndexByPos(pos))

    local booleans := []
    for (v in edges) {
        switch (v) {
            case "l":
                booleans.push(pos.x == rect.l)
            case "t":
                booleans.push(pos.y == rect.t)
            case "r":
                booleans.push(pos.x == rect.r - 1)
            case "b":
                booleans.push(pos.y == rect.b - 1)
        }
    }

    if (booleans.length == 0) {
        return false
    } else {
        local res := true
        for (v in booleans) {
            res := res && v
        }
        return res
    }
}

; 滚轮在屏幕右上角滚动调节音量
#HotIf isMouseAtEdges(['t', 'r'])
MButton::Volume_Mute
WheelUp::Volume_Up
WheelDown::Volume_Down
#HotIf

; 在屏幕右边缘按下前进键发送Ctrl + Alt +z，后退键发送Ctrl + Alt +w
#HotIf isMouseAtEdges(['r'])
XButton2:: Send("{F19}")

XButton1:: Send("^{F19}")
#HotIf
