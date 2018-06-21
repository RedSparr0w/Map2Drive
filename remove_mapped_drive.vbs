CreateObject("Wscript.Shell").Run "C:\WINDOWS\system32\net.exe use " & Left(WScript.Arguments(0),1) & ": /delete /y", 0, False

WScript.Quit
