unit KM_ScriptingParser;
interface
uses
  System.Classes, System.SysUtils, System.Types, Vcl.Forms, Winapi.Windows, System.Generics.Collections, System.IOUtils,
  System.StrUtils,
  KM_ScriptingCommon,
  KM_ScriptingMethods,
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
    fMethods: array [TKMParsingArea] of TKMScriptCommon;
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
  case I of
    paActions,
    paEvents,
    paStates,
    paUtils:  fMethods[I] := TKMScriptMethods.Create(fParsingGame, I, fOnLog);
    paTypes:  fMethods[I] := TKMScriptTypes.Create(fParsingGame, I, fOnLog);
  end;
end;


destructor TKMScriptingParser.Destroy;
begin
  for var I := Low(TKMParsingArea) to High(TKMParsingArea) do
    FreeAndNil(fMethods[I]);

  inherited;
end;


procedure TKMScriptingParser.CopyForReference(const aFilename: string; aArea: TKMParsingArea);
var
  tgtPath: string;
begin
  tgtPath := ExtractFilePath(Application.ExeName) + GAME_INFO[fParsingGame].Ext + '.' + SCRIPTING_DOMAIN_SPEC[aArea].Name + '.new.md';
  Winapi.Windows.CopyFile(PChar(aFilename), PChar(tgtPath), False);
end;


procedure TKMScriptingParser.GenerateCode(aPaths: TKMScriptingPaths);
begin
  //todo -cThink: Automate verification in ScriptingParser that functions/procedures pose under the same name in LogMissionWarning
  // Arrays can be declared in 2 ways in KP PS - "array of string" and TKMStringArray. First one is more traditional and more universal.
  // Second one is required for some Utils methods to allow for resizing of passed arrays. Resized arrays become TKMStringArray though.
  // Now, some functions in Actions expect string arrays. Problem is that they must be declared as TKMStringArray to accept both TKMStringArray and "array of"
  //todo -cThink: Hence we need to add such a check in here. KP arrays need to be declared as TKMStringArray (Integer/Single/etc)

  for var I := Low(TKMParsingArea) to High(TKMParsingArea) do
    fMethods[I].GenerateCode(aPaths.PathsScripting[I].SourceInput, aPaths.PathsScripting[I].SourceOutput1, aPaths.PathsScripting[I].SourceOutput2);
end;


procedure TKMScriptingParser.GenerateWiki(aPaths: TKMScriptingPaths);
begin
  for var I := Low(TKMParsingArea) to High(TKMParsingArea) do
    fMethods[I].GenerateWiki(aPaths.PathsScripting[I].SourceInput, aPaths.PathsScripting[I].WikiTemplate, aPaths.PathsScripting[I].WikiOutput);

  if DBG_COPY_FOR_REFERENCE then
    for var I := Low(TKMParsingArea) to High(TKMParsingArea) do
      CopyForReference(aPaths.PathsScripting[I].WikiOutput, I);
end;


procedure TKMScriptingParser.LintMessages(aPaths: TKMScriptingPaths);
begin
  fMethods[paActions].LintLogMessages(aPaths.PathsScripting[paActions].SourceInput);
  // Events dont have log messages
  fMethods[paStates].LintLogMessages(aPaths.PathsScripting[paStates].SourceInput);
  fMethods[paUtils].LintLogMessages(aPaths.PathsScripting[paUtils].SourceInput);
  // Utils dont have log messages
end;


procedure TKMScriptingParser.GenerateXML(aPaths: TKMScriptingPaths);
begin
  //todo -cThink: GenerateXML for ScriptingEditor
end;


end.
