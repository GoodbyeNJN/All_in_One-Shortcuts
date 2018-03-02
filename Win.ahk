;------------------------------------------------------------
; Win段开始
;------------------------------------------------------------
; 原计划将RWin用作修饰键，实际测试过程中发现效果不符合预期，所以在系统中
; 将RWin全局替换成AppsKey，以下皆为按下键盘上RWin键所产生的功能。
;------------------------------------------------------------
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

DetectAppsKey() { ; 检测按键函数
    global AppsKeyIsDown
    Input, InputKey, L1 ; 检测单个按键输入并保存到InputKey变量中
    If !AppsKeyIsDown
        Return
    SendStr(InputKey)
    DetectAppsKey() ; 递归调用自身
}

SendStr(InputStr) { ; 发送原样字符函数
    global AppsKeyAnotherKeyIsInput
    AppsKeyAnotherKeyIsInput := 1
    InputStr := Format("{U+{1:#x}}", Ord(InputStr))
    SendInput, %InputStr%
}

*AppsKey::
AppsKeyIsDown := 1
AppsKeyAnotherKeyIsInput := 0
DetectAppsKey()
Return

AppsKey Up::
AppsKeyIsDown := 0
AppsKeyAnotherKeyIsInput := 0
Input, InputKey, T0.01 ; 终止函数中还在等待输入的Input
If !AppsKeyAnotherKeyIsInput ; 没有其他按键输入
    Swtich_IME(-1)
Return
;------------------------------------------------------------
; Win段结束
;------------------------------------------------------------
