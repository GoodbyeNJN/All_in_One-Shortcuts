; 切换输入法
RWin:: {
    console.log("----------toggled----------")
    toggleIme()
}
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

; Win + t = 当前窗口置顶
#t:: WinSetAlwaysOnTop(-1, "A")
; Win + f = everything
#f:: runWithoutPrivilege("C:\Program Files\Everything\Everything.exe")
; Win + Space = WindowsTerminal (quake mode)
#Space:: {
    if ProcessExist("WindowsTerminal.exe") {
        Send("#``")
    } else {
        runWithoutPrivilege("wt -w _quake")
    }
}

; Snipaste 相关热键，Win + A 替换 F1，Win + S 替换 F3
#a:: Send("^#{PrintScreen}")
^#a:: Send("^{PrintScreen}")
+#a:: Send("+{PrintScreen}")
#s:: Send("#{F12}")
+#s:: Send("+#{F12}")
^#s:: Send("^#{F12}")

; F13 = 窗口居中
F13:: moveToCenter()

; F15 = 最小化本窗口
F15:: WinMinimize("A")

; F16 = Ditto
; F16:: Send("^!c")

; F17 = 最大化/恢复
F17:: {
    local status := WinGetMinMax("A")
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

; Launch_App2 = 打开系统计算器
Launch_App2:: runWithoutPrivilege("calc")

*CapsLock:: Send("{CapsLock Up}")

#HotIf GetKeyState("CapsLock", "P")
; CapsLock + ikjluo = 上下左右home end
i:: Up
k:: Down
j:: Left
l:: Right
u:: Home
o:: End

; CapsLock + ;h = BackSpace/Delete
vkBA:: BackSpace
h:: Delete

; w::Send("!{F4}") ; CapsLock + w = 发送Alt + F4
; c::Send("#1") ; CapsLock + c = chrome
e:: Send("#2")	; CapsLock + e = 文件浏览器

; CapsLock + d = 最小化本窗口
d:: WinMinimize("A")

; CapsLock + r = 任务管理器
r:: runWithoutPrivilege("taskmgr")

q:: moveToCenter()

a:: Send("!{F4}")

v:: Send("{F16}")

w:: Send("^!w")

z:: Send("^!z")

Tab:: Send("+#{Right}")

Up:: MouseMove(0, -10, 100, "R")
Down:: MouseMove(0, 10, 100, "R")
Left:: MouseMove(-10, 0, 100, "R")
Right:: MouseMove(10, 0, 100, "R")

^Up:: MouseMove(0, -100, 100, "R")
^Down:: MouseMove(0, 100, 100, "R")
^Left:: MouseMove(-100, 0, 100, "R")
^Right:: MouseMove(100, 0, 100, "R")

Space:: Click("Left")
!Space:: Click("Right")
#HotIf
