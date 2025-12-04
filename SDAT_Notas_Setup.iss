; SDAT_Notas_Setup.iss
; Inno Setup script — instala SDAT_Notas.xlam em %APPDATA%\SDAT_NOTAS e registra add-in no Excel

#define MyAppName "SDAT Notas - SDAT_NOTAS"
#define MyAppVersion "1.0.3"
#define MyPublisher "SDAT - DTE"
#define DestFolder "{userappdata}\SDAT_NOTAS"

[Setup]
AppName={#MyAppName}
AppVersion={#MyAppVersion}
AppPublisher={#MyPublisher}
DefaultDirName={#DestFolder}
DisableProgramGroupPage=yes
OutputBaseFilename=Instalador_SDAT_Notas_Setup
Compression=lzma
SolidCompression=yes
PrivilegesRequired=lowest

[Files]
; ajuste os paths de origem abaixo para a pasta onde você deixou os arquivos localmente
Source: "SDAT_Notas.xlam"; DestDir: "{app}"; Flags: ignoreversion
Source: "version.json"; DestDir: "{app}"; Flags: ignoreversion
Source: "CheckAndUpdate-SDAT.ps1"; DestDir: "{app}"; Flags: ignoreversion
Source: "RegisterAddin.vbs"; DestDir: "{app}"; Flags: ignoreversion

[Icons]
Name: "{userdesktop}\SDAT Notas - SDAT_NOTAS"; Filename: "{app}\SDAT_Notas.xlam"; WorkingDir: "{app}"; IconFilename: "{app}\SDAT_Notas.xlam"; IconIndex: 0

[Run]
; registra o add-in no Excel (usa cscript, silencioso)
Filename: "cscript.exe"; Parameters: "//nologo ""{app}\RegisterAddin.vbs"" ""{app}\SDAT_Notas.xlam"""; StatusMsg: "Registrando Add-in no Excel..."; Flags: runhidden skipifsilent

; cria tarefa agendada para auto-update diária às 03:00
Filename: "schtasks.exe"; Parameters: "/Create /F /SC DAILY /ST 03:00 /TN ""SDAT_Notas_AutoUpdate"" /TR ""powershell.exe -NoProfile -ExecutionPolicy Bypass -File `""{app}\CheckAndUpdate-SDAT.ps1`"" """; StatusMsg: "Criando tarefa agendada de auto-update..."; Flags: runhidden

[UninstallRun]
; remove tarefa agendada
Filename: "schtasks.exe"; Parameters: "/Delete /F /TN ""SDAT_Notas_AutoUpdate"""; Flags: runhidden

[Code]
function InitializeSetup(): Boolean;
begin
  Result := True;
end;
