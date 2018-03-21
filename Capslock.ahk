;------------------------------------------------------------
; Capslock段开始
;------------------------------------------------------------
SendKey(Key) {
	global CapsLockAnotherKeyIsInput
	SendInput, %Key%
	CapsLockAnotherKeyIsInput := 1 ; 置空变量，防止执行If下的语句
}

CapsLock::
CapsLockIsDown := 1
CapsLockAnotherKeyIsInput := 0
KeyWait, CapsLock
If !CapsLockAnotherKeyIsInput ; 按下了CapsLock键，且中途没有按下其他按键
	SetCapsLockState, % GetKeyState("CapsLock", "T")
						? "Off" : "On" ; 切换CapsLock状态
CapsLockIsDown := 0
CapsLockAnotherKeyIsInput := 0
Return

#If CapsLockIsDown ; 正处于按下CapsLock键的状态时触发
{
	w::SendKey("!{F4}") ; CapsLock + w = 发送Alt + F4
	c::SendKey("#1") ; CapsLock + c = chrome
	e::SendKey("#2") ; CapsLock + e = 文件浏览器

	; CapsLock + d = 最小化本窗口
	d::
	WinMinimize, A
	CapsLockAnotherKeyIsInput := 1
	Return

	; CapsLock + r = 任务管理器
	r::
	Run, taskmgr
	CapsLockAnotherKeyIsInput := 1
	Return
}
#If
;------------------------------------------------------------
; Capslock段结束
;------------------------------------------------------------
