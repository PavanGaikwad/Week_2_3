#include <IE.au3>


$IE_OBJ = _IECreate("http://google.com")
WinWait("Google")

; Get the URL from IE
$URL = _IEPropertyGet($IE_OBJ, "locationurl")

;ShellExecute("Firefox" ,"http://google.com")
;winwait("Google")

;copyURL_With_KS()


; Get URL by sending Key Strokes
Func copyURL_With_KS()
	
	Send("{F6}")
	Send("{CTRLDOWN}")
	Send("{a}")
	Send("{c}")
	Send("{CTRLUP}")

	MsgBox(0, "URL", ClipGet())

EndFunc