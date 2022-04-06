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
    NeedReturn: Boolean; // We dont need returns for Events
    Return: string; // Result type
    ReturnDesc: string; // Result comment
    constructor Create;
    destructor Destroy; override;
    property Details: TStringList read fDetails;
    property Parameters: TKMScriptParameters read fParameters;
    function GetBody: string;
    function GetLink: string;
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
    function GetBody: string;
    function GetLinks: string;
  end;


implementation
uses
  KM_ScriptingConsts;


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


function TKMCommandInfo.GetBody: string;
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
              IfThen(NeedReturn, ' | <sub>' + Return + IfThen(ReturnDesc <> '', ' //' + ReturnDesc) + '</sub>') +
              ' |';
end;


function TKMCommandInfo.GetLink: string;
begin
  Result := '* <a href="#' + Name + '">' + Name + '</a>';
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


function TKMScriptCommands.GetBody: string;
var
  I: Integer;
begin
  Result := '';

  for I := 0 to Count - 1 do
    Result := Result + IfThen(I > 0, sLineBreak) + Items[I].GetBody;
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


end.
