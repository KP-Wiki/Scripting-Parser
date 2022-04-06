unit KM_ScriptingParser;
interface
uses
  Classes, SysUtils, Types, Vcl.Forms, Windows, Generics.Collections,
  StrUtils,
  KM_ScriptingCommands,
  KM_ScriptingParameters;

type
  TKMParsingArea = (paActions, paEvents, paStates, paUtils);
  TKMParsingGame = (pgKaMRemake, pgKnightsProvince);

const
  AREA_SHORT: array [TKMParsingArea] of string = ('Actions', 'Events', 'States', 'Utils');
  GAME_EXT: array [TKMParsingGame] of string = ('kmr', 'kp');

type
  TKMScriptingParser = class
  private const
    DBG_COPY_FOR_REFERENCE = True;
  private
    fListActions, fListEvents, fListStates, fListUtils: TStringList;
    fParsingGame: TKMParsingGame;
    fCommands: array [TKMParsingArea] of TKMScriptCommands;
    procedure CopyForReference(aFilename: string; aArea: TKMParsingArea);
    procedure ParseSource(aArea: TKMParsingArea; const aTitle: string; aResultList: TStringList; const aInputFile, aHeaderFile, aOutputFile: string);
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

  fListActions := TStringList.Create;
  fListEvents := TStringList.Create;
  fListStates := TStringList.Create;
  fListUtils := TStringList.Create;

  for I := Low(TKMParsingArea) to High(TKMParsingArea) do
    fCommands[I] := TKMScriptCommands.Create;
end;


destructor TKMScriptingParser.Destroy;
var
  I: TKMParsingArea;
begin
  FreeAndNil(fListActions);
  FreeAndNil(fListEvents);
  FreeAndNil(fListStates);
  FreeAndNil(fListUtils);

  for I := Low(TKMParsingArea) to High(TKMParsingArea) do
    FreeAndNil(fCommands[I]);

  inherited;
end;


procedure TKMScriptingParser.CopyForReference(aFilename: string; aArea: TKMParsingArea);
var
  tgtPath: string;
begin
  tgtPath := ExtractFilePath(Application.ExeName) + '..\' + GAME_EXT[fParsingGame] + '.' + AREA_SHORT[aArea] + '.new.md';
  Windows.CopyFile(PChar(aFilename), PChar(tgtPath), False);
end;


procedure TKMScriptingParser.ParseSource(aArea: TKMParsingArea; const aTitle: string; aResultList: TStringList; const aInputFile, aHeaderFile, aOutputFile: string);
var
  exportPath: string;
begin
  if not FileExists(aInputFile) then Exit;

  fCommands[aArea].LoadFromFile(aInputFile);

  // Sort for neat order
  fCommands[aArea].SortByName;

  aResultList.Clear;

  if FileExists(aHeaderFile) then
    aResultList.LoadFromFile(aHeaderFile);

  aResultList.Add('');
  aResultList.Add('***');
  aResultList.Add('');

  aResultList.Append(fCommands[aArea].GetLinks);

  aResultList.Add('<br />');
  aResultList.Add('');

  if aArea <> paEvents then
  begin
    aResultList.Add('| Ver<br/>sion | ' + aTitle + ' description | Parameters<br/>and types | Returns |');
    aResultList.Add('| ------- | ------------------------------------ | -------------- | ------- |');
  end else begin
    aResultList.Add('| Ver<br/>sion | ' + aTitle + ' description | Parameters<br/>and types |');
    aResultList.Add('| ------- | ------------------------------------ | -------------- |');
  end;

  aResultList.Append(fCommands[aArea].GetBody(aArea <> paEvents));

  if aOutputFile <> '' then
  begin
    exportPath := ExpandFileName(ExtractFilePath(ParamStr(0)) + aOutputFile);
    if not DirectoryExists(ExtractFileDir(exportPath)) then
      ForceDirectories(ExtractFileDir(exportPath));

    aResultList.SaveToFile(aOutputFile);
  end;
end;


procedure TKMScriptingParser.GenerateWiki(aParsingGame: TKMParsingGame; const aActIn, aActHead, aActOut, aEventIn, aEventHead, aEventOut,
  aStateIn, aStateHead, aStateOut, aUtilIn, aUtilHead, aUtilOut: string);
begin
  fParsingGame := aParsingGame;

  ParseSource(paActions, 'Action', fListActions, aActIn, aActHead, aActOut);
  ParseSource(paEvents, 'Event', fListEvents, aEventIn, aEventHead, aEventOut);
  ParseSource(paStates, 'State', fListStates, aStateIn, aStateHead, aStateOut);
  ParseSource(paUtils, 'Utility function<br/>', fListUtils, aUtilIn, aUtilHead, aUtilOut);

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
  case aArea of
    paActions:  Result := fListActions.Text;
    paEvents:   Result := fListEvents.Text;
    paStates:   Result := fListStates.Text;
    paUtils:    Result := fListUtils.Text;
  end;
end;


end.
