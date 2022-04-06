unit KM_ScriptingCommands;
interface
uses
  Classes, SysUtils, Types, Vcl.Forms, Windows, Generics.Collections, Generics.Defaults,
  StrUtils,
  KM_ScriptingParameters, KM_ScriptingTypes;

type
  TKMCommandStatus = (csOk, csDeprecated, csRemoved);

  // Complete command info
  TKMCommandInfo = class
  private
    fDetails: TStringList; // Command description and parameters comments
    fParameters: TKMScriptParameters; // Parameters parsed from declaration
  public
    Name: string;
    Version: string; // Version in which command was added/changed
    Status: TKMCommandStatus;
    Replacement: string;
    Description: string;
    Return: string; // Result type
    ReturnDesc: string; // Result comment
    constructor Create;
    destructor Destroy; override;
    property Details: TStringList read fDetails;
    property Parameters: TKMScriptParameters read fParameters;
    function GetBody(aNeedReturn: Boolean): string;
    function GetLink: string;
  end;


  // List of commands
  TKMScriptCommands = class
  private
    fArea: TKMParsingArea;
    fList: TObjectList<TKMCommandInfo>;
    procedure Append(aCommand: TKMCommandInfo);
    procedure Clear;
    function GetCount: Integer;
    function GetItem(aIndex: Integer): TKMCommandInfo;
  public
    constructor Create(aArea: TKMParsingArea);
    destructor Destroy; override;

    procedure LoadFromFile(const aInputFile: string);
    property Count: Integer read GetCount;
    property Items[aIndex: Integer]: TKMCommandInfo read GetItem; default;
    procedure SortByName;
    function GetBody: string;
    function GetLinks: string;
    function ExportWiki(aTitle, aHeaderFile: string): string;
  end;


implementation
uses
  KM_ScriptingConsts, KM_StringUtils;


{ TKMCommandInfo }
constructor TKMCommandInfo.Create;
begin
  inherited;

  fDetails := TStringList.Create;
  fParameters := TKMScriptParameters.Create;
end;


destructor TKMCommandInfo.Destroy;
begin
  FreeAndNil(fDetails);
  FreeAndNil(fParameters);

  inherited;
end;


function TKMCommandInfo.GetBody(aNeedReturn: Boolean): string;
const
  UNICODE_RED_CROSS = '&#x274C;';
var
  deprStr: string;
begin
  case Status of
    csDeprecated: begin
                    deprStr := '<br/>' + UNICODE_RED_CROSS + '`Deprecated`<br/>' +
                               '<sub>*Method could be removed in the future game versions';

                    if Replacement <> '' then
                      if Replacement = StringReplace(Replacement, ' ', '', [rfReplaceAll]) then
                        deprStr := deprStr + ', use <a href="#' + Replacement + '">' + Replacement + '</a> instead'
                      else
                        deprStr := deprStr + ', ' + Replacement;

                    deprStr := deprStr + '*</sub>';
                  end;
    csRemoved:    begin
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


function TKMCommandInfo.GetLink: string;
begin
  Result := '* <a href="#' + Name + '">' + Name + '</a>';
end;


{ TKMScriptCommands }
constructor TKMScriptCommands.Create(aArea: TKMParsingArea);
begin
  inherited Create;

  fArea := aArea;

  fList := TObjectList<TKMCommandInfo>.Create(
    TComparer<TKMCommandInfo>.Construct(
      function(const A, B: TKMCommandInfo): Integer
      begin
        // Case-sensitive compare, since we use CamelCase and it looks nicer that way
        Result := CompareText(A.Name, B.Name);
      end));
end;


destructor TKMScriptCommands.Destroy;
begin
  FreeAndNil(fList);

  inherited;
end;


// Scans source contents and puts it all in proper formatting for most wikis.
procedure TKMScriptCommands.LoadFromFile(const aInputFile: string);
var
  slSource: TStringList;
  I, K, iPlus: Integer;
  restStr: string;
  srcLine: string;
  ci: TKMCommandInfo;
  strStatus: string;
begin
  Clear;

  slSource := TStringList.Create;
  try
    slSource.LoadFromFile(aInputFile);

    for i := 0 to slSource.Count - 1 do
    begin
      iPlus := 0;
      srcLine := slSource[i+iPlus];

      //* Version: 1234
      //* Status: -/Deprecated/Removed [optional]
      //* Replacement: Link to the replacement method [optional]
      //* Large description of the method [optional]
      //* aX: Small optional description of parameter
      //* aY: Small optional description of parameter
      //* Result: Small optional description of returned value

      // Before anything it should start with "//* Version:"
      if StartsStr('//* Version:', srcLine) then
      begin
        // Create new command to fill
        ci := TKMCommandInfo.Create;

        restStr := Trim(StrSubstring(srcLine, Pos(':', srcLine) + 1));
        ci.Version := IfThen(restStr = '', '-', restStr);
        Inc(iPlus);
        srcLine := slSource[i+iPlus];

        // Descriptions are only added by lines starting with "//*"
        // Repeat until no description tags are found
        while StartsStr('//*', srcLine) do
        begin
          if StartsStr('//* Status:', srcLine) then
          begin
            strStatus := Trim(StrSubstring(srcLine, Pos(':', srcLine) + 1));
            if StartsStr('Deprecated', strStatus) then
              ci.Status := csDeprecated
            else
            if StartsStr('Removed', strStatus) then
              ci.Status := csRemoved;
          end else
          if StartsStr('//* Replacement:', srcLine) then
            ci.Replacement := Trim(StrSubstring(srcLine, Pos(':', srcLine) + 1))
          else
          // Handle Result description separately to keep the output clean
          if StartsStr('//* Result:', srcLine) then
            ci.ReturnDesc := StrSubstring(srcLine, Pos(':', srcLine) + 1)
          else
            ci.Details.Add(StrSubstring(srcLine, Pos('*', srcLine) + 1));
          Inc(iPlus);
          srcLine := slSource[i+iPlus];
        end;

        // Skip empty or "faulty" lines (e.g. comments not intended for wiki)
        while not StartsStr('procedure', srcLine)
        and not StartsStr('function', srcLine) do
        begin
          Inc(iPlus);
          srcLine := slSource[i+iPlus];
        end;

        // Format procedures
        if StartsStr('procedure', srcLine) then
        begin
          if Pos('(', srcLine) <> 0 then
          begin
            // Procedure with parameters
            restStr := Copy(srcLine, Pos('.', srcLine) + 1, Pos('(', srcLine) - 1 - Pos('.', srcLine));
            restStr := ReplaceStr(restStr, 'ProcOn', 'On'); // For the KP
            ci.Name := ReplaceStr(restStr, 'Proc', 'On');   // For the KMR

            // Parameters could go for several lines
            restStr := '';
            while Pos(')', srcLine) = 0 do
            begin
              restStr := Copy(srcLine, Pos('(', srcLine) + 1, Length(srcLine));
              Inc(iPlus);
              srcLine := slSource[i+iPlus];
            end;
            restStr := restStr + Copy(srcLine, Pos('(', srcLine) + 1, Pos(')', srcLine) - 1 - Pos('(', srcLine));

            ci.Parameters.ParseFromString(restStr, ci.Details);
          end else
          begin
            // Procedure without parameters
            restStr := Copy(srcLine, Pos('.', srcLine) + 1, Pos(';', srcLine) - 1 - Pos('.', srcLine));
            restStr := ReplaceStr(restStr, 'ProcOn', 'On'); // For the KP
            ci.Name := ReplaceStr(restStr, 'Proc', 'On');   // For the KMR
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
            ci.Name := ReplaceStr(restStr, 'Func', 'On');   // For the KMR

            // Parameters could go for several lines
            restStr := '';
            while Pos(')', srcLine) = 0 do
            begin
              restStr := Copy(srcLine, Pos('(', srcLine) + 1, Length(srcLine));
              Inc(iPlus);
              srcLine := slSource[i+iPlus];
            end;
            restStr := restStr + Copy(srcLine, Pos('(', srcLine) + 1, Pos(')', srcLine) - 1 - Pos('(', srcLine));

            ci.Parameters.ParseFromString(restStr, ci.Details);
          end else
          begin
            // Function without parameters
            restStr := Copy(srcLine, Pos('.', srcLine) + 1, Pos(':', srcLine) - 1 - Pos('.', srcLine));
            restStr := ReplaceStr(restStr, 'FuncOn', 'On'); // For the KP
            ci.Name := ReplaceStr(restStr, 'Func', 'On');   // For the KMR
          end;

          // Function result
          restStr := StrTrimRightSeparators(StrSubstring(srcLine, StrLastIndexOf(srcLine, ':') + 2));
          ci.Return := TryTypeToAlias(restStr);
        end;

        // Now we can assemble Description, after we have detected and removed parameters descriptions from it
        for K := 0 to ci.Details.Count - 1 do
          // We don't need <br/> after </pre> since </pre> has an automatic visual "br" after it
          if (K > 0) and (RightStr(ci.Details[K-1], 6) = '</pre>') then
            ci.Description := ci.Description + ci.Details[K]
          else
            ci.Description := ci.Description + '<br/>' + ci.Details[K];

        Append(ci);
      end;
    end;
  finally
    slSource.Free;
  end;
end;


function TKMScriptCommands.GetCount: Integer;
begin
  Result := fList.Count;
end;


function TKMScriptCommands.GetItem(aIndex: Integer): TKMCommandInfo;
begin
  Result := fList[aIndex];
end;


procedure TKMScriptCommands.Append(aCommand: TKMCommandInfo);
begin
  fList.Add(aCommand);
end;


procedure TKMScriptCommands.Clear;
begin
  fList.Clear;
end;


function TKMScriptCommands.GetBody: string;
var
  I: Integer;
begin
  Result := '';

  for I := 0 to Count - 1 do
    Result := Result + IfThen(I > 0, sLineBreak) + Items[I].GetBody(AREA_NEED_RETURN[fArea]);
end;


function TKMScriptCommands.GetLinks: string;
var
  I: Integer;
begin
  Result := '';

  for I := 0 to Count - 1 do
    Result := Result + IfThen(I > 0, sLineBreak) + Items[I].GetLink;
end;


procedure TKMScriptCommands.SortByName;
begin
  fList.Sort;
end;


function TKMScriptCommands.ExportWiki(aTitle, aHeaderFile: string): string;
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
    sl.Add('| Ver<br/>sion | ' + aTitle + ' description | Parameters<br/>and types | Returns |');
    sl.Add('| ------- | ------------------------------------ | -------------- | ------- |');
  end else begin
    sl.Add('| Ver<br/>sion | ' + aTitle + ' description | Parameters<br/>and types |');
    sl.Add('| ------- | ------------------------------------ | -------------- |');
  end;

  sl.Append(GetBody);

  Result := sl.Text;

  sl.Free;
end;


end.
