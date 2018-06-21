' NameDrive.vbs
' VBScript to map a network drive.
' Authors Guy Thomas and Barry Maybury
' Version 1.4 - April 2010
' ----------------------------------------'
'
Option Explicit
Dim objNetwork, strDrive, objShell, objUNC
Dim strRemotePath, strDriveLetter, strNewName
'
strDriveLetter = WScript.Arguments(0)
strNewName = InputBox("Enter new name for drive " & WScript.Arguments(0), "Map2Drive")

' Section which actually (re)names the Mapped Drive
Set objShell = CreateObject("Shell.Application")
objShell.NameSpace(strDriveLetter).Self.Name = strNewName

WScript.Quit

' End of VBScript.
