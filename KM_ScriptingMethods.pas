unit KM_ScriptingMethods;
interface
uses
  System.Classes, System.SysUtils, System.Generics.Collections,
  KM_ParserTypes, KM_ScriptingMethod;

type
  // List of methods
  // Documenter > Scripting > Methods
  TKMScriptMethods = class
  private
    fGame: TKMParsingGame;
    fArea: TKMParsingArea;
    fOnLog: TProc<string>;
    fList: TObjectList<TKMMethodInfo>;
    function ExportWikiBody: string;
    function ExportWikiLinks: string;
    function ExportCodeSectionCheck(aSL: TStringList): Boolean;
    function ExportCodeSectionReg(aSL: TStringList): Boolean;
    procedure SortByName;
  public
    constructor Create(aGame: TKMParsingGame; aArea: TKMParsingArea; aOnLog: TProc<string>);
    destructor Destroy; override;

    procedure LoadFromFile(const aInputFile: string);
    procedure GenerateCode(const aFilename1, aFilename2: string);
    function GenerateWiki(const aTemplateFile, aOutputFile: string): string;

    procedure LintLogMessages(const aSourceFile: string);
  end;


implementation
uses
  System.StrUtils, System.Generics.Defaults,
  KM_StringUtils;


{ TKMScriptMethods }
constructor TKMScriptMethods.Create(aGame: TKMParsingGame; aArea: TKMParsingArea; aOnLog: TProc<string>);
begin
  inherited Create;

  fGame := aGame;
  fArea := aArea;
  fOnLog := aOnLog;

  fList := TObjectList<TKMMethodInfo>.Create(
    TComparer<TKMMethodInfo>.Construct(
      function (const A, B: TKMMethodInfo): Integer
      begin
        // Case-sensitive compare, since we use CamelCase and it looks nicer that way
        Result := CompareText(A.Name, B.Name);

        // Changed methods have same names, but need to be sorted from old to new
        if Result = 0 then
          Result := Ord(B.Status) - Ord(A.Status);
      end));
end;


destructor TKMScriptMethods.Destroy;
begin
  FreeAndNil(fList);

  inherited;
end;


// Scans source contents and puts it all in proper formatting for most wikis.
procedure TKMScriptMethods.LoadFromFile(const aInputFile: string);
var
  slSource: TStringList;
  I: Integer;
  srcLine: string;
  slMethodDeclaration: TStringList;
  sectionStarted, sectionTailEnded: Boolean;
  lastSectionStart: Integer;
begin
  fList.Clear;
  if not FileExists(aInputFile) then Exit;

  slSource := TStringList.Create;
  try
    slSource.LoadFromFile(aInputFile);

    // Assemble method sections 1 by 1
      {
      //* Version: 1234
      //* Status: Deprecated/Removed/Changed [optional]
      //* Replacement: name of the replacement method [optional]
      //* Large description of the method [optional]
      //*  empty line
      //* Another paragraph with even more description of the method [optional]
      //* aX: Small optional description of parameter
      //* aY: Small optional description of parameter
      //* Result: Small optional description of returned value
      function Something(something, something, something
        something): something
      }

    sectionStarted := False;
    sectionTailEnded := True;
    lastSectionStart := -1;

    slMethodDeclaration := TStringList.Create;
    for I := 0 to slSource.Count - 1 do
    begin
      srcLine := slSource[I];

      if not sectionStarted and StartsStr(DOC_TAG, srcLine) then
      begin
        sectionStarted := True;
        sectionTailEnded := True;
        slMethodDeclaration.Clear;
        lastSectionStart := I;
      end;

      if sectionStarted then
        slMethodDeclaration.Append(slSource[I]);

      if sectionStarted and (StartsStr('procedure', srcLine) or StartsStr('function', srcLine) or not sectionTailEnded) then
      begin
        if (Pos('(', srcLine) > 0)  then
          sectionTailEnded := False;
        if (Pos(')', srcLine) > 0)  then
          sectionTailEnded := True;

        if sectionTailEnded then
        begin
          sectionTailEnded := True;
          sectionStarted := False;

          fList.Add(TKMMethodInfo.Create);
          fList.Last.LoadFromStringList(slMethodDeclaration, lastSectionStart, fArea);

          lastSectionStart := -1;
        end;
      end;
    end;
    slMethodDeclaration.Free;
  finally
    slSource.Free;
  end;

  SortByName;

  fOnLog(Format('%d %s parsed', [fList.Count, AREA_INFO[fArea].Name]));
end;


function TKMScriptMethods.ExportWikiBody: string;
begin
  Result := '';

  for var I := 0 to fList.Count - 1 do
  begin
    fList[I].Parameters.AdjoinPairs;
    Result := Result + IfThen(I > 0, sLineBreak) + fList[I].ExportWikiBody(AREA_INFO[fArea].NeedsReturn);
  end;
end;


function TKMScriptMethods.ExportWikiLinks: string;
var
  I: Integer;
begin
  Result := '';

  for I := 0 to fList.Count - 1 do
    Result := Result + IfThen(I > 0, sLineBreak) + fList[I].ExportWikiLink;
end;


procedure TKMScriptMethods.SortByName;
begin
  fList.Sort;
end;


function TKMScriptMethods.ExportCodeSectionCheck(aSL: TStringList): Boolean;
begin
  var lineFrom, lineTo, padLevel: Integer;
  FindRegionBounds(aSL, AREA_INFO[fArea].CheckTag, lineFrom, lineTo, padLevel);
  if lineFrom = -1 then Exit(False);

  for var I := lineTo downto lineFrom do
    aSL.Delete(I);

  // Insert in reverse so we could skip "removed" methods
  for var I := fList.Count - 1 downto 0 do
    if fList[I].Status in [msOk, msDeprecated] then
      case fArea of
        paActions,
        paStates,
        paUtils:    begin
                      // We can write more compact code with AdjoinPairs
                      fList[I].Parameters.AdjoinPairs;
                      aSL.Insert(lineFrom, DupeString(' ', padLevel) + 'RegisterMethodCheck(c, '#39 + fList[I].ExportCodeSignature + #39');');
                    end;
        paEvents:   // Can not use AdjoinPairs here. All vars must be separate
                    aSL.Insert(lineFrom, DupeString(' ', padLevel) + fList[I].ExportCodeSignatureEvent(fGame, I = fList.Count-1));
      end;

  Result := True;
  fOnLog(Format('%d %s exported into Code checks', [fList.Count, AREA_INFO[fArea].Name]));
end;


function TKMScriptMethods.ExportCodeSectionReg(aSL: TStringList): Boolean;
const
  AREA_REG_CLASS: array [TKMParsingGame, TKMParsingArea] of string = (
    ('TKMScriptActions',    '', 'TKMScriptStates',    'TKMScriptUtils',    ''), // KMR
    ('TKMScriptingActions', '', 'TKMScriptingStates', 'TKMScriptingUtils', '')  // KP
  );
begin
  var lineFrom, lineTo, padLevel: Integer;
  FindRegionBounds(aSL, AREA_INFO[fArea].RegTag, lineFrom, lineTo, padLevel);
  if lineFrom = -1 then Exit(False);

  for var I := lineTo downto lineFrom do
    aSL.Delete(I);

  // Insert in reverse so we could skip "removed" methods
  for var I := fList.Count - 1 downto 0 do
    if fList[I].Status in [msOk, msDeprecated] then
      case fArea of
        paActions,
        paStates,
        paUtils:    aSL.Insert(lineFrom, DupeString(' ', padLevel) + 'RegisterMethod(@' + AREA_REG_CLASS[fGame, fArea] + '.' + fList[I].ExportCodeNameRegistration + ');');
        paEvents:   aSL.Insert(lineFrom, DupeString(' ', padLevel) + fList[I].ExportCodeNameRegistrationEvent(fGame, I = fList.Count - 1));
      end;

  Result := True;
  fOnLog(Format('%d %s exported into Code regs', [fList.Count, AREA_INFO[fArea].Name]));
end;


procedure TKMScriptMethods.GenerateCode(const aFilename1, aFilename2: string);
begin
  var checkFound := False;
  var regFound := False;

  // It is inefficient, but simple to just always process 2 files

  if FileExists(aFilename1) then
  begin
    var sl := TStringList.Create;
    sl.LoadFromFile(aFilename1);

    checkFound := ExportCodeSectionCheck(sl);
    regFound := ExportCodeSectionReg(sl);
    sl.SaveToFile(aFilename1);
    sl.Free;
  end;

  if FileExists(aFilename2) then
  begin
    var sl := TStringList.Create;
    sl.LoadFromFile(aFilename2);
    checkFound := checkFound or ExportCodeSectionCheck(sl);
    regFound := regFound or ExportCodeSectionReg(sl);
    sl.SaveToFile(aFilename2);
    sl.Free;
  end;

  if not checkFound then
    fOnLog(Format('%s tag not found', [AREA_INFO[fArea].CheckTag]));

  if not regFound then
    fOnLog(Format('%s tag not found', [AREA_INFO[fArea].RegTag]));
end;


function TKMScriptMethods.GenerateWiki(const aTemplateFile, aOutputFile: string): string;
var
  sl: TStringList;
  exportPath: string;
begin
  // Without template we cant generate output
  if aTemplateFile = '' then Exit;

  sl := TStringList.Create;

  sl.LoadFromFile(aTemplateFile);

  sl.Text := StringReplace(sl.Text, '{LINKS}', ExportWikiLinks, []);
  sl.Text := StringReplace(sl.Text, '{BODY}', ExportWikiBody, []);

  exportPath := ExpandFileName(ExtractFilePath(ParamStr(0)) + aOutputFile);
  if not DirectoryExists(ExtractFileDir(exportPath)) then
    ForceDirectories(ExtractFileDir(exportPath));

  sl.SaveToFile(aOutputFile);

  sl.Free;

  fOnLog(Format('%d %s exported into Wiki', [fList.Count, AREA_INFO[fArea].Name]));
end;


procedure TKMScriptMethods.LintLogMessages(const aSourceFile: string);
begin
  var slSourceCode := TStringList.Create;
  slSourceCode.LoadFromFile(aSourceFile);

  for var I := 0 to fList.Count - 1 do
  begin
    var res := fList[I].LintLogMessages(slSourceCode, LOG_MESSAGE_NAME[fGame]);
    if res <> '' then
      fOnLog(res);
  end;

  slSourceCode.Free;
end;


end.
