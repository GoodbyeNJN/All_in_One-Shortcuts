onWindowCreated(wParam, lParam) {
    console.log("----------Created----------")

    local imeConfig := getImeConfig(lParam)
    if (!imeConfig) {
        return
    }

    if (imeConfig.onCreated) {
        toggleIme(lParam, imeConfig.status)
    }
    if (imeConfig.HasOwnProp("delay") && Obj.isArray(imeConfig.delay)) {
        setImeDelay(imeConfig.delay, lParam, imeConfig.status)
    }
}

onWindowActivated(wParam, lParam) {
    console.log("---------Activated---------")

    local imeConfig := getImeConfig(lParam)
    if (!imeConfig) {
        return
    }

    if (imeConfig.onActivated) {
        toggleIme(lParam, imeConfig.status)
    }
}

onWindowFlash(wParam, lParam) {
    ; console.log("----------Flashed----------")
}

onWindowDestroyed(wParam, lParam) {
    ; console.log("---------Destroyed---------")
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
    ; msgNum: 消息编号，0xC000到0xFFFF之间的长整型，0表示注册失败
    ; SHELLHOOK: 被注册消息的名字
    local msgNum := DllCall("RegisterWindowMessage", "Str", "SHELLHOOK")

    ; OnMessage: 监听窗口消息
    OnMessage(msgNum, callback)
}

autorun() {
    listenWindowChange(onWindowChange)
}
