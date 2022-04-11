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
    fText: array [TKMParsingArea] of string;
    procedure CopyForReference(aFilename: string; aArea: TKMParsingArea);
    procedure ParseMethods(aArea: TKMParsingArea; const aSourceFile, aTemplateFile, aOutputFile, aVerifyFile: string);
    procedure ParseTypes(const aSourceMask, aTemplateFile, aOutputFile: string);
  public
    constructor Create;
    destructor Destroy; override;

    function GetText(aArea: TKMParsingArea): string;

    procedure GenerateWiki(aParsingGame: TKMParsingGame; aArea: TKMParsingArea; const aIn, aTempl, aOut, aVerifyFile: string);
    procedure GenerateXML;
  end;


implementation
uses
  KM_ScriptingConsts;


{ TKMScriptingParser }
constructor TKMScriptingParser.Create;
var
  I: TKMParsingArea;
begin
  inherited;

  for I := Low(TKMParsingArea) to High(TKMParsingArea) do
    fMethods[I] := TKMScriptMethods.Create(I);

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


procedure TKMScriptingParser.CopyForReference(aFilename: string; aArea: TKMParsingArea);
var
  tgtPath: string;
begin
  tgtPath := ExtractFilePath(Application.ExeName) + '..\' + GAME_EXT[fParsingGame] + '.' + AREA_SHORT[aArea] + '.new.md';
  Windows.CopyFile(PChar(aFilename), PChar(tgtPath), False);
end;


procedure TKMScriptingParser.ParseMethods(aArea: TKMParsingArea; const aSourceFile, aTemplateFile, aOutputFile, aVerifyFile: string);
var
  sl: TStringList;
  exportPath: string;
begin
  if not FileExists(aSourceFile) then Exit;

  fMethods[aArea].LoadFromFile(aSourceFile);

  // Sort for neat order
  fMethods[aArea].SortByName;

  fMethods[aArea].VerifyAgainst(aVerifyFile);

  if aOutputFile = '' then Exit;

  sl := TStringList.Create;

  fText[aArea] := fMethods[aArea].ExportWiki(aTemplateFile);
  sl.Text := fText[aArea];

  exportPath := ExpandFileName(ExtractFilePath(ParamStr(0)) + aOutputFile);
  if not DirectoryExists(ExtractFileDir(exportPath)) then
    ForceDirectories(ExtractFileDir(exportPath));

  sl.SaveToFile(aOutputFile);

  sl.Free;
end;


procedure TKMScriptingParser.ParseTypes(const aSourceMask, aTemplateFile, aOutputFile: string);
var
  sl: TStringList;
  exportPath: string;
  s: TStringDynArray;
  I: Integer;
begin
  fTypes.Clear;

  // Get all files matching the mask
  s := TDirectory.GetFiles(ExtractFilePath(aSourceMask), ExtractFileName(aSourceMask), TSearchOption.soAllDirectories);
  for I := Low(s) to High(s) do
    fTypes.LoadFromFile(s[I]);

  // Sort for neat order
  fTypes.SortByName;

  if aOutputFile = '' then Exit;

  sl := TStringList.Create;

  fText[paTypes] := fTypes.ExportWiki(aTemplateFile);
  sl.Text := fText[paTypes];

  exportPath := ExpandFileName(ExtractFilePath(ParamStr(0)) + aOutputFile);
  if not DirectoryExists(ExtractFileDir(exportPath)) then
    ForceDirectories(ExtractFileDir(exportPath));

  sl.SaveToFile(aOutputFile);

  sl.Free;
end;


procedure TKMScriptingParser.GenerateWiki(aParsingGame: TKMParsingGame; aArea: TKMParsingArea; const aIn, aTempl, aOut, aVerifyFile: string);
begin
  fParsingGame := aParsingGame;

  if aArea in [paActions..paUtils] then
    ParseMethods(aArea, aIn, aTempl, aOut, aVerifyFile)
  else
    ParseTypes(aIn, aTempl, aOut);

  if DBG_COPY_FOR_REFERENCE then
    CopyForReference(aOut, aArea);
end;


procedure TKMScriptingParser.GenerateXML;
begin
  //
end;


function TKMScriptingParser.GetText(aArea: TKMParsingArea): string;
begin
  Result := fText[aArea];
end;


end.
