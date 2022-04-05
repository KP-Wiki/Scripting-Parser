unit KM_ScriptingParameters;
interface
uses
  Classes, SysUtils, Types, Generics.Collections,
  StrUtils;

type
  // Single parameter info
  TKMScriptParameter = class
  public
    Name, Modifier, VarType, Desc: string;
    function GetText: string;
  end;

  // List of parameters
  TKMScriptParameters = class
  private
    fList: TObjectList<TKMScriptParameter>;
    function GetCount: Integer;
    function GetItem(aIndex: Integer): TKMScriptParameter;
    procedure SplitArguments(const aArguments: string; aTokenList: TStringList);
    procedure CollectParameters(aTokenList: TStringList; aDescriptions: TStringList);
  public
    constructor Create;
    destructor Destroy; override;

    procedure Append(aName, aModifier, aVarType, aDesc: string);
    property Count: Integer read GetCount;
    property Items[aIndex: Integer]: TKMScriptParameter read GetItem; default;
    function GetText: string;

    procedure ParseFromString(const aArguments: string; aDescriptions: TStringList);
  end;


implementation
uses
  KM_ScriptingConsts;


function StrSubstring(const aStr: string; aFrom: Integer): string;
begin
  Result := Copy(aStr, aFrom + 1, Length(aStr));
end;


procedure StrSplit(const aStr, aDelimiters: string; aStrings: TStringList);
var
  StrArray: TStringDynArray;
  I: Integer;
begin
  StrArray := SplitString(aStr, aDelimiters);
  for I := Low(StrArray) to High(StrArray) do
  if StrArray[I] <> '' then
    aStrings.Add(StrArray[I]);
end;


{ TKMScriptParameter }
function TKMScriptParameter.GetText: string;
begin
  Result := '**' + IfThen(Modifier <> '', Modifier + ' ') + Name + '**: ' + VarType + ';' + IfThen(Desc <> '', ' //_' + Desc + '_');
end;


{ TKMScriptParameters }
constructor TKMScriptParameters.Create;
begin
  inherited;

  fList := TObjectList<TKMScriptParameter>.Create;
end;


destructor TKMScriptParameters.Destroy;
begin
  FreeAndNil(fList);

  inherited;
end;


function TKMScriptParameters.GetItem(aIndex: Integer): TKMScriptParameter;
begin
  Result := fList[aIndex];
end;


function TKMScriptParameters.GetText: string;
var
  I: Integer;
begin
  Result := '';

  for I := 0 to Count - 1 do
    Result := Result + Items[I].GetText + IfThen(I <> Count - 1, ' <br/> ');
end;


procedure TKMScriptParameters.Append(aName, aModifier, aVarType, aDesc: string);
var
  sp: TKMScriptParameter;
begin
  sp := TKMScriptParameter.Create;
  sp.Name := aName;
  sp.Modifier := aModifier;
  sp.VarType := aVarType;
  sp.Desc := aDesc;
  fList.Add(sp);
end;


function TKMScriptParameters.GetCount: Integer;
begin
  Result := fList.Count;
end;


// Take a string of arguments and split it into list of tokens
procedure TKMScriptParameters.SplitArguments(const aArguments: string; aTokenList: TStringList);
var
  I: Integer;
begin
  StrSplit(aArguments, ',:; ', aTokenList);

  // Assemble the "[array] + [of] + [something]"
  // Do it first, cos we can have [array of const]
  for I := aTokenList.Count - 1 downto 0 do
    if SameText(aTokenList[I], 'array') then
    begin
      aTokenList[I] := aTokenList[I] + ' ' + aTokenList[I + 1] + ' ' + aTokenList[I + 2];
      aTokenList.Delete(I + 2);
      aTokenList.Delete(I + 1);
    end;

  // Remove single 'const' modifiers
  for I := aTokenList.Count - 1 downto 0 do
  if SameText(aTokenList[I], 'const') then
    aTokenList.Delete(I);
end;


procedure TKMScriptParameters.CollectParameters(aTokenList: TStringList; aDescriptions: TStringList);
  function FindDescription(const aName: string): string;
  var
    I: Integer;
  begin
    // Find the parameter description (and remove it from source)
    Result := '';
    // Scan in reverse since method descroption can contain the argument names too
    //for I := aDescriptions.Count - 1 downto 0 do
    for I := 0 to aDescriptions.Count - 1 do
      if StartsStr(aName + ':', aDescriptions[I]) then
      begin
        Result := StrSubstring(aDescriptions[I], Pos(':', aDescriptions[I]) + 1);
        aDescriptions.Delete(I);
        Exit;
      end;
  end;
var
  I, K: Integer;
  varModifier, newModifier: string;
  varType, newType: string;
  list: array of record Modifier, &Type: string; end;
  desc: string;
begin
  SetLength(list, aTokenList.Count);

  varModifier := '';
  varType := '';

  // Forward pass to assign modifiers
  for I := 0 to aTokenList.Count - 1 do
  begin
    if TokenIsModifier(aTokenList[I], newModifier) then
      varModifier := newModifier;

    if TokenIsType(aTokenList[I], newType) then
      varModifier := '';

    list[I].Modifier := varModifier;
  end;

  // Backward pass to assign types
  for I := aTokenList.Count - 1 downto 0 do
  begin
    if TokenIsType(aTokenList[I], newType) then
      varType := newType;

    list[I].&Type := varType;
  end;

  // Now we can collect names
  for I := 0 to aTokenList.Count - 1 do
  if not TokenIsModifier(aTokenList[I], newModifier)
  and not TokenIsType(aTokenList[I], newType) then
    Append(aTokenList[I], list[I].Modifier, list[I].&Type, FindDescription(aTokenList[I]));
end;


procedure TKMScriptParameters.ParseFromString(const aArguments: string; aDescriptions: TStringList);
var
  tokenList: TStringList;
begin
  tokenList := TStringList.Create;
  try
    // Split into tokens
    SplitArguments(aArguments, tokenList);

    CollectParameters(tokenList, aDescriptions);
  finally
    FreeAndNil(tokenList);
  end;
end;


end.
