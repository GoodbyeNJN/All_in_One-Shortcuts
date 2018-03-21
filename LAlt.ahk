;------------------------------------------------------------
; LAlt段开始
;------------------------------------------------------------
; 通过 LAlt + CapsLock 来开关 LAlt 相关的方向键功能，默认启动时关闭
LAlt & CapsLock::FuncLAltIsEnabled := !FuncLAltIsEnabled

#If FuncLAltIsEnabled
; LAlt + ikjluo = 上下左右home end
<!i::SendInput, {Up}
<!k::SendInput, {Down}
<!j::SendInput, {Left}
<!l::SendInput, {Right}
<!u::SendInput, {Home}
<!o::SendInput, {End}

; Ctrl/Shift/LAlt + LAlt + ikjluo = Ctrl/Shift/Alt + 上下左右home end
^<!i::SendInput, ^{Up}
^<!k::SendInput, ^{Down}
^<!j::SendInput, ^{Left}
^<!l::SendInput, ^{Right}
^<!u::SendInput, ^{Home}
^<!o::SendInput, ^{End}

+<!i::SendInput, +{Up}
+<!k::SendInput, +{Down}
+<!j::SendInput, +{Left}
+<!l::SendInput, +{Right}
+<!u::SendInput, +{Home}
+<!o::SendInput, +{End}

>!<!i::SendInput, !{Up}
>!<!k::SendInput, !{Down}
>!<!j::SendInput, !{Left}
>!<!l::SendInput, !{Right}
>!<!u::SendInput, !{Home}
>!<!o::SendInput, !{End}

; Ctrl/Shift/LAlt组合键 + LAlt + ikjluo
^+<!i::SendInput, ^+{Up}
^+<!k::SendInput, ^+{Down}
^+<!j::SendInput, ^+{Left}
^+<!l::SendInput, ^+{Right}
^+<!u::SendInput, ^+{Home}
^+<!o::SendInput, ^+{End}

+>!<!i::SendInput, +!{Up}
+>!<!k::SendInput, +!{Down}
+>!<!j::SendInput, +!{Left}
+>!<!l::SendInput, +!{Right}
+>!<!u::SendInput, +!{Home}
+>!<!o::SendInput, +!{End}

>!^<!i::SendInput, !^{Up}
>!^<!k::SendInput, !^{Down}
>!^<!j::SendInput, !^{Left}
>!^<!l::SendInput, !^{Right}
>!^<!u::SendInput, !^{Home}
>!^<!o::SendInput, !^{End}

^+>!<!i::SendInput, ^+!{Up}
^+>!<!k::SendInput, ^+!{Down}
^+>!<!j::SendInput, ^+!{Left}
^+>!<!l::SendInput, ^+!{Right}
^+>!<!u::SendInput, ^+!{Home}
^+>!<!o::SendInput, ^+!{End}

; Win + LAlt + ikjluo = Win + 上下左右
#<!i::SendInput, #{Up}
#<!k::SendInput, #{Down}
#<!j::SendInput, #{Left}
#<!l::SendInput, #{Right}
#<!u::SendInput, #{Home}
#<!o::SendInput, #{End}

; Ctrl + Win + LAlt + jl = Ctrl + Win + 左右
#^<!j::SendInput, ^#{Left}
#^<!l::SendInput, ^#{Right}

; LAlt + BackSpace = Delete
<!BackSpace::SendInput, {Delete}
#If

; Intellij IDEA窗口激活时，RAlt + Enter = Ctrl + Shift + Enter
#IfWinActive, ahk_class SunAwtFrame
>!Enter::SendInput, ^+{Enter}
#If
;------------------------------------------------------------
; LAlt段结束
;------------------------------------------------------------
