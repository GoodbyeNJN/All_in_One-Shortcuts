; 切换输入法
; RWin:: {
;     console.log("----------toggled----------")
;     toggleIme()
; }
F14:: {
    console.log("----------toggled----------")
    toggleIme()
}

; 当前资源管理器目录下调用everything搜索
#HotIf WinActive("ahk_class CabinetWClass")
^f:: {
    local path := getCurrentExplorerPath()
    runWithoutPrivilege("C:\Program Files\Everything\Everything.exe")

    if (!path) {
        return
    }

    WinWait("ahk_class EVERYTHING")
    ControlSetText(Format('"{1}" ', path), "Edit1", "ahk_class EVERYTHING")
    Send("{End}")
}
#HotIf

F18:: {
    if ProcessExist("Heynote.exe") {
        Send("^!{Numpad2}")
    } else {
        runWithoutPrivilege("C:\Users\cc\AppData\Local\Programs\Heynote\Heynote.exe")
    }
}

!F18:: {
    if WinActive("ahk_exe Telegram.exe") {
        WinClose("ahk_exe Telegram.exe")
    } else {
        runWithoutPrivilege("C:\Users\cc\AppData\Roaming\Telegram Desktop\Telegram.exe")
    }
}

^!F18:: {
    if WinActive("ahk_exe Spark Desktop.exe") {
        WinClose("ahk_exe Spark Desktop.exe")
    } else {
        runWithoutPrivilege("C:\Users\cc\AppData\Local\Programs\SparkDesktop\Spark Desktop.exe")
    }
}

; Win + t = 当前窗口置顶
#t:: WinSetAlwaysOnTop(-1, "A")
; Win + f = everything
; #f:: runWithoutPrivilege("C:\Program Files\Everything\Everything.exe")
; Win + Space = WindowsTerminal (quake mode)
; #Space:: {
F19:: {
    ; if ProcessExist("WindowsTerminal.exe") {
    ;     Send("#``")
    ; } else {
    ;     ; runWithoutPrivilege("wt -w _quake")
    ; }

    ; static process := "Hyper.exe"

    ; if ProcessExist(process) {
    ;     Send("#``")
    ; } else {
    ;     runWithoutPrivilege("C:\Users\cc\AppData\Local\Programs\Hyper\Hyper.exe")
    ; }

    static title := "ahk_class org.wezfurlong.wezterm"
    static process := "wezterm-gui.exe"

    ; try {

    ;     local hwnd := WinExist(title)
    ;     console.log("hwnd:", hwnd)
    ;     local desktop := VD.getDesktopNumOfWindow(title)
    ;     console.log("desktop:", desktop)

    ;     DetectHiddenWindows(true)
    ;     if (hwnd) {
    ;         local mouseMonitor := Monitor.getIndexByPos(getMousePos())
    ;         local windowMonitor := Monitor.getIndexByWindow(title)

    ;         if (windowMonitor != mouseMonitor) {
    ;             moveQuakeModeWindow(title, "60%", "50%", mouseMonitor)
    ;             WinActivate(title)
    ;         } else if (WinActive(title)) {
    ;             WinMinimize(title)
    ;             WinHide(title)
    ;         } else {
    ;             WinActivate(title)
    ;         }
    ;     } else if (desktop != -1) {
    ;         VD.MoveWindowToCurrentDesktop(title)
    ;         moveQuakeModeWindow(title, "60%", "50%")
    ;         WinActivate(title)
    ;     } else if (ProcessExist(process)) {
    ;         moveQuakeModeWindow(title, "60%", "50%")
    ;         WinShow(title)
    ;         WinActivate(title)
    ;     } else {
    ;         runWithoutPrivilege("C:\Program Files\WezTerm\wezterm-gui.exe")
    ;         WinWait(title, , 10)
    ;         moveQuakeModeWindow(title, "60%", "50%")
    ;     }
    ; } finally {
    ;     DetectHiddenWindows(false)
    ; }


    local pid := ProcessExist(process)
    if (!pid) {
        runWithoutPrivilege("C:\Program Files\WezTerm\wezterm-gui.exe")
        WinWait(title, , 10)
        ; WinHide(title)
        ; DetectHiddenWindows(true)
        ; WinSetExStyle("+0x80", title)
        ; DetectHiddenWindows(false)
        ; WinShow(title)
        moveQuakeModeWindow(title, "60%", "50%")
        return
    }

    local hwnd := WinExist(title)
    console.log("hwnd:", hwnd)
    local windowDesktop := VD.getDesktopNumOfWindow(title)
    console.log("windowDesktop:", windowDesktop)

    ; Window is hidden
    if (!hwnd && windowDesktop == -1) {
        DetectHiddenWindows(true)
        WinRestore(title)
        moveQuakeModeWindow(title, "60%", "50%")
        WinActivate(title)
        return
    }

    local mouseDesktop := VD.getCurrentDesktopNum()
    if (windowDesktop == mouseDesktop) {
        local mouseMonitor := Monitor.getIndexByPos(getMousePos())
        local windowMonitor := Monitor.getIndexByWindow(title)

        if (windowMonitor == mouseMonitor) {
            if (WinActive(title)) {
                WinMinimize(title)
                WinHide(title)
            } else {
                WinActivate(title)
            }
        } else {
            moveQuakeModeWindow(title, "60%", "50%", mouseMonitor)
            WinActivate(title)
        }
    } else {
        VD.MoveWindowToCurrentDesktop(title)
        moveQuakeModeWindow(title, "60%", "50%")
        WinActivate(title)
    }
}

; Snipaste 相关热键，Win + A 截图，Win + S 贴图，
#a:: Send("^#{PrintScreen}")
#s:: Send("+#{PrintScreen}")
#d:: Send("^+#{PrintScreen}")

; F13 = 窗口居中
F13:: moveToCenter()

; F15 = 最小化本窗口
F15:: {
    try {
        WinMinimize("A")
    }
}

; F16 = Ditto
; F16:: Send("^!c")

; F17 = 最大化/恢复
F17:: {
    local status := 1

    try {
        status := WinGetMinMax("A")
    }

    if (status == 1) {
        WinRestore("A")
    } else {
        WinMaximize("A")
    }
}
; Shift + F17 = 调整为纵向窗口
+F17:: winSize(960, 1920 + 58, "A")
; Ctrl + F17 = 调整为横向窗口
^F17:: winSize(2160, 1620, "A")
; Ctrl + Shift + F17 = 调整为小型横向窗口
^+F17:: winSize(1920, 1440, "A")

~F20:: {
    static title := "ahk_exe Flow.Launcher.exe"

    if (WinWaitActive(title, , 1)) {
        toggleIme(, state.imeSwitch.off.status)
    }
}

; Launch_App2 = 打开系统计算器
Launch_App2:: runWithoutPrivilege("calc")

; *CapsLock:: {
;     Send Send("{CapsLock Up}")
;     SetCapsLockState("AlwaysOff")
; }

; #HotIf GetKeyState("CapsLock", "P")
; ; CapsLock + ikjluo = 上下左右home end
; i::Up
; k::Down
; j::Left
; l::Right
; u::Home
; o::End

; ; CapsLock + ;h = BackSpace/Delete
; vkBA::BackSpace
; h::Delete

; ; w::Send("!{F4}") ; CapsLock + w = 发送Alt + F4
; ; c::Send("#1") ; CapsLock + c = chrome
; e:: Send("#2")    ; CapsLock + e = 文件浏览器

; ; CapsLock + d = 最小化本窗口
; d:: {
;     try {
;         WinMinimize("A")
;     }
; }

; ; CapsLock + r = 任务管理器
; r:: runWithoutPrivilege("taskmgr")

; q:: moveToCenter()

; a:: Send("!{F4}")

; v:: Send("{F16}")

; w:: Send("^!w")

; z:: Send("^!z")

; Tab:: Send("+#{Right}")

; Up:: MouseMove(0, -10, 100, "R")
; Down:: MouseMove(0, 10, 100, "R")
; Left:: MouseMove(-10, 0, 100, "R")
; Right:: MouseMove(10, 0, 100, "R")

; ^Up:: MouseMove(0, -100, 100, "R")
; ^Down:: MouseMove(0, 100, 100, "R")
; ^Left:: MouseMove(-100, 0, 100, "R")
; ^Right:: MouseMove(100, 0, 100, "R")

; Space:: Click("Left")
; !Space:: Click("Right")
; #HotIf
