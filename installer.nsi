!define PUBLISHER "RedSparr0w"
!define APPNAME "Map2Drive"
!define DESCRIPTION "Map Drives Quickly"
# These three must be integers
!define VERSIONMAJOR 1
!define VERSIONMINOR 0
!define VERSIONBUILD 0
# These will be displayed by the "Click here for support information" link in "Add/Remove Programs"
# It is possible to use "mailto:" links in here to open the email client
!define HELPURL "https://github.com/RedSparr0w/Map2Drive"
!define UPDATEURL "https://github.com/RedSparr0w/Map2Drive/releases"
!define ABOUTURL "https://github.com/RedSparr0w/Map2Drive"
# This is the size (in kB) of all the files copied into "Program Files"
!define INSTALLSIZE 69

RequestExecutionLevel admin ;Require admin rights on NT6+ (When UAC is turned on)

InstallDir "$PROGRAMFILES\${APPNAME}"

# rtf or txt file - remember if it is txt, it must be in the DOS text format (\r\n)
LicenseData "license.md"
# This will be in the installer/uninstaller's title bar
Name "${APPNAME}"
Icon "logo.ico"
outFile "${APPNAME}.exe"

!include LogicLib.nsh

# Just three pages - license agreement, install location, and installation
page license
page directory
Page instfiles

!macro VerifyUserIsAdmin
UserInfo::GetAccountType
pop $0
${If} $0 != "admin" ;Require admin rights on NT4+
        messageBox mb_iconstop "Administrator rights required!"
        setErrorLevel 740 ;ERROR_ELEVATION_REQUIRED
        quit
${EndIf}
!macroend

function .onInit
	setShellVarContext all
	!insertmacro VerifyUserIsAdmin
functionEnd

section "install"
	# Files for the install directory - to build the installer, these should be in the same directory as the install script (this file)
	setOutPath $INSTDIR
	# Files added here should be removed by the uninstaller (see section "uninstall")
  file "credits.md"
	file "map_drive.vbs"
	file "remove_mapped_drive.vbs"
	file "rename_mapped_drive.vbs"
	file "logo.ico"
	# Add any other files for the install directory (license files, app data, etc) here

  # Registry keys for context menu
  ## Folders
  WriteRegStr HKCR "Folder\shell\${APPNAME}" "subcommands" ""
  WriteRegStr HKCR "Folder\shell\${APPNAME}" "MUIVerb" "${APPNAME}"
  WriteRegStr HKCR "Folder\shell\${APPNAME}" "icon" "$INSTDIR\logo.ico"
  WriteRegStr HKCR "Folder\shell\${APPNAME}\shell" "" ""
  WriteRegStr HKCR "Folder\shell\${APPNAME}\shell\AutoMapDrive" "" "Quick Map Drive"
  WriteRegStr HKCR "Folder\shell\${APPNAME}\shell\AutoMapDrive" "icon" "shell32.dll,9"
  WriteRegStr HKCR "Folder\shell\${APPNAME}\shell\AutoMapDrive\command" "" "C:\WINDOWS\system32\wscript.exe $\"$INSTDIR\map2drive.vbs$\" Mount $\"%1$\" Auto"
  WriteRegStr HKCR "Folder\shell\${APPNAME}\shell\MapDrive" "" "Map Drive"
  WriteRegStr HKCR "Folder\shell\${APPNAME}\shell\MapDrive" "icon" "shell32.dll,149"
  WriteRegStr HKCR "Folder\shell\${APPNAME}\shell\MapDrive\command" "" "C:\WINDOWS\system32\wscript.exe $\"$INSTDIR\map2drive.vbs$\" Mount $\"%1$\" Manual"
  ## Drives
  WriteRegStr HKCR "Drive\shell\${APPNAME}" "subcommands" ""
  WriteRegStr HKCR "Drive\shell\${APPNAME}" "MUIVerb" "${APPNAME}"
  WriteRegStr HKCR "Drive\shell\${APPNAME}" "icon" "$INSTDIR\logo.ico"
  WriteRegStr HKCR "Drive\shell\${APPNAME}\shell" "" ""
  WriteRegStr HKCR "Drive\shell\${APPNAME}\shell\RenameMappedDrive" "" "Rename Drive"
  WriteRegStr HKCR "Drive\shell\${APPNAME}\shell\RenameMappedDrive" "icon" "shell32.dll,53"
  WriteRegStr HKCR "Drive\shell\${APPNAME}\shell\RenameMappedDrive\command" "" "C:\WINDOWS\system32\wscript.exe $\"$INSTDIR\map2drive.vbs$\" Rename $\"%1$\""
  WriteRegStr HKCR "Drive\shell\${APPNAME}\shell\RemoveMappedDrive" "" "Remove Drive"
  WriteRegStr HKCR "Drive\shell\${APPNAME}\shell\RemoveMappedDrive" "icon" "shell32.dll,10"
  WriteRegStr HKCR "Drive\shell\${APPNAME}\shell\RemoveMappedDrive\command" "" "C:\WINDOWS\system32\wscript.exe $\"$INSTDIR\map2drive.vbs$\" Remove $\"%1$\""

	# Uninstaller - See function un.onInit and section "uninstall" for configuration
	writeUninstaller "$INSTDIR\uninstall.exe"

	# Registry information for add/remove programs
	WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${APPNAME}" "DisplayName" "${APPNAME}"
	WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${APPNAME}" "UninstallString" "$\"$INSTDIR\uninstall.exe$\""
	WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${APPNAME}" "QuietUninstallString" "$\"$INSTDIR\uninstall.exe$\" /S"
	WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${APPNAME}" "InstallLocation" "$\"$INSTDIR$\""
	WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${APPNAME}" "DisplayIcon" "$\"$INSTDIR\logo.ico$\""
	WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${APPNAME}" "Publisher" "$\"${PUBLISHER}$\""
	WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${APPNAME}" "HelpLink" "$\"${HELPURL}$\""
	WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${APPNAME}" "URLUpdateInfo" "$\"${UPDATEURL}$\""
	WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${APPNAME}" "URLInfoAbout" "$\"${ABOUTURL}$\""
	WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${APPNAME}" "DisplayVersion" "$\"${VERSIONMAJOR}.${VERSIONMINOR}.${VERSIONBUILD}$\""
	WriteRegDWORD HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${APPNAME}" "VersionMajor" ${VERSIONMAJOR}
	WriteRegDWORD HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${APPNAME}" "VersionMinor" ${VERSIONMINOR}
	# There is no option for modifying or repairing the install
	WriteRegDWORD HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${APPNAME}" "NoModify" 1
	WriteRegDWORD HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${APPNAME}" "NoRepair" 1
	# Set the INSTALLSIZE constant (!defined at the top of this script) so Add/Remove Programs can accurately report the size
	WriteRegDWORD HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${APPNAME}" "EstimatedSize" ${INSTALLSIZE}
sectionEnd

# Uninstaller

function un.onInit
	SetShellVarContext all

	#Verify the uninstaller - last chance to back out
	MessageBox MB_OKCANCEL "Permanantly remove ${APPNAME}?" IDOK next
		Abort
	next:
	!insertmacro VerifyUserIsAdmin
functionEnd

section "uninstall"

	# Remove files
	delete $INSTDIR\credits.md
	delete $INSTDIR\map_drive.vbs
	delete $INSTDIR\remove_mapped_drive.vbs
	delete $INSTDIR\rename_mapped_drive.vbs
	delete $INSTDIR\logo.ico

	# Always delete uninstaller as the last action
	delete $INSTDIR\uninstall.exe

	# Try to remove the install directory - this will only happen if it is empty
	rmDir $INSTDIR

	# Remove uninstaller information from the registry
	DeleteRegKey HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${APPNAME}"
	DeleteRegKey HKCR "Folder\shell\${APPNAME}"
	DeleteRegKey HKCR "Drive\shell\${APPNAME}"
sectionEnd
