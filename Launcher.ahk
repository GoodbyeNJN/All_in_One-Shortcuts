;------------------------------------------------------------
; launcher段开始
;------------------------------------------------------------
#NoTrayIcon
#SingleInstance force

; 检测是否以管理员身份运行
If not A_IsAdmin {
    Run *RunAs "%A_ScriptFullPath%"
    ExitApp
}

; 检测Ditto是否运行，如未运行则运行之
Process, Exist, Ditto.exe
IfEqual, ErrorLevel, 0, Run, C:\Program Files\Ditto\Ditto.exe

; 定时重载脚本
If ((A_Min = 42) And (A_TimeIdle >= 10000))
    Reload

; 获取屏幕边界坐标
SysGet, ScreenBorderPos, Monitor
RightEdgePos := ScreenBorderPosRight - 1 ; 鼠标在屏幕右边缘的x坐标
BottomEdgePos := ScreenBorderPosBottom - 1 ; 鼠标在屏幕底边缘的y坐标

; 载入子模块
#Include, IME.ahk
#Include, Mouse.ahk
#Include, Alt.ahk
#Include, Ctrl and balabala.ahk
#Include, Capslock.ahk
#Include, Win.ahk

; 调试用：sublime text窗口激活时，F1运行帮助文档，F2重载脚本
#IfWinActive, ahk_class PX_WINDOW_CLASS
F1::Run, C:\Program Files\AutoHotkey\AutoHotkey.chm
F2::Reload
#If
;------------------------------------------------------------
; launcher段结束
;------------------------------------------------------------
