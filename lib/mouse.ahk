; 判断当前鼠标是否在当前屏幕的边缘
isMouseAtEdges(edges := unset) {
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

; 滚轮在屏幕下边缘切换虚拟桌面
#HotIf isMouseAtEdges(['b'])
WheelUp:: Send("^#{Left}")
WheelDown:: Send("^#{Right}")
#HotIf

; 在屏幕下边缘按下滚轮调出虚拟桌面管理
#HotIf isMouseAtEdges(['b'])
MButton:: Send("#{Tab}")
#HotIf

; 在屏幕右边缘按下前进键发送Ctrl + Alt +z，后退键发送Ctrl + Alt +w
#HotIf isMouseAtEdges(['r'])
XButton2:: {
    ; static title := "ahk_class TXGuiFoundation"
    static title := "ahk_exe QQ.exe"

    local isWindowShow := WinActive(title)

    Send("^!{Numpad1}")

    if (isWindowShow || !WinWait(title)) {
        return
    }

    local mouseIndex := Monitor.getIndexByPos(getMousePos())
    local windowIndex := Monitor.getIndexByWindow(title)

    ; if (WinActive("QQ " . title)) {
    ;     local rect := getWindowRect(title)
    ;     local border := Monitor.getWorkAreaRectByIndex(mouseIndex)

    ;     local x := border.r - rect.w - 50
    ;     local y := border.t + 50

    ;     WinMove(x, y, , , "QQ " . title)
    ; } else if (mouseIndex != windowIndex) {
    ;     moveToCenter(title, mouseIndex)
    ; }
    if (mouseIndex != windowIndex) {
        moveToCenter(title, mouseIndex)
    }
}

XButton1:: {
    static title := "ahk_class WeChatMainWndForPC"

    local isWindowShow := WinActive(title)

    Send("^{F18}")

    if (isWindowShow || !WinWait(title)) {
        return
    }

    local mouseIndex := Monitor.getIndexByPos(getMousePos())
    local windowIndex := Monitor.getIndexByWindow(title)

    if (mouseIndex != windowIndex) {
        moveToCenter(title, mouseIndex)
    }
}
#HotIf
