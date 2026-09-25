unit KM_ScriptingMethod;
interface
uses
  System.Classes,
  KM_ScriptingMethodParameters, KM_DocumenterTypes;

type
  TKMMethodType = (mtFunc, mtProc);
  TKMMethodStatus = (
    msOk,
    msDeprecated, // Method is slated for removal
    msRemoved,    // Method was removed (usually in favor of some other)
    msChanged     // Method has changed (arguments order, etc.)
  );

  // Single method info
  // Documenter > Scripting > Method
  TKMMethodInfo = class
  private
    fFirstLine: Integer;  // First line of code where this method documentation and declaration starts
    fName: string;
    fType: TKMMethodType;
    fVersion: string;         // Game version in which the method was added/changed
    fStatus: TKMMethodStatus;
    fReplacement: string;     // Replacement method recommendation
    fDescription: string;     // Description of the method as a whole
    fParameters: TKMScriptingMethodParameters; // Parameters parsed from declaration
    fResultType: string;
    fResultDesc: string;
  public
    constructor Create;
    destructor Destroy; override;
    procedure LoadFromStringList(aSource: TStringList; aLineOfCode: Integer; aAreaIsEvents: Boolean);
    function ExportWikiBody(aNeedReturn: Boolean): string;
    function ExportWikiLink: string;
    function ExportCodeSignature: string;
    function ExportCodeSignatureEvent(aGame: TKMParsingGame; aLastLine: Boolean): string;
    function ExportCodeNameRegistration: string;
    function ExportCodeNameRegistrationEvent(aGame: TKMParsingGame; aLastLine: Boolean): string;
    function LintLogMessages(aSourceCode: TStringList; const aLogMessageName: string): string;

    property Name: string read fName;
    property Status: TKMMethodStatus read fStatus;
    property Parameters: TKMScriptingMethodParameters read fParameters;
  end;


implementation
uses
  System.SysUtils, System.StrUtils,
  KM_ScriptingMethodConsts, KM_StringUtils;


const
  UNICODE_RED_CROSS = '&#x274C;';
  UNICODE_EXCLAMATION = '&#x26A0;';


{ TKMMethodInfo }
constructor TKMMethodInfo.Create;
begin
  inherited;

  fParameters := TKMScriptingMethodParameters.Create;
end;


destructor TKMMethodInfo.Destroy;
begin
  FreeAndNil(fParameters);

  inherited;
end;


procedure TKMMethodInfo.LoadFromStringList(aSource: TStringList; aLineOfCode: Integer; aAreaIsEvents: Boolean);
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

    if StartsStr(DOC_TAG_VERSION, srcLine) then
    begin
      fVersion := Trim(RightStrAfter(srcLine, ':'));
      Inc(I);
      srcLine := aSource[I];
    end;

    // Descriptions are only added by lines starting with "//*"
    // Repeat until no description tags are found
    while StartsStr(DOC_TAG, srcLine) do
    begin
      if StartsStr(DOC_TAG_STATUS, srcLine) then
      begin
        strStatus := Trim(RightStrAfter(srcLine, ':'));
        if StartsStr(DOC_TAG_STATUS_DEPRECATED, strStatus) then
          fStatus := msDeprecated
        else
        if StartsStr(DOC_TAG_STATUS_CHANGED, strStatus) then
          fStatus := msChanged
        else
        if StartsStr(DOC_TAG_STATUS_REMOVED, strStatus) then
          fStatus := msRemoved;
      end else
      if StartsStr(DOC_TAG_REPLACEMENT, srcLine) then
        fReplacement := Trim(RightStrAfter(srcLine, ':'))
      else
      // Handle Result description separately to keep the output clean
      if StartsStr(DOC_TAG_RESULT, srcLine) then
        fResultDesc := Trim(RightStrAfter(srcLine, ':'))
      else
        // Do not trim, we want to preseve the padding (especially in <pre> sections)
        details.Add(RightStrAfter(srcLine, DOC_TAG + ' '));

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

      if aAreaIsEvents then
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

      if aAreaIsEvents then
      begin
        metName := ReplaceStr(metName, 'FuncOn', 'On'); // For the KP
        fName := ReplaceStr(metName, 'Func', 'On');   // For the KMR
      end else
        fName := metName;

      // Function result
      restStr := ExtractFunctionResultType(srcLine);
      if aAreaIsEvents then
        fResultType := TryEventTypeToAlias(restStr)
      else
        fResultType := restStr;
    end;

    if aAreaIsEvents then
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
  begin
    //todo -cPractical: add link instead of text when our custom script type is mentioned
    var retType := IfThen(fResultType <> '', fResultType, '-');
    var retDesc := IfThen(fResultDesc <> '', ' // ' + fResultDesc);

    Result := Result + Format(TEMPLATE_RET, [retType, retDesc]);
  end;
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


function TKMMethodInfo.LintLogMessages(aSourceCode: TStringList; const aLogMessageName: string): string;
begin
  Result := '';

  // Start with the first LOC of the method
  var idx := fFirstLine;
  var lineTextThis := '';
  var lineTextPrev := '';
  //var logCount := 0;
  repeat
    lineTextPrev := lineTextThis;
    lineTextThis := Trim(aSourceCode[idx]);

    if ContainsText(lineTextThis, aLogMessageName) then
    begin
      //Inc(logCount);

      // If there is a LogMessage in this line, it should reference the method it is in
      if not ContainsText(lineTextThis, fName) then
        Result := Result + IfThen(Result <> '', sLineBreak) + Format('Line %d. "%s" missing in "%s"', [idx, fName, lineTextThis]);
    end;

    // Keep going until we encounter 2 EOLs (next method)
    Inc(idx);
  until lineTextThis + lineTextPrev = '';

  // There are quite a few methods without warnings in them
  //if (fStatus = msOk) and (fParameters.Count > 0) and (logCount = 0) then
  //  Result := Result + IfThen(Result <> '', sLineBreak) + fName + ' - no warnings?';
end;


end.
