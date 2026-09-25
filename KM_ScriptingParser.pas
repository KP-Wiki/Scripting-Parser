unit KM_ScriptingParser;
interface
uses
  System.Classes, System.SysUtils, System.Types, Vcl.Forms, Winapi.Windows, System.Generics.Collections, System.IOUtils,
  System.StrUtils,
  KM_ScriptingMethods,
  KM_ScriptingParameters,
  KM_ScriptingPaths,
  KM_ScriptingTypes,
  KM_ParserTypes;

type
  // Documenter > Scripting
  TKMScriptingParser = class
  private const
    DBG_COPY_FOR_REFERENCE = True;
  private
    fParsingGame: TKMParsingGame;
    fOnLog: TProc<string>;
    fMethods: array [TKMParsingArea] of TKMScriptMethods;
    fTypes: TKMScriptTypes;
    procedure ParseCode(aPaths: TKMScriptingPaths);
    procedure CopyForReference(const aFilename: string; aArea: TKMParsingArea);
  public
    constructor Create(aParsingGame: TKMParsingGame; aOnLog: TProc<string>);
    destructor Destroy; override;

    procedure GenerateCode(aPaths: TKMScriptingPaths);
    procedure GenerateWiki(aPaths: TKMScriptingPaths);
    procedure LintMessages(aPaths: TKMScriptingPaths);
    procedure GenerateXML(aPaths: TKMScriptingPaths);
  end;


implementation
uses
  KM_ScriptingConsts;


{ TKMScriptingParser }
constructor TKMScriptingParser.Create(aParsingGame: TKMParsingGame; aOnLog: TProc<string>);
begin
  inherited Create;

  fParsingGame := aParsingGame;
  fOnLog := aOnLog;

  for var I := Low(TKMParsingArea) to High(TKMParsingArea) do
    fMethods[I] := TKMScriptMethods.Create(fParsingGame, I, fOnLog);

  fTypes := TKMScriptTypes.Create(fOnLog);
end;


destructor TKMScriptingParser.Destroy;
begin
  for var I := Low(TKMParsingArea) to High(TKMParsingArea) do
    FreeAndNil(fMethods[I]);

  FreeAndNil(fTypes);

  inherited;
end;


procedure TKMScriptingParser.ParseCode(aPaths: TKMScriptingPaths);
begin
  fMethods[paActions].LoadFromFile(aPaths.PathsScripting[paActions].SourceInput);
  fMethods[paEvents].LoadFromFile(aPaths.PathsScripting[paEvents].SourceInput);
  fMethods[paStates].LoadFromFile(aPaths.PathsScripting[paStates].SourceInput);
  fMethods[paUtils].LoadFromFile(aPaths.PathsScripting[paUtils].SourceInput);
  fTypes.LoadFromFiles(aPaths.PathsScripting[paTypes].SourceInput);
end;


procedure TKMScriptingParser.CopyForReference(const aFilename: string; aArea: TKMParsingArea);
var
  tgtPath: string;
begin
  tgtPath := ExtractFilePath(Application.ExeName) + GAME_INFO[fParsingGame].Ext + '.' + AREA_INFO[aArea].Name + '.new.md';
  Winapi.Windows.CopyFile(PChar(aFilename), PChar(tgtPath), False);
end;


procedure TKMScriptingParser.GenerateCode(aPaths: TKMScriptingPaths);
begin
  ParseCode(aPaths);

  //todo -cThink: Automate verification in ScriptingParser that functions/procedures pose under the same name in LogMissionWarning
  // Arrays can be declared in 2 ways in KP PS - "array of string" and TKMStringArray. First one is more traditional and more universal.
  // Second one is required for some Utils methods to allow for resizing of passed arrays. Resized arrays become TKMStringArray though.
  // Now, some functions in Actions expect string arrays. Problem is that they must be declared as TKMStringArray to accept both TKMStringArray and "array of"
  //todo -cThink: Hence we need to add such a check in here. KP arrays need to be declared as TKMStringArray (Integer/Single/etc)

  fMethods[paActions].GenerateCode(aPaths.PathsScripting[paActions].SourceOutput1, aPaths.PathsScripting[paActions].SourceOutput2);
  fMethods[paEvents ].GenerateCode(aPaths.PathsScripting[paEvents].SourceOutput1, aPaths.PathsScripting[paEvents].SourceOutput2);
  fMethods[paStates ].GenerateCode(aPaths.PathsScripting[paStates].SourceOutput1, aPaths.PathsScripting[paStates].SourceOutput2);
  fMethods[paUtils  ].GenerateCode(aPaths.PathsScripting[paUtils].SourceOutput1, aPaths.PathsScripting[paUtils].SourceOutput2);
  fTypes.GenerateCode(aPaths.PathsScripting[paTypes].SourceOutput1);
end;


procedure TKMScriptingParser.GenerateWiki(aPaths: TKMScriptingPaths);
begin
  ParseCode(aPaths);

  fMethods[paActions].GenerateWiki(aPaths.PathsScripting[paActions].WikiTemplate, aPaths.PathsScripting[paActions].WikiOutput);
  fMethods[paEvents].GenerateWiki(aPaths.PathsScripting[paEvents].WikiTemplate, aPaths.PathsScripting[paEvents].WikiOutput);
  fMethods[paStates].GenerateWiki(aPaths.PathsScripting[paStates].WikiTemplate, aPaths.PathsScripting[paStates].WikiOutput);
  fMethods[paUtils].GenerateWiki(aPaths.PathsScripting[paUtils].WikiTemplate, aPaths.PathsScripting[paUtils].WikiOutput);
  fTypes.GenerateWiki(aPaths.PathsScripting[paTypes].WikiTemplate, aPaths.PathsScripting[paTypes].WikiOutput);

  if DBG_COPY_FOR_REFERENCE then
  begin
    CopyForReference(aPaths.PathsScripting[paActions].WikiOutput, paActions);
    CopyForReference(aPaths.PathsScripting[paEvents].WikiOutput, paEvents);
    CopyForReference(aPaths.PathsScripting[paStates].WikiOutput, paStates);
    CopyForReference(aPaths.PathsScripting[paUtils].WikiOutput, paUtils);
    CopyForReference(aPaths.PathsScripting[paTypes].WikiOutput, paTypes);
  end;
end;


procedure TKMScriptingParser.LintMessages(aPaths: TKMScriptingPaths);
begin
  ParseCode(aPaths);

  fMethods[paActions].LintLogMessages(aPaths.PathsScripting[paActions].SourceInput);
  // Events dont have log messages
  fMethods[paStates].LintLogMessages(aPaths.PathsScripting[paStates].SourceInput);
  fMethods[paUtils].LintLogMessages(aPaths.PathsScripting[paUtils].SourceInput);
  // Utils dont have log messages
end;


procedure TKMScriptingParser.GenerateXML(aPaths: TKMScriptingPaths);
begin
  ParseCode(aPaths);

  //todo -cThink: GenerateXML for ScriptingEditor
end;


end.
