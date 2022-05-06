#SingleInstance Force
#NoTrayIcon
SendMode "Input"
SetWorkingDir A_ScriptDir
SetTitleMatchMode 2
FileEncoding "UTF-8"

#DllLoad "imm32"

#Include "%A_ScriptDir%"
#Include <constant>
#Include <common>
#Include <json>
#Include <console>
#Include <debug>

global state := {
        username: A_UserName,
        password: A_Args[1],

        isSelectWindow: False,

        imeSwitch: {},
    }

initState()

; 以管理员权限重启
restartWithPrivilege()

; 以调试模式重启
; restartInDebugMode()

#Include <autorun>
#Include <ime>

autorun()

#Include <mouse>
#Include <keyboard>
