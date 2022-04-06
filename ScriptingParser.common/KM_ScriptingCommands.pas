unit KM_ScriptingCommands;
interface
uses
  Classes, SysUtils, Types, Vcl.Forms, Windows, Generics.Collections, Generics.Defaults,
  StrUtils,
  KM_ScriptingParameters;

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
  end;


  // List of commands
  TKMScriptCommands = class
  private
    fList: TObjectList<TKMCommandInfo>;
    function GetCount: Integer;
    function GetItem(aIndex: Integer): TKMCommandInfo;
  public
    constructor Create;
    destructor Destroy; override;

    procedure Append(aCommand: TKMCommandInfo);
    procedure Clear;
    property Count: Integer read GetCount;
    property Items[aIndex: Integer]: TKMCommandInfo read GetItem; default;
    procedure SortByName;
    function GetText: string;
  end;


implementation
uses
  KM_ScriptingConsts;


// string functions
// These function are replacements for string functions introduced after XE2 (XE5 probably)
// Names are the same as in new Delphi versions, but with 'Str' prefix
// We keep them here to support pre-XE5 compilation
function StrSubstring(const aStr: string; aFrom: Integer): string;
begin
  Result := Copy(aStr, aFrom + 1, Length(aStr));
end;


function StrLastIndexOf(const aStr, aSubStr: string): Integer;
var
  I: Integer;
begin
  Result := -1;
  for I := 1 to Length(aStr) do
    if AnsiPos(aSubStr, StrSubstring(aStr, I-1)) <> 0 then
      Result := I - 1;
end;


function StrTrimRightSeparators(const aStr: string): string;
var
  I, K: Integer;
begin
  K := 0;
  for I := Length(aStr) downto 1 do
  if not (aStr[I] in [',', ':', ';']) then
  begin
    K := I;
    Break;
  end;
  Result := Copy(aStr, 1, K);
end;



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



{ TKMScriptCommands }
constructor TKMScriptCommands.Create;
begin
  inherited;

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


function TKMScriptCommands.GetText: string;
var
  I: Integer;
begin
  Result := '';

  {for I := 0 to Count - 1 do
    Result := Result + Items[I].GetText + IfThen(I <> Count - 1, ' <br/> '); }
end;


procedure TKMScriptCommands.SortByName;
begin
  fList.Sort;
end;


end.
