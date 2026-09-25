unit KM_ModdingTypes;
interface
uses
  System.Classes, System.Math, System.SysUtils, System.Types, System.Generics.Collections, System.Generics.Defaults, System.StrUtils,
  KM_DocumenterTypes,
  KM_ModdingType;

type
  // List of types
  // Documenter > Modding > Types
  TKMModdingTypes = class
  private
    fOnLog: TProc<string>;
    fList: TObjectList<TKMModdingType>;
    procedure LoadFromFile(const aSourceMask: string);
    procedure AssignSortOrder;
    procedure Clear;
    function ExportWikiBody: string;
    function ExportWikiLinks: string;
    procedure LoadFromFileInt(const aInputFile: string);
    procedure SortByName(aSortBy: TKMSortType);
  public
    constructor Create(aOnLog: TProc<string>);
    destructor Destroy; override;

    procedure GenerateWiki(const aSourceFile, aTemplateFile, aOutputFile: string);
  end;


implementation
uses
  System.IOUtils,
  KM_StringUtils;


{ TKMModdingTypes }
constructor TKMModdingTypes.Create(aOnLog: TProc<string>);
begin
  inherited Create;

  fOnLog := aOnLog;

  fList := TObjectList<TKMModdingType>.Create(
    TComparer<TKMModdingType>.Construct(
      function (const A, B: TKMModdingType): Integer
      begin
        Result := CompareValue(A.SortPriority, B.SortPriority);
        if Result = 0 then
          // Case-sensitive compare, since we use CamelCase and it looks nicer that way
          Result := CompareText(A.Name, B.Name);
      end));
end;


destructor TKMModdingTypes.Destroy;
begin
  FreeAndNil(fList);

  inherited;
end;


procedure TKMModdingTypes.Clear;
begin
  fList.Clear;
end;


// Scans source contents and puts it all in proper formatting for most wikis.
procedure TKMModdingTypes.LoadFromFileInt(const aInputFile: string);
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

        fList.Add(TKMModdingType.Create);
        fList.Last.LoadFromStringList(sl);
      end;
    end;
    sl.Free;
  finally
    slSource.Free;
  end;
end;


procedure TKMModdingTypes.LoadFromFile(const aSourceMask: string);
var
  s: TStringDynArray;
  I: Integer;
begin
  Clear;

  // Get all files matching the mask
  s := TDirectory.GetFiles(ExtractFilePath(aSourceMask), ExtractFileName(aSourceMask), TSearchOption.soAllDirectories);

  for I := Low(s) to High(s) do
    LoadFromFileInt(s[I]);

  fOnLog(Format('%d %s parsed', [fList.Count, SCRIPTING_AREA_SPEC[paTypes].Name]));
end;


function TKMModdingTypes.ExportWikiBody: string;
var
  I: Integer;
begin
  Result := '';

  for I := 0 to fList.Count - 1 do
    Result := Result + IfThen(I > 0, sLineBreak) + fList[I].ExportWikiBody;
end;


function TKMModdingTypes.ExportWikiLinks: string;
var
  I: Integer;
begin
  Result := '';

  for I := 0 to fList.Count - 1 do
    Result := Result + IfThen(I > 0, sLineBreak) + fList[I].ExportWikiLink;
end;


procedure TKMModdingTypes.AssignSortOrder;
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


procedure TKMModdingTypes.SortByName(aSortBy: TKMSortType);
begin
  case aSortBy of
    stByAlphabet:   ; // Already sorted by default
    stByDependancy: AssignSortOrder;
  end;

  fList.Sort;
end;


procedure TKMModdingTypes.GenerateWiki(const aSourceFile, aTemplateFile, aOutputFile: string);
var
  sl: TStringList;
  exportPath: string;
begin
  // Without template we cant generate output
  if aTemplateFile = '' then Exit;

  LoadFromFile(aSourceFile);

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

  fOnLog(Format('Written %d items of %s into Wiki', [fList.Count, SCRIPTING_AREA_SPEC[paTypes].Name]));
end;


end.
