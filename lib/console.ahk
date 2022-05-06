class ConsoleWindow {
    isShown := false
    window := {}
    editor := {}

    __New(options := "", title := "") {
        if (!options) {
            options := "+AlwaysOnTop"
        }
        if (!title) {
            title := "调试控制台"
        }

        this.window := Gui(options, title)
        this.window.SetFont(, "等距更纱黑体 SC")
        this.window.MarginX := 0
        this.window.MarginY := 0

        ; this.window.Add("Tab3", , ["All", ])
        this.editor := this.window.Add("Edit", "+Multi +ReadOnly")

        this.window.OnEvent("Close", this.onClose)
    }

    show(options := "") {
        if (!options) {
            options := "W300 H600"
        }

        this.isShown := true
        this.editor.Value .= ""
        this.window.Show(options)
        this.resize()
    }

    resize() {
        local w := 0
        local h := 0

        this.window.GetClientPos(, , &w, &h)
        this.editor.Move(, , w, h)
    }

    scrollToBottom() {
        SendMessage(WM_VSCROLL, SB_BOTTOM, , this.editor.Hwnd)
    }

    update(text) {
        if (!this.isShown) {
            return
        }

        this.editor.Value .= text
        this.scrollToBottom()
    }

    onClose() {
        this.isShown := false
    }
}

class console {
    static _log(level := "info", params*) {
            local string := ""
            for (v in params) {
                if (string != "") {
                    string .= " "
                }

                string .= IsObject(v) ? JsonStringify(v, " ", 2) : v
            }
            string .= "`n"

            ; try {
            ;     FileAppend(string, "*")
            ; }

            try {
                state.window.update(string)
            }
        }

    static log(params*) {
            console._log("info", params*)
        }

    static debug(params*) {
            console._log("debug", params*)
        }

    static info(params*) {
            console._log("info", params*)
        }

    static warn(params*) {
            console._log("warn", params*)
        }

    static error(params*) {
        console._log("error", params*)
    }
}

showConsoleWindow() {
    state.window := ConsoleWindow()
    state.window.show()
}
