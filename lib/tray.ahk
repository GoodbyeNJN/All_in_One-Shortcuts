addToggleImeOption() {
    local name := "切换中/英输入状态"

    A_TrayMenu.Insert("&Open", name, toggleIme.Bind())
    A_TrayMenu.Insert()

    A_TrayMenu.ClickCount := 1
    A_TrayMenu.Default := name

}

setImeIcon(imeSwitch) {
    if (imeSwitch.status) {
        TraySetIcon(IME_ON_ICON)
    } else {
        TraySetIcon(IME_OFF_ICON)
    }
}
