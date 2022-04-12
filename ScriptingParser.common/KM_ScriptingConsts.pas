unit KM_ScriptingConsts;
interface
uses
  StrUtils, SysUtils;


  function TryTypeToAlias(const aType: string): string;
  function TryTypeToTyp(const aType: string): string;
  function TokenIsModifier(const aToken: string; out aName: string): Boolean;
  function TokenIsType(const aToken: string; out aName: string): Boolean;


implementation


type
  TKMTypeInfo = record
    Name: string;
    Alias: string; // Required for Events
    Typ: string; // Required for Events
  end;

const
  VAR_TYPE_COUNT = 67;

  VAR_MODIFIERS: array[0..1] of string = ('out', 'var');

  //@Rey: We need to specify aliases only for those types that are not exported into Wiki

  VAR_TYPE_INFO: array[0..VAR_TYPE_COUNT-1] of TKMTypeInfo = (
    // Simple types
    (Name: 'Byte'; Typ: 'btS32'),       (Name: 'Shortint'; Typ: 'btS32'),   (Name: 'Smallint'; Typ: 'btS32'),   (Name: 'Word'; Typ: 'btS32'),
    (Name: 'Integer'; Typ: 'btS32'),    (Name: 'Cardinal'),   (Name: 'Single'),     (Name: 'Extended'),
    (Name: 'Boolean'),    (Name: 'AnsiString'), (Name: 'String'),     (Name: 'UnicodeString'),
    (Name: 'array of const'),      (Name: 'array of Boolean'),
    (Name: 'array of String'),     (Name: 'array of AnsiString'),
    (Name: 'array of Integer'),    (Name: 'array of Single'),
    (Name: 'array of Extended'),
    // Custom types
    (Name: 'TKMPoint'), (Name: 'TKMWareType'; Typ: 'btEnum'), (Name: 'TKMFieldType'; Typ: 'btEnum'), (Name: 'TKMUnitType'; Typ: 'btEnum'),
    (Name: 'TByteSet'), (Name: 'TIntegerArray'), (Name: 'TAnsiStringArray'),
    // KMR
    (Name: 'TKMArmyType'), (Name: 'TKMGroupOrder'), (Name: 'TKMHouseType'; Typ: 'btEnum'),
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
    (Name: 'TKMHouseFace'; Typ: 'btEnum'), (Name: 'TKMObjectiveStatus'; Typ: 'btEnum'), (Name: 'TKMObjectiveType'; Typ: 'btEnum'), (Name: 'TKMFenceType'; Typ: 'btEnum'),
    // Werewolf types
    (Name: 'TKMHouse'; Alias: 'Integer'), (Name: 'TKMUnit'; Alias: 'Integer'), (Name: 'TKMUnitGroup'; Alias: 'Integer'),
    // KMR
    (Name: 'TKMHandID'; Alias: 'Integer'), (Name: 'array of TKMHandID'; Alias: 'array of Integer'),
    // KP
    (Name: 'TKMEntity'; Alias: 'Integer'), (Name: 'TKMHandIndex'; Alias: 'Integer'), (Name: 'array of TKMHandIndex'; Alias: 'array of Integer')
  );


// Try to convert a type into alias
function TryTypeToAlias(const aType: string): string;
var
  I: Integer;
begin
  Result := aType;
  for I := 0 to High(VAR_TYPE_INFO) do
    if (VAR_TYPE_INFO[I].Alias <> '') and SameText(VAR_TYPE_INFO[I].Name, aType) then
      Exit(VAR_TYPE_INFO[I].Alias);
end;


function TryTypeToTyp(const aType: string): string;
var
  I: Integer;
begin
  Result := '0';
  for I := 0 to High(VAR_TYPE_INFO) do
    if SameText(VAR_TYPE_INFO[I].Name, aType) then
      Exit(VAR_TYPE_INFO[I].Typ);
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


function TokenIsType(const aToken: string; out aName: string): Boolean;
var
  I: Integer;
begin
  aName := '';
  Result := False;
  for I := 0 to High(VAR_TYPE_INFO) do
    if SameText(VAR_TYPE_INFO[I].Name, aToken) then
    begin
      aName := IfThen(VAR_TYPE_INFO[I].Alias <> '', VAR_TYPE_INFO[I].Alias, VAR_TYPE_INFO[I].Name);
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
