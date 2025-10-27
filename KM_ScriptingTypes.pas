unit KM_ScriptingTypes;
interface
uses
  System.Classes, System.SysUtils, System.Types, System.Generics.Collections, System.Generics.Defaults,
  System.Math, System.StrUtils,
  KM_ParserTypes;

type
  // There are these base types we want to share in the Wiki:
  TKMTypeType = (ttEnum, ttRecord, ttArray, ttSetOfType, ttSetOfEnum);

  TKMSortType = (stByAlphabet, stByDependancy);

  // Single type element (
  TKMScriptTypeElement = class
  private
    fName: string; // Name of the element
    fDesc: string; // Description of the element
  public
    constructor Create(const aName, aDesc: string);
    function ExportWikiBody: string;
  end;

  // Collection of elements (e.g. enum)
  TKMScriptTypeElements = class
  private
    fList: TList<TKMScriptTypeElement>;
  public
    constructor Create;
    destructor Destroy; override;
    procedure ParseFromStringList(aType: TKMTypeType; aStrings: TStringList);
    function ExportCode(aType: TKMTypeType): string;
    function ExportWikiBody: string;
  end;

  // Single type info
  TKMScriptType = class
  private
    fName: string;
    fType: TKMTypeType;
    fDescription: string;
    fElements: TKMScriptTypeElements;
  public
    SortPriority: Integer;
    constructor Create;
    destructor Destroy; override;
    procedure LoadFromStringList(aSource: TStringList);
    function ExportCode: string;
    function ExportWikiBody: string;
    function ExportWikiLink: string;
  end;

  // List of types
  TKMScriptTypes = class
  private
    fOnLog: TProc<string>;
    fList: TObjectList<TKMScriptType>;
    procedure AssignSortOrder;
    function ExportWikiBody: string;
    function ExportWikiLinks: string;
    function GetCount: Integer;
    procedure LoadFromFile(const aInputFile: string);
    procedure SortByName(aSortBy: TKMSortType);
  public
    constructor Create(aOnLog: TProc<string>);
    destructor Destroy; override;

    procedure Clear;
    property Count: Integer read GetCount;
    procedure LoadFromFiles(const aSourceMask: string);
    procedure ExportCode(const aCodeFile: string);
    procedure ExportWiki(const aTemplateFile, aOutputFile: string);
  end;


implementation
uses
  System.IOUtils,
  KM_ScriptingConsts, KM_StringUtils;


{ TKMScriptTypeElement }
constructor TKMScriptTypeElement.Create(const aName, aDesc: string);
begin
  inherited Create;

  fName := aName;
  fDesc := aDesc;
end;


function TKMScriptTypeElement.ExportWikiBody: string;
begin
  Result := '<sub>**' + fName + '**' + IfThen(fDesc <> '', ' // ' + fDesc) + '</sub>';
end;


{ TKMScriptTypeElements }
constructor TKMScriptTypeElements.Create;
begin
  inherited;

  fList := TList<TKMScriptTypeElement>.Create;
end;


destructor TKMScriptTypeElements.Destroy;
begin
  FreeAndNil(fList);

  inherited;
end;


procedure TKMScriptTypeElements.ParseFromStringList(aType: TKMTypeType; aStrings: TStringList);
var
  I, K: Integer;
  comment: string;
  colonPos, commentPos: Integer;
  declaration: string;
  elements: TStringDynArray;
begin
  case aType of
    ttEnum:     begin
                  aStrings[0] := ReplaceStr(aStrings[0], '(', '');
                  aStrings[aStrings.Count - 1] := ReplaceStr(aStrings[aStrings.Count - 1], ');', '');

                  for I := 0 to aStrings.Count - 1 do
                  if aStrings[I] <> '' then
                  begin
                    commentPos := Pos('//', aStrings[I]);
                    if commentPos > 0 then
                    begin
                      comment := Trim(RightStr(aStrings[I], Length(aStrings[I]) - commentPos - 1));
                      declaration := LeftStr(aStrings[I], commentPos - 1);
                    end else
                    begin
                      comment := '';
                      declaration := aStrings[I];
                    end;

                    elements := SplitString(declaration, ',');

                    for K := Low(elements) to High(elements) do
                    if Trim(elements[K]) <> '' then
                      fList.Add(TKMScriptTypeElement.Create(Trim(elements[K]), comment));
                  end;
                end;
    ttRecord:   for I := 0 to aStrings.Count - 1 do
                if (aStrings[I] <> '') and (Pos(':', aStrings[I]) > 0) then
                begin
                  colonPos := Pos(':', aStrings[I]);
                  commentPos := Pos('//', aStrings[I]);

                  if (Pos('(', aStrings[I]) > colonPos)
                  or (Pos(')', aStrings[I]) > colonPos)
                  or InRange(Pos('function', aStrings[I]), 1, colonPos)
                  or InRange(Pos('procedure', aStrings[I]), 1, colonPos) then
                    Continue;

                  if commentPos > 0 then
                  begin
                    comment := Trim(RightStr(aStrings[I], Length(aStrings[I]) - commentPos - 1));
                    declaration := LeftStr(aStrings[I], commentPos - 1);
                  end else
                  begin
                    comment := '';
                    declaration := aStrings[I];
                  end;

                  // Trim trailing ";" for nicer look
                  declaration := Trim(ReplaceStr(declaration, ';', ''));

                  fList.Add(TKMScriptTypeElement.Create(declaration, comment));
                end;
    ttArray:    begin
                  Assert(aStrings.Count = 1);
                  commentPos := Pos('//', aStrings[0]);

                  if commentPos > 0 then
                  begin
                    comment := Trim(RightStr(aStrings[0], Length(aStrings[0]) - commentPos - 1));
                    declaration := LeftStr(aStrings[0], commentPos - 1);
                  end else
                  begin
                    comment := '';
                    declaration := aStrings[0];
                  end;

                  declaration := Trim(ReplaceStr(declaration, ';', ''));

                  fList.Add(TKMScriptTypeElement.Create(declaration, comment));
                end;
    ttSetOfType:begin
                  Assert(aStrings.Count = 1);

                  // Single type declaration needs no comments
                  declaration := ReplaceStr(aStrings[0], ';', '');

                  fList.Add(TKMScriptTypeElement.Create(declaration, ''));
                end;
    ttSetOfEnum:begin
                  aStrings[0] := ReplaceStr(aStrings[0], 'set of', '');
                  aStrings[0] := ReplaceStr(aStrings[0], '(', '');
                  aStrings[aStrings.Count - 1] := ReplaceStr(aStrings[aStrings.Count - 1], ');', '');

                  for I := 0 to aStrings.Count - 1 do
                  if aStrings[I] <> '' then
                  begin
                    commentPos := Pos('//', aStrings[I]);
                    if commentPos > 0 then
                    begin
                      comment := Trim(RightStr(aStrings[I], Length(aStrings[I]) - commentPos - 1));
                      declaration := LeftStr(aStrings[I], commentPos - 1);
                    end else
                    begin
                      comment := '';
                      declaration := aStrings[I];
                    end;

                    elements := SplitString(declaration, ',');

                    for K := Low(elements) to High(elements) do
                    if Trim(elements[K]) <> '' then
                      fList.Add(TKMScriptTypeElement.Create(Trim(elements[K]), comment));
                  end;
                end;
  end;
end;


function TKMScriptTypeElements.ExportCode(aType: TKMTypeType): string;
const
  WRAP_AROUND_COUNT = 5;
var
  I: Integer;
begin
  case aType of
    ttEnum:       begin
                    Result := #39'(';
                    for I := 0 to fList.Count - 1 do
                    begin
                      if (I > 0) and (I mod WRAP_AROUND_COUNT = 0) then
                        Result := Result + #39' +' + sLineBreak + '      '#39;

                      Result := Result + fList[I].fName + IfThen(I < fList.Count - 1, ', ');
                    end;
                    Result := Result + ')'#39;
                  end;
    ttRecord:     begin
                    Result := #39 + 'record '#39 + ' +' + sLineBreak;

                    for I := 0 to fList.Count - 1 do
                      Result := Result + '        '#39 + fList[I].fName + '; '#39 + ' +' + sLineBreak;

                    Result := Result + '      '#39'end;'#39;
                  end;
    ttArray:      Result := #39 + fList[0].fName + #39;
    ttSetOfType:  Result := #39 + fList[0].fName + #39;
    ttSetOfEnum:  begin
                    Result := #39'set of (';
                    for I := 0 to fList.Count - 1 do
                    begin
                      if (I > 0) and (I mod WRAP_AROUND_COUNT = 0) then
                        Result := Result + #39' +' + sLineBreak + '      '#39;

                      Result := Result + fList[I].fName + IfThen(I < fList.Count - 1, ', ');
                    end;
                    Result := Result + ')'#39;
                  end;
  end;
end;


function TKMScriptTypeElements.ExportWikiBody: string;
var
  I: Integer;
begin
  Result := '';
  for I := 0 to fList.Count - 1 do
    Result := Result + IfThen(I > 0, '<br/>') + fList[I].ExportWikiBody;
end;


{ TKMScriptType }
constructor TKMScriptType.Create;
begin
  inherited;

  fElements := TKMScriptTypeElements.Create;
end;


destructor TKMScriptType.Destroy;
begin
  FreeAndNil(fElements);

  inherited;
end;


procedure TKMScriptType.LoadFromStringList(aSource: TStringList);
var
  I: Integer;
  srcLine: string;
  enumStr: TStringList; // Needs to be a list because of comments
  details: TStringList;
begin
  details := TStringList.Create;
  enumStr := TStringList.Create;
  try
    I := 0;
    srcLine := aSource[I];

//    if StartsStr('//* Version:', srcLine) then
//    begin
//      fVersion := Trim(RightStrAfter(srcLine, ':'));
//      Inc(I);
//      srcLine := aSource[I];
//    end;

    // Descriptions are only added by lines starting with "//*"
    // Repeat until no description tags are found
    while StartsStr('//*', srcLine) do
    begin
      details.Add(RightStrAfter(srcLine, '* '));

      Inc(I);
      srcLine := aSource[I];
    end;

    // Skip empty or "faulty" lines (e.g. comments not intended for wiki)
    // until we get a type declaration (must start with T)
    while not StartsStr('T', srcLine) do
    begin
      Inc(I);
      srcLine := aSource[I];
    end;

    // Parse enum - detected by "("
    if Pos('(', srcLine) > 0 then
    begin
      fType := ttEnum;

      enumStr.Text := srcLine;
      if I < aSource.Count - 1 then
      repeat
        Inc(I);
        srcLine := aSource[I];
        enumStr.Append(srcLine);

        // Ignore closing brackets if they are in comments
      until ((Pos(')', srcLine) <> 0) and (Pos('//', srcLine) = 0))
         or ((Pos(')', srcLine) <> 0) and (Pos('//', srcLine) <> 0) and (Pos(')', srcLine) < Pos('//', srcLine)));
    end;

    // Parse record - detected by "record"
    if Pos('record', srcLine) > 0 then
    begin
      fType := ttRecord;

      enumStr.Text := srcLine;
      if I < aSource.Count - 1 then
      repeat
        Inc(I);
        srcLine := aSource[I];
        enumStr.Append(srcLine);
      until Pos('end;', srcLine) <> 0;
    end;

    // Parse array - detected by "array of"
    if Pos('array of', srcLine) > 0 then
    begin
      fType := ttArray;
      enumStr.Text := srcLine;
    end;

    // Parse set of type - detected by "set of A;"
    if (Pos('set of', srcLine) > 0) and ((Pos('(', srcLine) = 0)) then
    begin
      fType := ttSetOfType;
      enumStr.Text := srcLine;
    end;

    // Parse set of enum - detected by "set of (a, b);"
    if (Pos('set of', srcLine) > 0) and ((Pos('(', srcLine) > 0)) then
    begin
      fType := ttSetOfEnum;
      enumStr.Text := srcLine;
    end;

    // Name is the first word
    fName := Trim(LeftStr(enumStr[0], Pos('=', enumStr[0]) - 1));
    enumStr[0] := Trim(RightStrAfter(enumStr[0], '='));

    fElements.ParseFromStringList(fType, enumStr);

    // Now we can assemble Description, after we have detected and removed fParameters descriptions from it
    for I := 0 to details.Count - 1 do
      fDescription := fDescription + '<br/>' + details[I];
  finally
    details.Free;
    enumStr.Free;
  end;
end;


function TKMScriptType.ExportCode: string;
const
  TEMPLATE = 'Sender.AddTypeS(''%s'', %s);';
begin
  Result := Format(TEMPLATE, [fName, fElements.ExportCode(fType)]);
end;


function TKMScriptType.ExportWikiBody: string;
const
  TEMPLATE = '| - | <sub>%s</sub> | <a id="%s">%s</a><sub>%s</sub> |';
  TYPE_NAME: array [TKMTypeType] of string = ('enum', 'record', 'array', 'set', 'set');
begin
  Result := Format(TEMPLATE, [TYPE_NAME[fType], fName, fName, fDescription]) + fElements.ExportWikiBody;
end;


function TKMScriptType.ExportWikiLink: string;
const
  TEMPLATE = '* <a href="#%s">%s</a>';
begin
  Result := Format(TEMPLATE, [fName, fName]);
end;


{ TKMScriptTypes }
procedure TKMScriptTypes.Clear;
begin
  fList.Clear;
end;


constructor TKMScriptTypes.Create(aOnLog: TProc<string>);
begin
  inherited Create;

  fOnLog := aOnLog;

  fList := TObjectList<TKMScriptType>.Create(
    TComparer<TKMScriptType>.Construct(
      function (const A, B: TKMScriptType): Integer
      begin
        Result := CompareValue(A.SortPriority, B.SortPriority);
        if Result = 0 then
          // Case-sensitive compare, since we use CamelCase and it looks nicer that way
          Result := CompareText(A.fName, B.fName);
      end));
end;


destructor TKMScriptTypes.Destroy;
begin
  FreeAndNil(fList);

  inherited;
end;


// Scans source contents and puts it all in proper formatting for most wikis.
procedure TKMScriptTypes.LoadFromFile(const aInputFile: string);
var
  slSource: TStringList;
  I: Integer;
  srcLine: string;
  sl: TStringList;
  sectionStarted: Boolean;
  recordStarted: Boolean;
begin
  slSource := TStringList.Create;
  try
    slSource.LoadFromFile(aInputFile);

    // Assemble method sections 1 by 1

    {
    //* Enum
    TKMSomeType = (stNone,
      //
      stSomething);

    //* Record
    // ignore this comment
    TKMSomeType = record
      A,B: Integer;
      function Some: Byte;
    end;

    //* Array of
    TKMSomeType = array of TKMSomething;

    //* Set of
    TKMSomeType = set of TKMSomething;
    }

    sectionStarted := False;
    recordStarted := False;

    sl := TStringList.Create;
    for I := 0 to slSource.Count - 1 do
    begin
      srcLine := Trim(slSource[I]);

      if not sectionStarted and StartsStr('//* ', srcLine) then
      begin
        sectionStarted := True;
        sl.Clear;
      end;

      if sectionStarted then
        if not StartsStr('//', srcLine) or StartsStr('//*', srcLine) then
          sl.Append(srcLine);

      if sectionStarted and not StartsStr('//', srcLine) and (Pos('record', srcLine) > 0) then
        recordStarted := True;

      if sectionStarted and not recordStarted and (StartsStr('procedure', srcLine) or StartsStr('function', srcLine)) then
        sectionStarted := False;

      if sectionStarted and recordStarted and (Pos('end;', srcLine) > 0) then
        recordStarted := False;

      if sectionStarted and not recordStarted and not StartsStr('//*', srcLine) and (Pos(';', srcLine) > 0) then
      begin
        sectionStarted := False;

        fList.Add(TKMScriptType.Create);
        fList.Last.LoadFromStringList(sl);
      end;
    end;
    sl.Free;
  finally
    slSource.Free;
  end;
end;


procedure TKMScriptTypes.LoadFromFiles(const aSourceMask: string);
var
  s: TStringDynArray;
  I: Integer;
begin
  Clear;

  // Get all files matching the mask
  s := TDirectory.GetFiles(ExtractFilePath(aSourceMask), ExtractFileName(aSourceMask), TSearchOption.soAllDirectories);

  for I := Low(s) to High(s) do
    LoadFromFile(s[I]);

  fOnLog(Format('%d %s parsed', [GetCount, AREA_INFO[paTypes].Short]));
end;


function TKMScriptTypes.ExportWikiBody: string;
var
  I: Integer;
begin
  Result := '';

  for I := 0 to fList.Count - 1 do
    Result := Result + IfThen(I > 0, sLineBreak) + fList[I].ExportWikiBody;
end;


function TKMScriptTypes.ExportWikiLinks: string;
var
  I: Integer;
begin
  Result := '';

  for I := 0 to fList.Count - 1 do
    Result := Result + IfThen(I > 0, sLineBreak) + fList[I].ExportWikiLink;
end;


function TKMScriptTypes.GetCount: Integer;
begin
  Result := fList.Count;
end;


procedure TKMScriptTypes.AssignSortOrder;
  function FindType(aName: string): Integer;
  var
    I: Integer;
  begin
    Result := -1;
    for I := 0 to fList.Count - 1 do
      if fList[I].fName = aName then
        Exit(I);
  end;
var
  I, K: Integer;
  use: array of TList<Integer>;
  order: array of Integer;
  id: Integer;
  s: string;
  orderLoop: Integer;
  needsAnotherLoop: Boolean;
begin
  SetLength(use, fList.Count);
  for I := 0 to fList.Count - 1 do
    use[I] := TList<Integer>.Create;

  SetLength(order, fList.Count);
  for I := 0 to fList.Count - 1 do
    order[I] := -1;

  for I := 0 to fList.Count - 1 do
  case fList[I].fType of
    ttRecord:     begin
                    for K := 0 to fList[I].fElements.fList.Count - 1 do
                    begin
                      s := RightStrAfter(fList[I].fElements.fList[K].fName, ': ');
                      id := FindType(s);
                      if id <> -1 then
                        use[I].Add(id);
                    end;
                  end;
    ttArray:      begin
                    s := ReplaceStr(fList[I].fElements.fList[0].fName, 'array of ', '');
                    id := FindType(s);
                    if id <> -1 then
                      use[I].Add(id);
                  end;
    ttSetOfType:  begin
                    s := ReplaceStr(fList[I].fElements.fList[0].fName, 'set of ', '');
                    id := FindType(s);
                    if id <> -1 then
                      use[I].Add(id);
                  end;
  end;

  orderLoop := 0;
  repeat
    // Demark items without dependencies
    for I := 0 to fList.Count - 1 do
      if (order[I] = -1) and (use[I].Count = 0) then
        order[I] := orderLoop;

    // Trim demarked items
    for I := 0 to fList.Count - 1 do
    for K := use[I].Count - 1 downto 0 do
      if order[use[I][K]] = 0 then
        use[I].Delete(K);

    // Check if all items are demarked
    needsAnotherLoop := False;
    for I := 0 to fList.Count - 1 do
      if (order[I] = -1) then
        needsAnotherLoop := True;
    Inc(orderLoop);
  until not needsAnotherLoop or (orderLoop = 9);

  for I := 0 to fList.Count - 1 do
    fList[I].SortPriority := order[I];
end;


procedure TKMScriptTypes.SortByName(aSortBy: TKMSortType);
begin
  case aSortBy of
    stByAlphabet:   ; // Already sorted by default
    stByDependancy: AssignSortOrder;
  end;

  fList.Sort;
end;


procedure TKMScriptTypes.ExportCode(const aCodeFile: string);
var
  sl: TStringList;
  secStart, secEnd, pad: Integer;
  I: Integer;
begin
  if not FileExists(aCodeFile) then Exit;

  SortByName(stByDependancy);

  sl := TStringList.Create;
  try
    sl.LoadFromFile(aCodeFile);

    FindStartAndFinish(sl, AREA_INFO[paTypes].RegTag, secStart, secEnd, pad);

    if secStart <> -1 then
    begin
      for I := secEnd downto secStart do
        sl.Delete(I);

      for I := fList.Count - 1 downto 0 do
      begin
        sl.Insert(secStart, DupeString(' ', pad) + fList[I].ExportCode);

        if (I > 0) and (fList[I].SortPriority <> fList[I-1].SortPriority) then
          sl.Insert(secStart, DupeString(' ', pad) + '// Dependent types of level ' + IntToStr(fList[I].SortPriority));
      end;
    end;

    sl.SaveToFile(aCodeFile);
  finally
    sl.Free;
  end;

  fOnLog(Format('%d %s exported into Code checks', [fList.Count, AREA_INFO[paTypes].Short]));
end;


procedure TKMScriptTypes.ExportWiki(const aTemplateFile, aOutputFile: string);
var
  sl: TStringList;
  exportPath: string;
begin
  // Without template we cant generate output
  if aTemplateFile = '' then Exit;

  SortByName(stByAlphabet);

  sl := TStringList.Create;

  sl.LoadFromFile(aTemplateFile);

  sl.Text := StringReplace(sl.Text, '{LINKS}', ExportWikiLinks, []);
  sl.Text := StringReplace(sl.Text, '{BODY}', ExportWikiBody, []);

  exportPath := ExpandFileName(ExtractFilePath(ParamStr(0)) + aOutputFile);
  if not DirectoryExists(ExtractFileDir(exportPath)) then
    ForceDirectories(ExtractFileDir(exportPath));

  sl.SaveToFile(aOutputFile);

  sl.Free;

  fOnLog(Format('%d %s exported into Wiki', [fList.Count, AREA_INFO[paTypes].Short]));
end;


end.
