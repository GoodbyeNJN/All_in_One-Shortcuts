SendKey(Key) {
	global CapsLockState_2
	SendInput, %Key%
	CapsLockState_2 := 0 ; 置空变量，防止执行If下的语句
}

CapsLock::
CapsLockState_2 := CapsLockState_1 := 1
KeyWait, CapsLock
If CapsLockState_2 ; 1表示按下了CapsLock键，且中途没有按下其他按键
	SetCapsLockState, % GetKeyState("CapsLock", "T") ? "Off" : "On"
	; GetKeyState获取CapsLock状态，返回1则匹配Off，传递到SetCapsLockState
CapsLockState_2 := CapsLockState_1 := 0 ; 置空变量
Return

#If CapsLockState_1 ; 1表示正处于按下CapsLock键的状态
{
	w::SendKey("!{F4}") ; CapsLock + w = 发送Alt + F4
	c::SendKey("#1") ; CapsLock + c = chrome
	e::SendKey("#2") ; CapsLock + e = 文件浏览器

	; CapsLock + d = 最小化本窗口
	d::
	WinMinimize, A
	CapsLockState_2 := 0
	Return

	; CapsLock + r = 任务管理器
	r::
	Run, taskmgr
	CapsLockState_2 := 0
	Return
}
#If