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
        return (
            !Obj.isFunction(value) &&
            !Obj.isArray(value) &&
            !Obj.isMap(value) &&
            IsObject(value)
        )
    }
}

initState() {
    state.imeSwitch := readConfig("imeSwitch")
}

readConfig(key := unset) {
    local string := FileRead(CONFIG_FILE_PATH)
    local config := JsonParse(string)

    return IsSet(key) ? config.%key% : config
}

writeConfig(value, key := unset) {
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

runWithoutPrivilege(command, options := "") {
    RunAs(state.username, state.password)
    Run(command, , options)
    RunAs()
}

restart() {
    initState()

    ; if (isInDebugMode()) {
    ;     restartInDebugMode(true)
    ; } else {
    restartWithPrivilege(true)
    ; }

    ExitApp()
}

restartWithPrivilege(force := false) {
    if (!force) {
        local hasRestartSwitch := RegExMatch(DllCall("GetCommandLine", "str"), " /restart(?!\S)")

        if (hasRestartSwitch) {
            return
        }
    }

    local commandLine := getCommandLineString({ switches: ["restart"] })
    Run("*RunAs " . commandLine)
    ExitApp()
}

restartInDebugMode(force := false) {
    if (!force && isInDebugMode()) {
        return
    }

    local params := A_Args.Clone()
    params.Push("debug")
    local ahkPath := StrReplace(A_AhkPath, " ", "`` ")

    local commandLine := getCommandLineString({ ahkPath: ahkPath, params: params })
    Run(Format('wt -w 0 nt -p "Windows PowerShell" PowerShell -Command {1} ^| Write-Host', commandLine))
    ; Run(Format('wt -w _quake nt -p "Windows PowerShell" PowerShell -Command {1} ^| Write-Host', commandLine))
    ExitApp()
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

getCommandLineString(args := unset) {
    if (!IsSet(args)) {
        args := {}
    }

    local ahkPath := args.HasOwnProp("ahkPath") ? args.ahkPath : A_AhkPath
    local switches := args.HasOwnProp("switches") ? args.switches : []
    local filename := args.HasOwnProp("filename") ? args.filename : A_ScriptFullPath
    local params := args.HasOwnProp("params") ? args.params : A_Args

    local commandLine := A_IsCompiled
        ? Format('"{1}" {2} {3}', filename, getSwitchesString(switches), getParamsString(params))	; CompiledScript.exe [Switches] [Script Parameters]
        : Format('"{1}" {2} "{3}" {4}', ahkPath, getSwitchesString(switches), filename, getParamsString(params))	; AutoHotkey.exe [Switches] [Script Filename] [Script Parameters]

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

winSize(w, h, params*) {
    local x := 0
    local y := 0
    WinGetPos(&x, &y, , , params*)

    WinMove(x, y, w, h, params*)
}

moveToCenter() {
    local status := WinGetMinMax("A")
    if (status != 0) {
        return
    }

    local w := 0
    local h := 0
    WinGetPos(, , &w, &h, "A")

    local l := 0
    local t := 0
    local r := 0
    local b := 0
    MonitorGetWorkArea(getCurrentMonitorIndex(), &l, &t, &r, &b)

    local x := (r + l - w) / 2
    local y := (b + t - h) / 2
    WinMove(x, y, , , "A")
}

getCurrentMonitorIndex() {
    local count := MonitorGetCount()
    local x := 0
    local y := 0
    local w := 0
    local h := 0
    WinGetPos(&x, &y, &w, &h, "A")

    local monitorCoords := []
    loop (count) {
        local l := 0
        local t := 0
        local r := 0
        local b := 0
        MonitorGet(A_Index, &l, &t, &r, &b)
        monitorCoords.Push({ l: l, t: t, r: r, b: b })
    }

    ; 先按窗口中心点的坐标确定在哪个显示器上
    local centerX := x + w / 2
    local centerY := y + h / 2
    for (k, v in monitorCoords) {
        if (centerX >= v.l && centerX <= v.r && centerY >= v.t && centerY <= v.b) {
            return k
        }
    }
    ; 再按窗口左上角点的坐标确定在哪个显示器上
    for (k, v in monitorCoords) {
        if (x >= v.l && x <= v.r && y >= v.t && y <= v.b) {
            return k
        }
    }
}
