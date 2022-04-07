unit KM_ScriptingMethods;
interface
uses
  Classes, SysUtils, Types, Vcl.Forms, Windows, Generics.Collections, Generics.Defaults,
  StrUtils,
  KM_ScriptingParameters, KM_ScriptingTypes;

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
    constructor CreateFromStringList(aSource: TStringList);
    destructor Destroy; override;
    function ExportBody(aNeedReturn: Boolean): string;
    function ExportLink: string;
  end;


  // List of methods
  TKMScriptMethods = class
  private
    fArea: TKMParsingArea;
    fList: TObjectList<TKMMethodInfo>;
    procedure Append(aMethod: TKMMethodInfo);
    procedure Clear;
    function ExportBody: string;
    function ExportLinks: string;
    function GetCount: Integer;
    function GetItem(aIndex: Integer): TKMMethodInfo;
  public
    constructor Create(aArea: TKMParsingArea);
    destructor Destroy; override;

    procedure LoadFromFile(const aInputFile: string);
    property Count: Integer read GetCount;
    property Items[aIndex: Integer]: TKMMethodInfo read GetItem; default;
    procedure SortByName;
    function ExportWiki(const aTemplateFile: string): string;
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


constructor TKMMethodInfo.CreateFromStringList(aSource: TStringList);
var
  I: Integer;
  srcLine, restStr, metName: string;
  strStatus: string;
  details: TStringList;
begin
  Create;

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

      metName := ReplaceStr(metName, 'ProcOn', 'On'); // For the KP
      fName := ReplaceStr(metName, 'Proc', 'On');   // For the KMR
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

      metName := ReplaceStr(metName, 'FuncOn', 'On'); // For the KP
      fName := ReplaceStr(metName, 'Func', 'On');   // For the KMR

      // Function result
      restStr := StrTrimRightSeparators(StrSubstring(srcLine, StrLastIndexOf(srcLine, ':') + 2));
      fResultType := TryTypeToAlias(restStr);
    end;

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


destructor TKMMethodInfo.Destroy;
begin
  FreeAndNil(fParameters);

  inherited;
end;


function TKMMethodInfo.ExportBody(aNeedReturn: Boolean): string;
const
  UNICODE_RED_CROSS = '&#x274C;';
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

  Result := '| ' + IfThen(fVersion <> '', fVersion, '-') + ' | <a id="' + fName + '">' + fName + '</a>' +
              deprStr +
              '<sub>' + fDescription + '</sub>' +
              ' | <sub>' + fParameters.GetText + '</sub>' +
              IfThen(aNeedReturn, ' | <sub>' + fResultType + IfThen(fResultDesc <> '', ' // ' + fResultDesc) + '</sub>') +
              ' |';
end;


function TKMMethodInfo.ExportLink: string;
begin
  Result := '* <a href="#' + fName + '">' + fName + '</a>';
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
  Clear;

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

          Append(TKMMethodInfo.CreateFromStringList(sl));
        end;
      end;
    end;
    sl.Free;
  finally
    slSource.Free;
  end;
end;


function TKMScriptMethods.GetCount: Integer;
begin
  Result := fList.Count;
end;


function TKMScriptMethods.GetItem(aIndex: Integer): TKMMethodInfo;
begin
  Result := fList[aIndex];
end;


procedure TKMScriptMethods.Append(aMethod: TKMMethodInfo);
begin
  fList.Add(aMethod);
end;


procedure TKMScriptMethods.Clear;
begin
  fList.Clear;
end;


function TKMScriptMethods.ExportBody: string;
var
  I: Integer;
begin
  Result := '';

  for I := 0 to Count - 1 do
    Result := Result + IfThen(I > 0, sLineBreak) + Items[I].ExportBody(AREA_NEED_RETURN[fArea]);
end;


function TKMScriptMethods.ExportLinks: string;
var
  I: Integer;
begin
  Result := '';

  for I := 0 to Count - 1 do
    Result := Result + IfThen(I > 0, sLineBreak) + Items[I].ExportLink;
end;


procedure TKMScriptMethods.SortByName;
begin
  fList.Sort;
end;


function TKMScriptMethods.ExportWiki(const aTemplateFile: string): string;
var
  sl: TStringList;
begin
  sl := TStringList.Create;

  sl.LoadFromFile(aTemplateFile);

  sl.Text := StringReplace(sl.Text, '{LINKS}', ExportLinks, []);
  sl.Text := StringReplace(sl.Text, '{TITLE}', AREA_TITLE[fArea], []);
  sl.Text := StringReplace(sl.Text, '{BODY}', ExportBody, []);

  Result := sl.Text;

  sl.Free;
end;


end.
