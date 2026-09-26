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
begin
  var slSource := TStringList.Create;
  try
    slSource.LoadFromFile(aInputFile);

    // Look for areas denoted as Modding specifications
    {
    //*Area-Modding-Specification*//
    ...
    //*Area-Modding-Specification*//
    }

    var areaStarted := False;

    var slArea := TStringList.Create;
    for var I := 0 to slSource.Count - 1 do
    begin
      var srcLine := Trim(slSource[I]);

      // New area starts
      if not areaStarted and StartsStr(DOC_TAG_AREA_MODDING_SPECIFICATION, srcLine) then
      begin
        areaStarted := True;
        slArea.Clear;
        Continue;
      end;

      // Area ends
      if areaStarted and StartsStr(DOC_TAG_AREA_MODDING_SPECIFICATION, srcLine) then
      begin
        // Send area contents to parser
        fList.Add(TKMModdingType.Create);
        fList.Last.LoadFromStringList(slArea);

        areaStarted := False;
        Continue;
      end;

      if areaStarted then
        slArea.Append(srcLine);
    end;
    slArea.Free;
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
