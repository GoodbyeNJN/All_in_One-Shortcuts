/**
 * https://wyagd001.github.io/v2/docs/AutoHotkey.htm
 */

#HotIf ProcessExist("Code.exe")
>^>+F1:: showConsoleWindow()
>^>+F3:: state.isSelectWindow := !state.isSelectWindow
#HotIf

#HotIf (state.isSelectWindow)
~!LButton:: {
    local winExe := WinGetProcessName("A")
    local result := MsgBox("获取的进程名是否正确？`r`n" . winExe, "提示", "Y/N Icon?")

    if (result != "Yes") {
        return
    }

    local imeConfig := readConfig("imeConfig")
    imeConfig.Push({
        processName: winExe,
        status: 0,
        onCreated: true,
        onActivated: true
    })
    writeConfig(imeConfig, "imeConfig")
}
#HotIf

>^>+F2:: Reload()
