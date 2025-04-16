unit KM_ScriptingPaths;
interface
uses
  System.SysUtils,
  KM_ParserTypes;

type
  // Set of paths required for one job
  // Maybe we will split them for Events/Types?
  TKMAreaPaths = record
  public
    SourceInput: string;
    SourceOutputCheck: string;
    SourceOutputReg: string;
    WikiTemplate: string;
    WikiOutput: string;
  end;

  TKMScriptingPaths = class
  public
    Paths: array [TKMParsingArea] of TKMAreaPaths;
    procedure LoadFromINI(const aSettingsPath: string);
    procedure SaveToINI(const aSettingsPath: string);
  end;


implementation
uses
  System.IniFiles;


{ TKMScriptingPaths }
procedure TKMScriptingPaths.LoadFromINI(const aSettingsPath: string);
var
  ini: TINIFile;
begin
  ini := TINIFile.Create(aSettingsPath);

  // Listing everything plainly is KISS compared to loops and issues with Events and Types being slightly different
  Paths[paActions].SourceInput := ini.ReadString('INPUT',  'Actions', '..\..\src\scripting\KM_ScriptingActions.pas');
  Paths[paEvents].SourceInput  := ini.ReadString('INPUT',  'Events',  '..\..\src\scripting\KM_ScriptingEvents.pas');
  Paths[paStates].SourceInput  := ini.ReadString('INPUT',  'States',  '..\..\src\scripting\KM_ScriptingStates.pas');
  Paths[paUtils].SourceInput   := ini.ReadString('INPUT',  'Utils',   '..\..\src\scripting\KM_ScriptingUtils.pas');
  Paths[paTypes].SourceInput   := ini.ReadString('INPUT',  'Types',   '..\..\src\scripting\KM_ScriptingEnginePS.pas');

  Paths[paActions].WikiTemplate := ini.ReadString('TEMPLATE', 'Actions', 'template\Actions.template');
  Paths[paEvents].WikiTemplate  := ini.ReadString('TEMPLATE', 'Events',  'template\Events.template');
  Paths[paStates].WikiTemplate  := ini.ReadString('TEMPLATE', 'States',  'template\States.template');
  Paths[paUtils].WikiTemplate   := ini.ReadString('TEMPLATE', 'Utils',   'template\Utils.template');
  Paths[paTypes].WikiTemplate   := ini.ReadString('TEMPLATE', 'Types',   'template\Types.template');

  Paths[paActions].WikiOutput := ini.ReadString('OUTPUT', 'Actions', 'Actions.wiki');
  Paths[paEvents].WikiOutput  := ini.ReadString('OUTPUT', 'Events',  'Events.wiki');
  Paths[paStates].WikiOutput  := ini.ReadString('OUTPUT', 'States',  'States.wiki');
  Paths[paUtils].WikiOutput   := ini.ReadString('OUTPUT', 'Utils',   'Utils.wiki');
  Paths[paTypes].WikiOutput   := ini.ReadString('OUTPUT', 'Types',   'Types.wiki');

  Paths[paActions].SourceOutputCheck := ini.ReadString('CODE', 'Actions', '.pas');
  Paths[paEvents].SourceOutputCheck  := ini.ReadString('CODE', 'Events',  '.pas');
  Paths[paEvents].SourceOutputReg    := ini.ReadString('CODE', 'Events2',  '.pas');
  Paths[paStates].SourceOutputCheck  := ini.ReadString('CODE', 'States',  '.pas');
  Paths[paUtils].SourceOutputCheck   := ini.ReadString('CODE', 'Utils',   '.pas');
  Paths[paTypes].SourceOutputCheck   := ini.ReadString('CODE', 'Types',   '.pas');

  FreeAndNil(ini);

  if not FileExists(aSettingsPath) then
    SaveToINI(aSettingsPath);
end;


procedure TKMScriptingPaths.SaveToINI(const aSettingsPath: string);
var
  ini: TINIFile;
begin
  ini := TINIFile.Create(aSettingsPath);

  // Listing everything plainly is KISS compared to loops and issues with Events and Types being slightly different
  ini.WriteString('INPUT',  'Actions', Paths[paActions].SourceInput);
  ini.WriteString('INPUT',  'Events',  Paths[paEvents].SourceInput);
  ini.WriteString('INPUT',  'States',  Paths[paStates].SourceInput);
  ini.WriteString('INPUT',  'Utils',   Paths[paUtils].SourceInput);
  ini.WriteString('INPUT',  'Types',   Paths[paTypes].SourceInput);

  ini.WriteString('TEMPLATE',  'Actions', Paths[paActions].WikiTemplate);
  ini.WriteString('TEMPLATE',  'Events',  Paths[paEvents].WikiTemplate);
  ini.WriteString('TEMPLATE',  'States',  Paths[paStates].WikiTemplate);
  ini.WriteString('TEMPLATE',  'Utils',   Paths[paUtils].WikiTemplate);
  ini.WriteString('TEMPLATE',  'Types',   Paths[paTypes].WikiTemplate);

  ini.WriteString('OUTPUT',  'Actions', Paths[paActions].WikiOutput);
  ini.WriteString('OUTPUT',  'Events',  Paths[paEvents].WikiOutput);
  ini.WriteString('OUTPUT',  'States',  Paths[paStates].WikiOutput);
  ini.WriteString('OUTPUT',  'Utils',   Paths[paUtils].WikiOutput);
  ini.WriteString('OUTPUT',  'Types',   Paths[paTypes].WikiOutput);

  ini.WriteString('CODE',  'Actions', Paths[paActions].SourceOutputCheck);
  ini.WriteString('CODE',  'Events',  Paths[paEvents].SourceOutputCheck);
  ini.WriteString('CODE',  'Events2', Paths[paEvents].SourceOutputReg);
  ini.WriteString('CODE',  'States',  Paths[paStates].SourceOutputCheck);
  ini.WriteString('CODE',  'Utils',   Paths[paUtils].SourceOutputCheck);
  ini.WriteString('CODE',  'Types',   Paths[paTypes].SourceOutputCheck);

  FreeAndNil(ini);
end;


end.
