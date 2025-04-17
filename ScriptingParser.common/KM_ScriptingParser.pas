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
  TKMScriptingParser = class
  private const
    DBG_COPY_FOR_REFERENCE = True;
  private
    fParsingGame: TKMParsingGame;
    fOnLog: TProc<string>;
    fMethods: array [TKMParsingArea] of TKMScriptMethods;
    fTypes: TKMScriptTypes;
    procedure CopyForReference(const aFilename: string; aArea: TKMParsingArea);
    procedure ExportMethodsToWiki(aArea: TKMParsingArea; aPaths: TKMAreaPathsCommon);
    procedure ExportTypesToCode(const aCodeFile: string);
    procedure ExportTypesToWiki(aPaths: TKMAreaPathsCommon);
  public
    constructor Create(aParsingGame: TKMParsingGame; aOnLog: TProc<string>);
    destructor Destroy; override;

    procedure ParseCode(aPaths: TKMScriptingPaths);
    procedure GenerateCode(aPaths: TKMScriptingPaths);
    procedure GenerateWiki(aPaths: TKMScriptingPaths);
    procedure GenerateXML;
  end;


implementation
uses
  KM_ScriptingConsts;


{ TKMScriptingParser }
constructor TKMScriptingParser.Create(aParsingGame: TKMParsingGame; aOnLog: TProc<string>);
var
  I: TKMParsingArea;
begin
  inherited Create;

  fParsingGame := aParsingGame;
  fOnLog := aOnLog;

  for I := Low(TKMParsingArea) to High(TKMParsingArea) do
    fMethods[I] := TKMScriptMethods.Create(fParsingGame, I, fOnLog);

  fTypes := TKMScriptTypes.Create;
end;


destructor TKMScriptingParser.Destroy;
var
  I: TKMParsingArea;
begin
  for I := Low(TKMParsingArea) to High(TKMParsingArea) do
    FreeAndNil(fMethods[I]);

  FreeAndNil(fTypes);

  inherited;
end;


procedure TKMScriptingParser.CopyForReference(const aFilename: string; aArea: TKMParsingArea);
var
  tgtPath: string;
begin
  tgtPath := ExtractFilePath(Application.ExeName) + '..\' + GAME_INFO[fParsingGame].Ext + '.' + AREA_INFO[aArea].Short + '.new.md';
  Winapi.Windows.CopyFile(PChar(aFilename), PChar(tgtPath), False);
end;


procedure TKMScriptingParser.ExportMethodsToWiki(aArea: TKMParsingArea; aPaths: TKMAreaPathsCommon);
var
  sl: TStringList;
  exportPath: string;
  countWiki: Integer;
begin
  if aPaths.WikiOutput = '' then Exit;

  sl := TStringList.Create;

  sl.Text := fMethods[aArea].ExportWiki(aPaths.WikiTemplate, countWiki);

  exportPath := ExpandFileName(ExtractFilePath(ParamStr(0)) + aPaths.WikiOutput);
  if not DirectoryExists(ExtractFileDir(exportPath)) then
    ForceDirectories(ExtractFileDir(exportPath));

  sl.SaveToFile(aPaths.WikiOutput);

  sl.Free;

  fOnLog(Format('%d %s exported into Wiki', [countWiki, AREA_INFO[aArea].Short]));
  fOnLog('');
end;


procedure TKMScriptingParser.ExportTypesToCode(const aCodeFile: string);
var
  countReg: Integer;
begin
  fTypes.ExportCode(aCodeFile, countReg);
  fOnLog(Format('%d %s exported into Code', [countReg, AREA_INFO[paTypes].Short]));
  fOnLog('');
end;


procedure TKMScriptingParser.ExportTypesToWiki(aPaths: TKMAreaPathsCommon);
var
  countWiki: Integer;
begin
  fTypes.ExportWiki(aPaths.WikiTemplate, aPaths.WikiOutput, countWiki);
  fOnLog(Format('%d %s exported into Wiki', [countWiki, AREA_INFO[paTypes].Short]));
  fOnLog('');
end;


procedure TKMScriptingParser.GenerateCode(aPaths: TKMScriptingPaths);
begin
  //todo -cThink: Automate verification in ScriptingParser that functions/procedures pose under the same name in LogMissionWarning
  // Arrays can be declared in 2 ways in KP PS - "array of string" and TKMStringArray. First one is more traditional and more universal.
  // Second one is required for some Utils methods to allow for resizing of passed arrays. Resized arrays become TKMStringArray though.
  // Now, some functions in Actions expect string arrays. Problem is that they must be declared as TKMStringArray to accept both TKMStringArray and "array of"
  //todo -cThink: Hence we need to add such a check in here. KP arrays need to be declared as TKMStringArray (Integer/Single/etc)

  fMethods[paActions].ExportCode(aPaths.PathsA.SourceOutputCheckAndReg);
  fMethods[paEvents ].ExportCode(aPaths.PathsE.SourceOutputCheck, aPaths.PathsE.SourceOutputReg);
  fMethods[paStates ].ExportCode(aPaths.PathsS.SourceOutputCheckAndReg);
  fMethods[paUtils  ].ExportCode(aPaths.PathsU.SourceOutputCheckAndReg);
  ExportTypesToCode(aPaths.PathsT.SourceOutputReg);
end;


procedure TKMScriptingParser.ParseCode(aPaths: TKMScriptingPaths);
begin
  fMethods[paActions].LoadFromFile(aPaths.PathsA.SourceInput);
  fOnLog(Format('%d %s parsed', [fMethods[paActions].Count, AREA_INFO[paActions].Short]));

  fMethods[paEvents].LoadFromFile(aPaths.PathsE.SourceInput);
  fOnLog(Format('%d %s parsed', [fMethods[paEvents].Count, AREA_INFO[paEvents].Short]));

  fMethods[paStates].LoadFromFile(aPaths.PathsS.SourceInput);
  fOnLog(Format('%d %s parsed', [fMethods[paStates].Count, AREA_INFO[paStates].Short]));

  fMethods[paUtils].LoadFromFile(aPaths.PathsU.SourceInput);
  fOnLog(Format('%d %s parsed', [fMethods[paUtils].Count, AREA_INFO[paUtils].Short]));

  fTypes.LoadFromFiles(aPaths.PathsT.SourceInput);
  fOnLog(Format('%d %s parsed', [fTypes.Count, AREA_INFO[paTypes].Short]));
end;


procedure TKMScriptingParser.GenerateWiki(aPaths: TKMScriptingPaths);
begin
  ExportMethodsToWiki(paActions, aPaths.PathsA);
  ExportMethodsToWiki(paEvents, aPaths.PathsE);
  ExportMethodsToWiki(paStates, aPaths.PathsS);
  ExportMethodsToWiki(paUtils, aPaths.PathsU);
  ExportTypesToWiki(aPaths.PathsT);

  if DBG_COPY_FOR_REFERENCE then
  begin
    CopyForReference(aPaths.PathsA.WikiOutput, paActions);
    CopyForReference(aPaths.PathsE.WikiOutput, paEvents);
    CopyForReference(aPaths.PathsS.WikiOutput, paStates);
    CopyForReference(aPaths.PathsU.WikiOutput, paUtils);
    CopyForReference(aPaths.PathsT.WikiOutput, paTypes);
  end;
end;


procedure TKMScriptingParser.GenerateXML;
begin
  //todo -cThink: GenerateXML for ScriptingEditor
end;


end.
