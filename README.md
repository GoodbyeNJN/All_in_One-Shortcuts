个人常用的快捷键集合
# 功能
## CapsLock
Capslock + Backspace：删除本行  
~~Capslock + JKLUIO7890：数字1234567890~~  
Capslock + W：发送Alt + F4  
~~Capslock + Space：发送Alt + Tab~~    
Capslock + D：最小化本窗口  
Capslock + R：任务管理器  
Capslock + C：chrome  
Capslock + E：文件浏览器  
## Alt
LAlt + IKJLUO：上下左右home end  
RAlt：切换输入法  
RAlt + 某些标点：输出英文标点  
RAlt + 字母：输出字母  
RAlt + Shift + 某些标点：输出Shift英文标点  
RAlt + Shift + 字母：输出大写字母  
## Ctrl
~~Ctrl + <>""(){}：成对输出符号~~  
Ctrl + F：在当前目录下调用everything搜索  
Ctrl + D：在chrome中调用迅雷下载链接  
~~## Scrolllock~~
~~Scrolllock：数字区常开~~  
## Win
Win + C：Dittoff  
Win + T：置顶窗口  
Win + F：everything  
## 滚轮
屏幕右上角滚动调节音量  
屏幕下沿滚动切换虚拟桌面  
chrome标签页区域滚动切换标签  
## 右键
chrome标签页区域与中键交换功能  
## 中键
屏幕下沿按下调出虚拟桌面管理器  
## 前进键
屏幕右边缘发送Ctrl + Alt + Z
## config.ini 文件
在 IME 节 ClassName 键下填写需要在打开时自动切换到英文输入状态的程序窗口类名，ExeName 键下填写需要始终保持英文输入状态的程序进程名，SpecialName 键下填写切换输入状态异常的程序进程名，将强制保持系统英文键盘布局，例如 Xshell 5  
一个典型的配置文件如下，多个值之间由半角“,”分隔  
````
[IME]
ClassName=Notepad++,mintty,PX_WINDOW_CLASS,Photoshop,AfxMDIFrame100u,IrfanView
ExeName=
SpecialName=Xshell.exe
````
