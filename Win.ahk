;------------------------------------------------------------
; Win段开始
;------------------------------------------------------------
#t::WinSet, AlwaysOnTop, Toggle, A ; Win + t = 当前窗口置顶
#f::Run, C:\Program Files\Everything\Everything.exe ; Win + f = everything

; Snipaste 相关热键，Win + A 替换 F1，Win + S 替换 F3
#a::SendInput, ^#{PrintScreen}
^#a::SendInput, ^{PrintScreen}
+#a::SendInput, +{PrintScreen}
#s::SendInput, #{F12}
+#s::SendInput, +#{F12}
^#s::SendInput, ^#{F12}
;------------------------------------------------------------
; Win段结束
;------------------------------------------------------------
