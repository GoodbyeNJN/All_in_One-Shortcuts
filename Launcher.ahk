If not A_IsAdmin {
	Run *RunAs "%A_ScriptFullPath%"
	ExitApp
}
Process, Exist, Ditto.exe
IfEqual, ErrorLevel, 0, Run, C:\Program Files\Ditto\Ditto.exe
IfEqual, A_Min, 42, Reload
#NoTrayIcon
#SingleInstance force
#Include, IME.ahk
#Include, Capslock.ahk
#Include, Alt.ahk
#Include, Ctrl and balabala.ahk
#Include, Mouse.ahk
#IfWinActive, ahk_class PX_WINDOW_CLASS
F1::Run, C:\Program Files\AutoHotkey\AutoHotkey.chm
F2::Reload
#If
!^+F2::Reload

If ((A_Min = 42) And (A_TimeIdle >= 10000))
    Reload
