个人常用的快捷键集合
# 功能

## CapsLock

Capslock + W：发送Alt + F4  
Capslock + D：最小化本窗口  
Capslock + R：任务管理器  
Capslock + C：chrome  
Capslock + E：文件浏览器  

## Alt

LAlt + IKJLUO：上下左右home end  
Ctrl/Shift + LAlt + ikjluo：Ctrl/Shift + 上下左右home end  
Win + LAlt + ikjluo：Win + 上下左右  
Ctrl + Win + LAlt + jl：Ctrl + Win + 左右 （Win10 中切换虚拟桌面用）  
LAlt + BackSpace：Delete  
RAlt：切换输入法  
RAlt + 某些标点：输出英文标点  
RAlt + 字母：直接上屏字母  
RAlt + Shift + 某些标点：输出Shift+英文标点  
RAlt + Shift + 字母：直接上屏大写字母  
RAlt + Enter：Ctrl + Shift + Enter （在Intellij IDEA窗口中）  

## Ctrl

Ctrl + F：在当前目录下调用everything搜索  
Ctrl + D：在chrome中调用迅雷下载链接  

## Win

Win + T：置顶窗口  
Win + F：everything  

## 滚轮

屏幕右上角滚动调节音量  
屏幕下沿滚动切换虚拟桌面  
~~chrome标签页区域滚动切换标签~~ (脚本中保留相关代码，但不启用)  

## ~~右键~~

~~chrome标签页区域与中键交换功能~~ (脚本中保留相关代码，但不启用)  

## 中键

屏幕下沿按下调出虚拟桌面管理器  

## 前进键

屏幕右边缘发送Ctrl + Alt + Z  

## 后退键

屏幕右变松发送Ctrl + Alt + W  

## config.ini 文件

在 IME 节 ClassName 键下填写需要在打开时自动切换到英文输入状态的程序窗口类名，ExeName 键下填写需要始终保持英文输入状态的程序进程名，SpecialName 键下填写切换输入状态异常的程序进程名，将强制保持系统英文键盘布局，例如 Xshell 5  
一个典型的配置文件如下，多个值之间由半角“,”分隔  
````
[IME]
ClassName=Notepad++,mintty,PX_WINDOW_CLASS,Photoshop,AfxMDIFrame100u,IrfanView
ExeName=
SpecialName=Xshell.exe
````
