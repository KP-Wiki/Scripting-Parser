unit KM_ScriptingConsts;
interface
uses
  StrUtils, SysUtils;


  function TryEventTypeToAlias(const aType: string): string;
  function TryEventTypeToTyp(const aType: string): string;
  function TryEventModifierToDir(const aModifier: string): string;
  function TokenIsModifier(const aToken: string): Boolean;
  function FixModifierCase(const aModifier: string): string;
  function FixTypeCase(const aType: string): string;


implementation


type
  TKMEventTypesInfo = record
    TypeName: string;
    PSBaseType: string; // Required for Events
  end;

  TKMEventAliasInfo = record
    TypeName: string;
    Alias: string; // Required for Events
  end;

const
  VAR_MODIFIERS: array [0..1] of string = ('out', 'var');

  // PascalScript types of event variable types
  VAR_TYPES_FOR_EVENTS: array [0..15] of TKMEventTypesInfo = (
    (TypeName: 'Byte';          PSBaseType: 'btS32'),
    (TypeName: 'ShortInt';      PSBaseType: 'btS32'),
    (TypeName: 'SmallInt';      PSBaseType: 'btS32'),
    (TypeName: 'Word';          PSBaseType: 'btS32'),
    (TypeName: 'Integer';       PSBaseType: 'btS32'),
    (TypeName: 'Cardinal';      PSBaseType: 'btS32'),
    (TypeName: 'Boolean';       PSBaseType: 'btEnum'),
    (TypeName: 'Single';        PSBaseType: 'btSingle'),
    // Common
    (TypeName: 'TKMFieldType';  PSBaseType: 'btEnum'),
    (TypeName: 'TKMHouseType';  PSBaseType: 'btEnum'),
    (TypeName: 'TKMUnitType';   PSBaseType: 'btEnum'),
    (TypeName: 'TKMWareType';   PSBaseType: 'btEnum'),
    // KP
    (TypeName: 'TKMHouseFace';        PSBaseType: 'btEnum'),
    (TypeName: 'TKMObjectiveStatus';  PSBaseType: 'btEnum'),
    (TypeName: 'TKMObjectiveType';    PSBaseType: 'btEnum'),
    (TypeName: 'TKMFenceType';        PSBaseType: 'btEnum')
  );

  // Aliases for Event variable types
  VAR_ALIASES_FOR_EVENTS: array [0..7] of TKMEventAliasInfo = (
    // Common
    (TypeName: 'TKMHouse'; Alias: 'Integer'),
    (TypeName: 'TKMUnit'; Alias: 'Integer'),
    (TypeName: 'TKMUnitGroup'; Alias: 'Integer'),
    // KMR
    (TypeName: 'TKMHandID'; Alias: 'Integer'),
    (TypeName: 'array of TKMHandID'; Alias: 'array of Integer'),
    // KP
    (TypeName: 'TKMEntity'; Alias: 'Integer'),
    (TypeName: 'TKMHandIndex'; Alias: 'Integer'),
    (TypeName: 'array of TKMHandIndex'; Alias: 'array of Integer')
  );


// Try to convert a type into alias
function TryEventTypeToAlias(const aType: string): string;
var
  I: Integer;
begin
  Result := aType;
  for I := 0 to High(VAR_ALIASES_FOR_EVENTS) do
    if SameText(VAR_ALIASES_FOR_EVENTS[I].TypeName, aType) then
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
    if SameText(VAR_TYPES_FOR_EVENTS[I].TypeName, aType) then
      Exit(VAR_TYPES_FOR_EVENTS[I].PSBaseType);

  Assert(False, Format('Type "%s" not found', [aType]));
end;


function TryEventModifierToDir(const aModifier: string): string;
begin
  if aModifier = '' then
    Result := 'pmIn'
  else
  if aModifier = 'var' then
    Result := 'pmInOut'
  else
  if aModifier = 'out' then
    Result := 'pmOut'
  else
  Assert(False, Format('Modifier "%s" not found', [aModifier]));
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
