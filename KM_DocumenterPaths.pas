unit KM_DocumenterPaths;
interface
uses
  KM_DocumenterTypes;

type
  TKMScriptingPathSet = array [TKMScriptingArea] of TKMDocumenterPathSet;

  // Set of paths for scripting
  TKMDocumenterPaths = class
  public
    Scripting: TKMScriptingPathSet;
    Modding: TKMDocumenterPathSet;
    procedure LoadFromINI(const aSettingsPath: string);
    procedure SaveToINI(const aSettingsPath: string);
  end;


implementation
uses
  System.IniFiles, System.SysUtils;


{ TKMDocumenterPaths }
procedure TKMDocumenterPaths.LoadFromINI(const aSettingsPath: string);
begin
  var ini := TINIFile.Create(aSettingsPath);

  for var I := Low(TKMScriptingArea) to High(TKMScriptingArea) do
  begin
    Scripting[I].SourceInput   := ini.ReadString('INPUT',    SCRIPTING_AREA_SPEC[I].Name, '');
    Scripting[I].WikiTemplate  := ini.ReadString('TEMPLATE', SCRIPTING_AREA_SPEC[I].Name, '');
    Scripting[I].WikiOutput    := ini.ReadString('OUTPUT',   SCRIPTING_AREA_SPEC[I].Name, '');
    Scripting[I].SourceOutput1 := ini.ReadString('CODE',     SCRIPTING_AREA_SPEC[I].Name, '');
    Scripting[I].SourceOutput2 := ini.ReadString('CODE',     SCRIPTING_AREA_SPEC[I].Name + '2', '');
  end;

  Modding.SourceInput   := ini.ReadString('INPUT',    'Modding', '');
  Modding.WikiTemplate  := ini.ReadString('TEMPLATE', 'Modding', '');
  Modding.WikiOutput    := ini.ReadString('OUTPUT',   'Modding', '');

  FreeAndNil(ini);

  if not FileExists(aSettingsPath) then
    SaveToINI(aSettingsPath);
end;


procedure TKMDocumenterPaths.SaveToINI(const aSettingsPath: string);
begin
  var ini := TINIFile.Create(aSettingsPath);

  for var I := Low(TKMScriptingArea) to High(TKMScriptingArea) do
  begin
    ini.WriteString('INPUT',    SCRIPTING_AREA_SPEC[I].Name,       Scripting[I].SourceInput);
    ini.WriteString('TEMPLATE', SCRIPTING_AREA_SPEC[I].Name,       Scripting[I].WikiTemplate);
    ini.WriteString('OUTPUT',   SCRIPTING_AREA_SPEC[I].Name,       Scripting[I].WikiOutput);
    ini.WriteString('CODE',     SCRIPTING_AREA_SPEC[I].Name,       Scripting[I].SourceOutput1);
    ini.WriteString('CODE',     SCRIPTING_AREA_SPEC[I].Name + '2', Scripting[I].SourceOutput2);
  end;

  ini.WriteString('INPUT',    'Modding', Modding.SourceInput);
  ini.WriteString('TEMPLATE', 'Modding', Modding.WikiTemplate);
  ini.WriteString('OUTPUT',   'Modding', Modding.WikiOutput);

  FreeAndNil(ini);
end;


end.
