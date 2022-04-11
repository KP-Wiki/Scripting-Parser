unit KM_ScriptingParameters;
interface
uses
  Classes, SysUtils, Types, Generics.Collections,
  StrUtils;

type
  // Single parameter info
  TKMScriptParameter = class
  private
    fName: string;
    fModifier: string;
    fVarType: string;
    fDesc: string;
  public
    constructor Create(const aName, aModifier, aVarType, aDesc: string);
    function GetText: string;
    function ExportCodeCheck: string;
  end;

  // List of parameters of a method
  TKMScriptParameters = class
  private
    fList: TObjectList<TKMScriptParameter>;
    procedure SplitArguments(const aArguments: string; aTokenList: TStringList);
    function FindDescription(const aName: string; aDescriptions: TStringList): string;
    procedure CollectParameters(aTokenList: TStringList; aDescriptions: TStringList);
  public
    constructor Create;
    destructor Destroy; override;

    function GetText: string;
    function ExportCodeCheck: string;

    procedure ParseFromString(const aArguments: string; aDescriptions: TStringList);
  end;


implementation
uses
  KM_ScriptingConsts, KM_StringUtils;


{ TKMScriptParameter }
constructor TKMScriptParameter.Create(const aName, aModifier, aVarType, aDesc: string);
begin
  inherited Create;

  fName := aName;
  fModifier := aModifier;
  fVarType := aVarType;
  fDesc := aDesc;
end;


function TKMScriptParameter.ExportCodeCheck: string;
begin
  Result := IfThen(fModifier <> '', fModifier + ' ') + fName + ': ' + fVarType;
end;


function TKMScriptParameter.GetText: string;
begin
  Result := '**' + IfThen(fModifier <> '', fModifier + ' ') + fName + '**: ' + fVarType + ';' + IfThen(fDesc <> '', ' // _' + fDesc + '_');
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


function TKMScriptParameters.GetText: string;
var
  I: Integer;
begin
  Result := '';

  for I := 0 to fList.Count - 1 do
    Result := Result + fList[I].GetText + IfThen(I <> fList.Count - 1, ' <br/> ');
end;


function TKMScriptParameters.ExportCodeCheck: string;
var
  I: Integer;
begin
  Result := '';

  for I := 0 to fList.Count - 1 do
    Result := Result + IfThen(I = 0, '(') + fList[I].ExportCodeCheck + IfThen(I <> fList.Count - 1, '; ', ')');
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


function TKMScriptParameters.FindDescription(const aName: string; aDescriptions: TStringList): string;
var
  I: Integer;
begin
  // Find the parameter description (and remove it from source)
  Result := '';
  // Parameter names are identified by the [Name:]
  for I := 0 to aDescriptions.Count - 1 do
    if StartsStr(aName + ':', aDescriptions[I]) then
    begin
      Result := StrSubstring(aDescriptions[I], Pos(':', aDescriptions[I]) + 1);
      aDescriptions.Delete(I);
      Exit;
    end;
end;


procedure TKMScriptParameters.CollectParameters(aTokenList: TStringList; aDescriptions: TStringList);
var
  I: Integer;
  varModifier, newModifier: string;
  varType, newType: string;
  list: array of record Modifier, &Type: string; end;
begin
  SetLength(list, aTokenList.Count);

  varModifier := '';
  varType := '';

  // Forward pass to assign modifiers (modifier applies to all vars until type is met)
  for I := 0 to aTokenList.Count - 1 do
  begin
    if TokenIsModifier(aTokenList[I], newModifier) then
      varModifier := newModifier;

    if TokenIsType(aTokenList[I], newType) then
      varModifier := '';

    list[I].Modifier := varModifier;
  end;

  // Backward pass to assign types (type applies to all vars until new type is met)
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
    fList.Add(TKMScriptParameter.Create(aTokenList[I], list[I].Modifier, list[I].&Type, FindDescription(aTokenList[I], aDescriptions)));

  // Adjoin X and Y pairs wherever possible
  for I := fList.Count - 1 downto 1 do
  if ((fList[I].fName = 'Y') and (fList[I-1].fName = 'X')
  or (fList[I].fName = 'aY') and (fList[I-1].fName = 'aX'))
  and (fList[I].fDesc = fList[I-1].fDesc) then
  begin
    fList[I-1].fName := fList[I-1].fName + ', ' + fList[I].fName;
    fList.Delete(I);
  end;
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
