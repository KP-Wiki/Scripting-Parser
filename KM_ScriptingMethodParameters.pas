unit KM_ScriptingMethodParameters;
interface
uses
  System.Classes, System.SysUtils, System.Types, System.Generics.Collections,
  System.StrUtils;

type
  // Single parameter(argument) info
  TKMScriptingMethodParameter = class
  private
    fName: string;
    fModifier: string;
    fVarType: string;
    fDesc: string;
  public
    constructor Create(const aName, aModifier, aVarType, aDesc: string);
    property Modifier: string read fModifier;
    property VarType: string read fVarType;
    function ExportWikiBody: string;
    function ExportCodeSignature: string;
  end;

  // List of parameters(arguments) of a method
  TKMScriptingMethodParameters = class
  private
    fList: TObjectList<TKMScriptingMethodParameter>;
    procedure SplitIntoTokens(const aArguments: string; aTokenList: TStringList);
    function FindDescription(const aName: string; aDescriptions: TStringList): string;
    procedure CollectParameters(aTokenList: TStringList; aDescriptions: TStringList);
    function GetCount: Integer;
    function GetParameter(aIndex: Integer): TKMScriptingMethodParameter;
  public
    constructor Create;
    destructor Destroy; override;

    property Count: Integer read GetCount;
    property Parameters[aIndex: Integer]: TKMScriptingMethodParameter read GetParameter; default;
    function ExportWikiBody: string;
    function ExportCodeSignature: string;
    procedure AdjoinPairs;
    procedure DowngradeTypes;

    procedure ParseFromString(const aArguments: string; aDescriptions: TStringList);
  end;


implementation
uses
  KM_ScriptingMethodConsts, KM_StringUtils;


{ TKMScriptingMethodParameter }
constructor TKMScriptingMethodParameter.Create(const aName, aModifier, aVarType, aDesc: string);
begin
  inherited Create;

  fName := aName;
  fModifier := aModifier;
  fVarType := aVarType;
  fDesc := aDesc;
end;


function TKMScriptingMethodParameter.ExportCodeSignature: string;
begin
  Result := IfThen(fModifier <> '', fModifier + ' ') + fName + ': ' + fVarType;
end;


function TKMScriptingMethodParameter.ExportWikiBody: string;
const
  TEMPLATE = '**%s%s**: %s;%s';
begin
  //todo -cPractical: add link instead of text when our custom script type is mentioned
  Result := Format(TEMPLATE, [IfThen(fModifier <> '', fModifier + ' '), fName, fVarType, IfThen(fDesc <> '', ' // _' + fDesc + '_')]);
end;


{ TKMScriptingMethodParameters }
constructor TKMScriptingMethodParameters.Create;
begin
  inherited;

  fList := TObjectList<TKMScriptingMethodParameter>.Create;
end;


destructor TKMScriptingMethodParameters.Destroy;
begin
  FreeAndNil(fList);

  inherited;
end;


function TKMScriptingMethodParameters.GetCount: Integer;
begin
  Result := fList.Count;
end;


function TKMScriptingMethodParameters.GetParameter(aIndex: Integer): TKMScriptingMethodParameter;
begin
  Result := fList[aIndex];
end;


function TKMScriptingMethodParameters.ExportWikiBody: string;
var
  I: Integer;
begin
  Result := '';

  for I := 0 to fList.Count - 1 do
    Result := Result + fList[I].ExportWikiBody + IfThen(I <> fList.Count - 1, ' <br/> ');
end;


// Method signature for the "RegisterMethodCheck(c, '...');" in PS engine
function TKMScriptingMethodParameters.ExportCodeSignature: string;
const
  ROUGH_LINE_LIMIT = 60;
var
  I: Integer;
  line: Integer;
begin
  Result := '';

  line := 0;
  for I := 0 to fList.Count - 1 do
  begin
    Result := Result + IfThen(I = 0, '(') + fList[I].ExportCodeSignature + IfThen(I <> fList.Count - 1, '; ', ')');
    Inc(line, Length(fList[I].ExportCodeSignature));

    if (I <> fList.Count - 1) and (line > ROUGH_LINE_LIMIT) then
    begin
      Result := Result + #39' +' + sLineBreak + '      '#39;
      line := 0;
    end;
  end;
end;


// Take a string of arguments and split it into list of tokens
procedure TKMScriptingMethodParameters.SplitIntoTokens(const aArguments: string; aTokenList: TStringList);
var
  I: Integer;
  args: string;
begin
  args := ReplaceStr(aArguments, ',', ' , ');
  args := ReplaceStr(args, ':', ' : ');
  args := ReplaceStr(args, ';', ' ; ');
  StrSplit(args, ' ', aTokenList);

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


function TKMScriptingMethodParameters.FindDescription(const aName: string; aDescriptions: TStringList): string;
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


procedure TKMScriptingMethodParameters.CollectParameters(aTokenList: TStringList; aDescriptions: TStringList);
var
  I: Integer;
  varModifier, varType: string;
  list: array of record Modifier, Name, &Type: string; end;
begin
  SetLength(list, aTokenList.Count);

  varModifier := '';
  varType := '';

  // Forward pass to assign modifiers (modifier applies to all vars until ":")
  for I := 1 to aTokenList.Count - 1 do
  begin
    if TokenIsModifier(aTokenList[I-1]) then
      varModifier := FixModifierCase(aTokenList[I-1]);

    if aTokenList[I] = ':' then
      varModifier := '';

    list[I].Modifier := varModifier;
  end;

  // Backward pass to assign types (type applies to all vars until ";")
  for I := aTokenList.Count - 1 downto 0 do
  begin
    if (I < aTokenList.Count - 1)and (aTokenList[I+1] = ':') then
      varType := FixTypeCase(aTokenList[I+2]);

    if (aTokenList[I] = ';')
    or TokenIsModifier(aTokenList[I]) then
      varType := '';

    list[I].&Type := varType;
  end;

  // Now we can collect names (separate step to simplify the debug process)
  for I := 0 to aTokenList.Count - 1 do
  if (aTokenList[I] <> ',')
  and (list[I].&Type <> '') then
    list[I].Name := aTokenList[I];

  // Finally add to the list
  for I := 0 to aTokenList.Count - 1 do
  if (list[I].Name <> '') then
    fList.Add(TKMScriptingMethodParameter.Create(list[I].Name, list[I].Modifier, list[I].&Type, FindDescription(aTokenList[I], aDescriptions)));
end;


// Adjoin pairs wherever possible
procedure TKMScriptingMethodParameters.AdjoinPairs;
var
  I: Integer;
begin
  for I := fList.Count - 1 downto 1 do
    if ((fList[I].fName = 'Y') and (fList[I-1].fName = 'X')
    or (fList[I].fName = 'aY') and (fList[I-1].fName = 'aX')
    or (fList[I].fName = 'B') and (fList[I-1].fName = 'A')
    or (fList[I].fName = 'aMax') and (fList[I-1].fName = 'aMin'))
    and (fList[I].fDesc = fList[I-1].fDesc) then
    begin
      fList[I-1].fName := fList[I-1].fName + ', ' + fList[I].fName;
      fList.Delete(I);
    end;
end;


procedure TKMScriptingMethodParameters.DowngradeTypes;
var
  I: Integer;
begin
  for I := 0 to fList.Count - 1 do
    fList[I].fVarType := TryEventTypeToAlias(fList[I].fVarType);
end;


procedure TKMScriptingMethodParameters.ParseFromString(const aArguments: string; aDescriptions: TStringList);
var
  tokenList: TStringList;
begin
  tokenList := TStringList.Create;
  try
    SplitIntoTokens(aArguments, tokenList);

    CollectParameters(tokenList, aDescriptions);
  finally
    FreeAndNil(tokenList);
  end;
end;


end.
