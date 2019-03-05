;------------------------------------------------------------
; F14段开始
;------------------------------------------------------------
DetectAltKey() { ; 检测按键函数
    global AltHotKeyIsInput
    If !GetKeyState("F14", "P")
        Return
    Input, InputKey, IL1 ; 检测单个按键输入并保存到InputKey变量中
    If (ErrorLevel = "NewInput"){
        If !GetKeyState("F14", "P")
            Return
        Else If (AltHotKeyIsInput = 0)
            SendStr(InputKey)
    } Else If (ErrorLevel = "Max") {
        SendStr(InputKey)
    }
    DetectAltKey() ; 递归调用自身
}

SendStr(InputStr) { ; 发送原样字符函数
    global AltAnotherKeyIsInput
    AltAnotherKeyIsInput := 1 ; 置空变量，防止执行If下的语句
    SendInput, % Format("{U+{1:#x}}", Ord(InputStr))
}

Swtich_IME(NewState) { ; 切换输入法函数，-1为切换
    PtrSize := !A_PtrSize ? 4 : A_PtrSize
    VarSetCapacity(StGTI, CbSize := (PtrSize*6)+24, 0)
    NumPut(CbSize, StGTI,  0, "UInt")
    DllCall("GetGUIThreadInfo", "UInt", 0, "UInt", &StGTI)
    HWND := NumGet(StGTI, 8+PtrSize, "UInt")
    If (NewState = -1) {
        PreviousState := DllCall("SendMessage"
            , "UInt", DllCall("imm32\ImmGetDefaultIMEWnd", "UInt", HWND)
            , "UInt", 0x0283
            ,  "Int", 0x0005
            ,  "Int", 0)
        Return DllCall("SendMessage"
            , "UInt", DllCall("imm32\ImmGetDefaultIMEWnd", "UInt", HWND)
            , "UInt", 0x0283
            ,  "Int", 0x006
            ,  "Int", !PreviousState)
    } Else {
        Return DllCall("SendMessage"
            , "UInt", DllCall("imm32\ImmGetDefaultIMEWnd", "UInt", HWND)
            , "UInt", 0x0283
            ,  "Int", 0x006
            ,  "Int", NewState)
    }
}

F14::Swtich_IME(-1)

; *F14::
; AltAnotherKeyIsInput := 0
; AltHotKeyIsInput := 0
; SendInput, {F14 Up}
; DetectAltKey()
; Return

; F14 Up::
; Input ; 终止函数中还在等待输入的Input
; If !AltAnotherKeyIsInput ; 表示按下了F14键，且中途没有按下其他按键
;     Swtich_IME(-1) ; 切换输入法
; AltAnotherKeyIsInput := 0
; AltHotKeyIsInput := 0
; Return
;------------------------------------------------------------
; F14段结束
;------------------------------------------------------------


;------------------------------------------------------------
; F段开始
;------------------------------------------------------------
; F13 = 窗口居中
F13::
WinGet, WindowState, MinMax, A
WinGetPos, , , WindowWidth, WindowHeight, A
; MsgBox, % WindowWidth . ", " . WindowHeight . ", " . WindowState
If (WindowState != 0)
    Return
WinMove, A, , (A_ScreenWidth/2)-(WindowWidth/2), (A_ScreenHeight/2)-(WindowHeight/2)
Return

; F15 = 最小化本窗口
F15::
WinMinimize, A
CapsHotKeyIsInput := 1
Return

F16::
SendInput, ^!c
Return

F17::
Run, C:\Program Files\Everything\Everything.exe
Return

; F18 = wox翻译
F18::
SendInput, ^c
SendInput, !{Space}
Send, {Text}fy
Clipboard := " " . Clipboard
SendInput, ^v
Return
;------------------------------------------------------------
; F段结束
;------------------------------------------------------------
