class Gesture {
    bitmap := 0
    graphics := 0

    ; __New() {
    ;     local rect := Monitor.getRectByIndex(Monitor.getIndexByPos(getMousePos()))

    ;     this.bitmap := HBitmap(rect.w, rect.h)
    ;     this.graphics := Graphics(this.bitmap)

    ;     b := Brush(0x01000000)
    ;     g.drawSolidRectangle(b, { x: rect.x, y: rect.y, w: rect.w, h: rect.h })
    ;     b := ""

    ;     p := Pen()
    ;     ; Graphics.drawLine(g, p, { x: 100, y: 100, w: 200, h: 200 })
    ;     g.drawArrow(p, { x1: 500, y1: 500, x2: 500, y2: 400 })
    ;     p := ""

    ;     state.gesture := Gui("+AlwaysOnTop -Caption +LastFound +OwnDialogs +ToolWindow +E0x80000")
    ;     state.gesture.Show("NA")

    ;     g.update(state.gesture.Hwnd, { x: 0, y: 0, w: rect.w, h: rect.h })
    ; }

    ; __Delete() {
    ;     local coord := Monitor.getRectByIndex(Monitor.getIndexByPos(getMousePos()))

    ;     g.clear()
    ;     g.update(state.gesture.Hwnd, { x: 0, y: 0, w: coord.w, h: coord.h })

    ;     g.unbindBitmap()
    ;     hb := ""
    ;     g := ""
    ; }
}

class GDIP {
    static startup() {
        local token := 0
        local input := Buffer(16, 0)
        NumPut("UInt", 1, input, 0)

        DllCall(
            "gdiplus\GdiplusStartup",
            "Ptr*", &token,
            "Ptr", input,
            "Ptr", 0
        )

        return token
    }

    static shutdown(token) {
        DllCall("gdiplus\GdiplusShutdown", "Ptr", token)
    }

    static createDeviceDc(device) {
        return DllCall("CreateDC", "Ptr", 0, "Str", device, "Ptr", 0, "Ptr", 0)
    }

    static createCompatibleDc(dc := 0) {
        return DllCall("CreateCompatibleDC", "Ptr", dc)
    }

    static deleteDc(dc) {
        return DllCall("DeleteDC", "Ptr", dc)
    }

    static bitBlt(sourceDc, sourcePos, targetDc, targetRect, raster := 0x00CC0020) {
        ;   SRCCOPY			= 0x00CC0020
        ;   BLACKNESS		= 0x00000042
        ;   NOTSRCERASE		= 0x001100A6
        ;   NOTSRCCOPY		= 0x00330008
        ;   SRCERASE		= 0x00440328
        ;   DSTINVERT		= 0x00550009
        ;   PATINVERT		= 0x005A0049
        ;   SRCINVERT		= 0x00660046
        ;   SRCAND			= 0x008800C6
        ;   MERGEPAINT		= 0x00BB0226
        ;   MERGECOPY		= 0x00C000CA
        ;   SRCPAINT		= 0x00EE0086
        ;   PATCOPY			= 0x00F00021
        ;   PATPAINT		= 0x00FB0A09
        ;   WHITENESS		= 0x00FF0062
        ;   CAPTUREBLT		= 0x40000000
        ;   NOMIRRORBITMAP	= 0x80000000
        return DllCall(
            "gdi32\BitBlt",
            "Ptr", targetDc,
            "Int", targetRect.x, "Int", targetRect.y, "Int", targetRect.w, "Int", targetRect.h,
            "Ptr", sourceDc,
            "Int", sourcePos.x, "Int", sourcePos.y,
            "Uint", raster
        )
    }

    static selectObject(dc, obj) {
        return DllCall("SelectObject", "Ptr", dc, "Ptr", obj)
    }

    static deleteObject(obj) {
        return DllCall("DeleteObject", "Ptr", obj)
    }

    static __New() {
        this.token := GDIP.startup()
        return this.token
    }

    token := ""

    __New() {
        this.token := GDIP.startup()
        return this.token
    }

    __Delete() {
        GDIP.shutdown(this.token)
    }
}

class Bitmap extends GDIP {
    static createBitmapFromFile(path) {
        local bitmap := 0

        DllCall("gdiplus\GdipCreateBitmapFromFile", "Str", path, "Ptr*", &bitmap)

        return bitmap
    }

    static disposeImage(img) {
        DllCall("gdiplus\GdipDisposeImage", "Ptr", img)
    }

    ptr := 0

    __New(path) {
        this.ptr := Bitmap.createBitmapFromFile(path)
        return this.ptr
    }

    __Delete() {
        Bitmap.disposeImage(this)
    }
}

class HBitmap extends GDIP {
    static createDibSection(w, h) {
        local dc := DllCall("GetDC", "Ptr", 0)

        local bitmapInfo := Buffer(40)
        NumPut("UInt", 40, bitmapInfo, 0)
        NumPut("UInt", w, bitmapInfo, 4)
        NumPut("UInt", h, bitmapInfo, 8)
        NumPut("UShort", 1, bitmapInfo, 12)
        NumPut("UShort", 32, bitmapInfo, 14)
        NumPut("UInt", 0, bitmapInfo, 16)

        local ppvBits := 0

        local bitmap := DllCall(
            "CreateDIBSection",
            "Ptr", dc,
            "Ptr", bitmapInfo,
            "UInt", 0,
            "Ptr*", &ppvBits,
            "Ptr", 0,
            "UInt", 0,
            "Ptr"
        )

        DllCall("ReleaseDC", "Ptr", 0, "Ptr", dc)

        return bitmap
    }

    ptr := 0

    __New(w, h) {
        this.ptr := HBitmap.createDibSection(w, h)
        return this.ptr
    }

    __Delete() {
        GDIP.deleteObject(this)
    }
}

class Graphics extends GDIP {
    static setSmoothMode(graphics, mode) {
        /**
         * Default = 0
         * HighSpeed = 1
         * HighQuality = 2
         * None = 3
         * AntiAlias = 4
         */
        return DllCall("gdiplus\GdipSetSmoothingMode", "Ptr", graphics, "Int", mode)
    }

    static createGraphicsByDc(dc) {
        local graphics := 0

        DllCall("gdiplus\GdipCreateFromHDC", "Ptr", dc, "Ptr*", &graphics)

        return graphics
    }

    static createGraphicsByHwnd(hwnd) {
        local graphics := 0

        local status := DllCall("gdiplus\GdipCreateFromHWND", "Ptr", hwnd, "Ptr*", &graphics)
        console.log("status:", status)

        return graphics
    }

    static clearGraphics(graphics, argb := 0x00000000) {
        return DllCall("gdiplus\GdipGraphicsClear", "Ptr", graphics, "UInt", argb)
    }

    static deleteGraphics(graphics) {
        return DllCall("gdiplus\GdipDeleteGraphics", "Ptr", graphics)
    }

    static drawLine(graphics, pen, point) {
        return DllCall(
            "gdiplus\GdipDrawLine",
            "Ptr", graphics,
            "Ptr", pen,
            "Float", point.x1, "Float", point.y1,
            "Float", point.x2, "Float", point.y2
        )
    }

    static drawLines(graphics, pen, points) {
        local point := Buffer(8 * points.length)

        for (i, v in points) {
            local offset := (i - 1) * 8
            NumPut("Float", v.x, point, offset)
            NumPut("Float", v.y, point, offset + 4)
        }

        return DllCall(
            "gdiplus\GdipDrawLines",
            "Ptr", graphics,
            "Ptr", pen,
            "Ptr", point,
            "Int", points.length
        )
    }

    static fillRectangle(graphics, brush, x, y, w, h) {
        return DllCall(
            "gdiplus\GdipFillRectangle",
            "Ptr", graphics,
            "Ptr", brush,
            "Float", x, "Float", y,
            "Float", w, "Float", h
        )
    }

    static drawRectangle(graphics, pen, x, y, w, h) {
        return DllCall(
            "gdiplus\GdipDrawRectangle",
            "Ptr", graphics,
            "Ptr", pen,
            "Float", x, "Float", y,
            "Float", w, "Float", h
        )
    }

    static fillEllipse(graphics, brush, x, y, w, h) {
        return DllCall(
            "gdiplus\GdipFillEllipse",
            "Ptr", graphics,
            "Ptr", brush,
            "Float", x, "Float", y,
            "Float", w, "Float", h
        )
    }

    static drawEllipse(graphics, pen, x, y, w, h) {
        return DllCall(
            "gdiplus\GdipDrawEllipse",
            "Ptr", graphics,
            "Ptr", pen,
            "Float", x, "Float", y,
            "Float", w, "Float", h
        )
    }

    static updateLayeredWindow(hwnd, dc, x, y, w, h, alpha) {
        local point := Buffer(8)
        NumPut("UInt", x, point, 0)
        NumPut("UInt", y, point, 4)

        return DllCall(
            "UpdateLayeredWindow",
            "Ptr", hwnd,
            "Ptr", 0,
            "Ptr", point,
            "Int64*", w | (h << 32),
            "Ptr", dc,
            "Int64*", 0,
            "UInt", 0,
            "UInt*", (alpha << 16) | (1 << 24),
            "UInt", 2
        )
    }

    ptr := 0
    deviceDc := 0
    compatibleDc := 0
    obj := 0

    __New(bitmap, device, hwnd) {
        this.deviceDc := GDIP.createDeviceDc(device)
        this.compatibleDc := GDIP.createCompatibleDc(this.deviceDc)
        this.bindBitmap(bitmap)
        ; this.ptr := Graphics.createGraphicsByDc(this.compatibleDc)
        this.ptr := Graphics.createGraphicsByHwnd(hwnd)
        this.setSmoothMode(4)
        return this.ptr
    }

    __Delete() {
        if (this.deviceDc) {
            GDIP.deleteDc(this.deviceDc)
        }

        GDIP.deleteDc(this.compatibleDc)
        Graphics.deleteGraphics(this)
    }

    bindBitmap(bitmap) {
        this.obj := GDIP.selectObject(this.compatibleDc, bitmap)
    }

    unbindBitmap() {
        GDIP.selectObject(this.compatibleDc, this.obj)
    }

    setSmoothMode(mode) {
        Graphics.setSmoothMode(this, mode)
    }

    drawSolidRectangle(brush, rect) {
        Graphics.fillRectangle(this, brush, rect.x, rect.y, rect.w, rect.h)
    }

    drawHollowRectangle(brush, rect) {
        Graphics.drawRectangle(this, brush, rect.x, rect.y, rect.w, rect.h)
    }

    drawSolidEllipse(brush, rect) {
        Graphics.fillEllipse(this, brush, rect.x, rect.y, rect.w, rect.h)
    }

    drawHollowEllipse(brush, rect) {
        Graphics.drawEllipse(this, brush, rect.x, rect.y, rect.w, rect.h)
    }

    drawSingleLine(pen, point) {
        Graphics.drawLine(this, pen, point)
    }

    drawArrow(pen, rect) {
        local angle := PI / 4    ; 45°
        local scale := 4 / (7 * Cos(angle))

        local x1 := rect.x1
        local y1 := rect.y1
        local x2 := rect.x2
        local y2 := rect.y2

        local dx := x1 - x2
        local dy := y1 - y2

        local x3 := scale * (dx * Cos(angle) - dy * Sin(angle)) + x2
        local y3 := scale * (dy * Cos(angle) + dx * Sin(angle)) + y2
        local x4 := scale * (dx * Cos(angle) + dy * Sin(angle)) + x2
        local y4 := scale * (dy * Cos(angle) - dx * Sin(angle)) + y2

        Graphics.drawLine(this, pen, { x1: x1, y1: y1, x2: x2, y2: y2 })
        Graphics.drawLine(this, pen, { x1: x3, y1: y3, x2: x2, y2: y2 })
        Graphics.drawLine(this, pen, { x1: x4, y1: y4, x2: x2, y2: y2 })
    }

    clear(argb := 0x00000000) {
        Graphics.clearGraphics(this, argb)
    }

    update(hwnd, rect, alpha := 255) {
        Graphics.updateLayeredWindow(hwnd, this.compatibleDc, rect.x, rect.y, rect.w, rect.h, alpha)
        ; GDIP.bitBlt(this.compatibleDc, { x: rect.x, y: rect.y }, this.deviceDc, rect)
    }
}

class Brush extends GDIP {
    static createSolidBrush(argb) {
        local brush := 0

        DllCall("gdiplus\GdipCreateSolidFill", "UInt", argb, "Ptr*", &brush)

        return brush
    }

    static deleteBrush(brush) {
        return DllCall("gdiplus\GdipDeleteBrush", "Ptr", brush)
    }

    ptr := 0

    __New(argb := 0xff0000ff) {
        this.ptr := Brush.createSolidBrush(argb)
        return this.ptr
    }

    __Delete() {
        Brush.deleteBrush(this)
    }
}

class Pen extends GDIP {
    static createPen(argb, w) {
        local pen := 0

        DllCall(
            "gdiplus\GdipCreatePen1",
            "UInt", argb,
            "Float", w,
            "Int", 2,
            "Ptr*", &pen
        )

        return pen
    }

    static deletePen(pen) {
        return DllCall("gdiplus\GdipDeletePen", "Ptr", pen)
    }

    ptr := 0

    __New(argb := 0xff0000ff, w := 6) {
        this.ptr := Pen.createPen(argb, w)
        return this.ptr
    }

    __Delete() {
        Pen.deletePen(this)
    }
}
