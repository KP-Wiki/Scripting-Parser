unit KM_ScriptingPaths;
interface
uses
  KM_DocumenterTypes;

type
  // Set of paths for scripting
  TKMScriptingPaths = class
  public
    PathsScripting: array [TKMScriptingArea] of TKMDocumenterPathSet;
    procedure LoadFromINI(const aSettingsPath: string);
    procedure SaveToINI(const aSettingsPath: string);
  end;


implementation
uses
  System.IniFiles, System.SysUtils;


{ TKMScriptingPaths }
procedure TKMScriptingPaths.LoadFromINI(const aSettingsPath: string);
begin
  var ini := TINIFile.Create(aSettingsPath);

  for var I := Low(TKMScriptingArea) to High(TKMScriptingArea) do
  begin
    PathsScripting[I].SourceInput   := ini.ReadString('INPUT',    SCRIPTING_AREA_SPEC[I].Name, '');
    PathsScripting[I].WikiTemplate  := ini.ReadString('TEMPLATE', SCRIPTING_AREA_SPEC[I].Name, '');
    PathsScripting[I].WikiOutput    := ini.ReadString('OUTPUT',   SCRIPTING_AREA_SPEC[I].Name, '');
    PathsScripting[I].SourceOutput1 := ini.ReadString('CODE',     SCRIPTING_AREA_SPEC[I].Name, '');
    PathsScripting[I].SourceOutput2 := ini.ReadString('CODE',     SCRIPTING_AREA_SPEC[I].Name + '2', '');
  end;

  FreeAndNil(ini);

  if not FileExists(aSettingsPath) then
    SaveToINI(aSettingsPath);
end;


procedure TKMScriptingPaths.SaveToINI(const aSettingsPath: string);
begin
  var ini := TINIFile.Create(aSettingsPath);

  for var I := Low(TKMScriptingArea) to High(TKMScriptingArea) do
  begin
    ini.WriteString('INPUT',    SCRIPTING_AREA_SPEC[I].Name,       PathsScripting[I].SourceInput);
    ini.WriteString('TEMPLATE', SCRIPTING_AREA_SPEC[I].Name,       PathsScripting[I].WikiTemplate);
    ini.WriteString('OUTPUT',   SCRIPTING_AREA_SPEC[I].Name,       PathsScripting[I].WikiOutput);
    ini.WriteString('CODE',     SCRIPTING_AREA_SPEC[I].Name,       PathsScripting[I].SourceOutput1);
    ini.WriteString('CODE',     SCRIPTING_AREA_SPEC[I].Name + '2', PathsScripting[I].SourceOutput2);
  end;

  FreeAndNil(ini);
end;


end.
