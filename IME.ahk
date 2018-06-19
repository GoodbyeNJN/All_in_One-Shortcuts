;------------------------------------------------------------
; IME段开始
;------------------------------------------------------------
; 读取配置文件中需要更改输入法的窗口名
IniRead, iniClass, config.ini, IME, ClassName
IniRead, iniExe, config.ini, IME, ExeName
IniRead, iniTitle, config.ini, IME, TitleName

Gui, +LastFound
HWND := WinExist()

; RegisterShellHookWindow:  注册窗口消息钩子，注册指定的 Shell 窗口来接收对 Shell 应用有用的某个事件或通知消息
DllCall("RegisterShellHookWindow", "UInt", HWND)

; RegisterWindowMessage:    注册一个新的窗口消息，保证该消息在系统范围内是唯一的
; MsgNum:                   长整型，& C000 到 & FFFF之间的一个消息编号，零表示消息注册失败
; SHELLHOOK:                被注册消息的名字
MsgNum := DllCall("RegisterWindowMessage", "Str", "SHELLHOOK")

; OnMessage:                指定一个函数响应脚本关注的特殊消息.
OnMessage(MsgNum, "Switch_IME")
Return


Switch_IME(wParam, lParam) { ; 处理窗口事件的函数，参数由系统传入
    global iniClass, iniExe, iniSpecial
    WinGetclass, ClassName, ahk_id %lParam%
    WinGet, ExeName, ProcessName, ahk_id %lParam%
    If (ExeName != "" And InStr(iniExe, ExeName)) { ;And (InStr(iniExe, ClassName)) ; 判断获取的进程信息是否在配置文件中
        IME_Set(0, lParam)
    } Else If (ClassName != "" And InStr(iniClass, ClassName) And wParam = 1)
            ; Or (TitleName != "" And InStr(iniTitle, TitleName))
    { ; 消息号wParam = 1即为新建了一个窗口
        /*
            1               WINDOW_CREATED
            2               WINDOWD_ESTROYED
            3               ACTIVATE_SHELLWINDOW
            4               WINDOWA_CTIVATED
            5               GET_MINRECT
            6               REDRAW
            7               TASKMAN
            8               LANGUAGE                ; 仅ShellProc
            9               SYSMENU
            10              ENDTASK                 ; 仅ShellProc
            11              ACCESSIBILITY_STATE     ; 仅ShellProc
            12              APPCOMMAND
            13              WINDOW_REPLACED
            14              WINDOW_REPLACING        ; 仅RegisterShellHookWindow
            32772           RUDEAPPACTIVATED        ; 0x8004，仅RegisterShellHookWindow
            32774           FLASH                   ; 0x8006，仅RegisterShellHookWindow
            MONITORCHANGED  ?                       ; 仅RegisterShellHookWindow
            以上消息号自"WinUser.h"
            其中除后四个，其余见"ShellProc callback function (Windows)"
            后四个见"RegisterShellHookWindow function (Windows)"
        */
        ; 由于程序加载过程需要一定时间，或者加载完但并未处于前台，此处在5、20、60、180秒内一直尝试设置输入法状态
        If ((IME_Set(0, lParam, 5) = 0)
            Or (IME_Set(0, lParam, , 20) = 0)
            Or (IME_Set(0, lParam, , 60) = 0)
            Or (IME_Set(0, lParam, , 180) = 0)) {
            ; 若上一步尝试设置输入法失败，此处判断窗口是否存在，若存在，则在1800秒内再次尝试设置输入法状态
            If (WinExist("ahk_id" . lParam))
                IME_Set(0, lParam, 1800)
        }
    }
}

; 设置输入法
; SetStatus:        0 --> 关闭输入法
;                   1 --> 开启输入法
; WinID/WinExe:     窗口名称，不带ahk_***
; WaitngTime:       尝试设置输入法状态的有效时间，默认3秒
; 返回值:            在有效时间内未设置成功则返回1，成功返回0
IME_Set(SetStatus, WinID:=0, WinExe:=0, WaitngTime:=3) {
    If (WinID = 0)
        ControlGet, WinID, HWND, , , ahk_exe %WinExe%
    WinWaitActive, ahk_id %WinID%, , WaitngTime
    IfEqual, ErrorLevel, 1, Return, ErrorLevel ; WinWaitActive超时后ErrorLevel为1
    ; 判断系统为64位或32位
    PtrSize := !A_PtrSize ? 4 : A_PtrSize
    VarSetCapacity(StGTI, CbSize := (PtrSize*6)+24, 0)
    NumPut(CbSize, StGTI,  0, "UInt")   ; DWORD   cbSize
    WinID := DllCall("GetGUIThreadInfo", "UInt", 0, "UInt", &StGTI) ; 获取前台窗口或GUI信息
            ? NumGet(StGTI, 8+PtrSize, "UInt") : WinID
    Return DllCall("SendMessage"
        , "UInt", DllCall("imm32\ImmGetDefaultIMEWnd", "UInt", WinID)
        , "UInt", 0x0283        ; Message : WM_IME_CONTROL
        ,  "Int", 0x006         ; wParam  : IMC_SETOPENSTATUS
        ,  "Int", SetStatus)    ; lParam  : 0 or 1
}
/*
    IME_Get(WinID:=0, WinExe:=0) {
        If (WinID = 0)
            ControlGet, WinID, HWND, , , ahk_exe %WinExe%
        If (WinExist("ahk_id" . WinID)) Or (WinExist("ahk_exe" . WinExe)) {
            PtrSize := !A_PtrSize ? 4 : A_PtrSize
            VarSetCapacity(StGTI, CbSize := (PtrSize*6)+24, 0)
            NumPut(CbSize, StGTI,  0, "UInt")   ; DWORD   cbSize
            WinID := DllCall("GetGUIThreadInfo", "UInt", 0, "UInt", &StGTI)
                    ? NumGet(StGTI, 8+PtrSize, "UInt") : WinID
        }
        Return DllCall("SendMessage"
            , "UInt", DllCall("imm32\ImmGetDefaultIMEWnd", "UInt", WinID)
            , "UInt", 0x0283        ; Message : WM_IME_CONTROL
            ,  "Int", 0x005         ; wParam  : IMC_GETOPENSTATUS
            ,  "Int", 0)            ; lParam  : 0
    }

    IME_GetConvMode(WinID:=0, WinExe:=0) {
        If (WinID = 0)
            ControlGet, WinID, HWND, , , ahk_exe %WinExe%
        If (WinExist("ahk_id" . WinID)) Or (WinExist("ahk_exe" . WinExe)) {
            PtrSize := !A_PtrSize ? 4 : A_PtrSize
            VarSetCapacity(StGTI, CbSize := (PtrSize*6)+24, 0)
            NumPut(CbSize, StGTI,  0, "UInt")   ; DWORD   cbSize
            WinID := DllCall("GetGUIThreadInfo", "UInt", 0, "UInt", &StGTI)
                    ? NumGet(StGTI, 8+PtrSize, "UInt") : WinID
        }
        Return DllCall("SendMessage"
            , "UInt", DllCall("imm32\ImmGetDefaultIMEWnd", "UInt", WinID)
            , "UInt", 0x0283        ; Message : WM_IME_CONTROL
            ,  "Int", 0x001         ; wParam  : IMC_GETCONVERSIONMODE
            ,  "Int", 0)            ; lParam  : 0
    }

    IME_SetConvMode(ConvStatus, WinID:=0, WinExe:=0) {
        If (WinID = 0)
            ControlGet, WinID, HWND, , , ahk_exe %WinExe%
        If (WinExist("ahk_id" . WinID)) Or (WinExist("ahk_exe" . WinExe)) {
            PtrSize := !A_PtrSize ? 4 : A_PtrSize
            VarSetCapacity(StGTI, CbSize := (PtrSize*6)+24, 0)
            NumPut(CbSize, StGTI,  0, "UInt")   ; DWORD   cbSize
            WinID := DllCall("GetGUIThreadInfo", "UInt", 0, "UInt", &StGTI)
                    ? NumGet(StGTI, 8+PtrSize, "UInt") : WinID
        }
        Return DllCall("SendMessage"
            , UInt, DllCall("imm32\ImmGetDefaultIMEWnd", "UInt", WinID)
            , UInt, 0x0283          ; Message : WM_IME_CONTROL
            ,  Int, 0x002           ; wParam  : IMC_SETCONVERSIONMODE
            ,  Int, ConvStatus)     ; lParam  : CONVERSIONMODE
    }
*/
;------------------------------------------------------------
; IME段结束
;------------------------------------------------------------
