#Requires AutoHotkey v2.0

; use task scheduler to run with highest privileges at log on

; ┌─────────────────────┐
; │ PowerToys Overrides │
; └─────────────────────┘

#s::SendInput('!#{Space}')
#r::SendInput('!{Space}')

; ┌───────────────────────┐
; │ Window Manager Tweaks │
; └───────────────────────┘

; Gnome-Like Keyboard Shortcuts

#PgUp::SendInput('^#{Left}')
#PgDn::SendInput('^#{Right}')
#WheelUp::SendInput('^#{Left}')
#WheelDown::SendInput('^#{Right}')

; scroll on taskbar -> Switch Workspaces

#HotIf IsTaskbarScrollActive()
    *WheelUp::SendInput('^#{Left}')
    *WheelDown::SendInput('^#{Right}')
#HotIf

IsTaskbarScrollActive() {
    MouseGetPos(,, &win_hwnd, &ctrl_classnn)
    if !win_hwnd || WinGetClass("ahk_id " . win_hwnd) != "Shell_TrayWnd" {
        return false
    }
    if (ctrl_classnn = "TrayNotifyWnd1" || ctrl_classnn = "ToolbarWindow321") {
        return false ; It's the tray area, so disable the hotkeys.
    }
    return true
}

; double press win key -> Multitasking View

~LWin Up:: {
    if (A_PriorKey = "LWin") {
        if (IsNumber(A_TimeSincePriorHotkey) && A_TimeSincePriorHotkey < 400 && A_PriorHotkey = "~LWin Up") {
            Send("#`t") ; Send Win+Tab
        }
    }
}

~RWin Up:: {
    if (A_PriorKey = "RWin") {
        if (IsNumber(A_TimeSincePriorHotkey) && A_TimeSincePriorHotkey < 400 && A_PriorHotkey = "~RWin Up") {
            Send("#`t")
        }
    }
}
