;------------------------------------------------------------
; Capslock段开始
;------------------------------------------------------------
ModSendInput(InputKey) {
    global CapsHotKeyIsInput
    SendInput, % InputKey
    CapsHotKeyIsInput := 1
}

*CapsLock::
CapsAnotherKeyIsInput := 0
CapsHotKeyIsInput := 0
SendInput, {CapsLock Up}
; DetectCapsKey()
Return

CapsLock Up::
Input
If (!CapsAnotherKeyIsInput) And (!CapsHotKeyIsInput)
    SetCapsLockState, % GetKeyState("CapsLock", "T") ? "Off" : "On"
CapsAnotherKeyIsInput := 0
CapsHotKeyIsInput := 0
Return

#If GetKeyState("CapsLock", "P")
{
	; CapsLock + ikjluo = 上下左右home end
	i::ModSendInput("{Up}")
	k::ModSendInput("{Down}")
	j::ModSendInput("{Left}")
	l::ModSendInput("{Right}")
	u::ModSendInput("{Home}")
	o::ModSendInput("{End}")

	; Ctrl/Shift/Alt + CapsLock + ikjluo = Ctrl/Shift/Alt + 上下左右home end
	^i::ModSendInput("^{Up}")
	^k::ModSendInput("^{Down}")
	^j::ModSendInput("^{Left}")
	^l::ModSendInput("^{Right}")
	^u::ModSendInput("^{Home}")
	^o::ModSendInput("^{End}")

	+i::ModSendInput("+{Up}")
	+k::ModSendInput("+{Down}")
	+j::ModSendInput("+{Left}")
	+l::ModSendInput("+{Right}")
	+u::ModSendInput("+{Home}")
	+o::ModSendInput("+{End}")

	!i::ModSendInput("!{Up}")
	!k::ModSendInput("!{Down}")
	!j::ModSendInput("!{Left}")
	!l::ModSendInput("!{Right}")
	!u::ModSendInput("!{Home}")
	!o::ModSendInput("!{End}")

	; Ctrl/Shift/Alt组合键 + CapsLock + ikjluo
	^+i::ModSendInput("^+{Up}")
	^+k::ModSendInput("^+{Down}")
	^+j::ModSendInput("^+{Left}")
	^+l::ModSendInput("^+{Right}")
	^+u::ModSendInput("^+{Home}")
	^+o::ModSendInput("^+{End}")

	+!i::ModSendInput("+!{Up}")
	+!k::ModSendInput("+!{Down}")
	+!j::ModSendInput("+!{Left}")
	+!l::ModSendInput("+!{Right}")
	+!u::ModSendInput("+!{Home}")
	+!o::ModSendInput("+!{End}")

	!^i::ModSendInput("!^{Up}")
	!^k::ModSendInput("!^{Down}")
	!^j::ModSendInput("!^{Left}")
	!^l::ModSendInput("!^{Right}")
	!^u::ModSendInput("!^{Home}")
	!^o::ModSendInput("!^{End}")

	^+!i::ModSendInput("^+!{Up}")
	^+!k::ModSendInput("^+!{Down}")
	^+!j::ModSendInput("^+!{Left}")
	^+!l::ModSendInput("^+!{Right}")
	^+!u::ModSendInput("^+!{Home}")
	^+!o::ModSendInput("^+!{End}")

	; Win + CapsLock + ikjluo = Win + 上下左右
	#i::ModSendInput("#{Up}")
	#k::ModSendInput("#{Down}")
	#j::ModSendInput("#{Left}")
	#l::ModSendInput("#{Right}")
	#u::ModSendInput("#{Home}")
	#o::ModSendInput("#{End}")

	; Ctrl + Win + CapsLock + jl = Ctrl + Win + 左右
	#^j::ModSendInput("^#{Left}")
	#^l::ModSendInput("^#{Right}")

	w::ModSendInput("!{F4}") ; CapsLock + w = 发送Alt + F4
	c::ModSendInput("#1") ; CapsLock + c = chrome
	e::ModSendInput("#2") ; CapsLock + e = 文件浏览器

	; CapsLock + d = 最小化本窗口
	d::
	WinMinimize, A
	CapsHotKeyIsInput := 1
	Return

	; CapsLock + r = 任务管理器
	r::
	Run, taskmgr
	CapsHotKeyIsInput := 1
	Return

	; CapsLock + esc = 发送 Alt + F4
	Esc::SendInput, !{F4}
}
#If
;------------------------------------------------------------
; Capslock段结束
;------------------------------------------------------------
