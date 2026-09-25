unit KM_ScriptingTypes;
interface
uses
  System.Classes, System.SysUtils, System.Types, System.Generics.Collections, System.Generics.Defaults,
  System.Math, System.StrUtils,
  KM_ScriptingType;

type
  // List of types
  // Documenter > Scripting > Types
  TKMScriptTypes = class
  private
    fOnLog: TProc<string>;
    fList: TObjectList<TKMScriptType>;
    procedure AssignSortOrder;
    procedure Clear;
    function ExportWikiBody: string;
    function ExportWikiLinks: string;
    procedure LoadFromFile(const aInputFile: string);
    procedure SortByName(aSortBy: TKMSortType);
  public
    constructor Create(aOnLog: TProc<string>);
    destructor Destroy; override;

    procedure LoadFromFiles(const aSourceMask: string);
    procedure GenerateCode(const aCodeFile: string);
    procedure GenerateWiki(const aTemplateFile, aOutputFile: string);
  end;


implementation
uses
  System.IOUtils,
  KM_ParserTypes, KM_StringUtils;


{ TKMScriptTypes }
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
          Result := CompareText(A.Name, B.Name);
      end));
end;


destructor TKMScriptTypes.Destroy;
begin
  FreeAndNil(fList);

  inherited;
end;


procedure TKMScriptTypes.Clear;
begin
  fList.Clear;
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
    //* This is an Enum
    TKMSomeType = (stNone,
      //
      stSomething);

    //* This is a Record
    // ignore this comment
    TKMSomeType = record
      A,B: Integer;
      function Some: Byte;
    end;

    //* This is an Array of
    TKMSomeType = array of TKMSomething;

    //* This is a Set of
    TKMSomeType = set of TKMSomething;
    }

    var areaStarted := False;
    sectionStarted := False;
    recordStarted := False;

    sl := TStringList.Create;
    for I := 0 to slSource.Count - 1 do
    begin
      srcLine := Trim(slSource[I]);

      // Skip special areas
      if StartsStr(DOC_TAG_AREA, srcLine) then
        if not areaStarted then
          areaStarted := True
        else
        begin
          areaStarted := False;
          // Skip this closing line too
          Continue;
        end;

      if areaStarted then
        Continue;

      if not sectionStarted and StartsStr(DOC_TAG, srcLine) then
      begin
        sectionStarted := True;
        sl.Clear;
      end;

      if sectionStarted then
        if not StartsStr('//', srcLine) or StartsStr(DOC_TAG, srcLine) then
          sl.Append(srcLine);

      if sectionStarted and not StartsStr('//', srcLine) and (Pos('record', srcLine) > 0) then
        recordStarted := True;

      if sectionStarted and not recordStarted and (StartsStr('procedure', srcLine) or StartsStr('function', srcLine)) then
        sectionStarted := False;

      if sectionStarted and recordStarted and (Pos('end;', srcLine) > 0) then
        recordStarted := False;

      if sectionStarted and not recordStarted and not StartsStr(DOC_TAG, srcLine) and (Pos(';', srcLine) > 0) then
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

  fOnLog(Format('%d %s parsed', [fList.Count, AREA_INFO[paTypes].Name]));
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


procedure TKMScriptTypes.AssignSortOrder;
  function FindType(aName: string): Integer;
  var
    I: Integer;
  begin
    Result := -1;
    for I := 0 to fList.Count - 1 do
      if fList[I].Name = aName then
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
  case fList[I].Typ of
    ttRecord:     begin
                    for K := 0 to fList[I].Elements.List.Count - 1 do
                    begin
                      s := RightStrAfter(fList[I].Elements.List[K].Name, ': ');
                      id := FindType(s);
                      if id <> -1 then
                        use[I].Add(id);
                    end;
                  end;
    ttArray:      begin
                    s := ReplaceStr(fList[I].Elements.List[0].Name, 'array of ', '');
                    id := FindType(s);
                    if id <> -1 then
                      use[I].Add(id);
                  end;
    ttSetOfType:  begin
                    s := ReplaceStr(fList[I].Elements.List[0].Name, 'set of ', '');
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


procedure TKMScriptTypes.GenerateCode(const aCodeFile: string);
begin
  if not FileExists(aCodeFile) then Exit;

  SortByName(stByDependancy);

  var sl := TStringList.Create;
  try
    sl.LoadFromFile(aCodeFile);

    var lineFrom, lineTo, padLevel: Integer;
    FindRegionBounds(sl, AREA_INFO[paTypes].RegTag, lineFrom, lineTo, padLevel);

    if lineFrom <> -1 then
    begin
      // Remove old code
      for var I := lineTo downto lineFrom do
        sl.Delete(I);

      // Insert new code
      for var I := fList.Count - 1 downto 0 do
      begin
        sl.Insert(lineFrom, DupeString(' ', padLevel) + fList[I].ExportCode);

        if (I > 0) and (fList[I].SortPriority <> fList[I-1].SortPriority) then
        begin
          sl.Insert(lineFrom, '');
          sl.Insert(lineFrom + 1, DupeString(' ', padLevel) + Format('// Level %d types depend on preceeding types of level %d', [fList[I].SortPriority, fList[I].SortPriority - 1]));
        end;
      end;
    end;

    sl.SaveToFile(aCodeFile);
  finally
    sl.Free;
  end;

  fOnLog(Format('Written %d items of %s into Code', [fList.Count, AREA_INFO[paTypes].Name]));
end;


procedure TKMScriptTypes.GenerateWiki(const aTemplateFile, aOutputFile: string);
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

  fOnLog(Format('Written %d items of %s into Wiki', [fList.Count, AREA_INFO[paTypes].Name]));
end;


end.
