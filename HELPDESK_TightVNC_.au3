#NoTrayIcon
#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Version=Beta
#AutoIt3Wrapper_Icon=InstantSupport_Files\icon1.ico
#AutoIt3Wrapper_Outfile=helpdesk_tt.exe
#AutoIt3Wrapper_Compression=4
#AutoIt3Wrapper_UseUpx=y
#AutoIt3Wrapper_Res_Comment=HELPDESK LS
#AutoIt3Wrapper_Res_Description=HELPDESK
#AutoIt3Wrapper_Res_Fileversion=0.3.0.0
#AutoIt3Wrapper_Res_Language=1049
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****
#include <ButtonConstants.au3>
#include <EditConstants.au3>
#include <GUIConstantsEx.au3>
#include <StaticConstants.au3>
#include <WindowsConstants.au3>
#Include <WinAPIEx.au3>
#include <File.au3>
#include <SendMessage.au3>
#include <IE.au3>
;~ #include <ServiceControl.au3>
#include ".\repeaterData.au3"

;;перетаскивание окна
$SC_DRAGMOVE = 0xF012

; Global Vars.
Global $ExtractFiles = True
Global $WorkingPath = @AppDataDir & "\InstantSupport_Temp_Files"

;;test connect
Global $g_sTxtLabelRepeater = "---------"
Global $g_sNumLabelLatency = "----"
Global $g_iSetupStatus = 0
Global $g_nRepeaterIndex = 4

;;;;;;;;


; Create unique working path if our default directory already exists. (Possible InstantSupport is already running)
If FileExists( @AppDataDir & "\InstantSupport_Temp_Files" ) Then
	$WorkingPath = @AppDataDir & "\InstantSupport_Temp_Files_" & Random( 100000, 999999,1 )
EndIf

CreatFolder()

; Extract files.
If $ExtractFiles Then

	DirCreate( $WorkingPath )
	FileInstall( "InstantSupport_Files\VNCServ.exe", $WorkingPath & "\VNCServ.exe", 1 )
	FileInstall( "InstantSupport_Files\screenhooks32.dll", $WorkingPath & "\screenhooks32.dll", 1 )
	FileInstall( "InstantSupport_Files\logo.jpg", $WorkingPath & "\logo.jpg", 1 )
	FileInstall( "InstantSupport_Files\kitty38.exe", $WorkingPath & "\kitty38.exe", 1 )
	FileInstall( "InstantSupport_Files\kitty.ini", $WorkingPath & "\kitty.ini", 1 )
	FileInstall( "InstantSupport_Files\Sessions\helpdesk38", $WorkingPath & "\Sessions\helpdesk38", 1 )
	FileInstall( "InstantSupport_Files\Sessions\Default%20Settings", $WorkingPath & "\Sessions\Default%20Settings", 1 )
	FileInstall( "InstantSupport_Files\Jumplist\RecentSessions", $WorkingPath & "\Jumplist\RecentSessions", 1 )
	FileInstall( "InstantSupport_Files\dfmirage-setup.exe", $WorkingPath & "\dfmirage-setup.exe", 1 )
	FileInstall( "InstantSupport_Files\VNC.vnc", $WorkingPath & "\VNC.vnc", 1 )
	FileInstall( "InstantSupport_Files\tvnviewer.exe", $WorkingPath & "\tvnviewer.exe", 1 )
	FileInstall( "InstantSupport_Files\screenhooks.dll", $WorkingPath & "\screenhooks.dll", 1 )


	FileCopy( @ScriptDir & "\" & @ScriptName, $WorkingPath & "\InstantSupport.exe", 9 )

EndIf
Global $GenerateID = True
;~ Global $IDNumber = 12345
Global $GeneratePW = True
;~ Global $PWNumber = 1234
Global Const $GUI_NAME = 'HELPDESK Tightvnc'
Global Const $GUI_TITLE = $GUI_NAME & Chr(160)
Global Const $GUI_GUID = 'C58B53BB-B613-47BD-8E84-60795C9A6A03'

_AppSingleton($GUI_TITLE, $GUI_GUID)

If $CmdLine[0] <> 1 Then

;;;generate id
	$LowerLimit = 20000
	$UpperLimit = 62100
	$IDNumber = Random( $LowerLimit,$UpperLimit,1 )
;;;genereta password
;~ 	$LowerLimit2 = 1000
;~ 	$UpperLimit2 = 9999
;~ 	$PWNumber = Random( $LowerLimit2,$UpperLimit2,1 )
	Else
	$IDNumber = $CmdLine[1]
;~ 	$PWNumber = $CmdLine[2]

	EndIf




testconn()
DisableUAC(True)  ; Disable the UAC prompt dialog
_FileReplaceLine($WorkingPath &"\Sessions\helpdesk38", 98, 'PortForwardings\R' & $IDNumber & '=127.0.0.1%3A'&$IDNumber&'\')
_FileReplaceLine($WorkingPath &"\Sessions\helpdesk38", 292, 'HostName\' & $_g_aRepeaterIp[$g_nRepeaterIndex] & '\')
_FileReplaceLine($WorkingPath &"\Sessions\helpdesk38", 284, 'PortNumber\' & $_g_aRepeaterPort[$g_nRepeaterIndex] & '\')
_FileReplaceLine($WorkingPath &"\Sessions\helpdesk38", 6, $_g_aRepeaterPass[$g_nRepeaterIndex] )




;;;;;;;;;;;;;;;;;;;;;;;;;;;
$InstantSupport = GUICreate("HELPDESK Tightvnc", 450, 280, -1, -1, BitOR( $WS_SYSMENU,$WS_CAPTION,$WS_POPUP,$WS_POPUPWINDOW,$WS_BORDER,$WS_CLIPSIBLINGS,$WS_MINIMIZEBOX ) )
;~ $InstantSupport = GUICreate("HELPDESK", 450, 280, 656, 411)
$PageControl1 = GUICtrlCreateTab(8, 8, 440, 250)
$TabSheet1 = GUICtrlCreateTabItem("Клиент")

$MenuItem1 = GUICtrlCreateMenu("HELPDESK")
$MenuItem3 = GUICtrlCreateMenuItem("Перезапуск от имени администратора", $MenuItem1)
$MenuItem4 = GUICtrlCreateMenuItem("Отображать иконку VNC server в трее", $MenuItem1)

$MenuItem13 = GUICtrlCreateMenuItem("Установить mirror display driver", $MenuItem1)

$MenuItem12 = GUICtrlCreateMenuItem("Пробросить порт", $MenuItem1)


$empty1 = GUICtrlCreateMenuItem("", $MenuItem1)
$MenuItem5 = GUICtrlCreateMenuItem("Выйти", $MenuItem1)

$MenuItem2 = GUICtrlCreateMenu("Справка")

$MenuItem7 = GUICtrlCreateMenuItem("Скачать последнию версию", $MenuItem2)
$MenuItem11 = GUICtrlCreateMenuItem("Сайт программы", $MenuItem2)
$repstatus = GUICtrlCreateMenu("Выбран " & $g_sTxtLabelRepeater)



$Label3 = GUICtrlCreateLabel( "ВАШ ID", 0, 80, 450, 100, $SS_CENTER )
GUICtrlSetFont( -1, 16, 300, 0, "Arial Black" )
$Label1 = GUICtrlCreateLabel( $IDNumber, 0, 110, 450, 100, $SS_CENTER )
GUICtrlSetFont( -1, 50, 800, 0, "Arial Black" )


;~ $Pic1 = GUICtrlCreatePic( $WorkingPath & "\logo.jpg", 0, 0, 450, 90, BitOR( $SS_NOTIFY,$WS_GROUP,$WS_CLIPSIBLINGS ) )




$TabSheet2 = GUICtrlCreateTabItem("Оператор")
;~ $Input3 = GUICtrlCreateInput("", 15, 40, 200, 40)
$Combo1 = GUICtrlCreateCombo("", 15, 40, 200, 40)
GUICtrlSetFont(-1, 20, 700, 0, "Times New Roman")
$Button4 = GUICtrlCreateButton("Подключиться", 30, 100, 150, 40,$BS_DEFPUSHBUTTON)






;~ $TabSheet3 = GUICtrlCreateTabItem("TabSheet3")


GUISetState(@SW_SHOW)
;;;;;;;;;;;;;;;;;;;;;


WinSetOnTop( $GUI_TITLE, "",1)

;~ GUISetBkColor( 0xFFFFFF )






;;;;;;error internet
$Form01 = GUICreate("Ошибка подключения", 357, 183, 625, 573)
$Label1 = GUICtrlCreateLabel("Нет подключения к интернету, проверьте настройки", 40, 16, 300, 48)
GUICtrlSetFont( -1, 11, 800, 0, "MS Sans Serif" )
GUICtrlSetColor(-1, 0xff0000) ; Красный
$Button11 = GUICtrlCreateButton("настройка прокси", 216, 64, 129, 25)
$Button22 = GUICtrlCreateButton("OK", 128, 128, 105, 33)
WinSetOnTop( "HELPDESK", "",0 )
GUISetState(@SW_HIDE)


;;;proxy setting
$Form02 = GUICreate("Proxy settings", 369, 289, 423, 138)
$Input1 = GUICtrlCreateInput("", 24, 72, 249, 21)
$Input2 = GUICtrlCreateInput("", 288, 72, 65, 21)
$Label1 = GUICtrlCreateLabel("Proxy hostname / IP", 24, 48, 100, 17)
$Label2 = GUICtrlCreateLabel("Port", 288, 48, 23, 17)
$Label3 = GUICtrlCreateLabel("Proxy HTTP:", 24, 16, 80, 17)
$Input3 = GUICtrlCreateInput("", 176, 112, 177, 21)
$Input4 = GUICtrlCreateInput("", 176, 144, 177, 21)
$Label4 = GUICtrlCreateLabel("Username", 24, 112, 52, 17)
$Label5 = GUICtrlCreateLabel("Password", 24, 152, 50, 17)
$Button33 = GUICtrlCreateButton("OK", 80, 240, 81, 33)
$Button44 = GUICtrlCreateButton("Cancel", 184, 240, 89, 33)
GUISetState(@SW_HIDE)


;;;GUI Tunnel SSH
$Tunnel = GUICreate("Tunnel", 204, 282, 637, 417)
$port1 = GUICtrlCreateInput("", 24, 48, 145, 21)
$port2 = GUICtrlCreateInput("", 24, 184, 153, 21)
$Button40 = GUICtrlCreateButton("OK", 24, 224, 73, 33)
$Button41 = GUICtrlCreateButton("Отмена", 108, 224, 73, 33)
$tunnelIP1 = GUICtrlCreateInput("127.0.0.1", 24, 112, 146, 21)
$Labe41 = GUICtrlCreateLabel("порт подключения", 24, 22, 124, 25)
$Labe42 = GUICtrlCreateLabel("IP", 23, 85, 124, 25)
$Labe43 = GUICtrlCreateLabel("порт назначения", 24, 154, 124, 25)
GUISetState(@SW_HIDE)




$iPingS = Ping($_g_ping , 3000)
If $iPingS Then
;~ 	RunConnect()

$iPID_Kitty = ShellExecute($WorkingPath & '\kitty38.exe', '-auto_store_sshkey -load helpdesk38', '', '', @SW_HIDE)

;~ Sleep(4000)
;~ _FileReplaceLine($WorkingPath &"\Sessions\helpdesk38", 6, "Password\44511IC000000000\")
Sleep(2000)

RegWrite("HKEY_CURRENT_USER\Software\TightVNC\Server", "RfbPort", "REG_DWORD", $IDNumber)
RegWrite('HKEY_CURRENT_USER\Software\TightVNC\Server','IpAccessControl',"REG_SZ",'127.0.0.1-127.0.0.1:2')
RegWrite('HKEY_CURRENT_USER\Software\TightVNC\Server','ExtraPorts',"REG_SZ",'')
RegWrite('HKEY_CURRENT_USER\Software\TightVNC\Server','QueryTimeout',"REG_DWORD",0x0000001e)
RegWrite('HKEY_CURRENT_USER\Software\TightVNC\Server','QueryAcceptOnTimeout',"REG_DWORD",0x00000000)
RegWrite('HKEY_CURRENT_USER\Software\TightVNC\Server','LocalInputPriorityTimeout',"REG_DWORD",0x00000003)
RegWrite('HKEY_CURRENT_USER\Software\TightVNC\Server','LocalInputPriority',"REG_DWORD",0x00000000)
RegWrite('HKEY_CURRENT_USER\Software\TightVNC\Server','BlockRemoteInput',"REG_DWORD",0x00000000)
RegWrite('HKEY_CURRENT_USER\Software\TightVNC\Server','BlockLocalInput',"REG_DWORD",0x00000000)
RegWrite('HKEY_CURRENT_USER\Software\TightVNC\Server','HttpPort',"REG_DWORD",0x000016a8)
RegWrite('HKEY_CURRENT_USER\Software\TightVNC\Server','DisconnectAction',"REG_DWORD",0x00000000)
RegWrite('HKEY_CURRENT_USER\Software\TightVNC\Server','AcceptRfbConnections',"REG_DWORD",0x00000001)
RegWrite('HKEY_CURRENT_USER\Software\TightVNC\Server','UseVncAuthentication',"REG_DWORD",0x00000000)
RegWrite('HKEY_CURRENT_USER\Software\TightVNC\Server','UseControlAuthentication',"REG_DWORD",0x00000000)
RegWrite('HKEY_CURRENT_USER\Software\TightVNC\Server','RepeatControlAuthentication',"REG_DWORD",0x00000000)
RegWrite('HKEY_CURRENT_USER\Software\TightVNC\Server','LoopbackOnly',"REG_DWORD",0x00000001)
RegWrite('HKEY_CURRENT_USER\Software\TightVNC\Server','AcceptHttpConnections',"REG_DWORD",0x00000000)
RegWrite('HKEY_CURRENT_USER\Software\TightVNC\Server','LogLevel',"REG_DWORD",0x00000000)
RegWrite('HKEY_CURRENT_USER\Software\TightVNC\Server','EnableFileTransfers',"REG_DWORD",0x00000001)
RegWrite('HKEY_CURRENT_USER\Software\TightVNC\Server','RemoveWallpaper',"REG_DWORD",0x00000001)
RegWrite('HKEY_CURRENT_USER\Software\TightVNC\Server','UseD3D',"REG_DWORD",0x00000001)
RegWrite('HKEY_CURRENT_USER\Software\TightVNC\Server','UseMirrorDriver',"REG_DWORD",0x00000001)
RegWrite('HKEY_CURRENT_USER\Software\TightVNC\Server','EnableUrlParams',"REG_DWORD",0x00000001)
RegWrite('HKEY_CURRENT_USER\Software\TightVNC\Server','AlwaysShared',"REG_DWORD",0x00000000)
RegWrite('HKEY_CURRENT_USER\Software\TightVNC\Server','NeverShared',"REG_DWORD",0x00000001)
RegWrite('HKEY_CURRENT_USER\Software\TightVNC\Server','DisconnectClients',"REG_DWORD",0x00000001)
RegWrite('HKEY_CURRENT_USER\Software\TightVNC\Server','PollingInterval',"REG_DWORD",0x000003e8)
RegWrite('HKEY_CURRENT_USER\Software\TightVNC\Server','AllowLoopback',"REG_DWORD",0x00000001)
RegWrite('HKEY_CURRENT_USER\Software\TightVNC\Server','VideoRecognitionInterval',"REG_DWORD",0x00000bb8)
RegWrite('HKEY_CURRENT_USER\Software\TightVNC\Server','GrabTransparentWindows',"REG_DWORD",0x00000001)
RegWrite('HKEY_CURRENT_USER\Software\TightVNC\Server','SaveLogToAllUsersPath',"REG_DWORD",0x00000000)
RegWrite('HKEY_CURRENT_USER\Software\TightVNC\Server','RunControlInterface',"REG_DWORD",0x00000000)  ;иконка в трее vnc
RegWrite('HKEY_CURRENT_USER\Software\TightVNC\Server','IdleTimeout',"REG_DWORD",0x00000000)
RegWrite('HKEY_CURRENT_USER\Software\TightVNC\Server','VideoClasses',"REG_SZ",'')
RegWrite('HKEY_CURRENT_USER\Software\TightVNC\Server','VideoRects',"REG_SZ",'')

Sleep(1000)

$PID1 = ShellExecute( $WorkingPath & "\VNCServ.exe", "" ,@SW_SHOW)
;~ MsgBox(4096, "test", "test123" )
Else

GUISetState( @SW_SHOW, $Form01 )

;~     MsgBox(4096, "Ошибка подключения", "Нет подключения к интернету, проверьте настройки" )

EndIf



While 1
	$nMsg = GUIGetMsg()
	Switch $nMsg


		Case $GUI_EVENT_CLOSE
				WinSetOnTop( "HELPDESK", "",0 )
			If MsgBox( 4, "HELPDESK", "Вы действительно хотите выйти?" ) = 6 Then

				InstantSupportExit( True )

			EndIf
;;;перетаскивание окна
	Case $GUI_EVENT_PRIMARYDOWN ; событие нажатия мыши
			_SendMessage($InstantSupport, $WM_SYSCOMMAND, $SC_DRAGMOVE, 0) ; для перемещения окна за само окно


		Case $MenuItem3
			RunAdm()

		Case $MenuItem4
RegWrite('HKEY_CURRENT_USER\Software\TightVNC\Server','RunControlInterface',"REG_DWORD",0x00000001)
Reload()


;~ Run( "explorer.exe " & $WorkingPath  )

;~ 		Case $MenuItem6
;~ 			MsgBox (262208,"О нас",'ООО СОФТ. тел.(3952) 11-22-33, www.123456.ru' & @CR & 'Обслуживание 1С Предприятия' & @CR & 'Системное администрирование' & @CR & 'Удаленное программирование' & @CR & 'Автоматизация ЕГАИС')

		Case $MenuItem5  ;;exit
			WinSetOnTop( "HELPDESK", "",0 )
			If MsgBox( 4, "HELPDESK", "Вы действительно хотите выйти?" ) = 6 Then

				InstantSupportExit( True )

			EndIf

		Case $MenuItem7
			$WebPage = "https://maxlinus.github.io/BrynhildrHelpdesk/helpdesk_ls.exe"
$oIE = _IECreate ($WebPage,0,0)
;~ 			ShellExecuteWait($WorkingPath & '\wget.exe', 'https://maxlinus.github.io/BrynhildrHelpdesk/helpdesk_ls.exe -O helpdesk_NEW.exe', '', '', @SW_SHOW)
;~ 			FileCopy($WorkingPath & "\helpdesk_NEW.exe", @DesktopDir , 9)

		Case $MenuItem11
			ShellExecute('https://maxlinus.github.io/BrynhildrHelpdesk//')

;~ 		Case $MenuItem8
;~ 			InstallService()

;~ 		Case $MenuItem10
;~ 			deleteService()

	Case $Button11
			GUISetState( @SW_SHOW, $Form02 )
			GUISetState( @SW_HIDE, $Form01 )
		Case $Button44

			GUISetState( @SW_HIDE, $Form02 )

		Case $Button22
			InstantSupportExitError( True )

		Case $Button33
			writeproxy()
			GUISetState( @SW_HIDE, $Form02 )

		Case $Button40
			SSHTunnel()

		Case $Button41




			GUISetState( @SW_HIDE, $Tunnel )

					Case $MenuItem12   ;GUI Tunnel
GUISetState( @SW_SHOW, $Tunnel )


		Case $MenuItem13
ShellExecute( $WorkingPath & "\dfmirage-setup.exe", "" ,@SW_SHOW)

;~ 		Case $MenuItem14
;~ 				RDP()

;~ ;run vnc         ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
		Case $Button4

ShellExecute($WorkingPath & '\tvnviewer.exe', $_g_aRepeaterIp[$g_nRepeaterIndex] &"::"&GUICtrlRead( $Combo1 ) , @SW_SHOW)



	EndSwitch

	                                                       ;;;;Reconnect перезапуск kitty           http://autoit-script.ru/index.php?topic=26608.0#msg147032
;~ 	If TimerDiff($hTimer) > 12000 Then

;~ $iPing = Ping("8.8.8.8") ;проверяем соединение
;~ If $iPing=0 Then
;~   ProcessClose($iPID_Kitty );если соединения нет, закрываем Putty
;~ 	 MsgBox(0, "Ошибка", "идёт переподключение", 3)
;~   ElseIf Not ProcessExists($iPID_Kitty ) Then ;если соединение есть, а Putty не запущена, запускаем
;~   $iPID_Kitty = ShellExecute($WorkingPath & '\kitty38.exe', '-auto_store_sshkey -load helpdesk38', '', '', @SW_SHOW)
;~ 	MsgBox(0, "Ошибка", "соединение востановлено", 3)
;~     $hTimer=TimerInit()
;~ 	EndIf
;~ EndIf
WEnd


Func testconn()
;Test the connection to the Repeater
If $g_iSetupStatus = 2 Then ;If server, just test
	$g_bConnStatus = TestConnection(True, $g_nRepeaterIndex)
Else
	$g_bConnStatus = TestConnection()
EndIf
EndFunc

;;;Run admin
Func RunAdm()
ProcessClose ("VNCServ.exe")
	 #include "uac2.au3"
EndFunc

;;;;;;;;;;;;
Func InstantSupportExit( $DeleteFiles = False )

ProcessClose ("kitty38.exe")
ProcessClose ("VNCServ.exe")
ProcessClose ("kitty38.exe")
ProcessClose ("kitty38.exe")
ProcessClose ("kitty38.exe")
ProcessClose ("kitty38.exe")
ProcessClose ("kitty38.exe")
ProcessClose ("kitty38.exe")
;~ ProcessClose($iPID1)


RegDelete('HKEY_CURRENT_USER\Software\TightVNC\Server')

	; Remove temp files.
If $DeleteFiles = True Then _DeleteSelf( $WorkingPath, 5)

	Exit
;~ EndIf
EndFunc

;;;;;;;;;;;;
Func InstantSupportExitError( $DeleteFiles = False )

ProcessClose ("kitty38.exe")
ProcessClose ("VNCServ.exe")
;~ ProcessClose($iPID)


;~ RegDelete('HKEY_CURRENT_USER\Software\TightVNC')
;~ RegDelete('HKEY_CURRENT_USER\Software\Wow6432Node\TightVNC')

	; Remove temp files.
If $DeleteFiles = True Then _DeleteSelf( $WorkingPath, 5)

	Exit
;~ EndIf
EndFunc



Func _DeleteSelf( $Path, $iDelay = 5 )

	Local $sCmdFile

	FileDelete( @TempDir & "\scratch.bat" )


	$sCmdFile = 'PING -n ' & $iDelay & ' 127.0.0.1 > nul' & @CRLF _
			& 'DEL /F /Q "' & $Path & '\kitty38.exe"' & @CRLF _
			& 'DEL /F /Q "' & $Path & '\brynhildr.exe"' & @CRLF _
			& 'DEL /F /Q "' & $Path & '\brynhildr.dll"' & @CRLF _
			& 'DEL /F /Q "' & $Path & '\brynhildr.enc"' & @CRLF _
			& 'DEL /F /Q "' & $Path & '\brynhildr.ini"' & @CRLF _
			& 'DEL /F /Q "' & $Path & '\tvnserver38.exe"' & @CRLF _
			& 'DEL /F /Q "' & $Path & '\screenhooks32.dll"' & @CRLF _
			& 'DEL /F /Q "' & $Path & '\InstantSupport.exe"' & @CRLF _
			& 'DEL /F /Q "' & $Path & '\uac.exe"' & @CRLF _
			& 'DEL /F /Q "' & $Path & '\-operator4.0"' & @CRLF _
			& 'DEL /F /Q "' & $Path & '\-operator5.0"' & @CRLF _
			& 'DEL /F /Q "' & $Path & '\helpdesk_NEW.exe"' & @CRLF _
			& 'RMDIR /S /Q "' & $Path & '\plugins"' & @CRLF _
			& 'RMDIR /S /Q "' & $Path & '\Jumplist"' & @CRLF _
			& 'RMDIR /S /Q "' & $Path & '\Sessions"' & @CRLF _
			& 'RMDIR /S /Q "' & $Path & '\SshHostKeys"' & @CRLF _
			& 'RMDIR /S /Q "' & $Path & '\recv"' & @CRLF _
			& 'DEL /S /Q "' & $Path & '\"' & @CRLF _
			& 'RMDIR "' & $Path & '"' & @CRLF _
			& 'sc start helpdesk38' & @CRLF _
			& 'sc start Brynhildr_Service'  & @CRLF _
			& 'DEL "' & @TempDir & '\scratch.bat"'

	FileWrite( @TempDir & "\scratch.bat", $sCmdFile )

	Run( @TempDir & "\scratch.bat", @TempDir, @SW_HIDE )

EndFunc

Func _AppSingleton($sTitle, $sUnique, $tCopyData = 0)

    Local $PID, $hRoot, $List, $State, $Result

    $hRoot = WinGetHandle($sUnique)
    If Not $hRoot Then
        AutoItWinSetTitle($sUnique)
        Return
    EndIf
    $PID = WinGetProcess($hRoot)
    If $PID > -1 Then
        $List = _WinAPI_EnumProcessWindows($PID, 0)
        If Not IsArray($List) Then
            Exit
        EndIf
    EndIf
    For $i = 1 To $List[0][0]
        If _WinAPI_GetWindowText($List[$i][0]) = $sTitle Then
            $State = WinGetState($List[$i][0])
            If BitAND($State, 4) Then
                If BitAND($State, 2) Then
                    WinActivate($List[$i][0])
                EndIf
                If IsDllStruct($tCopyData) Then
                    $Result = DllCall('user32.dll', 'int', 'SendMessage', 'hwnd', $List[$i][0], 'uint', $WM_COPYDATA, 'hwnd', 0, 'struct*', $tCopyData)
                    If (@Error) Or (Not $Result[0]) Then
                        ; Nothing
                    EndIf
                EndIf
            Else
                For $j = 1 To $List[0][0]
                    If (_WinAPI_GetWindowText($List[$j][0])) And (_WinAPI_GetAncestor($List[$j][0], $GA_ROOTOWNER) = $List[$i][0]) Then
                        WinActivate($List[$j][0])
                        ExitLoop
                    EndIf
                Next
            EndIf
            ExitLoop
        EndIf
    Next
    Exit
EndFunc   ;==>_AppSingleton



;~ Func addreg()

;~ EndFunc
;;;изменяет сткроку с портами
Func _FileReplaceLine($sFile, $iLine, $sNewLineStr)
    Local $aRead_File

    If Not _FileReadToArray($sFile, $aRead_File) Then Return SetError(1, 0, 0)

    For $i = 1 To $aRead_File[0]
        If $i = $iLine Then
            $aRead_File[$i] = $sNewLineStr
            _FileWriteFromArray($sFile, $aRead_File, 1)
            Return 1
        EndIf
    Next

    Return SetError(2, 0, 0)
EndFunc





;UAC
Func DisableUAC($Disable)  ; Disable/Restore UAC prompt dialog setting
	If Not IsAdmin() Then Return False

	$Result = 1

	$Key = "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System"
	$Value = "ConsentPromptBehaviorAdmin"
	$Type = "REG_DWORD"

	$RegData = RegRead($Key, $Value)
	If @Error Then Return False ; Key doesn't exist, (probably not Vista or Windows 7)

	If $Disable Then
		RegWrite($Key, $Value, $Type, 0)

	EndIf

	If $Result = 0 Then Return False  ; Error: failed to do task

	Return True
EndFunc

Func CreatFolder()
DirCreate($WorkingPath&"\Sessions")
DirCreate($WorkingPath&"\SshHostKeys")
DirCreate($WorkingPath&"\plugins")
EndFunc


;;test conetc
Func TestConnection($bTestType = False, $iRepeaterIdx = 0)
	Local $iLatency
	Local $nSocket

	;Start TCP service
	TCPStartup()

	;If just checking current connection or server setup
	If $bTestType Then

		$nSocket = TCPConnect(TCPNameToIP($_g_aRepeaterIp[$iRepeaterIdx]), $_g_aRepeaterPort[$iRepeaterIdx])
		$iLatency = Ping($_g_aRepeaterIp[$iRepeaterIdx],1000)

		If $nSocket = -1 Or $iLatency = 0 Or $iLatency > 500 Then
			TCPShutdown()
			$g_sTxtLabelRepeater = "---------"
			$g_sNumLabelLatency = "----"
			Return False
		Else
			TCPShutdown()
			$g_sTxtLabelRepeater = $_g_aRepeaterName[$iRepeaterIdx]
			$g_sNumLabelLatency = $iLatency

			Return True
		EndIf

	Else

		;Test connection with the repeaters in crescent order
		While $iRepeaterIdx <= 3
;~ 			$nSocket = TCPConnect(TCPNameToIP($_g_aRepeaterIp[$iRepeaterIdx]), $_g_aRepeaterPort[$iRepeaterIdx])
			$iLatency = Ping($_g_aRepeaterIp[$iRepeaterIdx],1000)
			If $iLatency = 0 Or $iLatency > 500 Then
				$iRepeaterIdx+=1
			Else
				TCPShutdown()
				$g_sTxtLabelRepeater = $_g_aRepeaterName[$iRepeaterIdx]
				$g_sNumLabelLatency = $iLatency
				$g_nRepeaterIndex = $iRepeaterIdx

				Return True
			EndIf
		WEnd

	EndIf

	TCPShutdown()
	$g_sTxtLabelRepeater = "---------"
	$g_sNumLabelLatency = "----"
	Return False

EndFunc
;============> End testConnection() ==============================================================



Func writeproxy()

$ProxyIP = GUICtrlRead($Input1)
$ProxyPort = GUICtrlRead($Input2)
$ProxyUser = GUICtrlRead($Input3)
$ProxyPass = GUICtrlRead($Input4)

_FileReplaceLine($WorkingPath &"\Sessions\helpdesk38", 270, 'ProxyHost\' & $ProxyIP & '\')
_FileReplaceLine($WorkingPath &"\Sessions\helpdesk38", 269, 'ProxyPort\' & $ProxyPort & '\')
_FileReplaceLine($WorkingPath &"\Sessions\helpdesk38", 268, 'ProxyUsername\' & $ProxyUser & '\')
_FileReplaceLine($WorkingPath &"\Sessions\helpdesk38", 267, 'ProxyPassword\' & $ProxyPass & '\')
_FileReplaceLine($WorkingPath &"\Sessions\helpdesk38", 271, 'ProxyMethod\3\')   ;proxy http
;~ Run
$iPingS = Ping($_g_ping , 1000)
If $iPingS Then
;~ 	RunConnect()

	ShellExecute($WorkingPath & '\kitty38.exe', '-auto_store_sshkey -load helpdesk38', '', '', @SW_SHOW)

;~ Sleep(4000)
;~ _FileReplaceLine($WorkingPath &"\Sessions\helpdesk38", 6, "Password\44511IC000000000\")
Sleep(2000)


Else

GUISetState( @SW_SHOW, $Form01 )

;~     MsgBox(4096, "Ошибка подключения", "Нет подключения к интернету, проверьте настройки" )

EndIf
EndFunc

Func InstallService()

;;copy dir
DirCreate("C:\helpdesk38")
DirCopy($WorkingPath, "C:\helpdesk38", 1)
Sleep(4000)

			;;;;;;;install service

ShellExecute('C:\helpdesk38\instsrv.exe', 'helpdesk38 C:\helpdesk38\srvany.exe', '', '', @SW_HIDE)
ShellExecute('C:\helpdesk38\instsrv.exe', 'Brynhildr_Service C:\helpdesk38\srvany.exe', '', '', @SW_HIDE)
RegWrite('HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\services\helpdesk38\Parameters','Application',"REG_SZ",'C:\helpdesk38\kitty38.exe -load helpdesk38')

ShellExecute('C:\helpdesk38\VNCServ.exe', ' -install'&"" ,@SW_SHOW)
Sleep(3000)
ShellExecute('C:\helpdesk38\VNCServ.exe', ' -start'&"" ,@SW_SHOW)

Sleep(2000)
InstantSupportExit( True )


EndFunc

Func deleteService()
	Run(@ComSpec & " /c " & 'sc stop helpdesk38', "", @SW_HIDE)
	Run(@ComSpec & " /c " & 'sc stop Brynhildr_Service', "", @SW_HIDE)
	Run(@ComSpec & " /c " & 'sc delete helpdesk38', "", @SW_HIDE)
	Run(@ComSpec & " /c " & 'sc delete Brynhildr_Service', "", @SW_HIDE)
	DirRemove("C:\helpdesk38", 1)
EndFunc


Func RDP()


$iMsgBox = MsgBox (262177,"закрыть brynhildr?","Закрыть Brynhildr и открыт RDP с таким же ID")
Select
	Case $iMsgBox = 1 ;Ок

;~ 		ProcessClose($iPID)
		ProcessClose ("kitty38.exe")
		ProcessClose ("kitty38.exe")
		ProcessClose ("kitty38.exe")
		ProcessClose ("kitty38.exe")
		ProcessClose ("kitty38.exe")
		ProcessClose ("kitty38.exe")
		ProcessClose ("kitty38.exe")

_FileReplaceLine($WorkingPath &"\Sessions\helpdesk38", 98, 'PortForwardings\R' & $IDNumber & '=127.0.0.1%3A' & '3389' & '\')

ShellExecute($WorkingPath & '\kitty38.exe', '-auto_store_sshkey -load helpdesk38', '', '', @SW_HIDE)

	Case $iMsgBox = 2 ;Отмена
		; Внесите вот сюда то что хотите при нажатии Отмена
EndSelect

EndFunc

Func Reload()
	ShellExecute( $WorkingPath & '\VNCServ.exe', ' -controlapp -reload'&"" ,@SW_SHOW)
EndFunc


Func SSHTunnel()

$portIN = GUICtrlRead($port1)
$portOUT = GUICtrlRead($port2)
$tunnelIP = GUICtrlRead($tunnelIP1)

_FileReplaceLine($WorkingPath &"\Sessions\helpdesk38", 98, 'PortForwardings\R' & $portIN & '='&$tunnelIP&'%3A'& $portOUT &'\')

ShellExecute($WorkingPath & '\kitty38.exe', '-send-to-tray -auto_store_sshkey -load helpdesk38', '', '', @SW_HIDE)

GUISetState( @SW_HIDE, $Tunnel )

EndFunc
