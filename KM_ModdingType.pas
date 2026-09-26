unit KM_ModdingType;
interface
uses
  System.Classes, System.Generics.Collections;

type
  TKMSortType = (stByAlphabet, stByDependancy);

  // Single type element (
  TKMModdingTypeField = class
  strict private
    fName: string; // Name of the field
    fType: string;
    fDefault: string;
    fDesc: string; // Description of the field
  public
    constructor Create(const aDeclaration, aDesc: string);

    property Name: string read fName;
    property Typ: string read fType;
    property Default: string read fDefault;
    property Desc: string read fDesc;
  end;

  // Single type info
  // E.g. Map Objects or Terrain Decals
  // Documenter > Scripting > Type
  TKMModdingType = class
  private
    fName: string;
    fDescription: string;
    fFields: TList<TKMModdingTypeField>;
  public
    SortPriority: Integer;
    constructor Create;
    destructor Destroy; override;
    procedure LoadFromStringList(aSource: TStringList);
    function ExportWikiBody: string;
    function ExportWikiLink: string;

    property Name: string read fName;
  end;


implementation
uses
  System.Math, System.StrUtils, System.SysUtils, System.Types,
  KM_StringUtils,
  KM_DocumenterTypes;


{ TKMModdingTypeField }
constructor TKMModdingTypeField.Create(const aDeclaration, aDesc: string);
begin
  inherited Create;

  // Input examples:
  // EngName := aNode.Attributes['EngName'].AsString;
  // MinimapColor := TKMColor4f.NewRGBA(aNode.Attributes['MinimapColor'].AsCardinal(0));
  // AllowedHumiditySet := NameToSurfaceHumiditySet(aNode.Attributes['AllowedHumiditySet'].AsString);
  // AllowedHumiditySet := NameToSurfaceHumiditySet(aNode.Attributes['AllowedHumiditySet'].AsString(''));

  // Extract the name used in the XML
  fName := Trim(LeftStrBefore(RightStrAfter(aDeclaration, #39), #39));

  // Extract type from how it is accessed
  // String
  // Cardinal(0))
  // String)
  // String(''))
  var typeStr := LeftStrBefore(RightStrAfter(aDeclaration, '.As'), ';');

  if ContainsText(typeStr, '(') then
  begin
    fType := LeftStrBefore(typeStr, '(');
    fDefault := RightStrAfter(typeStr, '(');
  end else
  if ContainsText(typeStr, ')') then
    fType := LeftStrBefore(typeStr, ')')
  else
    fType := typeStr;

  fDesc := aDesc;
end;


{ TKMModdingType }
constructor TKMModdingType.Create;
begin
  inherited;

  fFields := TList<TKMModdingTypeField>.Create;
end;


destructor TKMModdingType.Destroy;
begin
  FreeAndNil(fFields);

  inherited;
end;


procedure TKMModdingType.LoadFromStringList(aSource: TStringList);
begin
  // Typical modding type looks like:
  {
  //* Name: Terrain decal
  //* Commentary on what this type is and etc.

  //* Unique identifier of the decal.
  EngName := aNode.Attributes['EngName'].AsString;

  //* Terrain humidity suitable for this decal (e.g. ore decals can be placed only on rock). Use "" for all.
  AllowedHumiditySet := NameToSurfaceHumiditySet(aNode.Attributes['AllowedHumiditySet'].AsString(''));

  //* Wherever roads and houses can be built on top of this decal.
  IsBuildable := aNode.Attributes['IsBuildable'].AsBoolean;

  //* Color of the decal on the minimap. Use 0 for none.
  MinimapColor := TKMColor4f.NewRGBA(aNode.Attributes['MinimapColor'].AsCardinal(0));

  //* Amount of stone this ore decal contains. Up to 255. Use on your own risk.
  if aNode.HasAttribute('StoneDeposit') then StoneDeposit := aNode.Attributes['StoneDeposit'].AsInteger;

  //* Height of the model for HitTest. Can be set slightly lower than the actual model for better match.
  if Selectable then ModelHeight := aNode.Attributes['ModelHeight'].AsFloat(0.0);

  // Defaults
  HUDAvatarSetup.CameraDistance := 3.8;
  HUDAvatarSetup.CameraHeight := 1.4;
  HUDAvatarSetup.CameraTargetHeight := 0.5;
  HUDAvatarSetup.ModelHeading := 145;

  //* HUD avatar setup. Used in MapEd palettes too.
  if aNode.HasAttribute('AvatarSetup') then
    HUDAvatarSetup := TKMHUDAvatarSetup.NewFromArray6(aNode.Attributes['AvatarSetup'].AsArrayFloat(6));
  }

  var descAccumulator: string;

  for var I := 0 to aSource.Count - 1 do
  begin
    var srcLine := Trim(aSource[I]);

    if srcLine = '' then
      Continue;

    if StartsStr(DOC_TAG_MODDING_NAME, srcLine) then
    begin
      fName := Trim(Copy(srcLine, Length(DOC_TAG_MODDING_NAME) + 1, MaxInt));
      Continue;
    end;

    // Accumulate description until we need it
    if StartsStr(DOC_TAG, srcLine) then
    begin
      descAccumulator := descAccumulator + IfThen(descAccumulator <> '', '<br/>') + RightStrAfter(srcLine, DOC_TAG + ' ');
      Continue;
    end;

    // Skip normal comments
    if StartsStr('//', srcLine) then
      Continue;

    // When we have a description, next code line is the type
    if descAccumulator <> '' then
    begin
      var line := srcLine;
      if ContainsText(line, '//') then
        line := Trim(LeftStrBefore(srcLine, '//'));
      var newField := TKMModdingTypeField.Create(line, descAccumulator);
      fFields.Add(newField);

      descAccumulator := '';
    end;
  end;
end;


function TKMModdingType.ExportWikiBody: string;
const
  TEMPLATE_HEADER      = '| Field name | Field type | Required | Description |';
  TEMPLATE_HEADER_LINE = '| ---------- | ---------- | -------- | ----------- |';
  TEMPLATE = '| %s | %s | %s | %s |';
begin
  Result := Format('### <a id="%s">%s</a>', [fName, fName]) + sLineBreak +
            fDescription + sLineBreak +
            TEMPLATE_HEADER + sLineBreak +
            TEMPLATE_HEADER_LINE + sLineBreak;

  for var I := 0 to fFields.Count - 1 do
    Result := Result + Format(TEMPLATE, [fFields[I].Name, fFields[I].Typ, IfThen(fFields[I].Default = '', 'Required', fFields[I].Default), fFields[I].Desc]) + sLineBreak;
end;


function TKMModdingType.ExportWikiLink: string;
const
  TEMPLATE = '* <a href="#%s">%s</a>';
begin
  Result := Format(TEMPLATE, [fName, fName]);
end;


end.
