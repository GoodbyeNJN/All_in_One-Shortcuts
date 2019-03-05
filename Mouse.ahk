;------------------------------------------------------------
; Mouse段开始
;------------------------------------------------------------
; 屏幕坐标与屏幕分辨率相关，具体数值由Launcher脚本运行时获取。
; 原计划包含chrome标签栏快捷操作功能，现在改用了CentBrowser，已自带标签
; 栏快捷功能，所以注释了一部分内容。
;------------------------------------------------------------
MousePos(X, Y) { ; 判断当前鼠标相对于屏幕的坐标是否匹配传入的坐标，X为0时仅判断Y是否匹配，Y为0同理
	CoordMode, Mouse, Screen
	MouseGetPos, MouseX, MouseY ; 获取鼠标相对于屏幕的坐标
	If (X = -1) {
		Return, % Y = MouseY ? "1" : "0"
	} Else If (Y = -1) {
		Return, % X = MouseX ? "1" : "0"
	} Else {
		Return, % (X = MouseX And Y = MouseY) ? "1" : "0"
	}
}
/*
	ChromeMousePos() { ; 判断鼠标位置是否在chrome标签栏区域
		CoordMode, Mouse, Window
		MouseGetPos, MouseX, MouseY ; 获取鼠标相对于chrome的坐标
		WinGet, ChromeState, MinMax ; 获取chrome最大化或窗口化状态
		WinGetPos, , , ChromeWidth, , ahk_class Chrome_WidgetWin_1 ; 获取鼠chrome窗口的宽度
		If (ChromeState = 1) {
			Return, % (MouseY >= 8 And MouseY <= 36) ? "1" : "0"
		} Else If (ChromeState = 0) {
			Return, % (MouseX >= 0 And MouseX <= ChromeWidth) And (MouseY >= 0 And MouseY <= 47) ? "1" : "0"
		}
	}
*/
; 滚轮在屏幕右上角滚动调节音量
#If MousePos(RightEdgePos, 0)
WheelUp::SendInput, {Volume_Up}
WheelDown::SendInput, {Volume_Down}
#If

; 滚轮在屏幕下边缘切换虚拟桌面
#If MousePos(-1, BottomEdgePos)
WheelUp::SendInput, ^#{Left}
WheelDown::SendInput, ^#{Right}
#If

; 在屏幕下边缘按下滚轮调出虚拟桌面管理
#If MousePos(-1, BottomEdgePos)
MButton::SendInput, #{Tab}
#If

; 在屏幕右边缘按下前进键发送Ctrl + Alt +z，后退键发送Ctrl + Alt +w
#If MousePos(RightEdgePos, -1)
XButton2::SendInput, ^!z
XButton1::SendInput, ^!w
#If
/*
	; 在chrome标签栏区域滚轮切换标签，按下右键发送中键
	#If WinActive("ahk_class Chrome_WidgetWin_1") And ChromeMousePos()
	WheelUp::SendInput, ^{PgUp}
	WheelDown::SendInput, ^{PgDn}
	RButton::SendInput, {MButton}
	#If

	; 按下后退键临时降低鼠标速度
	XButton1::
	SPI_GETMOUSESPEED := 0x70, SPI_SETMOUSESPEED := 0x71
	; 获取鼠标当前的速度
	DllCall("SystemParametersInfo", "UInt", SPI_GETMOUSESPEED, "UInt", 0, "UIntP", OrigMouseSpeed, "UInt", 0)
	; 倒数第二个参数为需要设置的速度 (范围为 1-20, 10 是默认值)
	DllCall("SystemParametersInfo", "UInt", SPI_SETMOUSESPEED, "UInt", 0, "Ptr", 3, "UInt", 0)
	SendInput, {XButton1}
	Return

	XButton1 up::
	; 恢复原来的速度
	DllCall("SystemParametersInfo", "UInt", 0x71, "UInt", 0, "Ptr", OrigMouseSpeed, "UInt", 0)
	Return
*/
;------------------------------------------------------------
; Mouse段结束
;------------------------------------------------------------
