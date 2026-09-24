unit KM_ScriptingPaths;
interface
uses
  System.SysUtils,
  KM_ParserTypes;

type
  // Set of paths required for one job
  TKMAreaPathsCommon = class
  public
    SourceInput: string;
    WikiTemplate: string;
    WikiOutput: string;
    SourceOutput1: string;
    SourceOutput2: string;
  end;

  TKMScriptingPaths = class
  public
    PathsA: TKMAreaPathsCommon;
    PathsE: TKMAreaPathsCommon;
    PathsS: TKMAreaPathsCommon;
    PathsU: TKMAreaPathsCommon;
    PathsT: TKMAreaPathsCommon;
    constructor Create;
    destructor Destroy; override;
    procedure LoadFromINI(const aSettingsPath: string);
    procedure SaveToINI(const aSettingsPath: string);
  end;


implementation
uses
  System.IniFiles;


{ TKMScriptingPaths }
constructor TKMScriptingPaths.Create;
begin
  inherited;

  PathsA := TKMAreaPathsCommon.Create;
  PathsE := TKMAreaPathsCommon.Create;
  PathsS := TKMAreaPathsCommon.Create;
  PathsU := TKMAreaPathsCommon.Create;
  PathsT := TKMAreaPathsCommon.Create;
end;


destructor TKMScriptingPaths.Destroy;
begin
  FreeAndNil(PathsA);
  FreeAndNil(PathsE);
  FreeAndNil(PathsS);
  FreeAndNil(PathsU);
  FreeAndNil(PathsT);

  inherited;
end;


procedure TKMScriptingPaths.LoadFromINI(const aSettingsPath: string);
begin
  var ini := TINIFile.Create(aSettingsPath);

  // Listing everything plainly is KISS compared to loops and issues with Events and Types being slightly different
  PathsA.SourceInput := ini.ReadString('INPUT',  'Actions', '..\..\src\scripting\KM_ScriptingActions.pas');
  PathsE.SourceInput := ini.ReadString('INPUT',  'Events',  '..\..\src\scripting\KM_ScriptingEvents.pas');
  PathsS.SourceInput := ini.ReadString('INPUT',  'States',  '..\..\src\scripting\KM_ScriptingStates.pas');
  PathsU.SourceInput := ini.ReadString('INPUT',  'Utils',   '..\..\src\scripting\KM_ScriptingUtils.pas');
  PathsT.SourceInput := ini.ReadString('INPUT',  'Types',   '..\..\src\scripting\KM_ScriptingEnginePS.pas');

  PathsA.WikiTemplate := ini.ReadString('TEMPLATE', 'Actions', 'template\Actions.template');
  PathsE.WikiTemplate := ini.ReadString('TEMPLATE', 'Events',  'template\Events.template');
  PathsS.WikiTemplate := ini.ReadString('TEMPLATE', 'States',  'template\States.template');
  PathsU.WikiTemplate := ini.ReadString('TEMPLATE', 'Utils',   'template\Utils.template');
  PathsT.WikiTemplate := ini.ReadString('TEMPLATE', 'Types',   'template\Types.template');

  PathsA.WikiOutput := ini.ReadString('OUTPUT', 'Actions', 'Actions.wiki');
  PathsE.WikiOutput := ini.ReadString('OUTPUT', 'Events',  'Events.wiki');
  PathsS.WikiOutput := ini.ReadString('OUTPUT', 'States',  'States.wiki');
  PathsU.WikiOutput := ini.ReadString('OUTPUT', 'Utils',   'Utils.wiki');
  PathsT.WikiOutput := ini.ReadString('OUTPUT', 'Types',   'Types.wiki');

  PathsA.SourceOutput1 := ini.ReadString('CODE', 'Actions', '.pas');
  PathsE.SourceOutput1 := ini.ReadString('CODE', 'Events',  '.pas');
  PathsE.SourceOutput2 := ini.ReadString('CODE', 'Events2', '.pas');
  PathsS.SourceOutput1 := ini.ReadString('CODE', 'States',  '.pas');
  PathsU.SourceOutput1 := ini.ReadString('CODE', 'Utils',   '.pas');
  PathsT.SourceOutput1 := ini.ReadString('CODE', 'Types',   '.pas');

  FreeAndNil(ini);

  if not FileExists(aSettingsPath) then
    SaveToINI(aSettingsPath);
end;


procedure TKMScriptingPaths.SaveToINI(const aSettingsPath: string);
begin
  var ini := TINIFile.Create(aSettingsPath);

  // Listing everything plainly is KISS compared to loops and issues with Events and Types being slightly different
  ini.WriteString('INPUT',  'Actions', PathsA.SourceInput);
  ini.WriteString('INPUT',  'Events',  PathsE.SourceInput);
  ini.WriteString('INPUT',  'States',  PathsS.SourceInput);
  ini.WriteString('INPUT',  'Utils',   PathsU.SourceInput);
  ini.WriteString('INPUT',  'Types',   PathsT.SourceInput);

  ini.WriteString('TEMPLATE',  'Actions', PathsA.WikiTemplate);
  ini.WriteString('TEMPLATE',  'Events',  PathsE.WikiTemplate);
  ini.WriteString('TEMPLATE',  'States',  PathsS.WikiTemplate);
  ini.WriteString('TEMPLATE',  'Utils',   PathsU.WikiTemplate);
  ini.WriteString('TEMPLATE',  'Types',   PathsT.WikiTemplate);

  ini.WriteString('OUTPUT',  'Actions', PathsA.WikiOutput);
  ini.WriteString('OUTPUT',  'Events',  PathsE.WikiOutput);
  ini.WriteString('OUTPUT',  'States',  PathsS.WikiOutput);
  ini.WriteString('OUTPUT',  'Utils',   PathsU.WikiOutput);
  ini.WriteString('OUTPUT',  'Types',   PathsT.WikiOutput);

  ini.WriteString('CODE',  'Actions', PathsA.SourceOutput1);
  ini.WriteString('CODE',  'Events',  PathsE.SourceOutput1);
  ini.WriteString('CODE',  'Events2', PathsE.SourceOutput2);
  ini.WriteString('CODE',  'States',  PathsS.SourceOutput1);
  ini.WriteString('CODE',  'Utils',   PathsU.SourceOutput1);
  ini.WriteString('CODE',  'Types',   PathsT.SourceOutput1);

  FreeAndNil(ini);
end;


end.
