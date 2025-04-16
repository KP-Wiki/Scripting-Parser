unit KM_ScriptingParser;
interface
uses
  System.Classes, System.SysUtils, System.Types, Vcl.Forms, Winapi.Windows, System.Generics.Collections, System.IOUtils,
  System.StrUtils,
  KM_ScriptingMethods,
  KM_ScriptingParameters,
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
    procedure ExportMethodsToCode(aArea: TKMParsingArea; const aSourceFile, aCodeFile, aCodeFile2: string);
    procedure ExportMethodsToWiki(aArea: TKMParsingArea; const aSourceFile, aTemplateFile, aOutputFile: string);
    procedure ExportTypesToCode(const aSourceMask, aCodeFile: string);
    procedure ExportTypesToWiki(const aSourceMask, aTemplateFile, aOutputFile: string);
  public
    constructor Create(aParsingGame: TKMParsingGame; aOnLog: TProc<string>);
    destructor Destroy; override;

    procedure GenerateCode(aArea: TKMParsingArea; const aSourceFile, aCodeFile, aCodeFile2: string);
    procedure GenerateWiki(aArea: TKMParsingArea; const aSourceFile, aTemplateFile, aOutputFile: string);
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


procedure TKMScriptingParser.ExportMethodsToCode(aArea: TKMParsingArea; const aSourceFile, aCodeFile, aCodeFile2: string);
var
  countCheck, countReg: Integer;
begin
  if not FileExists(aSourceFile) then Exit;

  fMethods[aArea].LoadFromFile(aSourceFile);

  fOnLog(Format('%d %s parsed', [fMethods[aArea].Count, AREA_INFO[aArea].Short]));

  // Sort for neat order
  fMethods[aArea].SortByName;

  countCheck := 0;
  countReg := 0;
  fMethods[aArea].ExportCode(aCodeFile, countCheck, countReg);
  fMethods[aArea].ExportCode(aCodeFile2, countCheck, countReg);

  fOnLog(Format('%d %s exported into Code checks', [countCheck, AREA_INFO[aArea].Short]));
  fOnLog(Format('%d %s exported into Code regs', [countReg, AREA_INFO[aArea].Short]));
  fOnLog('');
end;


procedure TKMScriptingParser.ExportMethodsToWiki(aArea: TKMParsingArea; const aSourceFile, aTemplateFile, aOutputFile: string);
var
  sl: TStringList;
  exportPath: string;
  countWiki: Integer;
begin
  if not FileExists(aSourceFile) then Exit;

  fMethods[aArea].LoadFromFile(aSourceFile);

  fOnLog(Format('%d %s parsed', [fMethods[aArea].Count, AREA_INFO[aArea].Short]));

  // Sort for neat order
  fMethods[aArea].SortByName;

  if aOutputFile = '' then Exit;

  sl := TStringList.Create;

  sl.Text := fMethods[aArea].ExportWiki(aTemplateFile, countWiki);

  exportPath := ExpandFileName(ExtractFilePath(ParamStr(0)) + aOutputFile);
  if not DirectoryExists(ExtractFileDir(exportPath)) then
    ForceDirectories(ExtractFileDir(exportPath));

  sl.SaveToFile(aOutputFile);

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


procedure TKMScriptingParser.ExportTypesToWiki(const aSourceMask, aTemplateFile, aOutputFile: string);
var
  sl: TStringList;
  exportPath: string;
  s: TStringDynArray;
  I: Integer;
  countWiki: Integer;
begin
  fTypes.Clear;

  // Get all files matching the mask
  s := TDirectory.GetFiles(ExtractFilePath(aSourceMask), ExtractFileName(aSourceMask), TSearchOption.soAllDirectories);
  for I := Low(s) to High(s) do
    fTypes.LoadFromFile(s[I]);

  fOnLog(Format('%d %s parsed', [fTypes.Count, AREA_INFO[paTypes].Short]));

  // Sort for neat order
  fTypes.SortByName(stByAlphabet);

  if aOutputFile = '' then Exit;

  sl := TStringList.Create;

  sl.Text := fTypes.ExportWiki(aTemplateFile, countWiki);

  exportPath := ExpandFileName(ExtractFilePath(ParamStr(0)) + aOutputFile);
  if not DirectoryExists(ExtractFileDir(exportPath)) then
    ForceDirectories(ExtractFileDir(exportPath));

  sl.SaveToFile(aOutputFile);

  sl.Free;

  fOnLog(Format('%d %s exported into Wiki', [countWiki, AREA_INFO[paTypes].Short]));
  fOnLog('');
end;


procedure TKMScriptingParser.GenerateCode(aArea: TKMParsingArea; const aSourceFile, aCodeFile, aCodeFile2: string);
begin
  //todo -cThink: Automate verification in ScriptingParser that functions/procedures pose under the same name in LogMissionWarning
  // Arrays can be declared in 2 ways in KP PS - "array of string" and TKMStringArray. First one is more traditional and more universal.
  // Second one is required for some Utils methods to allow for resizing of passed arrays. Resized arrays become TKMStringArray though.
  // Now, some functions in Actions expect string arrays. Problem is that they must be declared as TKMStringArray to accept both TKMStringArray and "array of"
  //todo -cThink: Hence we need to add such a check in here. KP arrays need to be declared as TKMStringArray (Integer/Single/etc)

  case aArea of
    paActions,
    paEvents,
    paStates,
    paUtils: ExportMethodsToCode(aArea, aSourceFile, aCodeFile, aCodeFile2);
    paTypes: ExportTypesToCode(aSourceFile, aCodeFile);
  end;
end;


procedure TKMScriptingParser.GenerateWiki(aArea: TKMParsingArea; const aSourceFile, aTemplateFile, aOutputFile: string);
begin
  case aArea of
    paActions,
    paEvents,
    paStates,
    paUtils: ExportMethodsToWiki(aArea, aSourceFile, aTemplateFile, aOutputFile);
    paTypes: ExportTypesToWiki(aSourceFile, aTemplateFile, aOutputFile);
  end;

  if DBG_COPY_FOR_REFERENCE then
    CopyForReference(aOutputFile, aArea);
end;


procedure TKMScriptingParser.GenerateXML;
begin
  //todo -cThink: GenerateXML for ScriptingEditor
end;


end.
