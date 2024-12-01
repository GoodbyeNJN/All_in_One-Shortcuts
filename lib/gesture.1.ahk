F3:: {
    state.gesture := Board()
    state.gesture.show()
    state.gesture.line(100, 200, 500, 400)
}

F4:: {
    state.gesture.hide()
}

; #HotIf !WinActive("ahk_group myGroup")
; RButton:: {
;     state.gui.show()

;     local x1 := 0
;     local y1 := 0
;     MouseGetPos(&x1, &y1)

;     local gesture := ""
;     local direction := ""	; "u"/"d"/"l"/"r"
;     local lastDirection := ""

;     local array := []

;     while (GetKeyState("RButton", "P")) {
;         Sleep(5)

;         local x2 := 0
;         local y2 := 0
;         MouseGetPos(&x2, &y2)

;         local i := array.Length

;         loop (i > 10 ? 10 : i) {
;             local d := getDirection(array[i].x1, array[i].y2, x2, y2)
;             i -= 1

;             if (d != "invalid") {
;                 if (d != "none") {
;                     direction := d
;                 }

;                 break
;             }
;         }

;         if (direction != lastDirection) {
;             gesture .= direction
;             lastDirection := direction
;         }

;         if (x1 != x2 || y1 != y2) {
;             array.Push({ x1: x1, y1: y1, x2: x2, y2: y2 })
;             x1 := x2
;             y1 := y2
;             ToolTip("手势: " . gesture)
;         }

;         for (k, v in array) {
;             state.gui.line(v.x1, v.y1, v.x2, v.y2)
;         }
;     }

;     ToolTip()
;     state.gui.clear()
;     state.gui.hide()

;     if (gesture == "") {
;         Click("Right")
;     }
; }
; #HotIf

getDirection(x1, y1, x2, y2) {
    local dx := x2 - x1
    local dy := y2 - y1
    local direction := "none"

    ; 移动距离小于5，视为未移动
    if (Abs(dx) < 5 && Abs(dy) < 5) {
        return "invalid"
    }

    ; 移动距离小于50，视为未触发手势
    ; if (Abs(dx) < 50 && Abs(dy) < 50) {
    ;     return "none"
    ; }

    local angle := dx == 0
        ? 90
        : Round(ATan(Abs(dy / dx)) / (ATan(1) / 45), 1)

    angle := dx >= 0
        ? (dy <= 0 ? angle : 360 - angle)
        : (dy <= 0 ? 180 - angle : 180 + angle)

    if (angle >= 360 - 30 || angle <= 30) {
        direction := "r"
    } else if (angle >= 90 - 30 && angle <= 90 + 30) {
        direction := "u"
    } else if (angle >= 180 - 30 && angle <= 180 + 30) {
        direction := "l"
    } else if (angle >= 270 - 30 && angle <= 270 + 30) {
        direction := "d"
    }

    return direction
}

class GDI {
    hwnd := 0
    dc := 0

    __New(hwnd) {
        this.hwnd := hwnd
        this.dc := DllCall("GetDC", "UPtr", hwnd, "UPtr")
    }

    __Delete() {
        DllCall("ReleaseDC", "UPtr", this.hwnd, "UPtr", this.dc)
    }

    drawPixel(x, y, color := 0x0000ff) {
        x := parseInt(x)
        y := parseInt(y)

        local bgr := parseRgbToBgr(color)

        DllCall("SetPixelV", "UPtr", this.dc, "Int", x, "Int", y, "UInt", bgr)
    }

    drawLine(x1, y1, x2, y2, w := 6, color := 0x0000ff) {
        x1 := parseInt(x1)
        y1 := parseInt(y1)
        x2 := parseInt(x2)
        y2 := parseInt(y2)
        w := parseInt(w)

        local pen := GDI.Pen(color, w)

        ; 保存当前画笔
        local originPen := DllCall("SelectObject", "UPtr", this.dc, "UPtr", pen.handle, "UPtr")

        DllCall(
            "MoveToEx",
            "UPtr", this.dc,
            "Int", x1, "Int", y1,
            "UInt", 0
        )
        DllCall(
            "LineTo",
            "UPtr", this.dc,
            "Int", x2, "Int", y2
        )

        ; 恢复原画笔
        DllCall("SelectObject", "UPtr", this.dc, "UPtr", originPen, "UPtr")
    }

    fillRectangle(x, y, w, h, color := 0x0000ff, borderWidth := 0, borderColor := 0xff0000) {
        x := parseInt(x)
        y := parseInt(y)
        w := parseInt(w)
        h := parseInt(h)

        ; 单像素
        if (w == 1 && h == 1) {
            this.drawPixel(x, y, color)
            return
        }

        local l := x
        local t := y
        local r := x + w
        local b := y + h

        ; 采用border-box模型，计算整体需要缩减的宽度
        local ltShrink := borderWidth ? -Floor(borderWidth / 2) : 0
        local rbShrink := borderWidth ? Ceil(borderWidth / 2) - 1 : 0

        local pen := GDI.Pen(borderWidth ? borderColor : color, borderWidth)
        local brush := GDI.Brush(color)

        ; 保存当前画笔
        local originPen := DllCall("SelectObject", "UPtr", this.dc, "UPtr", pen.handle, "UPtr")
        local originBrush := DllCall("SelectObject", "UPtr", this.dc, "UPtr", brush.handle, "UPtr")

        DllCall(
            "Rectangle",
            "UPtr", this.dc,
            "Int", l - ltShrink, "Int", t - ltShrink,
            "Int", r - rbShrink, "Int", b - rbShrink
        )

        ; 恢复原画笔
        DllCall("SelectObject", "UPtr", this.dc, "UPtr", originPen, "UPtr")
        DllCall("SelectObject", "UPtr", this.dc, "UPtr", originBrush, "UPtr")
    }

    fillEllipse(x, y, w, h, color := 0x0000ff, borderWidth := 0, borderColor := unset) {
        x := parseInt(x)
        y := parseInt(y)
        w := parseInt(w)
        h := parseInt(h)

        ; 单像素
        if (w == 1 && h == 1) {
            this.drawPixel(x, y, color)
            return
        }

        local l := x
        local t := y
        local r := x + w
        local b := y + h

        ; 采用border-box模型，计算整体需要缩减的宽度
        local ltShrink := borderWidth ? -Floor(borderWidth / 2) : 0
        local rbShrink := borderWidth ? Ceil(borderWidth / 2) - 1 : 0

        local pen := GDI.Pen(borderWidth ? borderColor : color, borderWidth)
        local brush := GDI.Brush(color)

        ; 保存当前画笔
        local originPen := DllCall("SelectObject", "UPtr", this.dc, "UPtr", pen.handle, "UPtr")
        local originBrush := DllCall("SelectObject", "UPtr", this.dc, "UPtr", brush.handle, "UPtr")

        DllCall(
            "Ellipse",
            "UPtr", this.dc,
            "Int", l - ltShrink, "Int", t - ltShrink,
            "Int", r - rbShrink, "Int", b - rbShrink
        )

        ; 恢复原画笔
        DllCall("SelectObject", "UPtr", this.dc, "UPtr", originPen, "UPtr")
        DllCall("SelectObject", "UPtr", this.dc, "UPtr", originBrush, "UPtr")
    }

    class Pen {
        handle := 0

        __New(color, w := 1, style := 0) {
            local bgr := parseRgbToBgr(color)

            ; https://docs.microsoft.com/en-us/windows/win32/api/wingdi/nf-wingdi-createpen
            this.handle := DllCall("CreatePen", "Int", style, "Int", w, "UInt", bgr, "UPtr")
        }

        __Delete() {
            DllCall("DeleteObject", "UPtr", this.handle)
        }
    }

    class Brush {
        handle := 0

        __New(color) {
            local bgr := parseRgbToBgr(color)

            ; https://docs.microsoft.com/en-us/windows/win32/api/wingdi/nf-wingdi-createsolidbrush
            this.handle := DllCall("CreateSolidBrush", "UInt", bgr, "UPtr")
        }

        __Delete() {
            DllCall("DeleteObject", "UPtr", this.handle)
        }
    }
}

class Board {
    static backgroundColor := 0x000000
    static getMonitorCoord() {
        local x := 0
        local y := 0
        CoordMode("Mouse", "Screen")
        MouseGetPos(&x, &y)

        local l := 0
        local t := 0
        local r := 0
        local b := 0
        MonitorGet(getMonitorIndexByPos(x, y), &l, &t, &r, &b)

        local w := Abs(r - l)
        local h := Abs(b - t)

        return { l: l, t: t, w: w, h: h }
    }

    gui := ""
    gdi := ""

    __New() {
        this.gui := Gui("+AlwaysOnTop -Caption +LastFound +ToolWindow")
        ; 使窗口可见部分透明
        this.gui.BackColor := Board.backgroundColor
        WinSetTransColor(Board.backgroundColor, this.gui)

        this.gui.Show("Hide")
        this.gdi := GDI(this.gui.Hwnd)
    }

    __Delete() {
        this.gdi := ""
        this.gui.Destroy()
    }

    Hwnd => this.gui.Hwnd

    show() {
        local coord := Board.getMonitorCoord()
        this.gui.Show(Format("NA X{1} Y{2} W{3} H{4}", coord.l, coord.t, coord.w, coord.h))
    }

    hide() {
        this.gui.Hide()
    }

    line(x1, y1, x2, y2, w := 6, color := 0x0000ff) {
        this.gdi.drawLine(x1, y1, x2, y2, w, color)
    }

    clear() {
        local coord := Board.getMonitorCoord()
        this.gdi.fillRectangle(0, 0, coord.w, coord.h, Board.backgroundColor)
    }
}
