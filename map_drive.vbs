if InStr(2,WScript.Arguments(0),":") = 2 then
  mapPath = "\\localhost\" & Replace(WScript.Arguments(0),":","$")
else
  mapPath = WScript.Arguments(0)
end if

if WScript.Arguments(1) = "auto" then
  CreateObject("Wscript.Shell").Run "C:\WINDOWS\system32\net.exe use * " & chr(34) & mapPath & chr(34), 0, False
else
  mapDriveLetter = InputBox("Enter a drive letter:","Map2Drive")
  mapDriveLetter = Left(mapDriveLetter,1) & ":"

  mapDriveName = InputBox("Enter name for your drive " & mapDriveLetter & "\", "Map2Drive")

  result = MsgBox ("Would you like this drive to persist across reboots?", vbYesNo, "Map2Drive")
  Select Case result
  Case vbYes
      mapPersist = "yes"
  Case vbNo
      mapPersist = "no"
  End Select

  CreateObject("Wscript.Shell").Run "C:\WINDOWS\system32\net.exe use " & mapDriveLetter & " " & chr(34) & mapPath & chr(34) & " /P:" & mapPersist, 0, False

  WScript.Sleep 5000

  Set objShell = CreateObject("Shell.Application")
  objShell.NameSpace(mapDriveLetter).Self.Name = mapDriveName
end if

WScript.Quit
