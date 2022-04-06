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
    procedure ExtractBodyAndLinks(aArea: TKMParsingArea; aSource: TStringList);
    procedure ExportBodyAndLinks(aArea: TKMParsingArea; aList, aLinks: TStringList);
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


// string functions
// These function are replacements for string functions introduced after XE2 (XE5 probably)
// Names are the same as in new Delphi versions, but with 'Str' prefix
// We keep them here to support pre-XE5 compilation
function StrSubstring(const aStr: string; aFrom: Integer): string;
begin
  Result := Copy(aStr, aFrom + 1, Length(aStr));
end;


function StrLastIndexOf(const aStr, aSubStr: string): Integer;
var
  I: Integer;
begin
  Result := -1;
  for I := 1 to Length(aStr) do
    if AnsiPos(aSubStr, StrSubstring(aStr, I-1)) <> 0 then
      Result := I - 1;
end;


function StrTrimRightSeparators(const aStr: string): string;
var
  I, K: Integer;
begin
  K := 0;
  for I := Length(aStr) downto 1 do
  if not (aStr[I] in [',', ':', ';']) then
  begin
    K := I;
    Break;
  end;
  Result := Copy(aStr, 1, K);
end;


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


// Scans source contents and puts it all in proper formatting for most wikis.
procedure TKMScriptingParser.ExtractBodyAndLinks(aArea: TKMParsingArea; aSource: TStringList);
var
  i, iPlus: Integer;
  restStr: string;
  srcLine: string;
  ci: TKMCommandInfo;
  strStatus: string;
begin
  fCommands[aArea].Clear;

  for i := 0 to aSource.Count - 1 do
  begin
    iPlus := 0;
    srcLine := aSource[i+iPlus];

    //* Version: 1234
    //* Status: -/Deprecated/Removed [optional]
    //* Replacement: Link to the replacement method [optional]
    //* Large description of the method [optional]
    //* aX: Small optional description of parameter
    //* aY: Small optional description of parameter
    //* Result: Small optional description of returned value

    // Before anything it should start with "//* Version:"
    if StartsStr('//* Version:', srcLine) then
    begin
      // Create new command to fill
      ci := TKMCommandInfo.Create;

      restStr := Trim(StrSubstring(srcLine, Pos(':', srcLine) + 1));
      ci.Version := IfThen(restStr = '', '-', restStr);
      Inc(iPlus);
      srcLine := aSource[i+iPlus];

      // Descriptions are only added by lines starting with "//*"
      // Repeat until no description tags are found
      while StartsStr('//*', srcLine) do
      begin
        if StartsStr('//* Status:', srcLine) then
        begin
          strStatus := Trim(StrSubstring(srcLine, Pos(':', srcLine) + 1));
          if StartsStr('Deprecated', strStatus) then
            ci.Status := csDeprecated
          else
          if StartsStr('Removed', strStatus) then
            ci.Status := csRemoved;
        end else
        if StartsStr('//* Replacement:', srcLine) then
          ci.Replacement := Trim(StrSubstring(srcLine, Pos(':', srcLine) + 1))
        else
        // Handle Result description separately to keep the output clean
        if StartsStr('//* Result:', srcLine) then
          ci.ReturnDesc := StrSubstring(srcLine, Pos(':', srcLine) + 1)
        else
          ci.Details.Add(StrSubstring(srcLine, Pos('*', srcLine) + 1));
        Inc(iPlus);
        srcLine := aSource[i+iPlus];
      end;

      // Skip empty or "faulty" lines (e.g. comments not intended for wiki)
      while not StartsStr('procedure', srcLine)
      and not StartsStr('function', srcLine) do
      begin
        Inc(iPlus);
        srcLine := aSource[i+iPlus];
      end;

      // Format procedures
      if StartsStr('procedure', srcLine) then
      begin
        if Pos('(', srcLine) <> 0 then
        begin
          // Procedure with parameters
          restStr := Copy(srcLine, Pos('.', srcLine) + 1, Pos('(', srcLine) - 1 - Pos('.', srcLine));
          restStr := ReplaceStr(restStr, 'ProcOn', 'On'); // For the KP
          ci.Name := ReplaceStr(restStr, 'Proc', 'On');   // For the KMR

          // Parameters could go for several lines
          restStr := '';
          while Pos(')', srcLine) = 0 do
          begin
            restStr := Copy(srcLine, Pos('(', srcLine) + 1, Length(srcLine));
            Inc(iPlus);
            srcLine := aSource[i+iPlus];
          end;
          restStr := restStr + Copy(srcLine, Pos('(', srcLine) + 1, Pos(')', srcLine) - 1 - Pos('(', srcLine));

          ci.Parameters.ParseFromString(restStr, ci.Details);
        end else
        begin
          // Procedure without parameters
          restStr := Copy(srcLine, Pos('.', srcLine) + 1, Pos(';', srcLine) - 1 - Pos('.', srcLine));
          restStr := ReplaceStr(restStr, 'ProcOn', 'On'); // For the KP
          ci.Name := ReplaceStr(restStr, 'Proc', 'On');   // For the KMR
        end;
      end;

      // Format functions
      if StartsStr('function', srcLine) then
      begin
        if Pos('(', srcLine) <> 0 then
        begin
          // Function with parameters
          restStr := Copy(srcLine, Pos('.', srcLine) + 1, Pos('(', srcLine) - 1 - Pos('.', srcLine));
          restStr := ReplaceStr(restStr, 'FuncOn', 'On'); // For the KP
          ci.Name := ReplaceStr(restStr, 'Func', 'On');   // For the KMR

          // Parameters could go for several lines
          restStr := '';
          while Pos(')', srcLine) = 0 do
          begin
            restStr := Copy(srcLine, Pos('(', srcLine) + 1, Length(srcLine));
            Inc(iPlus);
            srcLine := aSource[i+iPlus];
          end;
          restStr := restStr + Copy(srcLine, Pos('(', srcLine) + 1, Pos(')', srcLine) - 1 - Pos('(', srcLine));

          ci.Parameters.ParseFromString(restStr, ci.Details);
        end else
        begin
          // Function without parameters
          restStr := Copy(srcLine, Pos('.', srcLine) + 1, Pos(':', srcLine) - 1 - Pos('.', srcLine));
          restStr := ReplaceStr(restStr, 'FuncOn', 'On'); // For the KP
          ci.Name := ReplaceStr(restStr, 'Func', 'On');   // For the KMR
        end;

        // Function result
        restStr := StrTrimRightSeparators(StrSubstring(srcLine, StrLastIndexOf(srcLine, ':') + 2));
        ci.Return := TryTypeToAlias(restStr);
      end;

      fCommands[aArea].Append(ci);
    end;
  end;
end;


procedure TKMScriptingParser.ExportBodyAndLinks(aArea: TKMParsingArea; aList, aLinks: TStringList);
const
  UNICODE_RED_CROSS = '&#x274C;';
var
  I, J: Integer;
  ci: TKMCommandInfo;
  deprStr: string;
begin
  for I := 0 to fCommands[aArea].Count - 1 do
  begin
    ci := fCommands[aArea][I];

    // Now we can assemble Description, after we have detected and removed parameters descriptions from it
    for j := 0 to ci.Details.Count - 1 do
      // We don't need <br/> after </pre> since </pre> has an automatic visual "br" after it
      if (j > 0) and (RightStr(ci.Details[j-1], 6) = '</pre>') then
        ci.Description := ci.Description + ci.Details[j]
      else
        ci.Description := ci.Description + '<br/>' + ci.Details[j];

    deprStr := '';
    if ci.Status = csDeprecated then
    begin
      deprStr := '<br/>' + UNICODE_RED_CROSS + '`Deprecated`<br/>' +
                 '<sub>*Method could be removed in the future game versions';

      if ci.Replacement <> '' then
        if ci.Replacement = StringReplace(ci.Replacement, ' ', '', [rfReplaceAll]) then
          deprStr := deprStr + ', use <a href="#' + ci.Replacement + '">' + ci.Replacement + '</a> instead'
        else
          deprStr := deprStr + ', ' + ci.Replacement;

      deprStr := deprStr + '*</sub>';
    end;
    if ci.Status = csRemoved then
    begin
      deprStr := '<br/>' + UNICODE_RED_CROSS + '`Removed`<br/>' +
                 '<sub>*Method was removed';

      if ci.Replacement <> '' then
        if ci.Replacement = StringReplace(ci.Replacement, ' ', '', [rfReplaceAll]) then
          deprStr := deprStr + ', use <a href="#' + ci.Replacement + '">' + ci.Replacement + '</a> instead'
        else
          deprStr := deprStr + ', ' + ci.Replacement;

      deprStr := deprStr + '*</sub>';
    end;

    // Now we have all the parts and can combine them however we like
    aList.Add('| ' + ci.Version + ' | <a id="' + ci.Name + '">' + ci.Name + '</a>' +
              deprStr +
              '<sub>' + ci.Description + '</sub>' +
              ' | <sub>' + ci.Parameters.GetText + '</sub>' +
              IfThen(aArea <> paEvents, ' | <sub>' + ci.Return + IfThen(ci.ReturnDesc <> '', ' //' + ci.ReturnDesc) + '</sub>') +
              ' |');

    aLinks.Add('* <a href="#' + ci.Name + '">' + ci.Name + '</a>');
  end;
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
  slSource, slBody, slLinks: TStringList;
  Path: string;
begin
  if not FileExists(aInputFile) then Exit;

  slBody := TStringList.Create;
  slLinks := TStringList.Create;

  aResultList.Clear;

  slSource := TStringList.Create;
  try
    slSource.LoadFromFile(aInputFile);
    ExtractBodyAndLinks(aArea, slSource);
  finally
    slSource.Free;
  end;

  // Sort for neat order
  fCommands[aArea].SortByName;

  ExportBodyAndLinks(aArea, slBody, slLinks);

  if FileExists(aHeaderFile) then
    aResultList.LoadFromFile(aHeaderFile);

  aResultList.Add('');
  aResultList.Add('***');
  aResultList.Add('');

  aResultList.AddStrings(slLinks);

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

  aResultList.AddStrings(slBody);

  if aOutputFile <> '' then
  begin
    Path := ExpandFileName(ExtractFilePath(ParamStr(0)) + aOutputFile);
    if not DirectoryExists(ExtractFileDir(Path)) then
      ForceDirectories(ExtractFileDir(Path));
    aResultList.SaveToFile(aOutputFile);
  end;

  FreeAndNil(slBody);
  FreeAndNil(slLinks);
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
