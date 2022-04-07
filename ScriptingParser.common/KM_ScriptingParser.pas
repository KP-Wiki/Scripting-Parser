unit KM_ScriptingParser;
interface
uses
  Classes, SysUtils, Types, Vcl.Forms, Windows, Generics.Collections,
  StrUtils,
  KM_ScriptingMethods,
  KM_ScriptingParameters,
  KM_ScriptingTypes;

type
  TKMScriptingParser = class
  private const
    DBG_COPY_FOR_REFERENCE = True;
  private
    fParsingGame: TKMParsingGame;
    fMethods: array [TKMParsingArea] of TKMScriptMethods;
    fText: array [TKMParsingArea] of string;
    procedure CopyForReference(aFilename: string; aArea: TKMParsingArea);
    procedure ParseSource(aArea: TKMParsingArea; const aInputFile, aHeaderFile, aOutputFile: string);
  public
    constructor Create;
    destructor Destroy; override;

    function GetText(aArea: TKMParsingArea): string;

    procedure GenerateWiki(aParsingGame: TKMParsingGame; const aActIn, aActHead, aActOut, aEventIn, aEventHead, aEventOut,
      aStateIn, aStateHead, aStateOut, aUtilIn, aUtilHead, aUtilOut: string);
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
end;


destructor TKMScriptingParser.Destroy;
var
  I: TKMParsingArea;
begin
  for I := Low(TKMParsingArea) to High(TKMParsingArea) do
    FreeAndNil(fMethods[I]);

  inherited;
end;


procedure TKMScriptingParser.CopyForReference(aFilename: string; aArea: TKMParsingArea);
var
  tgtPath: string;
begin
  tgtPath := ExtractFilePath(Application.ExeName) + '..\' + GAME_EXT[fParsingGame] + '.' + AREA_SHORT[aArea] + '.new.md';
  Windows.CopyFile(PChar(aFilename), PChar(tgtPath), False);
end;


procedure TKMScriptingParser.ParseSource(aArea: TKMParsingArea; const aInputFile, aHeaderFile, aOutputFile: string);
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

  fText[aArea] := fMethods[aArea].ExportWiki(aHeaderFile);
  sl.Text := fText[aArea];

  exportPath := ExpandFileName(ExtractFilePath(ParamStr(0)) + aOutputFile);
  if not DirectoryExists(ExtractFileDir(exportPath)) then
    ForceDirectories(ExtractFileDir(exportPath));

  sl.SaveToFile(aOutputFile);

  sl.Free;
end;


procedure TKMScriptingParser.GenerateWiki(aParsingGame: TKMParsingGame; const aActIn, aActHead, aActOut, aEventIn, aEventHead, aEventOut,
  aStateIn, aStateHead, aStateOut, aUtilIn, aUtilHead, aUtilOut: string);
begin
  fParsingGame := aParsingGame;

  ParseSource(paActions, aActIn, aActHead, aActOut);
  ParseSource(paEvents, aEventIn, aEventHead, aEventOut);
  ParseSource(paStates, aStateIn, aStateHead, aStateOut);
  ParseSource(paUtils, aUtilIn, aUtilHead, aUtilOut);

  if DBG_COPY_FOR_REFERENCE then
  begin
    CopyForReference(aActOut, paActions);
    CopyForReference(aEventOut, paEvents);
    CopyForReference(aStateOut, paStates);
    CopyForReference(aUtilOut, paUtils);
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
