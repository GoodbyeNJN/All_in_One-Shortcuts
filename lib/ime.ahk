/**
 * 参考：
 * https://wyagd001.github.io/v2/docs/commands/DllCall.htm#ExStruct
 * https://maul-esel.github.io/ahkbook/en/DllCalls.html
 * https://maul-esel.github.io/ahkbook/en/Structures.html
 */

getImeConfig(lParam) {
    console.log("lParam:", lParam)
    if (!lParam) {
        return
    }

    local winExe := ""
    try {
        winExe := WinGetProcessName("ahk_id " . lParam)
    }
    if (winExe == "") {
        return
    }
    console.log("winExe:", winExe)

    local imeConfig := readConfig("imeConfig")
    for (k, v in imeConfig) {
        if (v.processName == winExe) {
            return v
        }
    }
}

/**
 * 获取输入法默认的窗口句柄，0表示获取失败
 */
getDefaultImeWnd(lParam := 0) {
    /**
     * 获取当前输入焦点的窗口句柄，0表示获取失败
     */
    getKeyboardFocusHwnd() {
        /**
         * typedef struct GUITHREADINFO {   // size: x86  x64
         * DWORD cbSize;                  //        4    4
         * DWORD flags;                   //        4    4
         * HWND  hwndActive;              //        4    8
         * HWND  hwndFocus;               //        4    8
         * HWND  hwndCapture;             //        4    8
         * HWND  hwndMenuOwner;           //        4    8
         * HWND  hwndMoveSize;            //        4    8
         * HWND  hwndCaret;               //        4    8
         * RECT  rcCaret;                 //       16   16
         * } GUITHREADINFO, *PGUITHREADINFO, *LPGUITHREADINFO;
         * 
         * typedef struct RECT {            // size
         * LONG left;                     //   4
         * LONG top;                      //   4
         * LONG right;                    //   4
         * LONG bottom;                   //   4
         * } RECT, *PRECT, *NPRECT, *LPRECT;
         */

        local cbSize := 4 + 4 + (A_PtrSize * 6) + 4 * 4
        local buff := Buffer(cbSize, 0)
        NumPut("UInt", cbSize, buff, 0)

        ; https://docs.microsoft.com/en-us/windows/win32/api/winuser/nf-winuser-getguithreadinfo
        local isSuccess := DllCall("GetGUIThreadInfo", "UInt", 0, "Ptr", buff)
        ; https://docs.microsoft.com/en-us/windows/win32/api/winuser/ns-winuser-guithreadinfo
        local hwndFocus := isSuccess ? NumGet(buff, 4 + 4 + A_PtrSize, "UInt") : 0

        return hwndFocus
    }

    /**
     * 获取当前活动窗口的句柄，0表示获取失败
     */
    getActiveHwnd() {
        local hwndActive := 0

        try {
            hwndActive := WinGetID("A")
        }

        return hwndActive
    }

    local hwndFocus := getKeyboardFocusHwnd()
    console.log("hwndFocus:", hwndFocus)
    local hwndActive := getActiveHwnd()
    console.log("hwndActive:", hwndActive)
    local hwnd := lParam ? lParam : hwndActive ? hwndActive : hwndFocus
    console.log("hwnd:", hwnd)

    if (!WinActive("ahk_id " . hwnd)) {
        console.log("WinActive:", hwnd)
        return 0
    }

    ; https://docs.microsoft.com/en-us/windows/win32/api/imm/nf-imm-immgetdefaultimewnd
    local imeWnd := DllCall("imm32\ImmGetDefaultIMEWnd", "UInt", hwnd)

    return imeWnd
}

getCurrentImeSwitch(imeWnd) {
    /**
     * 获取输入法开关
     */
    getImeStatus(imeWnd) {
        return DllCall(
            "SendMessage",
            "UInt", imeWnd,
            "UInt", WM_IME_CONTROL,
            "Int", IMC_GETOPENSTATUS,
            "Int", 0
        )
    }

    /**
     * 获取输入法转换状态
     */
    getImeConvMode(imeWnd) {
        return DllCall(
            "SendMessage",
            "UInt", imeWnd,
            "UInt", WM_IME_CONTROL,
            "Int", IMC_GETCONVERSIONMODE,
            "Int", 0
        )
    }

    local imeOpenStatus := getImeStatus(imeWnd)
    local imeConvMode := getImeConvMode(imeWnd)

    local imeStatus := false
    if (imeOpenStatus == state.imeSwitch.on.status && imeConvMode == state.imeSwitch.on.convMode) {
        imeStatus := true
    } else if (imeOpenStatus == state.imeSwitch.off.status && imeConvMode == state.imeSwitch.off.convMode) {
        imeStatus := false
    }

    local currentImeSwitch := {
        status: imeStatus,
        openStatus: imeOpenStatus,
        convMode: imeConvMode
    }
    console.log("currentImeSwitch:", currentImeSwitch)

    return currentImeSwitch
}

getNextImeSwitch(imeWnd) {
    local currentImeSwitch := getCurrentImeSwitch(imeWnd)
    local nextImeSwitch := currentImeSwitch.status ? state.imeSwitch.off : state.imeSwitch.on
    console.log("nextImeSwitch:", nextImeSwitch)

    return nextImeSwitch
}

setImeSwitch(imeSwitch, imeWnd) {
    /**
     * 设置输入法开关
     */
    setImeStatus(status, imeWnd) {
        return DllCall(
            "SendMessage",
            "UInt", imeWnd,
            "UInt", WM_IME_CONTROL,
            "Int", IMC_SETOPENSTATUS,
            "Int", status
        )
    }

    /**
     * 设置输入法转换状态
     */
    setImeConvMode(status, imeWnd) {
        return DllCall(
            "SendMessage",
            "UInt", imeWnd,
            "UInt", WM_IME_CONTROL,
            "Int", IMC_SETCONVERSIONMODE,
            "Int", status
        )
    }

    setImeStatus(imeSwitch.status, imeWnd)
    setImeConvMode(imeSwitch.convMode, imeWnd)
}

toggleIme(lParam := 0, status := unset) {
    local imeWnd := getDefaultImeWnd(lParam)
    console.log("imeWnd:", imeWnd)
    if (!imeWnd) {
        return
    }

    local nextImeSwitch := state.imeSwitch.off
    if (IsSet(status)) {
        nextImeSwitch := status ? state.imeSwitch.on : state.imeSwitch.off
    } else {
        nextImeSwitch := getNextImeSwitch(imeWnd)
    }

    setImeSwitch(nextImeSwitch, imeWnd)
}

setImeDelay(delay, lParam := 0, status := unset) {
    static index := 1
    fn() {
        toggleIme(lParam, status)

        index += 1
        setImeDelay(delay, lParam, status)
    }

    if (!delay.Has(index)) {
        index := 1
        return
    }

    local currentDelay := delay[index]
    console.log("currentDelay:", currentDelay)
    ; SetTimer(toggleIme.Bind(lParam, status), 0 - currentDelay)
    SetTimer(fn, 0 - currentDelay)
}
