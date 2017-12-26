; chrome中调用迅雷下载链接
#IfWinActive, ahk_class Chrome_WidgetWin_1
^d::
Run, C:\Program Files (x86)\Thunder Network\MiniThunder\Bin\ThunderMini.exe
WinWait, 迅雷精简版
SendInput, ^n
SendInput, ^v
Return
#If

; 当前资源管理器目录下调用everything搜索
#IfWinActive, ahk_class CabinetWClass
^f::
Send, !c
Run, C:\Program Files\Everything\Everything.exe
WinWait, ahk_class EVERYTHING
ControlSetText, Edit1, "%Clipboard%"%A_space%
Send, {End}
Return
#If

; Ctrl + ESC = 发送Alt + F4
^Esc::SnedKey("!{F4}")

#If, GetKeyState("ScrollLock", "T")
; ScrollLock打开时，jkluio键输入数字
j::SendInput, 1
k::SendInput, 2
l::SendInput, 3
u::SendInput, 4
i::SendInput, 5
o::SendInput, 6
#If

#c::SendInput, #{F9} ; Win + c = ditto
#t::WinSet, AlwaysOnTop, Toggle, A ; Win + t = 当前窗口置顶
#f::Run, C:\Program Files\Everything\Everything.exe ; Win + f = everything
