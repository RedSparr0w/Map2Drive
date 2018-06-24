Select Case WScript.Arguments(0)
  Case "Mount"
    mount_path = getPath(WScript.Arguments(1))
    If WScript.Arguments(2) = "Auto" Then
      drive_letter = "*"
      drive_name = ""
      drive_persist = "no"
    Else
      drive_letter = getDriveLetter(False)
      drive_name = getDriveName()
      drive_persist = shouldDrivePersist()
    End If

    Call mountDrive(mount_path, drive_letter, drive_name, drive_persist)
  Case "Rename"
    drive_name = getDriveName()
    Call renameDrive(WScript.Arguments(1), drive_name)
  Case "Remove"
    Call removeDrive(WScript.Arguments(1))
  Case Else
End Select


WScript.Quit

Function getPath(map_path)
  if InStr(2, map_path, ":") = 2 then
    getPath = "\\localhost\" & Replace(map_path, ":", "$")
  else
    getPath = map_path
  end if
End Function

Function getDriveLetter(error_message)
  If error_message <> False Then
    drive_letter = InputBox("Enter a drive letter:" & vbCrlf & error_message, "Map2Drive", "Z")
  Else
    drive_letter = InputBox("Enter a drive letter:", "Map2Drive", "Z")
  End If

  If IsEmpty(drive_letter) Then
    WScript.Quit
  Else
    If regexTest("^[a-z][:\\//]{0,2}$", drive_letter) Then
      drive_letter = UCase(Left(drive_letter,1)) & ":"
      If doesDriveExist(drive_letter) Then
        getDriveLetter = getDriveLetter(drive_letter & " drive already in use!")
      Else
        getDriveLetter = drive_letter
      End If
    Else
      getDriveLetter = getDriveLetter("Must be a letter!")
    End If
  End If
End Function

Function doesDriveExist(drive_letter)
  Set file_system = Wscript.CreateObject("Scripting.FileSystemObject")
  doesDriveExist = file_system.DriveExists(UCase(Left(drive_letter,1)) & ":")
End Function

Function getDriveName()
  drive_name = InputBox("Enter name for your drive", "Map2Drive")
  If IsEmpty(drive_name) Then
    WScript.Quit
  Else
    getDriveName = drive_name
  End If
End Function

Function shouldDrivePersist()
  persist = MsgBox ("Would you like this drive to persist across reboots?", vbYesNo, "Map2Drive")
  Select Case persist
    Case vbYes
      shouldDrivePersist = "yes"
    Case vbNo
      shouldDrivePersist = "no"
    Case Else
      shouldDrivePersist = "no"
  End Select
End Function

Function regexTest(pattern, drive_letter)
  Set regex = New RegExp
  With regex
      .Pattern    = pattern
      .IgnoreCase = True
      .Global     = False
  End With
  regexTest = regex.Test(drive_letter)
End Function

Sub mountDrive(map_path, drive_letter, drive_name, drive_persist)
  CreateObject("Wscript.Shell").Run "C:\WINDOWS\system32\net.exe use " & drive_letter & " " & chr(34) & map_path & chr(34) & " /P:" & drive_persist, 0, False
  If drive_name <> "" Then
    WScript.Sleep 5000
    Call renameDrive(drive_letter, drive_name)
  End If
End Sub

Sub renameDrive(drive_letter, drive_name)
  Set objShell = CreateObject("Shell.Application")
  objShell.NameSpace(drive_letter).Self.Name = drive_name
End Sub

Sub removeDrive(drive_letter)
  CreateObject("Wscript.Shell").Run "C:\WINDOWS\system32\net.exe use " & Left(drive_letter,1) & ": /delete /y", 0, False
End Sub
