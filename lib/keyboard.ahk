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

; 切换输入法
^F13:: {
    console.log("----------toggled----------")
    toggleIme()
}

; FlowLauncher
~^+F13:: {
    static title := "ahk_exe Flow.Launcher.exe"

    if (WinWaitActive(title, , 1)) {
        toggleIme(, state.imeSwitch.off.status)
    }
}

; ----------------------------------------------
; F14
; ----------------------------------------------


; ----------------------------------------------
; F15
; ----------------------------------------------

; 切换上一个/下一个虚拟桌面
^F15:: goToRelativeDesktopNum(-1)
!F15:: goToRelativeDesktopNum(1)

; 移动当前窗口到上一个/下一个虚拟桌面
^+F15:: {
    moveToRelativeDesktopNum("A", -1)
    goToRelativeDesktopNum(-1)
}
!+F15:: {
    moveToRelativeDesktopNum("A", 1)
    goToRelativeDesktopNum(1)
}

; ----------------------------------------------
; F16
; ----------------------------------------------

; 切换到指定虚拟桌面
F16:: goToDesktopNum(1)

^F16:: goToDesktopNum(2)

+F16:: goToDesktopNum(3)

!F16:: goToDesktopNum(4)

^+F16:: goToDesktopNum(5)

; ----------------------------------------------
; F17
; ----------------------------------------------

; ChatGPT
F17:: Send("^!{F13}")

; Pot
; 划词翻译
^F17:: Send("^+{F23}")
+F17:: Send("+!{F23}")

; Ditto
!F17:: Send("^+!{F23}")

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

!F18::
^!F18::
+!F18::
^+!F18::
{
    if (GetKeyState("Ctrl", "P") && GetKeyState("Shift", "P")) {
        ; Ctrl + Shift + F18 调整为全屏窗口
        winSize(3840, 2076, "A")
    } else if GetKeyState("Ctrl", "P") {
        ; Ctrl + F18 调整为横向窗口
        winSize(2160, 1620, "A")
    } else if GetKeyState("Shift", "P") {
        ; Shift + F18 调整为小型横向窗口
        winSize(1920, 1440, "A")
    } else {
        ; 最大化/恢复当前窗口
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
}

; 在所有虚拟桌面上置顶当前窗口
^+F18:: {
    VD.TogglePinWindow("A")

    ; if VD.IsWindowPinned("A") {
    ;     toast("已在所有桌面上固定此窗口")
    ; }
}

; ----------------------------------------------
; F19
; ----------------------------------------------

; QQ
F19:: {
    static title := "ahk_exe QQ.exe"
    static last := 0

    if WinActive(title) {
        Send("^!{Numpad1}")

        if (WinWaitClose(title, , 1) && last != 0) {
            WinActivate(last)
        }
    } else {
        last := WinActive("A")

        Send("^!{Numpad1}")
    }
}

; 主微信
^F19:: Send("^!{Numpad2}")

; 副微信
+F19:: Send("^!{Launch_App2}")

; Telegram
!F19:: {
    static title := "ahk_exe Telegram.exe"
    static file := "C:\Users\cc\AppData\Roaming\Telegram Desktop\Telegram.exe"
    ; static title := "Unigram"
    ; static file := "C:\Program Files\WindowsApps\38833FF26BA1D.UnigramPreview_11.7.0.0_x64__g9c9v27vpyspw\Telegram.exe"

    if WinActive(title) {
        WinClose(title)
    } else if ProcessExist("Telegram.exe") {
        Run(file)
    } else {
        runWithoutPrivilege(file)
    }
}

; Spark
^+F19:: {
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
; F24
; ----------------------------------------------

*F24:: Send("{F24 Up}")

#HotIf GetKeyState("F24", "P")
; 左键 浏览器内调用沉浸式划词翻译，其他应用调用Pot划词翻译
LButton:: {
    if (WinActive("ahk_exe chrome.exe") || WinActive("ahk_exe firefox.exe")) {
        Send("+!z")
    } else {
        Send("^{F17}")
    }
}

; 右键 浏览器内调用沉浸式全页翻译
RButton:: {
    if (WinActive("ahk_exe chrome.exe") || WinActive("ahk_exe firefox.exe")) {
        Send("+!a")
    }
}

; 中键在所有虚拟桌面上置顶当前窗口
MButton:: VD.TogglePinWindow("A")

; 切换滚动方向
WheelUp::WheelLeft
WheelDown::WheelRight

; PageUp/PageDown 切换虚拟桌面
PgUp:: goToRelativeDesktopNum(-1)
PgDn:: goToRelativeDesktopNum(1)

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
