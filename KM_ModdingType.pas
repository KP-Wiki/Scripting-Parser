unit KM_ModdingType;
interface
uses
  System.Classes, System.Generics.Collections,
  KM_DocumenterTypes;

type
  TKMSortType = (stByAlphabet, stByDependancy);

  TKMModdingType = class;

  // Single field of a type
  TKMModdingField = class
  public
    FieldName: string;
    FieldType: string;
    IsRequired: Boolean;
    Default: string;
    Description: string; // Description of the field

    constructor Create(const aDeclaration, aDescription: string);
    procedure CrossLinkWith(aType: TKMModdingType); virtual;
    function GetXmlExample: string; virtual;
    function GetTableType: string; virtual;
    function IsReference: Boolean; virtual;
    function IsSubObject: Boolean; virtual;
  end;

  // Field that is an object (and has a reference to that object type)
  TKMModdingField_Reference = class(TKMModdingField)
  public
    ReferenceStr: string; // Reference to sub-type
    ReferenceType: TKMModdingType; // Reference to sub-type

    constructor Create(const aDeclaration, aDescription, aReferenceStr: string);
    procedure CrossLinkWith(aType: TKMModdingType); override;
    function GetXmlExample: string; override;
    function GetTableType: string; override;
    function IsReference: Boolean; override;
    function IsSubObject: Boolean; override;
  end;

//todo: Enums, Enum sets
  // Single type info
  // E.g. Map Objects or Terrain Decals
  // Documenter > Scripting > Type
  TKMModdingType = class
  private
    fIsRoot: Boolean;
    fTypeName: string;
    fTypeSpecialty: TKMModdingTypeSpecialty;
    fCaption: string;
    fDescription: string;

    // Special data for specialities
    // mtsListOfType
    fXmlListName: string;
    fXmlNodeName: string;

    fFields: TList<TKMModdingField>;
    function ExportWikiBody_Header: string;
    function ExportWikiBody_XmlExample(const aPad: string): string;
    function ExportWikiBody_Fields: string;
    function HasSubObjects: Boolean;
  public
    constructor Create;
    destructor Destroy; override;

    procedure LoadFromStringList(aSource: TStringList);
    procedure CrossLinkWith(aType: TKMModdingType);
    procedure SortFieldsByType;

    function ExportWikiBody: string;
    function ExportWikiLink: string;

    property Caption: string read fCaption;
    function IsRoot: Boolean;
    function IsList: Boolean;
  end;

  TKMModdingFactory = class
  public
    class function NewTypeFromStringList(aSource: TStringList): TKMModdingType;
  end;


implementation
uses
  System.Math, System.StrUtils, System.SysUtils, System.Types,
  KM_StringUtils;


{ TKMModdingField }
constructor TKMModdingField.Create(const aDeclaration, aDescription: string);
begin
  inherited Create;

  // Input examples:
  // EngName := aNode.Attributes['EngName'].AsString;
  // MinimapColor := TKMColor4f.NewRGBA(aNode.Attributes['MinimapColor'].AsCardinal(0));
  // AllowedHumiditySet := NameToSurfaceHumiditySet(aNode.Attributes['AllowedHumiditySet'].AsString);
  // AllowedHumiditySet := NameToSurfaceHumiditySet(aNode.Attributes['AllowedHumiditySet'].AsString(''));

  // Extract the name used in the XML
  FieldName := Trim(LeftStrBefore(RightStrAfter(aDeclaration, #39), #39));
  Description := aDescription;

  // Extract type from how it is accessed
  // String
  // Cardinal(0))
  // String)
  // String(''))
  var typeStr := '';
  if ContainsText(aDeclaration, '.As') then
    typeStr := FirstStrBetween(aDeclaration, '.As', ';')
  else
    typeStr := FirstStrBetween(aDeclaration, ':', ';');

  if ContainsText(typeStr, '(') then
  begin
    // There is a default value
    FieldType := LeftStrBefore(typeStr, '(');
    Default := LeftStrBefore(RightStrAfter(typeStr, '('), ')');
  end else
  begin
    // This must be a Required field
    IsRequired := True;

    // Trim last bracket if this field undergoes some extra conversion
    if ContainsText(typeStr, ')') then
      FieldType := LeftStrBefore(typeStr, ')')
    else
      FieldType := typeStr;
  end;

  // Some strings are actually enums
  if FieldType = 'String' then
  begin
    var typeSpec := Pos('.As', aDeclaration);

    var firstBracketSet := Pos('Set(', aDeclaration);
    if (firstBracketSet > 0) and (firstBracketSet < typeSpec) then
      FieldType := 'Enum set'
    else
    begin
      var firstBracket := Pos('(', aDeclaration);
      if (firstBracket > 0) and (firstBracket < typeSpec) then
        FieldType := 'Enum';
    end;
  end;

  // Post-process
  if Default = #39#39 then
    Default := '';
end;


procedure TKMModdingField.CrossLinkWith(aType: TKMModdingType);
begin
  //
end;


function TKMModdingField.GetTableType: string;
begin
  Result := FieldType;
end;


function TKMModdingField.GetXmlExample: string;
begin
  Result := FieldName + '="value"';
end;


function TKMModdingField.IsReference: Boolean;
begin
  Result := False;
end;


function TKMModdingField.IsSubObject: Boolean;
begin
  Result := False;
end;


{ TKMModdingField_Reference }
constructor TKMModdingField_Reference.Create(const aDeclaration, aDescription, aReferenceStr: string);
begin
  inherited Create(aDeclaration, aDescription);

  ReferenceStr := aReferenceStr;

  FieldType := Format('<a href="#%s">%s</a>', [ReferenceStr, ReferenceStr]);
  Default := '..';
end;


procedure TKMModdingField_Reference.CrossLinkWith(aType: TKMModdingType);
begin
  if ReferenceStr = aType.fTypeName then
    ReferenceType := aType;
end;


function TKMModdingField_Reference.GetTableType: string;
begin
  if ReferenceType.fTypeSpecialty = mtsSemicolonDelimitedArray then
    Result := FieldType + ' <sub>[attribute]</sub>'
  else
    Result := FieldType + ' <sub>[object]</sub>'
end;


function TKMModdingField_Reference.GetXmlExample: string;
begin
  Result := FieldName + '="value"';
end;


function TKMModdingField_Reference.IsReference: Boolean;
begin
  Result := True;
end;


function TKMModdingField_Reference.IsSubObject: Boolean;
begin
  Result := ReferenceType.fTypeSpecialty in [mtsNormal, mtsListOfType];
end;


{ TKMModdingType }
constructor TKMModdingType.Create;
begin
  inherited;

  fFields := TList<TKMModdingField>.Create;
end;


destructor TKMModdingType.Destroy;
begin
  FreeAndNil(fFields);

  inherited;
end;


procedure TKMModdingType.LoadFromStringList(aSource: TStringList);
begin
  var descAccumulator := '';
  var fieldReference := '';

  for var I := 0 to aSource.Count - 1 do
  begin
    var srcLine := Trim(aSource[I]);

    if srcLine = '' then
      Continue;

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

      var newField: TKMModdingField;
      if fieldReference = '' then
        newField := TKMModdingField.Create(line, descAccumulator)
      else
        newField := TKMModdingField_Reference.Create(line, descAccumulator, fieldReference);

      fFields.Add(newField);

      descAccumulator := '';
      fieldReference := '';
    end;
  end;
end;


procedure TKMModdingType.SortFieldsByType;
begin
  // Special sorting that will preserve relative item positions
  var sortedFields := TList<TKMModdingField>.Create;

  for var I := 0 to fFields.Count - 1 do
    if not fFields[I].IsSubObject then
      sortedFields.Add(fFields[I]);

  for var I := 0 to fFields.Count - 1 do
    if fFields[I].IsSubObject then
      sortedFields.Add(fFields[I]);

  fFields.Clear;
  fFields.AddRange(sortedFields);

  sortedFields.Free;
end;


procedure TKMModdingType.CrossLinkWith(aType: TKMModdingType);
begin
  for var I := 0 to fFields.Count - 1 do
    fFields[I].CrossLinkWith(aType);
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
      '```' + sLineBreak;

  if fFields.Count > 0 then
    Result := Result + ExportWikiBody_Fields + sLineBreak;
end;


function TKMModdingType.ExportWikiBody_Header: string;
begin
  Result := Format('### <a id="%s">%s</a>', [fTypeName, fCaption]) + sLineBreak + sLineBreak +
            fDescription + sLineBreak;
end;


function TKMModdingType.ExportWikiBody_XmlExample(const aPad: string): string;
begin
  if fFields.Count = 0 then Exit('');

  if fTypeSpecialty = mtsSemicolonDelimitedArray then
  begin
    Result := '';
    for var I := 0 to fFields.Count - 1 do
      Result := Result + IfThen(Result <> '', ';') + '0.000';

    Result := '"' + Result + '"' + sLineBreak;

    Exit;
  end;

  var sb := TStringBuilder.Create;

  var usePad := aPad;

  // Some types are lists
  if IsList then
  begin
    sb.AppendLine(usePad + '<' + fXmlListName + '>');
    usePad := usePad + '  ';
  end;

  // Attributes
  var attributeString := usePad + '<' + fXmlNodeName;
  for var I := 0 to fFields.Count - 1 do
    if not fFields[I].IsSubObject then
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
    var objectsString := '';
    for var I := 0 to fFields.Count - 1 do
      if fFields[I].IsSubObject then
        objectsString := objectsString + TKMModdingField_Reference(fFields[I]).ReferenceType.ExportWikiBody_XmlExample(usePad + '  ');

    attributeString := attributeString + objectsString + usePad + '  </' + fXmlNodeName + '>';
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

    Result := Result + Format(TEMPLATE, [fFields[I].FieldName, fFields[I].GetTableType, req, desc]) + sLineBreak;
  end;
end;


function TKMModdingType.ExportWikiLink: string;
const
  TEMPLATE = '* [%s](#%s)';
begin
  Result := Format(TEMPLATE, [fCaption, fTypeName]);
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
  if fFields[I].IsSubObject then
    Exit(True);
end;


{ TKMModdingFactory }
class function TKMModdingFactory.NewTypeFromStringList(aSource: TStringList): TKMModdingType;
begin
  Result := TKMModdingType.Create;

  for var I := 0 to aSource.Count - 1 do
  begin
    var srcLine := Trim(aSource[I]);

    // Skip empty lines
    if srcLine = '' then
      Continue;

    // Name of the type
    if StartsStr(DOC_TAG_MODDING_TYPENAME, srcLine) then
    begin
      Result.fTypeName := Trim(RightStrAfter(srcLine, DOC_TAG_MODDING_TYPENAME));
      Continue;
    end;

    if StartsStr('procedure ', srcLine) then
    begin
      Result.fTypeName := FirstStrBetween(srcLine, 'procedure ', '.');
      Continue;
    end;

    if StartsStr(DOC_TAG_MODDING_TYPE_SPECIALTY, srcLine) then
    begin
      if ContainsText(srcLine, MODDING_TYPE_SPECIALTY_NAME[mtsListOfType]) then
      begin
        var rs := Trim(RightStrAfter(srcLine, MODDING_TYPE_SPECIALTY_NAME[mtsListOfType]));

        Result.fXmlListName := LeftStrBefore(rs, ':');
        Result.fXmlNodeName := RightStrAfter(rs, ':');

        Result.fTypeSpecialty := mtsListOfType;

      end else
      if ContainsText(srcLine, MODDING_TYPE_SPECIALTY_NAME[mtsSemicolonDelimitedArray]) then
        Result.fTypeSpecialty := mtsSemicolonDelimitedArray
      else
        raise Exception.CreateFmt('Unexpected tag value - "%s"', [srcLine]);

      Continue;
    end;

    if StartsStr(DOC_TAG_MODDING_IS_ROOT, srcLine) then
    begin
      Result.fIsRoot := True;
      Continue;
    end;

    if StartsStr(DOC_TAG_MODDING_CAPTION, srcLine) then
    begin
      Result.fCaption := Trim(RightStrAfter(srcLine, DOC_TAG_MODDING_CAPTION));
      Continue;
    end;

    if StartsStr(DOC_TAG_MODDING_DESCRIPTION, srcLine) then
    begin
      Result.fDescription := Result.fDescription + IfThen(Result.fDescription <> '', '  ' + sLineBreak) + Trim(RightStrAfter(srcLine, DOC_TAG_MODDING_DESCRIPTION));
      Continue;
    end;

    if StartsStr(DOC_TAG, srcLine) then
    begin
      // Delete parsed data
      var firstNonHeaderLine := I;
      for var K := firstNonHeaderLine - 1 downto 0 do
        aSource.Delete(K);

      Exit;
    end;
  end;

  // We did not exit earlier
  aSource.Clear;
end;

end.
