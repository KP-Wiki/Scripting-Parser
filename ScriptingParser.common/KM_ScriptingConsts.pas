unit KM_ScriptingConsts;
interface
uses
  StrUtils, SysUtils;


  function TryEventTypeToAlias(const aType: string): string;
  function TryEventTypeToTyp(const aType: string): string;
  function TokenIsModifier(const aToken: string; out aName: string): Boolean;
  function TokenIsType(const aToken: string; out aName: string): Boolean;


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

  TKMTypeInfo = record
    Name: string;
  end;

const
  VAR_MODIFIERS: array [0..1] of string = ('out', 'var');

  //@Rey: We need to specify aliases only for those types that are not exported into Wiki

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
    (Name: 'TKMHouse'; Alias: 'Integer'), (Name: 'TKMUnit'; Alias: 'Integer'), (Name: 'TKMUnitGroup'; Alias: 'Integer'),
    // KMR
    (Name: 'TKMHandID'; Alias: 'Integer'), (Name: 'array of TKMHandID'; Alias: 'array of Integer'),
    // KP
    (Name: 'TKMEntity'; Alias: 'Integer'), (Name: 'TKMHandIndex'; Alias: 'Integer'), (Name: 'array of TKMHandIndex'; Alias: 'array of Integer')
  );

  // Known types
  VAR_TYPE_INFO: array [0..58] of TKMTypeInfo = (
    // Simple types
    (Name: 'Byte'),    (Name: 'Shortint'),   (Name: 'Smallint'), (Name: 'Word'),
    (Name: 'Integer'), (Name: 'Cardinal'),   (Name: 'Single'),   (Name: 'Extended'),
    (Name: 'Boolean'), (Name: 'AnsiString'), (Name: 'String'),   (Name: 'UnicodeString'),
    (Name: 'array of const'),         (Name: 'array of Boolean'),
    (Name: 'array of String'),        (Name: 'array of AnsiString'),
    (Name: 'array of Integer'),       (Name: 'array of Single'),
    (Name: 'array of Extended'),
    // Custom types
    (Name: 'TKMPoint'), (Name: 'TKMWareType'), (Name: 'TKMFieldType'), (Name: 'TKMUnitType'),
    (Name: 'TByteSet'), (Name: 'TIntegerArray'), (Name: 'TAnsiStringArray'),
    // KMR
    (Name: 'TKMArmyType'), (Name: 'TKMGroupOrder'), (Name: 'TKMHouseType'),
    (Name: 'TKMTerrainTileBrief'), (Name: 'TKMMissionDifficulty'), (Name: 'TKMMissionDifficultySet'),
    (Name: 'array of TKMTerrainTileBrief'), (Name: 'TKMAudioFormat'), (Name: 'TKMAIAttackTarget'),
    (Name: 'TKMTerrainKind'), (Name: 'TKMTileMaskKind'), (Name: 'TKMTileOverlay'),
    (Name: 'TKMGroupType'), (Name: 'TKMGroupTypeSet'), (Name: 'TKMDirection'), (Name: 'TKMDeliveryMode'),
    (Name: 'TKMWoodcutterMode'), (Name: 'TKMHandHouseLock'), (Name: 'TKMTerrainPassability'),
    (Name: 'TKMAIDefencePosType'), (Name: 'TKMAIAttackType'), (Name: 'TKMAIRepairMode'),
    (Name: 'TKMAIAttackInfo'), (Name: 'TKMDefencePositionInfo'), (Name: 'TKMHouseTypeSet'),
    (Name: 'TKMUnitTypeSet'), (Name: 'TKMWareTypeSet'), (Name: 'TReplaceFlags'),
    (Name: 'TKMFont'),
    // KP
    (Name: 'TKMHouseFace'), (Name: 'TKMObjectiveStatus'), (Name: 'TKMObjectiveType'), (Name: 'TKMFenceType')
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


function TokenIsModifier(const aToken: string; out aName: string): Boolean;
var
  I: Integer;
begin
  aName := '';
  Result := False;
  for I := 0 to High(VAR_MODIFIERS) do
    if SameText(VAR_MODIFIERS[I], aToken) then
    begin
      aName := VAR_MODIFIERS[I];
      Exit(True);
    end;
end;


// Broad check to see if the token is a type
function TokenIsType(const aToken: string; out aName: string): Boolean;
var
  I: Integer;
begin
  aName := '';
  Result := False;
  for I := 0 to High(VAR_TYPE_INFO) do
    if SameText(VAR_TYPE_INFO[I].Name, aToken) then
    begin
      aName := VAR_TYPE_INFO[I].Name;
      Exit(True);
    end;

  aName := '';
  Result := False;
  for I := 0 to High(VAR_ALIASES_FOR_EVENTS) do
    if SameText(VAR_ALIASES_FOR_EVENTS[I].Name, aToken) then
    begin
      aName := VAR_ALIASES_FOR_EVENTS[I].Name;
      Exit(True);
    end;

  // Rarely there can be an "array of TKMSomeListedType"
  // Despite the type being listed in the VAR_TYPE_INFO, "array of " may be not
  // But we are certain, it is a Type
  if StartsStr('array of T', aToken) then
  begin
    aName := aToken;
    Exit(True);
  end;
end;


end.
