unit KM_ScriptingPaths;
interface
uses
  System.SysUtils,
  KM_ParserTypes;

type
  // Set of paths required for one job
  TKMAreaPathsCommon = record
  public
    SourceInput: string;    // Supports wildcards
    WikiTemplate: string;
    WikiOutput: string;
    SourceOutput1: string;
    SourceOutput2: string;
  end;

  TKMScriptingPaths = class
  public
    PathsScripting: array [TKMParsingArea] of TKMAreaPathsCommon;
    procedure LoadFromINI(const aSettingsPath: string);
    procedure SaveToINI(const aSettingsPath: string);
  end;


implementation
uses
  System.IniFiles;


{ TKMScriptingPaths }
procedure TKMScriptingPaths.LoadFromINI(const aSettingsPath: string);
begin
  var ini := TINIFile.Create(aSettingsPath);

  for var I := Low(TKMParsingArea) to High(TKMParsingArea) do
  begin
    PathsScripting[I].SourceInput   := ini.ReadString('INPUT',    AREA_INFO[I].Name, '');
    PathsScripting[I].WikiTemplate  := ini.ReadString('TEMPLATE', AREA_INFO[I].Name, '');
    PathsScripting[I].WikiOutput    := ini.ReadString('OUTPUT',   AREA_INFO[I].Name, '');
    PathsScripting[I].SourceOutput1 := ini.ReadString('CODE',     AREA_INFO[I].Name, '');
    PathsScripting[I].SourceOutput2 := ini.ReadString('CODE',     AREA_INFO[I].Name + '2', '');
  end;

  FreeAndNil(ini);

  if not FileExists(aSettingsPath) then
    SaveToINI(aSettingsPath);
end;


procedure TKMScriptingPaths.SaveToINI(const aSettingsPath: string);
begin
  var ini := TINIFile.Create(aSettingsPath);

  for var I := Low(TKMParsingArea) to High(TKMParsingArea) do
  begin
    ini.WriteString('INPUT',    AREA_INFO[I].Name,       PathsScripting[I].SourceInput);
    ini.WriteString('TEMPLATE', AREA_INFO[I].Name,       PathsScripting[I].WikiTemplate);
    ini.WriteString('OUTPUT',   AREA_INFO[I].Name,       PathsScripting[I].WikiOutput);
    ini.WriteString('CODE',     AREA_INFO[I].Name,       PathsScripting[I].SourceOutput1);
    ini.WriteString('CODE',     AREA_INFO[I].Name + '2', PathsScripting[I].SourceOutput2);
  end;

  FreeAndNil(ini);
end;


end.
