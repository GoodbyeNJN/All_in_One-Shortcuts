; 读取配置文件中需要更改输入法的窗口名
IniRead, iniClass, config.ini, IME, ClassName
IniRead, iniExe, config.ini, IME, ExeName
IniRead, iniSpecial, config.ini, IME, SpecialName

Gui, +LastFound
HWND := WinExist()

; RegisterShellHookWindow:	注册窗口消息钩子，注册指定的 Shell 窗口来接收对 Shell 应用有用的某个事件或通知消息
DllCall("RegisterShellHookWindow", "UInt", HWND)

; RegisterWindowMessage:	注册一个新的窗口消息，保证该消息在系统范围内是唯一的
; MsgNum:					长整型，& C000 到 & FFFF之间的一个消息编号，零表示消息注册失败
; SHELLHOOK:				被注册消息的名字
MsgNum := DllCall("RegisterWindowMessage", "Str", "SHELLHOOK")

; OnMessage:				指定一个函数响应脚本关注的特殊消息.
OnMessage(MsgNum, "Switch_IME")
Return


Switch_IME(wParam, lParam) {
	global iniClass, iniExe, iniSpecial
	WinGetclass, ClassName, ahk_id %lParam%
	WinGet, ExeName, ProcessName, ahk_id %lParam%
	If (ExeName != "" And InStr(iniExe, ExeName)) { ;And (InStr(iniExe, ClassName))
		IME_Set(0, lParam)
	} Else If (ClassName != "" And InStr(iniClass, ClassName) And wParam = 1) { ;消息号wParam = 1即为新建了一个窗口
		/*
			1				WINDOW_CREATED
			2				WINDOWD_ESTROYED
			3				ACTIVATE_SHELLWINDOW
			4				WINDOWA_CTIVATED
			5				GET_MINRECT
			6				REDRAW
			7				TASKMAN
			8				LANGUAGE				; 仅ShellProc
			9				SYSMENU
			10				ENDTASK					; 仅ShellProc
			11				ACCESSIBILITY_STATE		; 仅ShellProc
			12				APPCOMMAND
			13				WINDOW_REPLACED
			14				WINDOW_REPLACING		; 仅RegisterShellHookWindow
			32772			RUDEAPPACTIVATED		; 0x8004，仅RegisterShellHookWindow
			32774			FLASH					; 0x8006，仅RegisterShellHookWindow
			MONITORCHANGED	?						; 仅RegisterShellHookWindow
			以上消息号自"WinUser.h"
			其中除后四个，其余见"ShellProc callback function (Windows)"
			后四个见"RegisterShellHookWindow function (Windows)"
		*/
		Loop {
			If (IME_Get(lParam) = 1 And IME_GetConvMode(lParam) = 1025) {
				IME_Set(0, lParam)
				Break
			}
			Sleep, 50
		} Until (IME_Get(lParam) = 0 And IME_GetConvMode(lParam) = 1025)
	}
}

IME_Get(WinID:=0, WinExe:=0) {
	If (WinID = 0)
		ControlGet, WinID, HWND, , , ahk_exe %WinExe%
	If (WinExist("ahk_id" . WinID)) Or (WinExist("ahk_exe" . WinExe)) {
		PtrSize := !A_PtrSize ? 4 : A_PtrSize
		VarSetCapacity(StGTI, CbSize := (PtrSize*6)+24, 0)
		NumPut(CbSize, StGTI,  0, "UInt")	; DWORD   cbSize
		WinID := DllCall("GetGUIThreadInfo", "UInt", 0, "UInt", &StGTI)
				? NumGet(StGTI, 8+PtrSize, "UInt") : WinID
	}
	Return DllCall("SendMessage"
		, "UInt", DllCall("imm32\ImmGetDefaultIMEWnd", "UInt", WinID)
		, "UInt", 0x0283		; Message : WM_IME_CONTROL
		,  "Int", 0x005			; wParam  : IMC_GETOPENSTATUS
		,  "Int", 0)			; lParam  : 0
}

IME_Set(SetStatus, WinID:=0, WinExe:=0) {
	If (WinID = 0)
		ControlGet, WinID, HWND, , , ahk_exe %WinExe%
	If (WinExist("ahk_id" . WinID)) Or (WinExist("ahk_exe" . WinExe)) {
		PtrSize := !A_PtrSize ? 4 : A_PtrSize
		VarSetCapacity(StGTI, CbSize := (PtrSize*6)+24, 0)
		NumPut(CbSize, StGTI,  0, "UInt")	; DWORD   cbSize
		WinID := DllCall("GetGUIThreadInfo", "UInt", 0, "UInt", &StGTI)
				? NumGet(StGTI, 8+PtrSize, "UInt") : WinID
	}
	Return DllCall("SendMessage"
		, "UInt", DllCall("imm32\ImmGetDefaultIMEWnd", "UInt", WinID)
		, "UInt", 0x0283		; Message : WM_IME_CONTROL
		,  "Int", 0x006			; wParam  : IMC_SETOPENSTATUS
		,  "Int", SetStatus)	; lParam  : 0 or 1
}

IME_GetConvMode(WinID:=0, WinExe:=0) {
	If (WinID = 0)
		ControlGet, WinID, HWND, , , ahk_exe %WinExe%
	If (WinExist("ahk_id" . WinID)) Or (WinExist("ahk_exe" . WinExe)) {
		PtrSize := !A_PtrSize ? 4 : A_PtrSize
		VarSetCapacity(StGTI, CbSize := (PtrSize*6)+24, 0)
		NumPut(CbSize, StGTI,  0, "UInt")	; DWORD   cbSize
		WinID := DllCall("GetGUIThreadInfo", "UInt", 0, "UInt", &StGTI)
				? NumGet(StGTI, 8+PtrSize, "UInt") : WinID
	}
	Return DllCall("SendMessage"
    	, "UInt", DllCall("imm32\ImmGetDefaultIMEWnd", "UInt", WinID)
		, "UInt", 0x0283		; Message : WM_IME_CONTROL
		,  "Int", 0x001			; wParam  : IMC_GETCONVERSIONMODE
		,  "Int", 0)			; lParam  : 0
}

IME_SetConvMode(ConvStatus, WinID:=0, WinExe:=0) {
	If (WinID = 0)
		ControlGet, WinID, HWND, , , ahk_exe %WinExe%
	If (WinExist("ahk_id" . WinID)) Or (WinExist("ahk_exe" . WinExe)) {
		PtrSize := !A_PtrSize ? 4 : A_PtrSize
		VarSetCapacity(StGTI, CbSize := (PtrSize*6)+24, 0)
		NumPut(CbSize, StGTI,  0, "UInt")	; DWORD   cbSize
		WinID := DllCall("GetGUIThreadInfo", "UInt", 0, "UInt", &StGTI)
				? NumGet(StGTI, 8+PtrSize, "UInt") : WinID
	}
	Return DllCall("SendMessage"
		, UInt, DllCall("imm32\ImmGetDefaultIMEWnd", "UInt", WinID)
		, UInt, 0x0283			; Message : WM_IME_CONTROL
		,  Int, 0x002			; wParam  : IMC_SETCONVERSIONMODE
		,  Int, ConvStatus)		; lParam  : CONVERSIONMODE
}