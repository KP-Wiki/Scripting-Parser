unit KM_ScriptingConsts;
interface
uses
  StrUtils, SysUtils;


  function TryEventTypeToAlias(const aType: string): string;
  function TryEventTypeToTyp(const aType: string): string;
  function TokenIsModifier(const aToken: string): Boolean;
  function FixModifierCase(const aModifier: string): string;
  function FixTypeCase(const aType: string): string;


implementation


type
  TKMEventTypesInfo = record
    Name: string;
    Typ: string; // Required for Events
  end;

  TKMEventAliasInfo = record
    Name: string;
    Alias: string; // Required for Events
  end;

const
  VAR_MODIFIERS: array [0..1] of string = ('out', 'var');

  // PascalScript types of event variable types
  VAR_TYPES_FOR_EVENTS: array [0..14] of TKMEventTypesInfo = (
    (Name: 'Byte';          Typ: 'btS32'),
    (Name: 'Shortint';      Typ: 'btS32'),
    (Name: 'Smallint';      Typ: 'btS32'),
    (Name: 'Word';          Typ: 'btS32'),
    (Name: 'Integer';       Typ: 'btS32'),
    (Name: 'Cardinal';      Typ: 'btS32'),
    (Name: 'Boolean';       Typ: 'btEnum'),
    (Name: 'TKMWareType';   Typ: 'btEnum'),
    (Name: 'TKMFieldType';  Typ: 'btEnum'),
    (Name: 'TKMUnitType';   Typ: 'btEnum'),
    (Name: 'TKMHouseType';  Typ: 'btEnum'),

    // KP
    (Name: 'TKMHouseFace';        Typ: 'btEnum'),
    (Name: 'TKMObjectiveStatus';  Typ: 'btEnum'),
    (Name: 'TKMObjectiveType';    Typ: 'btEnum'),
    (Name: 'TKMFenceType';        Typ: 'btEnum')
  );

  // Aliases for Event variable types
  VAR_ALIASES_FOR_EVENTS: array [0..7] of TKMEventAliasInfo = (
    // Common
    (Name: 'TKMHouse'; Alias: 'Integer'),
    (Name: 'TKMUnit'; Alias: 'Integer'),
    (Name: 'TKMUnitGroup'; Alias: 'Integer'),
    // KMR
    (Name: 'TKMHandID'; Alias: 'Integer'),
    (Name: 'array of TKMHandID'; Alias: 'array of Integer'),
    // KP
    (Name: 'TKMEntity'; Alias: 'Integer'),
    (Name: 'TKMHandIndex'; Alias: 'Integer'),
    (Name: 'array of TKMHandIndex'; Alias: 'array of Integer')
  );


// Try to convert a type into alias
function TryEventTypeToAlias(const aType: string): string;
var
  I: Integer;
begin
  Result := aType;
  for I := 0 to High(VAR_ALIASES_FOR_EVENTS) do
    if SameText(VAR_ALIASES_FOR_EVENTS[I].Name, aType) then
      Exit(VAR_ALIASES_FOR_EVENTS[I].Alias);

  //Assert(False, Format('Type "%s" not found', [aType]));
end;


// Figure out types type for PascalScript
function TryEventTypeToTyp(const aType: string): string;
var
  I: Integer;
begin
  Result := '0';
  for I := 0 to High(VAR_TYPES_FOR_EVENTS) do
    if SameText(VAR_TYPES_FOR_EVENTS[I].Name, aType) then
      Exit(VAR_TYPES_FOR_EVENTS[I].Typ);

  Assert(False, Format('Type "%s" not found', [aType]));
end;


function TokenIsModifier(const aToken: string): Boolean;
var
  I: Integer;
begin
  Result := False;
  for I := 0 to High(VAR_MODIFIERS) do
    if SameText(VAR_MODIFIERS[I], aToken) then
      Exit(True);
end;


function FixModifierCase(const aModifier: string): string;
var
  I: Integer;
begin
  Result := aModifier;
  for I := 0 to High(VAR_MODIFIERS) do
    if SameText(VAR_MODIFIERS[I], aModifier) then
      Exit(VAR_MODIFIERS[I]);
end;


function FixTypeCase(const aType: string): string;
begin
  if aType = 'Shortint' then
    Result := 'ShortInt'
  else
  if aType = 'String' then
    Result := 'string'
  else
    Result := aType;
end;


end.
