If not A_IsAdmin {
	Run *RunAs "%A_ScriptFullPath%"
	ExitApp
}
Run, C:\Program Files\Ditto\Ditto.exe
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