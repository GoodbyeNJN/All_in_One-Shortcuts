onWindowCreated(wParam, lParam) {
    if (state.enableWindowChangeLog) {
        console.log("----------Created----------")
    }

    ; setImeIcon(getCurrentImeSwitch(getHwnd(lParam)))

    local imeConfig := getImeConfig(lParam)
    if (!imeConfig) {
        return
    }

    if (imeConfig.onCreated) {
        toggleIme(lParam, imeConfig.status)
    }
}

onWindowActivated(wParam, lParam) {
    if (state.enableWindowChangeLog) {
        console.log("---------Activated---------")
    }

    ; setImeIcon(getCurrentImeSwitch(getHwnd(lParam)))

    local imeConfig := getImeConfig(lParam)
    if (!imeConfig) {
        return
    }

    if (imeConfig.onActivated) {
        toggleIme(lParam, imeConfig.status)
    }
}

onWindowFlash(wParam, lParam) {
    if (state.enableWindowChangeLog) {
        ; console.log("----------Flashed----------")
    }
}

onWindowDestroyed(wParam, lParam) {
    if (state.enableWindowChangeLog) {
        ; console.log("---------Destroyed---------")
    }
}

; 处理窗口事件的函数，参数由系统传入
onWindowChange(wParam, lParam, *) {
    switch (wParam) {
        case HSHELL_WINDOWCREATED:
            onWindowCreated(wParam, lParam)
        case HSHELL_WINDOWACTIVATED, HSHELL_RUDEAPPACTIVATED:
            onWindowActivated(wParam, lParam)
        case HSHELL_REDRAW, HSHELL_FLASH:
            onWindowFlash(wParam, lParam)
        case HSHELL_WINDOWDESTROYED:
            onWindowDestroyed(wParam, lParam)
    }
}

listenWindowChange(callback) {
    ; 创建一个窗口但不显示，并获取其hwnd
    state.gui := Gui("+LastFound")
    local hwnd := WinExist()

    ; RegisterShellHookWindow: 在刚刚创建的窗口上注册消息钩子
    DllCall("RegisterShellHookWindow", "UInt", hwnd)

    ; RegisterWindowMessage: 注册一个窗口消息，保证该消息在系统范围内唯一
    ; msg: 消息编号，0xc000到0xffff之间的长整型，0表示注册失败
    ; SHELLHOOK: 被注册消息的名字
    local msg := DllCall("RegisterWindowMessage", "Str", "SHELLHOOK", "UInt")

    ; OnMessage: 监听窗口消息
    OnMessage(msg, callback)
}

listenMouseEvent() {
    ; OnMessage: 监听窗口消息
    OnMessage(WM_MOUSEMOVE, callback)

    callback(wParam, lParam, *) {
        ; console.log("wParam:", wParam)
        ; console.log("lParam:", lParam)
        console.log("lParam:", lParam)
        console.log("x:", getXLparam(lParam))
        console.log("y:", getYLparam(lParam))
    }
}

getXLparam(lParam) {
    local buff := Buffer(32)

    NumPut("UInt", lParam, buff, 0)
    return NumGet(buff, 0, "Short")
}
getYLparam(lParam) {
    local buff := Buffer(32)

    NumPut("UInt", lParam, buff, 0)
    return NumGet(buff, 2, "Short")
}

launchWezterm() {
    local title := "ahk_class org.wezfurlong.wezterm"
    local process := "wezterm-gui.exe"

    local pid := ProcessExist(process)
    if (pid) {
        return
    }

    runWithoutPrivilege("C:\Program Files\WezTerm\wezterm-gui.exe")
    WinWait(title, , 10)
    moveQuakeModeWindow(title, "60%", "50%")

    try {
        WinMinimize(title)
        WinHide(title)
    }
}

autorun() {
    listenWindowChange(onWindowChange)
    ; TraySetIcon(IME_ON_ICON)
    ; setImeIcon(getCurrentImeSwitch(getHwnd()))
    ; addToggleImeOption()
    launchWezterm()
}
