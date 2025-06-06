unit KM_ScriptingMethods;
interface
uses
  System.Classes, System.SysUtils, System.Types, Vcl.Forms, Winapi.Windows, System.Generics.Collections, System.Generics.Defaults,
  System.StrUtils,
  KM_ScriptingParameters, KM_ParserTypes;

type
  TKMMethodType = (mtFunc, mtProc);
  TKMMethodStatus = (
    msOk,
    msDeprecated, // Method is slated for removal
    msRemoved,    // Method was removed (usually in favor of some other)
    msChanged     // Method has changed (arguments order, etc.)
  );

  // Single method info
  TKMMethodInfo = class
  private
    fFirstLine: Integer;  // First line of code where this method documentation and declaration starts
    fName: string;
    fType: TKMMethodType;
    fVersion: string;         // Game version in which the method was added/changed
    fStatus: TKMMethodStatus;
    fReplacement: string;     // Replacement method recommendation
    fDescription: string;     // Description of the method as a whole
    fParameters: TKMScriptParameters; // Parameters parsed from declaration
    fResultType: string;
    fResultDesc: string;
  public
    constructor Create;
    destructor Destroy; override;
    procedure LoadFromStringList(aSource: TStringList; aLineOfCode: Integer; aArea: TKMParsingArea);
    function ExportWikiBody(aNeedReturn: Boolean): string;
    function ExportWikiLink: string;
    function ExportCodeSignature: string;
    function ExportCodeSignatureEvent(aGame: TKMParsingGame; aLastLine: Boolean): string;
    function ExportCodeNameRegistration: string;
    function ExportCodeNameRegistrationEvent(aGame: TKMParsingGame; aLastLine: Boolean): string;
    function CheckLogMessages(aSourceCode: TStringList; const aLogMessageName: string): string;
  end;


  // List of methods
  TKMScriptMethods = class
  private
    fGame: TKMParsingGame;
    fArea: TKMParsingArea;
    fOnLog: TProc<string>;
    fList: TObjectList<TKMMethodInfo>;
    function ExportWikiBody: string;
    function ExportWikiLinks: string;
    function GetCount: Integer;
    procedure ExportCodeSectionCheck(aSL: TStringList);
    procedure ExportCodeSectionReg(aSL: TStringList);
    procedure SortByName;
  public
    constructor Create(aGame: TKMParsingGame; aArea: TKMParsingArea; aOnLog: TProc<string>);
    destructor Destroy; override;

    property Count: Integer read GetCount;
    procedure LoadFromFile(const aInputFile: string);
    procedure ExportCode(const aFilenameCheckAndReg: string); overload;
    procedure ExportCode(const aFilenameCheck, aFilenameReg: string); overload;
    function ExportWiki(const aTemplateFile, aOutputFile: string): string;

    procedure CheckMessages(const aSourceFile: string; const aLogMessageName: string);
  end;


implementation
uses
  KM_ScriptingConsts, KM_StringUtils;


const
  UNICODE_RED_CROSS = '&#x274C;';
  UNICODE_EXCLAMATION = '&#x26A0;';


{ TKMMethodInfo }
constructor TKMMethodInfo.Create;
begin
  inherited;

  fParameters := TKMScriptParameters.Create;
end;


destructor TKMMethodInfo.Destroy;
begin
  FreeAndNil(fParameters);

  inherited;
end;


procedure TKMMethodInfo.LoadFromStringList(aSource: TStringList; aLineOfCode: Integer; aArea: TKMParsingArea);
var
  I: Integer;
  srcLine, restStr, metName: string;
  strStatus: string;
  details: TStringList;
begin
  fFirstLine := aLineOfCode;

  details := TStringList.Create;
  try
    I := 0;
    srcLine := aSource[I];

    if StartsStr('//* Version:', srcLine) then
    begin
      fVersion := Trim(RightStrAfter(srcLine, ':'));
      Inc(I);
      srcLine := aSource[I];
    end;

    // Descriptions are only added by lines starting with "//*"
    // Repeat until no description tags are found
    while StartsStr('//*', srcLine) do
    begin
      if StartsStr('//* Status:', srcLine) then
      begin
        strStatus := Trim(RightStrAfter(srcLine, ':'));
        if StartsStr('Deprecated', strStatus) then
          fStatus := msDeprecated
        else
        if StartsStr('Changed', strStatus) then
          fStatus := msChanged
        else
        if StartsStr('Removed', strStatus) then
          fStatus := msRemoved;
      end else
      if StartsStr('//* Replacement:', srcLine) then
        fReplacement := Trim(RightStrAfter(srcLine, ':'))
      else
      // Handle Result description separately to keep the output clean
      if StartsStr('//* Result:', srcLine) then
        fResultDesc := Trim(RightStrAfter(srcLine, ':'))
      else
        // Do not trim, we want to preseve the padding (especially in <pre> sections)
        details.Add(RightStrAfter(srcLine, '* '));
      Inc(I);
      srcLine := aSource[I];
    end;

    // Skip empty or "faulty" lines (e.g. comments not intended for wiki)
    while not StartsStr('procedure', srcLine)
    and not StartsStr('function', srcLine) do
    begin
      Inc(I);
      srcLine := aSource[I];
    end;

    // Parse procedure
    if StartsStr('procedure', srcLine) then
    begin
      fType := mtProc;

      if Pos('(', srcLine) <> 0 then
      begin
        // Procedure with fParameters
        metName := Copy(srcLine, Pos('.', srcLine) + 1, Pos('(', srcLine) - 1 - Pos('.', srcLine));

        // fParameters could go for several lines
        restStr := '';
        while Pos(')', srcLine) = 0 do
        begin
          restStr := restStr + Copy(srcLine, Pos('(', srcLine) + 1, Length(srcLine));
          Inc(I);
          srcLine := aSource[I];
        end;
        restStr := restStr + Copy(srcLine, Pos('(', srcLine) + 1, Pos(')', srcLine) - 1 - Pos('(', srcLine));

        fParameters.ParseFromString(restStr, details);
      end else
        // Procedure without fParameters (ends with ";")
        metName := Copy(srcLine, Pos('.', srcLine) + 1, Pos(';', srcLine) - 1 - Pos('.', srcLine));

      if aArea = paEvents then
      begin
        metName := ReplaceStr(metName, 'ProcOn', 'On'); // For the KP
        fName := ReplaceStr(metName, 'Proc', 'On');   // For the KMR
      end else
        fName := metName;
    end;

    // Parse function
    if StartsStr('function', srcLine) then
    begin
      fType := mtFunc;

      if Pos('(', srcLine) <> 0 then
      begin
        // Function with fParameters
        metName := Copy(srcLine, Pos('.', srcLine) + 1, Pos('(', srcLine) - 1 - Pos('.', srcLine));

        // fParameters could go for several lines
        restStr := '';
        while Pos(')', srcLine) = 0 do
        begin
          restStr := restStr + Copy(srcLine, Pos('(', srcLine) + 1, Length(srcLine));
          Inc(I);
          srcLine := aSource[I];
        end;
        restStr := restStr + Copy(srcLine, Pos('(', srcLine) + 1, Pos(')', srcLine) - 1 - Pos('(', srcLine));

        fParameters.ParseFromString(restStr, details);
      end else
        // Function without fParameters (ends with ":")
        metName := Copy(srcLine, Pos('.', srcLine) + 1, Pos(':', srcLine) - 1 - Pos('.', srcLine));

      if aArea = paEvents then
      begin
        metName := ReplaceStr(metName, 'FuncOn', 'On'); // For the KP
        fName := ReplaceStr(metName, 'Func', 'On');   // For the KMR
      end else
        fName := metName;

      // Function result
      restStr := StrTrimRightSeparators(StrSubstring(srcLine, StrLastIndexOf(srcLine, ':') + 2));
      if aArea = paEvents then
        fResultType := TryEventTypeToAlias(restStr)
      else
        fResultType := restStr;
    end;

    if aArea = paEvents then
      fParameters.DowngradeTypes;

    // Now we can assemble Description, after we have detected and removed fParameters descriptions from it
    for I := 0 to details.Count - 1 do
      // We don't need <br/> after </pre> since </pre> has an automatic visual "br" after it
      if (I > 0) and (EndsStr('</pre>', details[I-1])) then
        fDescription := fDescription + details[I]
      else
        fDescription := fDescription + '<br/>' + details[I];
  finally
    details.Free;
  end;
end;


function TKMMethodInfo.ExportWikiBody(aNeedReturn: Boolean): string;
const
  TEMPLATE = '| %s | <a id="%s">%s</a>%s<sub>%s</sub> | <sub>%s</sub> |';
  TEMPLATE_RET = ' <sub>%s%s</sub> |';
var
  deprStr: string;
begin
  case fStatus of
    msDeprecated: begin
                    deprStr := '<br/>' + UNICODE_RED_CROSS + '`Deprecated`<br/>' +
                               '<sub>*Method could be removed in the future game versions';

                    if fReplacement <> '' then
                      if fReplacement = StringReplace(fReplacement, ' ', '', [rfReplaceAll]) then
                        deprStr := deprStr + ', use <a href="#' + fReplacement + '">' + fReplacement + '</a> instead'
                      else
                        deprStr := deprStr + ', ' + fReplacement;

                    deprStr := deprStr + '*</sub>';
                  end;
    msRemoved:    begin
                    deprStr := '<br/>' + UNICODE_RED_CROSS + '`Removed`<br/>' +
                               '<sub>*Method was removed';

                    if fReplacement <> '' then
                      if fReplacement = StringReplace(fReplacement, ' ', '', [rfReplaceAll]) then
                        deprStr := deprStr + ', use <a href="#' + fReplacement + '">' + fReplacement + '</a> instead'
                      else
                        deprStr := deprStr + ', ' + fReplacement;

                    deprStr := deprStr + '*</sub>';
                  end;
    msChanged:    begin
                    deprStr := '<br/>' + UNICODE_EXCLAMATION + '`Changed`<br/>' +
                               '<sub>*Method was changed*</sub>';
                  end;
  else
    deprStr := '';
  end;

  Result := Format(TEMPLATE, [
    IfThen(fVersion <> '', fVersion, '-'), fName, fName, deprStr, fDescription, fParameters.ExportWikiBody]);
  if aNeedReturn then
    // todo: add link instead of text when our custom script type are mentioned
    Result := Result + Format(TEMPLATE_RET, [fResultType, IfThen(fResultDesc <> '', ' // ' + fResultDesc)]);
end;


// Method signature for the "RegisterMethodCheck(c, '...');" in PS engine
function TKMMethodInfo.ExportCodeSignature: string;
begin
  Result := IfThen(fResultType = '', 'procedure', 'function ') + ' ' + fName +
    fParameters.ExportCodeSignature +
    IfThen(fResultType <> '', ': ' + fResultType);
end;


function TKMMethodInfo.ExportCodeSignatureEvent(aGame: TKMParsingGame; aLastLine: Boolean): string;
const
  CNT: array [TKMParsingGame] of Byte = (5, 5);
  TEMPLATE_KMR = '(ParamCount: %d; Typ: (0, %-8s, %-8s, %-8s, %-8s, %-8s); Dir: (%s, %s, %s, %s, %s))%s // %s';
  TEMPLATE_KP = '(Name: ''%-32s''; ParamCount: %d; Typ: (0, %-6s, %-6s, %-6s, %-6s, %-6s); Dir: (%s, %s, %s, %s, %s))%s';
var
  typ: array [0..5] of string;
  dir: array [0..5] of string;
  I: Integer;
begin
  Assert(fParameters.Count <= CNT[aGame]);

  for I := 0 to CNT[aGame] - 1 do
    if I < fParameters.Count then
    begin
      typ[I] := TryEventTypeToTyp(fParameters[I].VarType);
      dir[I] := TryEventModifierToDir(fParameters[I].Modifier);
    end else
    begin
      typ[I] := '0';
      dir[I] := 'pmIn';
    end;

  case aGame of
    pgKaMRemake:        Result := Format(TEMPLATE_KMR,
      [fParameters.Count, typ[0], typ[1], typ[2], typ[3], typ[4], dir[0], dir[1], dir[2], dir[3], dir[4], IfThen(not aLastLine, ','), fName]);
    pgKnightsProvince:  Result := Format(TEMPLATE_KP,
      [fName, fParameters.Count, typ[0], typ[1], typ[2], typ[3], typ[4], dir[0], dir[1], dir[2], dir[3], dir[4], IfThen(not aLastLine, ',')]);
  end;
end;


function TKMMethodInfo.ExportCodeNameRegistration: string;
begin
  Result := fName + ', '#39 + fName + #39;
end;


function TKMMethodInfo.ExportCodeNameRegistrationEvent(aGame: TKMParsingGame; aLastLine: Boolean): string;
begin
  case aGame of
    pgKaMRemake:        Result := 'evt' + Copy(fName, 3, Length(fName)) + IfThen(not aLastLine, ',');
    pgKnightsProvince:  Result := Format('fProc%-24s := fExec.GetProcAsMethodN('#39'%s'#39');', [fName, fName]);
  end;
end;


function TKMMethodInfo.ExportWikiLink: string;
const
  STATUS_ICON: array [TKMMethodStatus] of string = ('',  UNICODE_RED_CROSS + ' ', UNICODE_RED_CROSS + ' ', UNICODE_EXCLAMATION + ' ');
  TEMPLATE = '* <a href="#%s">%s%s</a>';
begin
  Result := Format(TEMPLATE, [fName, STATUS_ICON[fStatus], fName]);
end;


function TKMMethodInfo.CheckLogMessages(aSourceCode: TStringList; const aLogMessageName: string): string;
begin
  Result := '';

  var idx := fFirstLine;
  var lineTextThis := '';
  var lineTextPrev := '';
  var logCount := 0;
  repeat
    lineTextPrev := lineTextThis;
    lineTextThis := Trim(aSourceCode[idx]);

    if (Pos(aLogMessageName, lineTextThis) <> 0) then
    begin
      Inc(logCount);

      // If there is a LogMessage in this line, it should reference the method it is in
      if (Pos(fName, lineTextThis) = 0) then
        Result := Result + IfThen(Result <> '', sLineBreak) + Format('Line %d. "%s" missing in "%s"', [idx, fName, lineTextThis]);
    end;

    Inc(idx);
  until lineTextThis + lineTextPrev = '';

  // There are quite a few methods without warnings in them
  //if (fStatus = msOk) and (fParameters.Count > 0) and (logCount = 0) then
  //  Result := Result + IfThen(Result <> '', sLineBreak) + fName + ' - no warnings?';
end;


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
        Result := CompareText(A.fName, B.fName);

        // Changed methods have same names, but need to be sorted from old to new
        if Result = 0 then
          Result := Ord(B.fStatus) - Ord(A.fStatus);
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
      //* Status: -/Deprecated/Removed/Changed [optional]
      //* Replacement: Link to the replacement method [optional]
      //* Large description of the method [optional]
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

      if not sectionStarted and StartsStr('//*', srcLine) then
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

  fOnLog(Format('%d %s parsed', [GetCount, AREA_INFO[fArea].Short]));
end;


function TKMScriptMethods.ExportWikiBody: string;
var
  I: Integer;
begin
  Result := '';

  for I := 0 to fList.Count - 1 do
  begin
    fList[I].fParameters.AdjoinPairs;
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


function TKMScriptMethods.GetCount: Integer;
begin
  Result := fList.Count;
end;


procedure TKMScriptMethods.SortByName;
begin
  fList.Sort;
end;


procedure TKMScriptMethods.ExportCodeSectionCheck(aSL: TStringList);
var
  secStart, secEnd, pad: Integer;
  I: Integer;
begin
  FindStartAndFinish(aSL, AREA_INFO[fArea].CheckTag, secStart, secEnd, pad);
  if secStart <> -1 then
  begin
    for I := secEnd downto secStart do
      aSL.Delete(I);

    // Insert in reverse so we could skip "removed" methods
    for I := fList.Count - 1 downto 0 do
      if fList[I].fStatus in [msOk, msDeprecated] then
        case fArea of
          paActions,
          paStates,
          paUtils:    begin
                        // We can write more compact code with AdjoinPairs
                        fList[I].fParameters.AdjoinPairs;
                        aSL.Insert(secStart, DupeString(' ', pad) + 'RegisterMethodCheck(c, '#39 + fList[I].ExportCodeSignature + #39');');
                      end;
          paEvents:   // Can not use AdjoinPairs here. All vars must be separate
                      aSL.Insert(secStart, DupeString(' ', pad) + fList[I].ExportCodeSignatureEvent(fGame, I = fList.Count-1));
        end;

    fOnLog(Format('%d %s exported into Code checks', [GetCount, AREA_INFO[fArea].Short]));
  end else
    fOnLog(Format('%s tag not found', [AREA_INFO[fArea].CheckTag]));
end;


procedure TKMScriptMethods.ExportCodeSectionReg(aSL: TStringList);
const
  AREA_REG_CLASS: array [TKMParsingGame, TKMParsingArea] of string = (
    ('TKMScriptActions',    '', 'TKMScriptStates',    'TKMScriptUtils',    ''), // KMR
    ('TKMScriptingActions', '', 'TKMScriptingStates', 'TKMScriptingUtils', '')  // KP
  );
var
  secStart, secEnd, pad: Integer;
  I: Integer;
begin
  FindStartAndFinish(aSL, AREA_INFO[fArea].RegTag, secStart, secEnd, pad);
  if secStart <> -1 then
  begin
    for I := secEnd downto secStart do
      aSL.Delete(I);

    // Insert in reverse so we could skip "removed" methods
    for I := fList.Count - 1 downto 0 do
      if fList[I].fStatus in [msOk, msDeprecated] then
        case fArea of
          paActions,
          paStates,
          paUtils:    aSL.Insert(secStart, DupeString(' ', pad) + 'RegisterMethod(@' + AREA_REG_CLASS[fGame, fArea] + '.' + fList[I].ExportCodeNameRegistration + ');');
          paEvents:   aSL.Insert(secStart, DupeString(' ', pad) + fList[I].ExportCodeNameRegistrationEvent(fGame, I = fList.Count - 1));
        end;

    fOnLog(Format('%d %s exported into Code regs', [GetCount, AREA_INFO[fArea].Short]));
  end else
    fOnLog(Format('%s tag not found', [AREA_INFO[fArea].RegTag]));
end;


procedure TKMScriptMethods.ExportCode(const aFilenameCheckAndReg: string);
var
  sl: TStringList;
begin
  if not FileExists(aFilenameCheckAndReg) then Exit;

  sl := TStringList.Create;
  sl.LoadFromFile(aFilenameCheckAndReg);
  ExportCodeSectionCheck(sl);
  ExportCodeSectionReg(sl);
  sl.SaveToFile(aFilenameCheckAndReg);
  sl.Free;
end;


procedure TKMScriptMethods.ExportCode(const aFilenameCheck, aFilenameReg: string);
var
  sl: TStringList;
begin
  if FileExists(aFilenameCheck) then
  begin
    sl := TStringList.Create;
    sl.LoadFromFile(aFilenameCheck);
    ExportCodeSectionCheck(sl);
    sl.SaveToFile(aFilenameCheck);
    sl.Free;
  end;

  if FileExists(aFilenameReg) then
  begin
    sl := TStringList.Create;
    sl.LoadFromFile(aFilenameReg);
    ExportCodeSectionReg(sl);
    sl.SaveToFile(aFilenameReg);
    sl.Free;
  end;
end;


function TKMScriptMethods.ExportWiki(const aTemplateFile, aOutputFile: string): string;
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

  fOnLog(Format('%d %s exported into Wiki', [GetCount, AREA_INFO[fArea].Short]));
end;


procedure TKMScriptMethods.CheckMessages(const aSourceFile: string; const aLogMessageName: string);
var
  sl: TStringList;
begin
  sl := TStringList.Create;
  sl.LoadFromFile(aSourceFile);

  for var I := 0 to fList.Count - 1 do
  begin
    var res := fList[I].CheckLogMessages(sl, aLogMessageName);
    if res <> '' then
      fOnLog(res);
  end;

  sl.Free;
end;


end.
