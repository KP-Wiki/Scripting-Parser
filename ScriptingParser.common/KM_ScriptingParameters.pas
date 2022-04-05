unit KM_ScriptingParameters;
interface
uses
  Classes, SysUtils, Types, Generics.Collections,
  StrUtils;

type
  // Single parameter info
  TKMScriptParameter = record
  public
    Name, VarType, Desc: string;
    function GetText: string;
  end;

  // List of parameters
  TKMScriptParameters = class
  private
    fList: TList<TKMScriptParameter>;
    function GetCount: Integer;
    function GetItem(aIndex: Integer): TKMScriptParameter;
  public
    constructor Create;
    destructor Destroy; override;

    procedure Append(aName, aVarType, aDesc: string);
    property Count: Integer read GetCount;
    property Items[aIndex: Integer]: TKMScriptParameter read GetItem; default;
    function GetText: string;
  end;


implementation


{ TKMScriptParameter }
function TKMScriptParameter.GetText: string;
begin
  Result := '**' + Name + '**: ' + VarType + ';' + IfThen(Desc <> '', ' //_' + Desc + '_');
end;


{ TKMScriptParameters }
constructor TKMScriptParameters.Create;
begin
  inherited;

  fList := TList<TKMScriptParameter>.Create;
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

  for I := Count - 1 downto 0 do
    Result := Result + Items[I].GetText + IfThen(I <> 0, ' <br/> ');
end;


procedure TKMScriptParameters.Append(aName, aVarType, aDesc: string);
var
  sp: TKMScriptParameter;
begin
  sp.Name := aName;
  sp.VarType := aVarType;
  sp.Desc := aDesc;
  fList.Add(sp);
end;


function TKMScriptParameters.GetCount: Integer;
begin
  Result := fList.Count;
end;


end.
