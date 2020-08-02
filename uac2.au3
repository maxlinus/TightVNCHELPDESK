
RegWrite("HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System", "ConsentPromptBehaviorAdmin", "REG_DWORD", 0)
ShellExecute( $WorkingPath & "\VNCServ.exe", "" , $WorkingPath, "runas")