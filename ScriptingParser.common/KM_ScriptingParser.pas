unit KM_ScriptingParser;
interface
uses
  Classes, SysUtils, Types, Vcl.Forms, Windows, Generics.Collections,
  StrUtils,
  KM_ScriptingParameters;

type
  TKMParsingArea = (paActions, paEvents, paStates, paUtils);
const
  AREA_SHORT: array [TKMParsingArea] of string = ('Actions', 'Events', 'States', 'Utils');
type
  TKMParsingGame = (pgKaMRemake, pgKnightsProvince);
const
  GAME_EXT: array [TKMParsingGame] of string = ('kmr', 'kp');

type
  TKMScriptingParser = class
  private const
    DBG_COPY_FOR_REFERENCE = True;
  private
    fListActions, fListEvents, fListStates, fListUtils: TStringList;
    fParsingGame: TKMParsingGame;
    procedure ExtractBodyAndLinks(aArea: TKMParsingArea; aSource, aList, aLinks: TStringList);
    function ExtractParams(aArguments: string; aDescriptions: TStringList): string;
    procedure CopyForReference(aFilename: string; aArea: TKMParsingArea);
    procedure SplitArguments(const aArguments: string; aParamList: TStringList);
    procedure ParseSource(aArea: TKMParsingArea; const aTitle: string; aResultList: TStringList; const aInputFile, aHeaderFile, aOutputFile: string);
  public
    constructor Create;
    destructor Destroy; override;

    function GetText(aArea: TKMParsingArea): string;

    procedure GenerateWiki(aParsingGame: TKMParsingGame; const aActIn, aActHead, aActOut, aEventIn, aEventHead, aEventOut,
      aStateIn, aStateHead, aStateOut, aUtilIn, aUtilHead, aUtilOut: string);
    procedure GenerateXML;
    function ExpandMethodName(const aMethod: string): string;
  end;

  TKMCommandStatus = (csOk, csDeprecated, csRemoved);

  // Complete command info
  TCommandInfo = class
  public
    Version: string; // Version in which command was added/changed
    Name: string;
    Status: TKMCommandStatus;
    Replacement: string;
    Description: string;
    Parameters: string; // Parameters parsed from declaration
    Return: string; // Result type
    ReturnDesc: string; // Result comment
    Details: TStringList; // Command description and parameters comments
    constructor Create;
    destructor Destroy; override;
  end;

  TKMTypeInfo = record
    Name: string;
    Alias: string;
  end;

const
  VAR_TYPE_COUNT = 49;

  VAR_MODIFIERS: array[0..1] of string = ('out', 'var');
  VAR_TYPE_INFO: array[0..VAR_TYPE_COUNT-1] of TKMTypeInfo = (
    // Simple types
    (Name: 'Byte'),       (Name: 'Shortint'),   (Name: 'Smallint'),   (Name: 'Word'),
    (Name: 'Integer'),    (Name: 'Cardinal'),   (Name: 'Single'),     (Name: 'Extended'),
    (Name: 'Boolean'),    (Name: 'AnsiString'), (Name: 'String'),     (Name: 'UnicodeString'),
    (Name: 'array of const'),      (Name: 'array of Boolean'),
    (Name: 'array of String'),     (Name: 'array of AnsiString'),
    (Name: 'array of Integer'),    (Name: 'array of Single'),
    (Name: 'array of Extended'),
    // Custom types
    (Name: 'TKMPoint'), (Name: 'TKMWareType'), (Name: 'TKMFieldType'), (Name: 'TKMUnitType'),
    // KMR
    (Name: 'TKMArmyType'), (Name: 'TKMGroupOrder'), (Name: 'TKMHouseType'),
    (Name: 'TKMTerrainTileBrief'), (Name: 'TKMMissionDifficulty'), (Name: 'TKMMissionDifficultySet'),
    (Name: 'array of TKMTerrainTileBrief'), (Name: 'TKMAudioFormat'), (Name: 'TKMAIAttackTarget'),
    (Name: 'TKMTerrainKind'), (Name: 'TKMTileMaskKind'), (Name: 'TKMTileOverlay'),
    // KP
    (Name: 'TKMHouseFace'), (Name: 'TKMObjectiveStatus'), (Name: 'TKMObjectiveType'),
    // Werewolf types
    (Name: 'TByteSet'; Alias: 'set of Byte'), (Name: 'TIntegerArray'; Alias: 'array of Integer'), (Name: 'TAnsiStringArray'; Alias: 'array of AnsiString'),
    (Name: 'TKMHouse'; Alias: 'Integer'), (Name: 'TKMUnit'; Alias: 'Integer'), (Name: 'TKMUnitGroup'; Alias: 'Integer'),
    // KMR
    (Name: 'TKMHandID'; Alias: 'Integer'), (Name: 'array of TKMHandID'; Alias: 'array of Integer'),
    // KP
    (Name: 'TKMEntity'; Alias: 'Integer'), (Name: 'TKMHandIndex'; Alias: 'Integer'), (Name: 'array of TKMHandIndex'; Alias: 'array of Integer')
  );


implementation


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


procedure StrSplit(const aStr, aDelimiters: string; aStrings: TStringList);
var
  StrArray: TStringDynArray;
  I: Integer;
begin
  StrArray := SplitString(aStr, aDelimiters);
  for I := Low(StrArray) to High(StrArray) do
  if StrArray[I] <> '' then
    aStrings.Add(StrArray[I]);
end;


// Try to convert a type into alias
function TryTypeToAlias(const aType: string): string;
var
  I: Integer;
begin
  Result := aType;
  for I := 0 to High(VAR_TYPE_INFO) do
    if (VAR_TYPE_INFO[I].Alias <> '') and SameText(VAR_TYPE_INFO[I].Name, aType) then
      Exit(VAR_TYPE_INFO[I].Alias);
end;


{ TCommandInfo }
constructor TCommandInfo.Create;
begin
  inherited;

  Details := TStringList.Create;
end;


destructor TCommandInfo.Destroy;
begin
  FreeAndNil(Details);

  inherited;
end;


{ TKMScriptingParser }
constructor TKMScriptingParser.Create;
begin
  inherited;

  fListActions := TStringList.Create;
  fListEvents := TStringList.Create;
  fListStates := TStringList.Create;
  fListUtils := TStringList.Create;
end;


destructor TKMScriptingParser.Destroy;
begin
  FreeAndNil(fListActions);
  FreeAndNil(fListEvents);
  FreeAndNil(fListStates);
  FreeAndNil(fListUtils);

  inherited;
end;


function TKMScriptingParser.ExpandMethodName(const aMethod: string): string;
var
  I: Integer;
begin
  Result := '';

  for I := 0 to High(VAR_TYPE_INFO) do
  if SameText(VAR_TYPE_INFO[I].Name, aMethod) then
    Exit(IfThen(VAR_TYPE_INFO[I].Alias <> '', VAR_TYPE_INFO[I].Alias, VAR_TYPE_INFO[I].Name));
end;


procedure TKMScriptingParser.SplitArguments(const aArguments: string; aParamList: TStringList);
var
  I, nextType: Integer;
  listTokens: TStringList;
begin
  listTokens := TStringList.Create;
  try
    StrSplit(aArguments, ',:; ', listTokens);

    // Re-combine type arrays
    nextType := -1;
    for I := 0 to listTokens.Count - 1 do
    if not SameText(listTokens[I], 'const') then
    begin
      if SameText(listTokens[I], 'array') then
      begin
        // Assemble the "[array] + [of] + [something]"
        aParamList.Add(listTokens[I] + ' ' + listTokens[I + 1] + ' ' + listTokens[I + 2]);
        nextType := I + 2;
      end else
        // Skip parts after [array]
        if I > nextType then
          aParamList.Add(listTokens[I]);
    end;
  finally
    FreeAndNil(listTokens);
  end;
end;

{
  Parses the param string into prefered wiki-format.
  Results:
  1 - [name]: [type];
  2 - etc
}
function TKMScriptingParser.ExtractParams(aArguments: string; aDescriptions: TStringList): string;
var
  I, J, K: Integer;
  isParam: Boolean;
  paramList, typeList: TStringList;
  scriptParameters: TKMScriptParameters;
  lastType: string;
  nextVarModifier: string;
  desc: string;
begin
  Result := '';

  scriptParameters := TKMScriptParameters.Create;

  paramList := TStringList.Create;
  typeList  := TStringList.Create;
  try
    // If not set to -1 it skips the first variable
    nextVarModifier := '';

    SplitArguments(aArguments, paramList);

    //Check for 'out' and 'var' variables modifiers (they are in paramList now)
    nextVarModifier := '';
    for I := 0 to paramList.Count - 1 do
    begin
      // See if this token is a Type
      isParam := True;
      for K := 0 to High(VAR_MODIFIERS) do
        if SameText(VAR_MODIFIERS[K], paramList[I]) then
        begin
          nextVarModifier := VAR_MODIFIERS[K];
          paramList[I] := ''; //modifier is not a param
          isParam := False;
          Break;
        end;

      //Update var names until first type found
      if isParam then
        for K := 0 to High(VAR_TYPE_INFO) do
          if SameText(VAR_TYPE_INFO[K].Name, paramList[I]) then
          begin
            nextVarModifier := '';
            isParam := False;
            Break;
          end;

      //Update var name (add modifier to it)
      if isParam and (nextVarModifier <> '') then
        paramList[I] := nextVarModifier + ' ' + paramList[I];
    end;

    // Bind variable names to their type
    // Use reverse scan, so that we can remember last met type and apply it to all preceeding parameters
    lastType := '';
    for I := paramList.Count - 1 downto 0 do
    begin
      if paramList[I] = '' then // Skip empty params (f.e. modifiers "var" or "out")
        Continue;

      // See if this token is a Type
      isParam := True;
      for K := 0 to High(VAR_TYPE_INFO) do
        if SameText(VAR_TYPE_INFO[K].Name, paramList[I]) then
        begin
          lastType := IfThen(VAR_TYPE_INFO[K].Alias <> '', VAR_TYPE_INFO[K].Alias, VAR_TYPE_INFO[K].Name);
          isParam := False;
          Break;
        end;

      if isParam then
      begin
        // Find and remove parameter description
        desc := '';
        for J := aDescriptions.Count - 1 downto 0 do
          if StartsStr(paramList[I], aDescriptions[J]) then
          begin
            desc := StrSubstring(aDescriptions[J], Pos(':', aDescriptions[J]) + 1);
            aDescriptions.Delete(J);
            Break;
          end;

        scriptParameters.Append(paramList[I], lastType, desc);
      end;
    end;
  finally
    FreeAndNil(paramList);
    FreeAndNil(typeList);
  end;

  Result := scriptParameters.GetText;

  scriptParameters.Free;
end;


// Scans source contents and puts it all in proper formatting for most wikis.
procedure TKMScriptingParser.ExtractBodyAndLinks(aArea: TKMParsingArea; aSource, aList, aLinks: TStringList);
const
  UNICODE_RED_CROSS = '&#x274C;';
var
  i, j, iPlus: Integer;
  restStr, deprStr: string;
  srcLine: string;
  ci: TCommandInfo;
  strStatus: string;
begin
  for i := 0 to aSource.Count - 1 do
  begin
    // Create new command to fill
    ci := TCommandInfo.Create;
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
      restStr := Trim(StrSubstring(srcLine, Pos(':', srcLine) + 1));
      ci.Version := IfThen(restStr = '', '-', restStr);
      Inc(iPlus);
      srcLine := aSource[i+iPlus];

      ci.Status := csOk;
      ci.Replacement := '';
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

          ci.Parameters := ExtractParams(restStr, ci.Details);
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

          ci.Parameters := ExtractParams(restStr, ci.Details);
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
                ' | <sub>' + ci.Parameters + '</sub>' +
                IfThen(aArea <> paEvents, ' | <sub>' + ci.Return + IfThen(ci.ReturnDesc <> '', ' //' + ci.ReturnDesc) + '</sub>') +
                ' |');

      aLinks.Add('* <a href="#' + ci.Name + '">' + ci.Name + '</a>');
    end;

    FreeAndNil(ci);
  end;
end;


function DoSort(List: TStringList; Index1, Index2: Integer): Integer;
var
  A, B: string;
begin
  A := List[Index1];
  B := List[Index2];
  // Sort in assumption that method name is in the second || clause
  A := Copy(A, PosEx('| ', A, 2) + 2, 40);
  B := Copy(B, PosEx('| ', B, 2) + 2, 40);
  Result := CompareText(A, B);
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
    ExtractBodyAndLinks(aArea, slSource, slBody, slLinks);
  finally
    slSource.Free;
  end;

  slBody.CustomSort(DoSort);
  slLinks.Sort();

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
