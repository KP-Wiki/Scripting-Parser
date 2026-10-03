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
    fList: TObjectList<TKMModdingNode>;
    procedure LoadFromFile(const aSourceMask: string);
    procedure Clear;
    procedure ConnectCrossReferences;
    function ExportWikiBody: string;
    function ExportWikiLinks: string;
    procedure LoadFromFileInt(const aInputFile: string);
    procedure SortByName(aSortBy: TKMSortType);
    function ExportListing: string;
  public
    constructor Create(aOnLog: TProc<string>);
    destructor Destroy; override;

    procedure GenerateWiki(const aSourceFile, aTemplateFile, aOutputFile: string);
    procedure LintCode(const aSourceFile: string);
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

  fList := TObjectList<TKMModdingNode>.Create(
    TComparer<TKMModdingNode>.Construct(
      function (const A, B: TKMModdingNode): Integer
      begin
        // Case-sensitive compare, since we use CamelCase and it looks nicer that way
        Result := CompareText(A.Caption, B.Caption);
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


procedure TKMModdingTypes.ConnectCrossReferences;
begin
  // Let the fields know about each other if they need references
  // O(n^2) is definitely stupid, but it is KISS
  for var I := 0 to fList.Count - 1 do
  for var K := 0 to fList.Count - 1 do
  if I <> K then
    fList[I].CrossLinkWith(fList[K]);

  for var I := 0 to fList.Count - 1 do
    fList[I].SortFieldsByType;

  //todo: Verify no everything got cross-referenced, no stray types/references
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
        var newType := TKMModdingFactory.NewTypeFromStringList(slArea);

        fList.Add(newType);

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
begin
  Clear;

  // Get all files matching the mask
  var sa := TDirectory.GetFiles(ExtractFilePath(aSourceMask), ExtractFileName(aSourceMask), TSearchOption.soAllDirectories);

  for var I := Low(sa) to High(sa) do
    LoadFromFileInt(sa[I]);

  ConnectCrossReferences;

  fOnLog(Format('%d %s parsed', [fList.Count, SCRIPTING_AREA_SPEC[paTypes].Name]));
end;


function TKMModdingTypes.ExportListing: string;
begin
  Result := '';

  for var I := 0 to fList.Count - 1 do
    Result := Result + fList[I].ExportListing(IntToStr(I) + '. ') + sLineBreak;
end;


function TKMModdingTypes.ExportWikiBody: string;
begin
  Result := '';

  for var I := 0 to fList.Count - 1 do
    if fList[I].IsRoot then
      Result := Result + fList[I].ExportWikiBody + sLineBreak + '---' + sLineBreak;
end;


function TKMModdingTypes.ExportWikiLinks: string;
begin
  Result := '### Root types' + sLineBreak + sLineBreak;

  for var I := 0 to fList.Count - 1 do
    if fList[I].IsRoot then
      Result := Result + fList[I].ExportWikiLink + sLineBreak;
end;


procedure TKMModdingTypes.SortByName(aSortBy: TKMSortType);
begin
  fList.Sort;
end;


procedure TKMModdingTypes.GenerateWiki(const aSourceFile, aTemplateFile, aOutputFile: string);
begin
  // Without template we cant generate output
  if aTemplateFile = '' then Exit;

  LoadFromFile(aSourceFile);

  SortByName(stByAlphabet);

  var sl := TStringList.Create;

  sl.LoadFromFile(aTemplateFile);

  sl.Text := StringReplace(sl.Text, '{LINKS}', ExportWikiLinks, []);
  sl.Text := StringReplace(sl.Text, '{BODY}', ExportWikiBody, []);

  //sl.Text := sl.Text + sLineBreak + ExportListing;

  var exportPath := ExpandFileName(ExtractFilePath(ParamStr(0)) + aOutputFile);
  if not DirectoryExists(ExtractFileDir(exportPath)) then
    ForceDirectories(ExtractFileDir(exportPath));

  sl.SaveToFile(aOutputFile);

  sl.Free;

  fOnLog(Format('Written %d items of %s into Wiki', [fList.Count, SCRIPTING_AREA_SPEC[paTypes].Name]));
end;


procedure TKMModdingTypes.LintCode(const aSourceFile: string);
begin
  //todo: Following things could be linted:
  // - matching names between XML attribute name and field name
end;


end.
