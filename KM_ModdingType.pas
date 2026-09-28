unit KM_ModdingType;
interface
uses
  System.Classes, System.Generics.Collections;

type
  TKMSortType = (stByAlphabet, stByDependancy);

  TKMModdingType = class;

  // Single type element (
  TKMModdingTypeField = class
  public
    Name: string; // Name of the field
    Typ: string;
    IsRequired: Boolean;
    Default: string;
    Description: string; // Description of the field

    Reference: string; // Reference to sub-type
    ReferenceType: TKMModdingType; // Reference to sub-type

    constructor Create(const aDeclaration, aDescription, aReference: string);
    function GetXmlExample: string;
  end;

  // Single type info
  // E.g. Map Objects or Terrain Decals
  // Documenter > Scripting > Type
  TKMModdingType = class
  private
    fIsRoot: Boolean;
    fTypeName: string;
    fCaption: string;
    fDescription: string;
    fXmlListName: string;
    fXmlNodeName: string;
    fFields: TList<TKMModdingTypeField>;
    function ExportWikiBody_Header: string;
    function ExportWikiBody_XmlExample(const aPad: string): string;
    function ExportWikiBody_Fields: string;
    function HasSubObjects: Boolean;
  public
    constructor Create;
    destructor Destroy; override;

    procedure LoadFromStringList(aSource: TStringList);
    procedure CrossLinkWith(aType: TKMModdingType);

    function ExportWikiBody: string;
    function ExportWikiLink: string;

    property Caption: string read fCaption;
    function IsRoot: Boolean;
    function IsList: Boolean;
    function IsAttribute: Boolean;
  end;


implementation
uses
  System.Math, System.StrUtils, System.SysUtils, System.Types,
  KM_StringUtils,
  KM_DocumenterTypes;


{ TKMModdingTypeField }
constructor TKMModdingTypeField.Create(const aDeclaration, aDescription, aReference: string);
begin
  inherited Create;

  // Input examples:
  // EngName := aNode.Attributes['EngName'].AsString;
  // MinimapColor := TKMColor4f.NewRGBA(aNode.Attributes['MinimapColor'].AsCardinal(0));
  // AllowedHumiditySet := NameToSurfaceHumiditySet(aNode.Attributes['AllowedHumiditySet'].AsString);
  // AllowedHumiditySet := NameToSurfaceHumiditySet(aNode.Attributes['AllowedHumiditySet'].AsString(''));

  // Extract the name used in the XML
  Name := Trim(LeftStrBefore(RightStrAfter(aDeclaration, #39), #39));
  Description := aDescription;
  Reference := aReference;

  if Reference = '' then
  begin
    // Extract type from how it is accessed
    // String
    // Cardinal(0))
    // String)
    // String(''))
    var typeStr := FirstStrBetween(aDeclaration, '.As', ';');

    if ContainsText(typeStr, '(') then
    begin
      // There is a default value
      Typ := LeftStrBefore(typeStr, '(');
      Default := LeftStrBefore(RightStrAfter(typeStr, '('), ')');
    end else
    begin
      // This must be a Required field
      IsRequired := True;

      // Trim last bracket if this field undergoes some extra conversion
      if ContainsText(typeStr, ')') then
        Typ := LeftStrBefore(typeStr, ')')
      else
        Typ := typeStr;
    end;

    // Some strings are actually enums
    if Typ = 'String' then
    begin
      var typeSpec := Pos('.As', aDeclaration);

      var firstBracketSet := Pos('Set(', aDeclaration);
      if (firstBracketSet > 0) and (firstBracketSet < typeSpec) then
        Typ := 'Enum set'
      else
      begin
        var firstBracket := Pos('(', aDeclaration);
        if (firstBracket > 0) and (firstBracket < typeSpec) then
          Typ := 'Enum';
      end;
    end;
  end else
  begin
    // Reference
    Typ := Format('<a href="#%s">%s</a>', [Reference, Reference]);
    Default := '..';
  end;

  // Post-process
  if Default = #39#39 then
    Default := '';
end;


function TKMModdingTypeField.GetXmlExample: string;
begin
  Result := Name + '="value"';
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
  //* Caption: Terrain decal
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

  var descAccumulator := '';
  var fieldReference := '';

  for var I := 0 to aSource.Count - 1 do
  begin
    var srcLine := Trim(aSource[I]);

    if srcLine = '' then
      Continue;

    // Name of the type
    if StartsStr('procedure ', srcLine) then
    begin
      fTypeName := FirstStrBetween(srcLine, 'procedure ', '.');
      Continue;
    end;

    if StartsStr(DOC_TAG_MODDING_IS_ROOT, srcLine) then
    begin
      fIsRoot := True;
      Continue;
    end;

    if StartsStr(DOC_TAG_MODDING_TYPENAME, srcLine) then
    begin
      fTypeName := Trim(RightStrAfter(srcLine, DOC_TAG_MODDING_TYPENAME));
      Continue;
    end;

    if StartsStr(DOC_TAG_MODDING_CAPTION, srcLine) then
    begin
      fCaption := Trim(RightStrAfter(srcLine, DOC_TAG_MODDING_CAPTION));
      Continue;
    end;

    if StartsStr(DOC_TAG_MODDING_DESCRIPTION, srcLine) then
    begin
      //fDescription := fDescription + IfThen(fDescription <> '', '<br/>') + Trim(RightStrAfter(srcLine, DOC_TAG_MODDING_DESCRIPTION));
      fDescription := fDescription + IfThen(fDescription <> '', '  ' + sLineBreak) + Trim(RightStrAfter(srcLine, DOC_TAG_MODDING_DESCRIPTION));
      Continue;
    end;

    if StartsStr(DOC_TAG_MODDING_XML_LIST_NAME, srcLine) then
    begin
      fXmlListName := Trim(RightStrAfter(srcLine, DOC_TAG_MODDING_XML_LIST_NAME));
      Continue;
    end;

    if StartsStr(DOC_TAG_MODDING_XML_NODE_NAME, srcLine) then
    begin
      fXmlNodeName := Trim(RightStrAfter(srcLine, DOC_TAG_MODDING_XML_NODE_NAME));
      Continue;
    end;

    // Reference means we need to lookup some other type description instead for the type
    if StartsStr(DOC_TAG_MODDING_REFERENCE, srcLine) then
    begin
      fieldReference := Trim(RightStrAfter(srcLine, DOC_TAG_MODDING_REFERENCE));
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
      var newField := TKMModdingTypeField.Create(line, descAccumulator, fieldReference);
      fFields.Add(newField);

      descAccumulator := '';
      fieldReference := '';
    end;
  end;
end;


procedure TKMModdingType.CrossLinkWith(aType: TKMModdingType);
begin
  for var I := 0 to fFields.Count - 1 do
    if fFields[I].Reference = aType.fTypeName then
      fFields[I].ReferenceType := aType;
end;


function TKMModdingType.ExportWikiBody: string;
begin
  Result := ExportWikiBody_Header + sLineBreak;

  var xmlText := '';

  if IsRoot then
  begin
    // Root includes xml header for clarity
    xmlText := xmlText + '<?xml version="1.0" encoding="UTF-8"?>' + sLineBreak +
    '<Root>' + sLineBreak;
  end;

  if IsRoot then
    xmlText := xmlText + ExportWikiBody_XmlExample('  ')
  else
    xmlText := xmlText + ExportWikiBody_XmlExample('');

  if IsRoot then
    xmlText := xmlText + '</Root>' + sLineBreak;

  if xmlText <> '' then
    Result := Result +
      'XML layout example:' + sLineBreak +
      '```xml' + sLineBreak +
      xmlText +
      '```' + sLineBreak +
      sLineBreak;

  if fFields.Count > 0 then
    Result := Result + ExportWikiBody_Fields;
end;


function TKMModdingType.ExportWikiBody_Header: string;
begin
  Result := Format('### <a id="%s">%s</a>', [fTypeName, fCaption]) + sLineBreak +
            fDescription + sLineBreak;
end;


function TKMModdingType.ExportWikiBody_XmlExample(const aPad: string): string;
begin
  if fFields.Count = 0 then Exit('');

  var sb := TStringBuilder.Create;

  var usePad := aPad;

//  if IsList then
//    usePad := usePad + '  ';

  // Some types are lists
  if IsList then
  begin
    sb.AppendLine(usePad + '<' + fXmlListName + '>');
    usePad := usePad + '  ';
  end;

  // Attributes
  var attributeString := usePad + '<' + fXmlNodeName;
  for var I := 0 to fFields.Count - 1 do
    if (fFields[I].ReferenceType = nil) or fFields[I].ReferenceType.IsAttribute then
    begin
      var lastEol := FindLastSubStr(attributeString, sLineBreak);
      var lengthSinceEol := Length(attributeString) - lastEol;
      var nameValue := fFields[I].GetXmlExample;

      // Append or start new line
      if lengthSinceEol + Length(nameValue) <= 112 then
        nameValue := ' ' + nameValue
      else
        nameValue := sLineBreak + usePad + nameValue;

      attributeString := attributeString + nameValue;
    end;

  if HasSubObjects then
  begin
    attributeString := attributeString + '>' + sLineBreak;

    // Sub-objects
    for var I := 0 to fFields.Count - 1 do
      if fFields[I].Reference <> '' then
        attributeString := attributeString + fFields[I].ReferenceType.ExportWikiBody_XmlExample(usePad + '  ');

    attributeString := attributeString + usePad + '  </' + fXmlNodeName + '>';
  end else
    if IsRoot then
      attributeString := attributeString + '>' + sLineBreak + usePad + '  </' + fXmlNodeName + '>'
    else
      attributeString := attributeString + '/>';

  sb.AppendLine(attributeString);

  if IsList then
  begin
    sb.AppendLine(aPad + '  ...');
    sb.AppendLine(aPad + '</' + fXmlListName + '>');
  end;

  Result := sb.ToString;

  sb.Free;
end;


function TKMModdingType.ExportWikiBody_Fields: string;
const
  TEMPLATE_HEADER      = '| Attribute name | Type | Required / Default | Description |';
  TEMPLATE_HEADER_LINE = '| -------------- |:----:|:------------------:| ----------- |';
  TEMPLATE = '| %s | %s | %s | %s |';
begin
  Result := TEMPLATE_HEADER + sLineBreak +
            TEMPLATE_HEADER_LINE + sLineBreak;

  for var I := 0 to fFields.Count - 1 do
  begin
    var req := IfThen(fFields[I].IsRequired, '**Required**', '`"' + fFields[I].Default + '"`');

    var desc := fFields[I].Description;

    var fieldType := '';
    if fFields[I].ReferenceType <> nil then
      if fFields[I].ReferenceType.IsAttribute then
        fieldType := ' <sub>[attribute]</sub>'
      else
        fieldType := ' <sub>[object]</sub>'
    else
      fieldType := '';


    Result := Result + Format(TEMPLATE, [fFields[I].Name, fFields[I].Typ + fieldType, req, desc]) + sLineBreak;
  end;
end;


function TKMModdingType.ExportWikiLink: string;
const
  TEMPLATE = '* [%s](#%s)';
begin
  Result := Format(TEMPLATE, [fCaption, fTypeName]);
end;


function TKMModdingType.IsAttribute: Boolean;
begin
  Result := fFields.Count = 0;
end;


function TKMModdingType.IsList: Boolean;
begin
  Result := fXmlListName <>'';
end;


function TKMModdingType.IsRoot: Boolean;
begin
  Result := fIsRoot;
end;


function TKMModdingType.HasSubObjects: Boolean;
begin
  Result := False;

  // Check if any of the fields are referencing any objects
  // Some of the refrences could be for attributes, ignore them
  for var I := 0 to fFields.Count - 1 do
  if (fFields[I].ReferenceType <> nil) and not fFields[I].ReferenceType.IsAttribute then
    Exit(True);
end;


end.
