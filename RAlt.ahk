;------------------------------------------------------------
; RAlt段开始
;------------------------------------------------------------
DetectAltKey() { ; 检测按键函数
    If !GetKeyState("RAlt", "P")
        Return
    Input, InputKey, IL1 ; 检测单个按键输入并保存到InputKey变量中
    If (ErrorLevel = "NewInput")
        DetectAltKey()
    SendStr(InputKey)
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

*RAlt::
AltAnotherKeyIsInput := 0
SendInput, {RAlt Up}
DetectAltKey()
Return

RAlt Up::
Input ; 终止函数中还在等待输入的Input
If !AltAnotherKeyIsInput ; 表示按下了RAlt键，且中途没有按下其他按键
    Swtich_IME(-1) ; 切换输入法
AltAnotherKeyIsInput := 0
Return

#If GetKeyState("RAlt", "P")
; Intellij IDEA窗口激活时，RAlt + Enter = Ctrl + Shift + Enter
Enter::
Input ; 终止函数中还在等待输入的Input
SendInput, +{Enter}
AltAnotherKeyIsInput := 1
Return
#If
;------------------------------------------------------------
; RAlt段结束
;------------------------------------------------------------
