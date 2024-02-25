unit KM_ScriptingParser;
interface
uses
  Classes, SysUtils, Types, Vcl.Forms, Windows, Generics.Collections, System.IOUtils,
  StrUtils,
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
    fMethods: array [TKMParsingArea] of TKMScriptMethods;
    fTypes: TKMScriptTypes;
    procedure CopyForReference(const aFilename: string; aArea: TKMParsingArea);
    procedure ExportMethodsToCode(aArea: TKMParsingArea; const aSourceFile, aCodeFile, aCodeFile2: string);
    procedure ExportMethodsToWiki(aArea: TKMParsingArea; const aSourceFile, aTemplateFile, aOutputFile: string);
    procedure ExportTypesToCode(const aSourceMask, aCodeFile: string);
    procedure ExportTypesToWiki(const aSourceMask, aTemplateFile, aOutputFile: string);
  public
    OnLog: TProc<string>;
    constructor Create(aOnLog: TProc<string>);
    destructor Destroy; override;

    procedure GenerateCode(aParsingGame: TKMParsingGame; aArea: TKMParsingArea; const aSourceFile, aCodeFile, aCodeFile2: string);
    procedure GenerateWiki(aParsingGame: TKMParsingGame; aArea: TKMParsingArea; const aSourceFile, aTemplateFile, aOutputFile: string);
    procedure GenerateXML;
  end;


implementation
uses
  KM_ScriptingConsts;


{ TKMScriptingParser }
constructor TKMScriptingParser.Create(aOnLog: TProc<string>);
var
  I: TKMParsingArea;
begin
  inherited Create;

  OnLog := aOnLog;

  for I := Low(TKMParsingArea) to High(TKMParsingArea) do
    fMethods[I] := TKMScriptMethods.Create(I, OnLog);

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
  Windows.CopyFile(PChar(aFilename), PChar(tgtPath), False);
end;


procedure TKMScriptingParser.ExportMethodsToCode(aArea: TKMParsingArea; const aSourceFile, aCodeFile, aCodeFile2: string);
var
  countCheck, countReg: Integer;
begin
  if not FileExists(aSourceFile) then Exit;

  fMethods[aArea].LoadFromFile(aSourceFile);

  OnLog(Format('%d %s parsed', [fMethods[aArea].Count, AREA_INFO[aArea].Short]));

  // Sort for neat order
  fMethods[aArea].SortByName;

  countCheck := 0;
  countReg := 0;
  fMethods[aArea].ExportCode(aCodeFile, fParsingGame, countCheck, countReg);
  fMethods[aArea].ExportCode(aCodeFile2, fParsingGame, countCheck, countReg);

  OnLog(Format('%d %s exported into Code checks', [countCheck, AREA_INFO[aArea].Short]));
  OnLog(Format('%d %s exported into Code regs', [countReg, AREA_INFO[aArea].Short]));
  OnLog('');
end;


procedure TKMScriptingParser.ExportMethodsToWiki(aArea: TKMParsingArea; const aSourceFile, aTemplateFile, aOutputFile: string);
var
  sl: TStringList;
  exportPath: string;
  countWiki: Integer;
begin
  if not FileExists(aSourceFile) then Exit;

  fMethods[aArea].LoadFromFile(aSourceFile);

  OnLog(Format('%d %s parsed', [fMethods[aArea].Count, AREA_INFO[aArea].Short]));

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

  OnLog(Format('%d %s exported into Wiki', [countWiki, AREA_INFO[aArea].Short]));
  OnLog('');
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

  OnLog(Format('%d %s parsed', [fTypes.Count, AREA_INFO[paTypes].Short]));

  // Sort for neat order
  fTypes.SortByName(stByDependancy);

  fTypes.ExportCode(aCodeFile, countReg);

  OnLog(Format('%d %s exported into Code', [countReg, AREA_INFO[paTypes].Short]));
  OnLog('');
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

  OnLog(Format('%d %s parsed', [fTypes.Count, AREA_INFO[paTypes].Short]));

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

  OnLog(Format('%d %s exported into Wiki', [countWiki, AREA_INFO[paTypes].Short]));
  OnLog('');
end;


procedure TKMScriptingParser.GenerateCode(aParsingGame: TKMParsingGame; aArea: TKMParsingArea; const aSourceFile, aCodeFile, aCodeFile2: string);
begin
  fParsingGame := aParsingGame;

  //todo: Verify that functions/procedures pose under the same name in LogMissionWarning

  if aArea in [paActions..paUtils] then
    ExportMethodsToCode(aArea, aSourceFile, aCodeFile, aCodeFile2)
  else
    ExportTypesToCode(aSourceFile, aCodeFile);
end;


procedure TKMScriptingParser.GenerateWiki(aParsingGame: TKMParsingGame; aArea: TKMParsingArea; const aSourceFile, aTemplateFile, aOutputFile: string);
begin
  fParsingGame := aParsingGame;

  if aArea in [paActions..paUtils] then
    ExportMethodsToWiki(aArea, aSourceFile, aTemplateFile, aOutputFile)
  else
    ExportTypesToWiki(aSourceFile, aTemplateFile, aOutputFile);

  if DBG_COPY_FOR_REFERENCE then
    CopyForReference(aOutputFile, aArea);
end;


procedure TKMScriptingParser.GenerateXML;
begin
  //todo -cThink: GenerateXML for ScriptingEditor
end;


end.
