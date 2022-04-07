unit KM_ScriptingMethods;
interface
uses
  Classes, SysUtils, Types, Vcl.Forms, Windows, Generics.Collections, Generics.Defaults,
  StrUtils,
  KM_ScriptingParameters, KM_ScriptingTypes;

type
  TKMMethodStatus = (msOk, msDeprecated, msRemoved);

  // Single method info
  TKMMethodInfo = class
  private
    fDetails: TStringList; // Method description and parameters comments
    fParameters: TKMScriptParameters; // Parameters parsed from declaration
  public
    Name: string;
    Version: string; // Version in which the method was added/changed
    Status: TKMMethodStatus;
    Replacement: string;
    Description: string;
    Return: string; // Result type
    ReturnDesc: string; // Result comment
    constructor Create;
    constructor CreateFromStringList(aSource: TStringList);
    destructor Destroy; override;
    property Details: TStringList read fDetails;
    property Parameters: TKMScriptParameters read fParameters;
    function GetBody(aNeedReturn: Boolean): string;
    function GetLink: string;
  end;


  // List of methods
  TKMScriptMethods = class
  private
    fArea: TKMParsingArea;
    fList: TObjectList<TKMMethodInfo>;
    procedure Append(aMethod: TKMMethodInfo);
    procedure Clear;
    function GetCount: Integer;
    function GetItem(aIndex: Integer): TKMMethodInfo;
  public
    constructor Create(aArea: TKMParsingArea);
    destructor Destroy; override;

    procedure LoadFromFile(const aInputFile: string);
    property Count: Integer read GetCount;
    property Items[aIndex: Integer]: TKMMethodInfo read GetItem; default;
    procedure SortByName;
    function GetBody: string;
    function GetLinks: string;
    function ExportWiki(aHeaderFile: string): string;
  end;


implementation
uses
  KM_ScriptingConsts, KM_StringUtils;


{ TKMMethodInfo }
constructor TKMMethodInfo.Create;
begin
  inherited;

  fDetails := TStringList.Create;
  fParameters := TKMScriptParameters.Create;
end;


constructor TKMMethodInfo.CreateFromStringList(aSource: TStringList);
var
  I: Integer;
  srcLine: string;
  restStr: string;
  strStatus: string;
begin
  Create;

  I := 0;
  srcLine := aSource[I];

  if StartsStr('//* Version:', srcLine) then
  begin
    restStr := Trim(StrSubstring(srcLine, Pos(':', srcLine) + 1));
    Version := IfThen(restStr = '', '-', restStr);
    Inc(I);
    srcLine := aSource[I];
  end;

  // Descriptions are only added by lines starting with "//*"
  // Repeat until no description tags are found
  while StartsStr('//*', srcLine) do
  begin
    if StartsStr('//* Status:', srcLine) then
    begin
      strStatus := Trim(StrSubstring(srcLine, Pos(':', srcLine) + 1));
      if StartsStr('Deprecated', strStatus) then
        Status := msDeprecated
      else
      if StartsStr('Removed', strStatus) then
        Status := msRemoved;
    end else
    if StartsStr('//* Replacement:', srcLine) then
      Replacement := Trim(StrSubstring(srcLine, Pos(':', srcLine) + 1))
    else
    // Handle Result description separately to keep the output clean
    if StartsStr('//* Result:', srcLine) then
      ReturnDesc := StrSubstring(srcLine, Pos(':', srcLine) + 1)
    else
      Details.Add(StrSubstring(srcLine, Pos('*', srcLine) + 1));
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

  // Format procedures
  if StartsStr('procedure', srcLine) then
  begin
    if Pos('(', srcLine) <> 0 then
    begin
      // Procedure with parameters
      restStr := Copy(srcLine, Pos('.', srcLine) + 1, Pos('(', srcLine) - 1 - Pos('.', srcLine));
      restStr := ReplaceStr(restStr, 'ProcOn', 'On'); // For the KP
      Name := ReplaceStr(restStr, 'Proc', 'On');   // For the KMR

      // Parameters could go for several lines
      restStr := '';
      while Pos(')', srcLine) = 0 do
      begin
        restStr := Copy(srcLine, Pos('(', srcLine) + 1, Length(srcLine));
        Inc(I);
        srcLine := aSource[I];
      end;
      restStr := restStr + Copy(srcLine, Pos('(', srcLine) + 1, Pos(')', srcLine) - 1 - Pos('(', srcLine));

      Parameters.ParseFromString(restStr, Details);
    end else
    begin
      // Procedure without parameters
      restStr := Copy(srcLine, Pos('.', srcLine) + 1, Pos(';', srcLine) - 1 - Pos('.', srcLine));
      restStr := ReplaceStr(restStr, 'ProcOn', 'On'); // For the KP
      Name := ReplaceStr(restStr, 'Proc', 'On');   // For the KMR
    end;
  end;

  // Format functions
  if StartsStr('function', srcLine) then
  begin
    if Pos('(', srcLine) <> 0 then
    begin
      // Function with parameters
      restStr := Copy(srcLine, Pos('.', srcLine) + 1, Pos('(', srcLine) - 1 - Pos('.', srcLine));
      restStr := ReplaceStr(restStr, 'FuncOn', 'On'); // For the KP
      Name := ReplaceStr(restStr, 'Func', 'On');   // For the KMR

      // Parameters could go for several lines
      restStr := '';
      while Pos(')', srcLine) = 0 do
      begin
        restStr := Copy(srcLine, Pos('(', srcLine) + 1, Length(srcLine));
        Inc(I);
        srcLine := aSource[I];
      end;
      restStr := restStr + Copy(srcLine, Pos('(', srcLine) + 1, Pos(')', srcLine) - 1 - Pos('(', srcLine));

      Parameters.ParseFromString(restStr, Details);
    end else
    begin
      // Function without parameters
      restStr := Copy(srcLine, Pos('.', srcLine) + 1, Pos(':', srcLine) - 1 - Pos('.', srcLine));
      restStr := ReplaceStr(restStr, 'FuncOn', 'On'); // For the KP
      Name := ReplaceStr(restStr, 'Func', 'On');   // For the KMR
    end;

    // Function result
    restStr := StrTrimRightSeparators(StrSubstring(srcLine, StrLastIndexOf(srcLine, ':') + 2));
    Return := TryTypeToAlias(restStr);
  end;

  // Now we can assemble Description, after we have detected and removed parameters descriptions from it
  for I := 0 to Details.Count - 1 do
    // We don't need <br/> after </pre> since </pre> has an automatic visual "br" after it
    if (I > 0) and (RightStr(Details[I-1], 6) = '</pre>') then
      Description := Description + Details[I]
    else
      Description := Description + '<br/>' + Details[I];
end;


destructor TKMMethodInfo.Destroy;
begin
  FreeAndNil(fDetails);
  FreeAndNil(fParameters);

  inherited;
end;


function TKMMethodInfo.GetBody(aNeedReturn: Boolean): string;
const
  UNICODE_RED_CROSS = '&#x274C;';
var
  deprStr: string;
begin
  case Status of
    msDeprecated: begin
                    deprStr := '<br/>' + UNICODE_RED_CROSS + '`Deprecated`<br/>' +
                               '<sub>*Method could be removed in the future game versions';

                    if Replacement <> '' then
                      if Replacement = StringReplace(Replacement, ' ', '', [rfReplaceAll]) then
                        deprStr := deprStr + ', use <a href="#' + Replacement + '">' + Replacement + '</a> instead'
                      else
                        deprStr := deprStr + ', ' + Replacement;

                    deprStr := deprStr + '*</sub>';
                  end;
    msRemoved:    begin
                    deprStr := '<br/>' + UNICODE_RED_CROSS + '`Removed`<br/>' +
                               '<sub>*Method was removed';

                    if Replacement <> '' then
                      if Replacement = StringReplace(Replacement, ' ', '', [rfReplaceAll]) then
                        deprStr := deprStr + ', use <a href="#' + Replacement + '">' + Replacement + '</a> instead'
                      else
                        deprStr := deprStr + ', ' + Replacement;

                    deprStr := deprStr + '*</sub>';
                  end;
  else
    deprStr := '';
  end;

  Result := '| ' + Version + ' | <a id="' + Name + '">' + Name + '</a>' +
              deprStr +
              '<sub>' + Description + '</sub>' +
              ' | <sub>' + Parameters.GetText + '</sub>' +
              IfThen(aNeedReturn, ' | <sub>' + Return + IfThen(ReturnDesc <> '', ' //' + ReturnDesc) + '</sub>') +
              ' |';
end;


function TKMMethodInfo.GetLink: string;
begin
  Result := '* <a href="#' + Name + '">' + Name + '</a>';
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
        Result := CompareText(A.Name, B.Name);
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


function TKMScriptMethods.GetBody: string;
var
  I: Integer;
begin
  Result := '';

  for I := 0 to Count - 1 do
    Result := Result + IfThen(I > 0, sLineBreak) + Items[I].GetBody(AREA_NEED_RETURN[fArea]);
end;


function TKMScriptMethods.GetLinks: string;
var
  I: Integer;
begin
  Result := '';

  for I := 0 to Count - 1 do
    Result := Result + IfThen(I > 0, sLineBreak) + Items[I].GetLink;
end;


procedure TKMScriptMethods.SortByName;
begin
  fList.Sort;
end;


function TKMScriptMethods.ExportWiki(aHeaderFile: string): string;
var
  sl: TStringList;
begin
  sl := TStringList.Create;

  if FileExists(aHeaderFile) then
    sl.LoadFromFile(aHeaderFile);

  sl.Add('');
  sl.Add('***');
  sl.Add('');

  sl.Append(GetLinks);

  sl.Add('<br />');
  sl.Add('');

  if AREA_NEED_RETURN[fArea] then
  begin
    sl.Add('| Ver<br/>sion | ' + AREA_TITLE[fArea] + ' description | Parameters<br/>and types | Returns |');
    sl.Add('| ------- | ------------------------------------ | -------------- | ------- |');
  end else begin
    sl.Add('| Ver<br/>sion | ' + AREA_TITLE[fArea] + ' description | Parameters<br/>and types |');
    sl.Add('| ------- | ------------------------------------ | -------------- |');
  end;

  sl.Append(GetBody);

  Result := sl.Text;

  sl.Free;
end;


end.
