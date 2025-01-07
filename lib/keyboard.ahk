; ----------------------------------------------
; Win
; ----------------------------------------------

; Win + t 当前窗口置顶
#t:: WinSetAlwaysOnTop(-1, "A")

; Snipaste
; Win + a 截图
#a:: Send("^#{PrintScreen}")
; Win + s 贴图
#s:: Send("+#{PrintScreen}")
; #d:: Send("^+#{PrintScreen}")

; Win + r 任务管理器
#r:: Send("^+{Esc}")

; ----------------------------------------------
; F13
; ----------------------------------------------

; Terminal
F13:: {
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
    ; console.log("hwnd:", hwnd)
    local windowDesktop := VD.getDesktopNumOfWindow(title)
    ; console.log("windowDesktop:", windowDesktop)

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

; ----------------------------------------------
; F14
; ----------------------------------------------

; 切换输入法
F14:: {
    console.log("----------toggled----------")
    toggleIme()
}

; ----------------------------------------------
; F15
; ----------------------------------------------

; FlowLauncher
~F15:: {
    static title := "ahk_exe Flow.Launcher.exe"

    if (WinWaitActive(title, , 1)) {
        toggleIme(, state.imeSwitch.off.status)
    }
}

; ----------------------------------------------
; F16
; ----------------------------------------------

; ----------------------------------------------
; F17
; ----------------------------------------------

; ChatGPT
F17:: Send("^!{F13}")

; Pot
; 划词翻译
^F17:: Send("^+{F13}")
+F17:: Send("+!{F13}")

; Ditto
!F17:: Send("^+!{F13}")

; ----------------------------------------------
; F18
; ----------------------------------------------

; 关闭当前窗口
F18:: {
    if WinActive("ahk_exe Spark Desktop.exe") {
        Send("^w")
    } else {
        Send("!{F4}")
    }
}

; 居中当前窗口
^F18:: moveToCenter()

; 最小化当前窗口
+F18:: {
    try {
        WinMinimize("A")
    }
}

; 总览所有窗口
^!F18:: Send("#{Tab}")

; ----------------------------------------------
; F19
; ----------------------------------------------

; QQ
F19:: Send("^!{Numpad1}")

; 主微信
^F19:: Send("^!{Numpad2}")

; 副微信
+F19:: Send("^!{Launch_App2}")

; Telegram
!F19:: {
    static title := "ahk_exe Telegram.exe"
    static file := "C:\Users\cc\AppData\Roaming\Telegram Desktop\Telegram.exe"

    if WinActive(title) {
        WinClose(title)
    } else if ProcessExist("Telegram.exe") {
        Run(file)
    } else {
        runWithoutPrivilege(file)
    }
}

; Spark
^!F19:: {
    static title := "ahk_exe Spark Desktop.exe"
    static file := "C:\Users\cc\AppData\Local\Programs\SparkDesktop\Spark Desktop.exe"

    if WinActive(title) {
        WinClose(title)
    } else if ProcessExist("Spark Desktop.exe") {
        Run(file)
    } else {
        runWithoutPrivilege(file)
    }
}

; ----------------------------------------------
; F20
; ----------------------------------------------

; 最大化/恢复当前窗口
F20:: {
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

; Shift + F20 调整为纵向窗口
+F20:: winSize(960, 1920 + 58, "A")
; Ctrl + F20 调整为横向窗口
^F20:: winSize(2160, 1620, "A")
; Ctrl + Shift + F20 调整为小型横向窗口
^+F20:: winSize(1920, 1440, "A")

; ----------------------------------------------
; F24
; ----------------------------------------------
*F24:: {
    Send("{F24 Up}")
}

#HotIf GetKeyState("F24", "P")
; 左键 浏览器内调用沉浸式划词翻译，其他应用调用Pot划词翻译
LButton:: {
    if WinActive("ahk_exe chrome.exe") {
        Send("!z")
    } else {
        Send("^{F17}")
    }
}

; 右键 浏览器内调用沉浸式全页翻译
RButton:: {
    if WinActive("ahk_exe chrome.exe") {
        Send("!a")
    }
}

; 中键打开虚拟桌面管理
MButton:: Send("#{Tab}")

; 切换滚动方向
WheelUp::WheelLeft
WheelDown::WheelRight

; PageUp/PageDown 切换虚拟桌面
PgUp:: Send("^#{Left}")
PgDn:: Send("^#{Right}")

#HotIf

; ----------------------------------------------
; CapsLock
; ----------------------------------------------

*CapsLock:: {
    Send("{CapsLock Up}")
    SetCapsLockState("AlwaysOff")
}

#HotIf GetKeyState("CapsLock", "P")
; CapsLock + ikjluo 上下左右Home/End
i::Up
k::Down
j::Left
l::Right
u::Home
o::End

; CapsLock + ;h BackSpace/Delete
vkBA::BackSpace
h::Delete

; CapsLock + [] PageUp/PageDown
[::PgUp
]::PgDn

Tab:: Send("+#{Right}")
Space:: Send("F15")

#HotIf

; ----------------------------------------------
; 窗口特定
; ----------------------------------------------

; 当前窗口是资源管理器时
#HotIf WinActive("ahk_class CabinetWClass")
; Ctrl + f 在FlowLauncher中搜索当前路径
^f:: {
    static title := "ahk_exe Flow.Launcher.exe"

    local path := getCurrentExplorerPath()
    Send("{F15}")
    if (WinWaitActive(title, , 1)) {
        SendText(path)
    }
}
#HotIf
