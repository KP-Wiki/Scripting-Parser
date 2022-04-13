unit KM_ScriptingMethods;
interface
uses
  Classes, SysUtils, Types, Vcl.Forms, Windows, Generics.Collections, Generics.Defaults,
  StrUtils,
  KM_ScriptingParameters, KM_ParserTypes;

type
  TKMMethodType = (mtFunc, mtProc);
  TKMMethodStatus = (msOk, msDeprecated, msRemoved);

  // Single method info
  TKMMethodInfo = class
  private
    fName: string;
    fType: TKMMethodType;
    fVersion: string; // Version in which the method was added/changed
    fStatus: TKMMethodStatus;
    fReplacement: string;
    fDescription: string;
    fParameters: TKMScriptParameters; // Parameters parsed from declaration
    fResultType: string;
    fResultDesc: string;
  public
    constructor Create;
    destructor Destroy; override;
    procedure LoadFromStringList(aSource: TStringList; aArea: TKMParsingArea);
    function ExportWikiBody(aNeedReturn: Boolean): string;
    function ExportWikiLink: string;
    function ExportCodeCheck: string;
    function ExportCodeCheckEvent(aGame: TKMParsingGame): string;
    function ExportCodeReg: string;
  end;


  // List of methods
  TKMScriptMethods = class
  private
    fArea: TKMParsingArea;
    fList: TObjectList<TKMMethodInfo>;
    function ExportWikiBody: string;
    function ExportWikiLinks: string;
    function GetCount: Integer;
  public
    constructor Create(aArea: TKMParsingArea);
    destructor Destroy; override;

    property Count: Integer read GetCount;
    procedure LoadFromFile(const aInputFile: string);
    procedure SortByName;
    procedure ExportCode(const aCodeFile: string; aGame: TKMParsingGame; out aCountCheck, aCountReg: Integer);
    function ExportWiki(const aTemplateFile: string; out aCountWiki: Integer): string;
  end;


implementation
uses
  KM_ScriptingConsts, KM_StringUtils;


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


procedure TKMMethodInfo.LoadFromStringList(aSource: TStringList; aArea: TKMParsingArea);
var
  I: Integer;
  srcLine, restStr, metName: string;
  strStatus: string;
  details: TStringList;
begin
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
  UNICODE_RED_CROSS = '&#x274C;';
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
  else
    deprStr := '';
  end;

  Result := Format(TEMPLATE, [
    IfThen(fVersion <> '', fVersion, '-'), fName, fName, deprStr, fDescription, fParameters.ExportWikiBody]);
  if aNeedReturn then
    Result := Result + Format(TEMPLATE_RET, [fResultType, IfThen(fResultDesc <> '', ' // ' + fResultDesc)]);
end;


function TKMMethodInfo.ExportCodeCheck: string;
begin
  Result := IfThen(fResultType = '', 'procedure', 'function ') + ' ' + fName +
    fParameters.ExportCodeCheck +
    IfThen(fResultType <> '', ': ' + fResultType);
end;


function TKMMethodInfo.ExportCodeCheckEvent(aGame: TKMParsingGame): string;
const
  CNT = 5;
  TEMPLATE_KMR = '(ParamCount: %d; Typ: (0, %s, %s, %s, %s, %s); Dir: (pmIn, pmIn, pmIn, pmIn, pmIn)) // %s';
  TEMPLATE_KP = '(Name: ''%s'';       ParamCount: %d; Typ: (0, %s, %s, %s, %s, %s); Dir: (pmIn, pmIn, pmIn, pmIn, pmIn))';
var
  p: array [0..CNT-1] of string;
  n: string;
  I: Integer;
begin
  Assert(fParameters.Count <= CNT);

  for I := 0 to High(p) do
  begin
    if I < fParameters.Count then
      p[I] := TryEventTypeToTyp(fParameters[I].VarType)
    else
      p[I] := '0';

    p[I] := p[I] + DupeString(' ', 6 - Length(p[I]));
  end;

  n := fName + DupeString(' ', 32 - Length(fName));

  case aGame of
    pgKaMRemake:        Result := Format(TEMPLATE_KMR, [fParameters.Count, p[0], p[1], p[2], p[3], p[4], fName]);
    pgKnightsProvince:  Result := Format(TEMPLATE_KP, [n, fParameters.Count, p[0], p[1], p[2], p[3], p[4]]);
  end;
end;


function TKMMethodInfo.ExportCodeReg: string;
begin
  Result := fName + ', '#39 + fName + #39;
end;


function TKMMethodInfo.ExportWikiLink: string;
const
  TEMPLATE = '* <a href="#%s">%s</a>';
begin
  Result := Format(TEMPLATE, [fName, fName]);
end;


{ TKMScriptMethods }
constructor TKMScriptMethods.Create(aArea: TKMParsingArea);
begin
  inherited Create;

  fArea := aArea;

  fList := TObjectList<TKMMethodInfo>.Create(
    TComparer<TKMMethodInfo>.Construct(
      function(const A, B: TKMMethodInfo): Integer
      begin
        // Case-sensitive compare, since we use CamelCase and it looks nicer that way
        Result := CompareText(A.fName, B.fName);
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
  sl: TStringList;
  sectionStarted, sectionTailEnded: Boolean;
begin
  fList.Clear;

  slSource := TStringList.Create;
  try
    slSource.LoadFromFile(aInputFile);

    // Assemble method sections 1 by 1
      {
      //* Version: 1234
      //* Status: -/Deprecated/Removed [optional]
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

    sl := TStringList.Create;
    for I := 0 to slSource.Count - 1 do
    begin
      srcLine := slSource[I];

      if not sectionStarted and StartsStr('//*', srcLine) then
      begin
        sectionStarted := True;
        sectionTailEnded := True;
        sl.Clear;
      end;

      if sectionStarted then
        sl.Append(slSource[I]);

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
          fList.Last.LoadFromStringList(sl, fArea);
        end;
      end;
    end;
    sl.Free;
  finally
    slSource.Free;
  end;
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


procedure TKMScriptMethods.ExportCode(const aCodeFile: string; aGame: TKMParsingGame; out aCountCheck, aCountReg: Integer);
const
  AREA_REG_CLASS: array [TKMParsingGame, TKMParsingArea] of string = (
    ('TKMScriptActions', '', 'TKMScriptStates', 'TKMScriptUtils', ''),
    ('TKMScriptingActions', '', 'TKMScriptingStates', 'TKMScriptUtils', '')
  );
var
  sl: TStringList;
  secStart, secEnd, pad: Integer;
  I: Integer;
begin
  aCountCheck := 0;
  aCountReg := 0;

  //todo: Events check in KMR needs to be handled differently (account for evt***)
  if (aGame = pgKaMRemake) and (fArea = paEvents) then Exit;
  if not FileExists(aCodeFile) then Exit;

  sl := TStringList.Create;
  try
    sl.LoadFromFile(aCodeFile);

    FindStartAndFinish(sl, AREA_INFO[fArea].CheckTag, secStart, secEnd, pad);
    if secStart <> -1 then
    begin
      for I := secEnd downto secStart do
        sl.Delete(I);

      // Insert in reverse so we could skip "removed" methods
      for I := fList.Count - 1 downto 0 do
      begin
        if fList[I].fStatus <> msRemoved then
        case fArea of
          paActions,
          paStates,
          paUtils:    begin
                        // We can write more compact code with AdjoinPairs
                        fList[I].fParameters.AdjoinPairs;
                        sl.Insert(secStart, DupeString(' ', pad) + 'RegisterMethodCheck(c, '#39 + fList[I].ExportCodeCheck + #39');');
                      end;
          paEvents:   // Can not use AdjoinPairs here. All vars must be separate
                      sl.Insert(secStart, DupeString(' ', pad) + fList[I].ExportCodeCheckEvent(aGame) + IfThen(I <> fList.Count-1, ','));
        end;

        Inc(aCountCheck);
      end;
    end;

    FindStartAndFinish(sl, AREA_INFO[fArea].RegTag, secStart, secEnd, pad);
    if secStart <> -1 then
    begin
      for I := secEnd downto secStart do
        sl.Delete(I);

      // Insert in reverse so we could skip "removed" methods
      for I := fList.Count - 1 downto 0 do
      begin
        if fList[I].fStatus <> msRemoved then
          sl.Insert(secStart, DupeString(' ', pad) + 'RegisterMethod(@' + AREA_REG_CLASS[aGame, fArea] + '.' + fList[I].ExportCodeReg + ');');
        Inc(aCountReg);
      end;
    end;

    sl.SaveToFile(aCodeFile);
  finally
    sl.Free;
  end;
end;


function TKMScriptMethods.ExportWiki(const aTemplateFile: string; out aCountWiki: Integer): string;
var
  sl: TStringList;
begin
  sl := TStringList.Create;

  sl.LoadFromFile(aTemplateFile);

  sl.Text := StringReplace(sl.Text, '{LINKS}', ExportWikiLinks, []);
  sl.Text := StringReplace(sl.Text, '{BODY}', ExportWikiBody, []);

  Result := sl.Text;

  sl.Free;

  // No surprises here, everything gets exported
  aCountWiki := Count;
end;


end.
