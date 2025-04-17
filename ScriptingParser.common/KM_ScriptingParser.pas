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
    procedure ExportMethodsToCode(aArea: TKMParsingArea; const aSourceFile, aFilenameCheck, aFilenameReg: string);
    procedure ExportMethodsToWiki(aArea: TKMParsingArea; aPaths: TKMAreaPathsCommon);
    procedure ExportTypesToCode(const aSourceMask, aCodeFile: string);
    procedure ExportTypesToWiki(aPaths: TKMAreaPathsCommon);
  public
    constructor Create(aParsingGame: TKMParsingGame; aOnLog: TProc<string>);
    destructor Destroy; override;

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


procedure TKMScriptingParser.ExportMethodsToCode(aArea: TKMParsingArea; const aSourceFile, aFilenameCheck, aFilenameReg: string);
begin
  if not FileExists(aSourceFile) then Exit;

  fMethods[aArea].LoadFromFile(aSourceFile);

  fOnLog(Format('%d %s parsed', [fMethods[aArea].Count, AREA_INFO[aArea].Short]));

  // Sort for neat order
  fMethods[aArea].SortByName;

  fMethods[aArea].ExportCode(aFilenameCheck, aFilenameReg);

  fOnLog('');
end;


procedure TKMScriptingParser.ExportMethodsToWiki(aArea: TKMParsingArea; aPaths: TKMAreaPathsCommon);
var
  sl: TStringList;
  exportPath: string;
  countWiki: Integer;
begin
  if not FileExists(aPaths.SourceInput) then Exit;

  fMethods[aArea].LoadFromFile(aPaths.SourceInput);

  fOnLog(Format('%d %s parsed', [fMethods[aArea].Count, AREA_INFO[aArea].Short]));

  // Sort for neat order
  fMethods[aArea].SortByName;

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


procedure TKMScriptingParser.ExportTypesToCode(const aSourceMask, aCodeFile: string);
var
  s: TStringDynArray;
  I: Integer;
  countReg: Integer;
begin
  fTypes.Clear;

  // Get all files matching the mask
  s := TDirectory.GetFiles(ExtractFilePath(aSourceMask), ExtractFileName(aSourceMask), TSearchOption.soAllDirectories);
  for I := Low(s) to High(s) do
    fTypes.LoadFromFile(s[I]);

  fOnLog(Format('%d %s parsed', [fTypes.Count, AREA_INFO[paTypes].Short]));

  // Sort for neat order
  fTypes.SortByName(stByDependancy);

  fTypes.ExportCode(aCodeFile, countReg);

  fOnLog(Format('%d %s exported into Code', [countReg, AREA_INFO[paTypes].Short]));
  fOnLog('');
end;


procedure TKMScriptingParser.ExportTypesToWiki(aPaths: TKMAreaPathsCommon);
var
  sl: TStringList;
  exportPath: string;
  s: TStringDynArray;
  I: Integer;
  countWiki: Integer;
begin
  fTypes.Clear;

  // Get all files matching the mask
  s := TDirectory.GetFiles(ExtractFilePath(aPaths.SourceInput), ExtractFileName(aPaths.SourceInput), TSearchOption.soAllDirectories);
  for I := Low(s) to High(s) do
    fTypes.LoadFromFile(s[I]);

  fOnLog(Format('%d %s parsed', [fTypes.Count, AREA_INFO[paTypes].Short]));

  // Sort for neat order
  fTypes.SortByName(stByAlphabet);

  if aPaths.WikiOutput = '' then Exit;

  sl := TStringList.Create;

  sl.Text := fTypes.ExportWiki(aPaths.WikiTemplate, countWiki);

  exportPath := ExpandFileName(ExtractFilePath(ParamStr(0)) + aPaths.WikiOutput);
  if not DirectoryExists(ExtractFileDir(exportPath)) then
    ForceDirectories(ExtractFileDir(exportPath));

  sl.SaveToFile(aPaths.WikiOutput);

  sl.Free;

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

  ExportMethodsToCode(paActions, aPaths.PathsA.SourceInput, aPaths.PathsA.SourceOutputCheckAndReg, aPaths.PathsA.SourceOutputCheckAndReg);
  ExportMethodsToCode(paEvents, aPaths.PathsE.SourceInput, aPaths.PathsE.SourceOutputCheck, aPaths.PathsE.SourceOutputReg);
  ExportMethodsToCode(paStates, aPaths.PathsS.SourceInput, aPaths.PathsS.SourceOutputCheckAndReg, aPaths.PathsS.SourceOutputCheckAndReg);
  ExportMethodsToCode(paUtils, aPaths.PathsU.SourceInput, aPaths.PathsU.SourceOutputCheckAndReg, aPaths.PathsU.SourceOutputCheckAndReg);
  ExportTypesToCode(aPaths.PathsT.SourceInput, aPaths.PathsT.SourceOutputReg);
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
