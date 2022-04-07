unit KM_ScriptingParser;
interface
uses
  Classes, SysUtils, Types, Vcl.Forms, Windows, Generics.Collections,
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
    procedure ParseMethods(aArea: TKMParsingArea; const aInputFile, aTemplateFile, aOutputFile: string);
    procedure ParseTypes(const aInputFile, aTemplateFile, aOutputFile: string);
  public
    constructor Create;
    destructor Destroy; override;

    function GetText(aArea: TKMParsingArea): string;

    procedure GenerateWiki(aParsingGame: TKMParsingGame; const aActIn, aActTempl, aActOut, aEventIn, aEventTempl, aEventOut,
      aStateIn, aStateTempl, aStateOut, aUtilIn, aUtilTempl, aUtilOut, aTypeIn, aTypeTempl, aTypeOut: string);
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


procedure TKMScriptingParser.ParseMethods(aArea: TKMParsingArea; const aInputFile, aTemplateFile, aOutputFile: string);
var
  sl: TStringList;
  exportPath: string;
begin
  if not FileExists(aInputFile) then Exit;

  fMethods[aArea].LoadFromFile(aInputFile);

  // Sort for neat order
  fMethods[aArea].SortByName;

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


procedure TKMScriptingParser.ParseTypes(const aInputFile, aTemplateFile, aOutputFile: string);
var
  sl: TStringList;
  exportPath: string;
begin
  if not FileExists(aInputFile) then Exit;

  fTypes.LoadFromFile(aInputFile);

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


procedure TKMScriptingParser.GenerateWiki(aParsingGame: TKMParsingGame; const aActIn, aActTempl, aActOut, aEventIn, aEventTempl, aEventOut,
  aStateIn, aStateTempl, aStateOut, aUtilIn, aUtilTempl, aUtilOut, aTypeIn, aTypeTempl, aTypeOut: string);
begin
  fParsingGame := aParsingGame;

  ParseMethods(paActions, aActIn, aActTempl, aActOut);
  ParseMethods(paEvents, aEventIn, aEventTempl, aEventOut);
  ParseMethods(paStates, aStateIn, aStateTempl, aStateOut);
  ParseMethods(paUtils, aUtilIn, aUtilTempl, aUtilOut);
  ParseTypes(aTypeIn, aTypeTempl, aTypeOut);

  if DBG_COPY_FOR_REFERENCE then
  begin
    CopyForReference(aActOut, paActions);
    CopyForReference(aEventOut, paEvents);
    CopyForReference(aStateOut, paStates);
    CopyForReference(aUtilOut, paUtils);
    CopyForReference(aTypeOut, paTypes);
  end;
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
