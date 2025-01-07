/**
 * 参考：
 * https://wyagd001.github.io/v2/docs/commands/DllCall.htm#ExStruct
 * https://maul-esel.github.io/ahkbook/en/DllCalls.html
 * https://maul-esel.github.io/ahkbook/en/Structures.html
 */

getImeConfig(lParam) {
    if (state.enableWindowChangeLog) {
        console.log("lParam:", lParam)
    }

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

    if (state.enableWindowChangeLog) {
        console.log("winExe:", winExe)
    }

    local imeConfig := readConfig("imeConfig")
    for (v in imeConfig) {
        if (v.processName == winExe) {
            return v
        }
    }
}

/**
 * 获取窗口句柄，0表示获取失败
 */
getHwnd(lParam := 0) {
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
        local buff := Buffer(cbSize)
        NumPut("UInt", cbSize, buff, 0)

        ; https://docs.microsoft.com/en-us/windows/win32/api/winuser/nf-winuser-getguithreadinfo
        local isSuccess := DllCall("GetGUIThreadInfo", "UInt", 0, "Ptr", buff, "UInt")
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
    local hwndActive := getActiveHwnd()
    local hwnd := lParam ? lParam : hwndFocus ? hwndFocus : hwndActive

    if (state.enableWindowChangeLog) {
        console.log("hwndFocus:", hwndFocus)
        console.log("hwndActive:", hwndActive)
        console.log("hwnd:", hwnd)
    }


    ; if (!WinActive("ahk_id " . hwnd)) {
    ;     console.log("WinActive:", hwnd)
    ;     return 0
    ; }

    return hwnd
}

getCurrentImeSwitch(hwnd) {
    local hex := state.imeSwitch.on

    try {
        local processId := DllCall("GetWindowThreadProcessId", "UInt", hwnd, "UInt", 0, "UInt")
        local layout := DllCall("GetKeyboardLayout", "UInt", processId, "UInt")
        hex := Format("0x{:x}", layout)
    }

    local imeSwitch := state.imeSwitch.on
    if (hex == state.imeSwitch.on.layout) {
        imeSwitch := state.imeSwitch.on
    } else if (hex == state.imeSwitch.off.layout) {
        imeSwitch := state.imeSwitch.off
    }

    return imeSwitch
}

getNextImeSwitch(hwnd) {
    local currentImeSwitch := getCurrentImeSwitch(hwnd)
    local nextImeSwitch := currentImeSwitch.status ? state.imeSwitch.off : state.imeSwitch.on

    return nextImeSwitch
}

setImeSwitch(imeSwitch, hwnd) {
    try {
        PostMessage(WM_INPUTLANGCHANGEREQUEST, , imeSwitch.layout, , "ahk_id " . hwnd)
    }
}

toggleIme(lParam := 0, status := unset) {
    local hwnd := getHwnd(lParam)
    if (!hwnd) {
        return
    }

    local nextImeSwitch := state.imeSwitch.off
    if (IsSet(status)) {
        nextImeSwitch := status ? state.imeSwitch.on : state.imeSwitch.off
    } else {
        nextImeSwitch := getNextImeSwitch(hwnd)
    }

    setImeSwitch(nextImeSwitch, hwnd)
    ; setImeIcon(nextImeSwitch)
}
