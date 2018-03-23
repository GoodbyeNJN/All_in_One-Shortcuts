;------------------------------------------------------------
; LAlt段开始
;------------------------------------------------------------
; 通过 LAlt + CapsLock 来开关 LAlt 相关的方向键功能，默认开启
LAlt & CapsLock::FuncLAltIsDisabled := !FuncLAltIsDisabled

#If !FuncLAltIsDisabled
; LAlt + ikjluo = 上下左右home end
<!i::SendInput, {Up}
<!k::SendInput, {Down}
<!j::SendInput, {Left}
<!l::SendInput, {Right}
<!u::SendInput, {Home}
<!o::SendInput, {End}

; Ctrl/Shift/RAlt + LAlt + ikjluo = Ctrl/Shift/Alt + 上下左右home end
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

; >!<!i::SendInput, !{Up}
; >!<!k::SendInput, !{Down}
; >!<!j::SendInput, !{Left}
; >!<!l::SendInput, !{Right}
; >!<!u::SendInput, !{Home}
; >!<!o::SendInput, !{End}

; Ctrl/Shift/RAlt组合键 + LAlt + ikjluo
^+<!i::SendInput, ^+{Up}
^+<!k::SendInput, ^+{Down}
^+<!j::SendInput, ^+{Left}
^+<!l::SendInput, ^+{Right}
^+<!u::SendInput, ^+{Home}
^+<!o::SendInput, ^+{End}

; +>!<!i::SendInput, +!{Up}
; +>!<!k::SendInput, +!{Down}
; +>!<!j::SendInput, +!{Left}
; +>!<!l::SendInput, +!{Right}
; +>!<!u::SendInput, +!{Home}
; +>!<!o::SendInput, +!{End}

; >!^<!i::SendInput, !^{Up}
; >!^<!k::SendInput, !^{Down}
; >!^<!j::SendInput, !^{Left}
; >!^<!l::SendInput, !^{Right}
; >!^<!u::SendInput, !^{Home}
; >!^<!o::SendInput, !^{End}

; ^+>!<!i::SendInput, ^+!{Up}
; ^+>!<!k::SendInput, ^+!{Down}
; ^+>!<!j::SendInput, ^+!{Left}
; ^+>!<!l::SendInput, ^+!{Right}
; ^+>!<!u::SendInput, ^+!{Home}
; ^+>!<!o::SendInput, ^+!{End}

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
;------------------------------------------------------------
; LAlt段结束
;------------------------------------------------------------
