﻿;------------------------------------------------------------
; Alt段开始
;------------------------------------------------------------
DetectAltKey() { ; 检测按键函数
    global
    Input, InputKey, L1 ; 检测单个按键输入并保存到InputKey变量中
    IfNotEqual, RAlt_1, 1, Return ; 检测RAlt是否释放，释放则跳出函数
    RAlt_2 := 0 ; 置空变量，防止执行If下的语句
    DetectAltKey() ; 递归调用自身
}
/*
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
*/
*RAlt::
RAlt_2 := RAlt_1 := 1
DetectAltKey()
Return

RAlt Up::
If RAlt_2 ; 1表示按下了RAlt键，且中途没有按下其他按键
    Swtich_IME(-1) ; 切换输入法
Input, InputKey, T0.01 ; 终止函数中还在等待输入的Input
RAlt_2 := RAlt_1 := 0 ; 置空变量
Return

; RAlt + ikjluo = 上下左右home end
>!i::SendInput, {Up}
>!k::SendInput, {Down}
>!j::SendInput, {Left}
>!l::SendInput, {Right}
>!u::SendInput, {Home}
>!o::SendInput, {End}

; Ctrl/Shift/LAlt + RAlt + ikjluo = Ctrl/Shift/Alt + 上下左右home end
^>!i::SendInput, ^{Up}
^>!k::SendInput, ^{Down}
^>!j::SendInput, ^{Left}
^>!l::SendInput, ^{Right}
^>!u::SendInput, ^{Home}
^>!o::SendInput, ^{End}

+>!i::SendInput, +{Up}
+>!k::SendInput, +{Down}
+>!j::SendInput, +{Left}
+>!l::SendInput, +{Right}
+>!u::SendInput, +{Home}
+>!o::SendInput, +{End}

<!>!i::SendInput, !{Up}
<!>!k::SendInput, !{Down}
<!>!j::SendInput, !{Left}
<!>!l::SendInput, !{Right}
<!>!u::SendInput, !{Home}
<!>!o::SendInput, !{End}

; Ctrl/Shift/LAlt组合键 + RAlt + ikjluo
^+>!i::SendInput, ^+{Up}
^+>!k::SendInput, ^+{Down}
^+>!j::SendInput, ^+{Left}
^+>!l::SendInput, ^+{Right}
^+>!u::SendInput, ^+{Home}
^+>!o::SendInput, ^+{End}

+<!>!i::SendInput, +!{Up}
+<!>!k::SendInput, +!{Down}
+<!>!j::SendInput, +!{Left}
+<!>!l::SendInput, +!{Right}
+<!>!u::SendInput, +!{Home}
+<!>!o::SendInput, +!{End}

<!^>!i::SendInput, !^{Up}
<!^>!k::SendInput, !^{Down}
<!^>!j::SendInput, !^{Left}
<!^>!l::SendInput, !^{Right}
<!^>!u::SendInput, !^{Home}
<!^>!o::SendInput, !^{End}

^+<!>!i::SendInput, ^+!{Up}
^+<!>!k::SendInput, ^+!{Down}
^+<!>!j::SendInput, ^+!{Left}
^+<!>!l::SendInput, ^+!{Right}
^+<!>!u::SendInput, ^+!{Home}
^+<!>!o::SendInput, ^+!{End}

; Ctrl + Win + RAlt + jl = Ctrl + Win + 左右
#^>!j::SendInput, ^#{Left}
#^>!l::SendInput, ^#{Right}

; RAlt + BackSpace = Delete
>!BackSpace::SendInput, {Delete}

; Intellij IDEA窗口激活时，RAlt + Enter = Ctrl + Shift + Enter
#IfWinActive, ahk_class SunAwtFrame
>!Enter::SendInput, ^+{Enter}
#If
;------------------------------------------------------------
; Alt段结束
;------------------------------------------------------------
