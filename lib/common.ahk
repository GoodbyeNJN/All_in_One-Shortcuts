class Obj {
    static isFunction(value) {
        return IsObject(value) && (value is Func)
    }

    static isArray(value) {
        return IsObject(value) && (value is Array)
    }

    static isMap(value) {
        return IsObject(value) && (value is Map)
    }

    static isObject(value) {
        return !Obj.isFunction(value) && !Obj.isArray(value) && !Obj.isMap(value) && IsObject(value)
    }
}

initState() {
    state.imeSwitch := readConfig("imeSwitch")
    state.username := readEnv("username")
    state.password := readEnv("password")
}

readEnv(key?) {
    local string := FileRead(ENV_FILE_PATH)
    local env := JsonParse(string)

    return IsSet(key) ? env.%key% : env
}

readConfig(key?) {
    local string := FileRead(CONFIG_FILE_PATH)
    local config := JsonParse(string)

    return IsSet(key) ? config.%key% : config
}

writeConfig(value, key?) {
    local config := {}

    if (IsSet(key)) {
        config := readConfig()
        config.%key% := value
    } else {
        config := value
    }

    local string := JsonStringify(config, " ", 4)

    FileDelete(CONFIG_FILE_PATH)
    FileAppend(string, CONFIG_FILE_PATH)
}

isInDebugMode() {
    for (v in A_Args) {
        if (v == "debug") {
            return true
        }
    }

    return false
}

runWithPrivilege() {
    if (A_IsAdmin) {
        return
    }

    local hasRestartSwitch := RegExMatch(DllCall("GetCommandLine", "Str"), " /restart(?!\S)")
    if (hasRestartSwitch) {
        return
    }

    local commandLine := getCommandLineString({ switches: ["restart"] })
    Run("*RunAs " . commandLine)
    ExitApp()
}

runWithoutPrivilege(command, options := "") {
    RunAs(state.username, state.password)
    Run(command, , options)
    RunAs()
}

getSwitchesString(switches) {
    if (!IsSet(switches)) {
        switches := []
    }

    local str := ""

    for (v in switches) {
        if (str != "") {
            str .= " "
        }

        str .= '/' . v
    }

    return str
}

getParamsString(params) {
    local str := ""

    for (v in params) {
        if (str != "") {
            str .= " "
        }

        str .= v
    }

    return str
}

getCommandLineString(args?) {
    if (!IsSet(args)) {
        args := {}
    }

    local ahkPath := args.HasOwnProp("ahkPath") ? args.ahkPath : A_AhkPath
    local switches := args.HasOwnProp("switches") ? args.switches : []
    local filename := args.HasOwnProp("filename") ? args.filename : A_ScriptFullPath
    local params := args.HasOwnProp("params") ? args.params : A_Args

    local commandLine := A_IsCompiled
        ? Format('"{1}" {2} {3}', filename, getSwitchesString(switches), getParamsString(params))    ; CompiledScript.exe [Switches] [Script Parameters]
        : Format('"{1}" {2} "{3}" {4}', ahkPath, getSwitchesString(switches), filename, getParamsString(params))    ; AutoHotkey.exe [Switches] [Script Filename] [Script Parameters]

    return commandLine
}

getCurrentExplorerPath() {
    local hwnd := WinActive("ahk_class CabinetWClass")
    if (!hwnd) {
        return ""
    }

    local com := ComObject("Shell.Application")
    for (window in com.Windows) {
        if (window.hwnd == hwnd) {
            return window.Document.Folder.Self.Path
        }
    }
}

winMoveReal(x?, y?, w?, h?, params*) {
    local rect := getWindowRect(params*)
    local real := getWindowRealRect(params*)

    local xShadowW := real.x - rect.x
    local yShadowH := (rect.h - real.h) / 2

    local newX := IsSet(x) && x - (xShadowW + 1)
    local newY := IsSet(y) && y - 1
    local newW := IsSet(w) && w + (xShadowW + 1) * 2
    local newH := IsSet(h) && h + (yShadowH + 1) * 2

    WinMove(newX, newY, newW, newH, params*)
}

winSize(w?, h?, params*) {
    WinMove(, , w, h, params*)
}

winSizeReal(w?, h?, params*) {
    winMoveReal(, , w, h, params*)
}

goToDesktopNum(num) {
    if (num < 1 || num > VD.getCount() || num == VD.getCurrentDesktopNum()) {
        return
    }

    VD.goToDesktopNum(num)
}

goToRelativeDesktopNum(num) {
    local current := VD.getCurrentDesktopNum()

    if (num < 0) {
        goToDesktopNum(current - 1)
    } else if (num > 0) {
        goToDesktopNum(current + 1)
    }
}

moveToDesktopNum(title := "A", num?) {
    if (!IsSet(num) || num < 1 || num > VD.getCount() || num == VD.getDesktopNumOfWindow(title)) {
        return
    }

    VD.MoveWindowToDesktopNum(title, num)
}

moveToRelativeDesktopNum(title := "A", num?) {
    local current := VD.getDesktopNumOfWindow(title)

    if (num < 0) {
        moveToDesktopNum(title, current - 1)
    } else if (num > 0) {
        moveToDesktopNum(title, current + 1)
    }
}

moveToCenter(title := "A", monitorIndex?) {
    local status := 1

    try {
        status := WinGetMinMax(title)
    }

    if (status != 0) {
        return
    }

    local rect := getWindowRect(title)
    local index := IsSet(monitorIndex) ? monitorIndex : Monitor.getIndexByWindow(title)
    local border := Monitor.getWorkAreaRectByIndex(index)

    local x := (border.r + border.l - rect.w) / 2
    local y := (border.b + border.t - rect.h) / 2
    WinMove(x, y, , , title)
}

moveQuakeModeWindow(title := "A", w?, h?, monitorIndex?) {
    try {
        DetectHiddenWindows(true)

        local status := 1
        try {
            status := WinGetMinMax(title)
        }
        if (status != 0) {
            return
        }

        if (!IsSet(monitorIndex)) {
            monitorIndex := Monitor.getIndexByPos(getMousePos())
        }

        local windowRect := getWindowRect(title)
        local monitorRect := Monitor.getWorkAreaRectByIndex(monitorIndex)
        if (!IsSet(w)) {
            w := windowRect.w
        } else if (Type(w) == "String" && SubStr(w, -1) == "%") {
            w := StrReplace(w, "%", "") / 100 * monitorRect.w
        }
        if (!IsSet(h)) {
            h := windowRect.h
        } else if (Type(h) == "String" && SubStr(h, -1) == "%") {
            h := StrReplace(h, "%", "") / 100 * monitorRect.h
        }

        local x := (monitorRect.r + monitorRect.l - w) / 2
        local y := monitorRect.t
        WinMove(x, y, w, h, title)
    } finally {
        DetectHiddenWindows(false)
    }
}

getWindowRect(title := "A") {
    local x := 0
    local y := 0
    local w := 0
    local h := 0

    try {
        WinGetPos(&x, &y, &w, &h, title)
    }

    return { x: x, y: y, w: w, h: h }
}

getWindowRealRect(title := "A") {
    local x := 0
    local y := 0
    local w := 0
    local h := 0

    local rect := Buffer(16, 0)
    try {
        DllCall("dwmapi\DwmGetWindowAttribute",
            "Ptr", WinExist(title),
            "UInt", DWMWA_EXTENDED_FRAME_BOUNDS,
            "Ptr", rect,
            "UInt", rect.size,
            "UInt")
        x := NumGet(rect, 0, "Int") - x
        y := NumGet(rect, 4, "Int") - y
        w := NumGet(rect, 8, "Int") - x
        h := NumGet(rect, 12, "Int") - y
    } catch {
        return { x: x, y: y, w: w, h: h }
    }

    return { x: x, y: y, w: w, h: h }
}

getWindowShadowDimension(title := "A") {
    local rect := getWindowRect(title)
    local real := getWindowRealRect(title)

    local w := real.x - rect.x
    local h := (rect.h - real.h) / 2

    return { w: w, h: h }
}

getMousePos() {
    local x := 0
    local y := 0
    CoordMode("Mouse", "Screen")
    MouseGetPos(&x, &y)

    return { x: x, y: y }
}

toast(text) {
    static appId := "AutoHotkey.AutoHotkey"
    static TNM := Windows.UI.Notifications.ToastNotificationManager

    TNM.History.Clear appId

    local toastXml := TNM.GetTemplateContent('ToastText01')
    toastXml.GetElementsByTagName("text").GetAt(0).InnerText := text

    local notification := Windows.UI.Notifications.ToastNotification(toastXml)

    local toastNotifier := TNM.CreateToastNotifier(appId)
    toastNotifier.Show(notification)
}

class Monitor {
    static getCount() {
        return MonitorGetCount()
    }

    static getIndexByPos(pos) {
        local borders := []
        loop Monitor.getCount() {
            borders.Push(Monitor.getRectByIndex(A_Index))
        }

        for (i, v in borders) {
            if (pos.x >= v.l && pos.x <= v.r && pos.y >= v.t && pos.y <= v.b) {
                return i
            }
        }
    }

    static getIndexByWindow(title := "A") {
        local rect := getWindowRect(title)
        local borders := []
        loop Monitor.getCount() {
            borders.Push(Monitor.getRectByIndex(A_Index))
        }

        ; 先按窗口中心点的坐标确定在哪个显示器上
        local centerX := rect.x + rect.w / 2
        local centerY := rect.y + rect.h / 2
        for (i, v in borders) {
            if (centerX >= v.l && centerX <= v.r && centerY >= v.t && centerY <= v.b) {
                return i
            }
        }
        ; 再按窗口左上角点的坐标确定在哪个显示器上
        for (i, v in borders) {
            if (rect.x >= v.l && rect.x <= v.r && rect.y >= v.t && rect.y <= v.b) {
                return i
            }
        }
    }

    static getRectByIndex(index) {
        local l := 0
        local t := 0
        local r := 0
        local b := 0
        MonitorGet(index, &l, &t, &r, &b)

        local w := Abs(r - l)
        local h := Abs(b - t)

        return { l: l, t: t, r: r, b: b,
            x: l, y: t, w: w, h: h }
    }

    static getWorkAreaRectByIndex(index) {
        local l := 0
        local t := 0
        local r := 0
        local b := 0
        MonitorGetWorkArea(index, &l, &t, &r, &b)

        local w := Abs(r - l)
        local h := Abs(b - t)

        return { l: l, t: t, r: r, b: b,
            x: l, y: t, w: w, h: h }
    }

    static getNameByIndex(index) {
        local name := MonitorGetName(index)

        return name
    }
}
