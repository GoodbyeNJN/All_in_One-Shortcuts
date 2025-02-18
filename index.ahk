#requires AutoHotkey v2.0

#SingleInstance Force
#NoTrayIcon
SendMode("Input")
SetWorkingDir(A_ScriptDir)
SetTitleMatchMode(2)
FileEncoding("UTF-8")

A_HotkeyInterval := 100
A_MaxHotkeysPerInterval := 30

#DllLoad "imm32"

#Include "%A_ScriptDir%"
#Include <VD>
#Include <constant>
#Include <common>
#Include <json>
#Include <console>
#Include <debug>
#Include <winrt\windows>

global state := {
    enableWindowChangeLog: false,
    gui: "",
    gesture: "",
    window: "",
    username: "",
    password: "",
    isSelectWindow: false,
    imeSwitch: {},
}

initState()

; 以管理员权限运行
runWithPrivilege()

#Include <autorun>
#Include <ime>
#Include <tray>

autorun()

#Include <mouse>
#Include <keyboard>
