#include <IE.au3>
;_IECreate("http://google.com")
;WinWait("Google")

ShellExecute("Firefox" ,"http://google.com")
winwait("Google")

copyURL()

Func copyURL()
	
	Send("{F6}")
	Send("{CTRLDOWN}")
	Send("{a}")
	Send("{c}")
	Send("{CTRLUP}")

	MsgBox(0, "URL", ClipGet())

EndFunc