unit KM_ModdingType;
interface
uses
  System.Classes, System.Generics.Collections,
  KM_DocumenterTypes;

type
  TKMSortType = (stByAlphabet, stByDependancy);

  TKMModdingNode = class;

  // Single field of a type
  TKMModdingAttribute = class
  public
    FieldName: string;
    FieldType: string;
    Cardinality: string;
    Default: string;
    Description: string; // Description of the field

    ReferenceStr: string;
    Reference: TKMModdingNode;

    constructor Create(const aDeclaration, aDescription, aAttrReference, aAttrCardinality, aAttrDefault: string);
    function GetXmlExample: string;
    function GetTableType: string;
    function GetTableDescription: string;
  end;

  TKMModdingNode = class
  private
    function ExportWikiBody_Header: string;
    function ExportWikiBody_Table(const aParent, aCardinality: string): string;
    function ExportWikiBody_XmlExample(aFull: Boolean): string;
  public
    TypeName: string; // TKMSomething
    NodeName: string; // Decals

    IsRoot: Boolean;
    Caption: string;
    TypeSpecialty: TKMModdingTypeSpecialty;

    Description: string;
    Cardinality: string;
    ReferenceStr: string;

    Attributes: TList<TKMModdingAttribute>;
    Nodes: TList<TKMModdingNode>;
    NodeCardinality: TList<string>;

    constructor Create;
    constructor CreateNode(const aDeclaration, aDescription, aNodeReference: string);
    constructor CreateList(const aDeclaration, aDescription: string);
    destructor Destroy; override;

    procedure LoadFromStringList(aSource: TStringList);
    procedure CrossLinkWith(aNode: TKMModdingNode);
    procedure SortFieldsByType;

    function ExportListing(const aPad: string): string;
    function ExportWikiBody: string;
    function ExportWikiLink: string;

    function GetXmlExample(aFull: Boolean): string;
    function GetTableCardinality: string;
    function GetTableType: string;
    function GetTableDescription: string;
  end;

  TKMModdingFactory = class
  public
    class function NewTypeFromStringList(aSource: TStringList): TKMModdingNode;
  end;


implementation
uses
  System.Math, System.StrUtils, System.SysUtils, System.Types,
  KM_StringUtils;


{ TKMModdingAttribute }
constructor TKMModdingAttribute.Create(const aDeclaration, aDescription, aAttrReference, aAttrCardinality, aAttrDefault: string);
begin
  inherited Create;

  // Input examples:
  // EngName := aNode.Attributes['EngName'].AsString;
  // MinimapColor := TKMColor4f.NewRGBA(aNode.Attributes['MinimapColor'].AsCardinal(0));
  // AllowedHumiditySet := NameToSurfaceHumiditySet(aNode.Attributes['AllowedHumiditySet'].AsString);
  // AllowedHumiditySet := NameToSurfaceHumiditySet(aNode.Attributes['AllowedHumiditySet'].AsString(''));

  // Extract the name used in the XML
  FieldName := Trim(FirstStrBetween(aDeclaration, #39, #39));
  Description := aDescription;
  ReferenceStr := aAttrReference;
  Cardinality := '0..1';

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
    Default := '"' + ReplaceStr(FirstStrBetween(typeStr, '(', ')'), #39#39, '') + '"';
  end else
  begin
    // This must be a Required field
    if aAttrCardinality = '' then
      Cardinality := '1';

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

  if aAttrCardinality <> '' then
    Cardinality := aAttrCardinality;

  if aAttrDefault <> '' then
    Default := '"' + aAttrDefault + '"';
end;


function TKMModdingAttribute.GetTableType: string;
begin
  Result := FieldType;
  if Reference <> nil then
    Result := Reference.GetTableType;
end;


function TKMModdingAttribute.GetTableDescription: string;
begin
  if Reference <> nil then
    Result := Description + '<br>' + Reference.GetTableDescription
  else
    Result := Description;
end;


function TKMModdingAttribute.GetXmlExample: string;
begin
  Result := FieldName + '="value"';
end;


{ TKMModdingNode }
constructor TKMModdingNode.Create;
begin
  inherited;

  Attributes := TList<TKMModdingAttribute>.Create;
  Nodes := TList<TKMModdingNode>.Create;
  NodeCardinality := TList<string>.Create;
end;


constructor TKMModdingNode.CreateNode(const aDeclaration, aDescription, aNodeReference: string);
begin
  Create;

  NodeName := Trim(FirstStrBetween(aDeclaration, #39, #39));
  Description := aDescription;
  ReferenceStr := aNodeReference;
  Cardinality := 'Node';
end;


constructor TKMModdingNode.CreateList(const aDeclaration, aDescription: string);
begin
  Create;

  NodeName := Trim(FirstStrBetween(aDeclaration, #39, #39));
  Description := aDescription;
  TypeName := 'list';
  TypeSpecialty := mtsList;
  Cardinality := 'List';
end;


destructor TKMModdingNode.Destroy;
begin
  FreeAndNil(Attributes);
  FreeAndNil(Nodes);
  FreeAndNil(NodeCardinality);

  inherited;
end;


procedure TKMModdingNode.LoadFromStringList(aSource: TStringList);
type
  TKMItemType = (itUndefined, itListForNextNode, itAttribute, itAttributeRef, itNode, itNodeInList);
begin
  var descAccumulator := '';
  var nodeReference := '';
  var attrReference := '';
  var listForNextNode: TKMModdingNode := nil;
  var newAttrDefault := '';
  var newAttrCardinality := '';
  var newNodeCardinality := '';

  for var I := 0 to aSource.Count - 1 do
  begin
    var srcLine := Trim(aSource[I]);

    if srcLine = '' then
      Continue;

    // Reference means we need to lookup some other type description instead for the type
    if StartsStr(DOC_TAG_MODDING_REFERENCE_NODE, srcLine) then
    begin
      nodeReference := Trim(RightStrAfter(srcLine, DOC_TAG_MODDING_REFERENCE_NODE));
      Continue;
    end;

    if StartsStr(DOC_TAG_MODDING_REFERENCE_ATTR, srcLine) then
    begin
      attrReference := Trim(RightStrAfter(srcLine, DOC_TAG_MODDING_REFERENCE_ATTR));
      Continue;
    end;

    if StartsStr(DOC_TAG_MODDING_LIST_FOR_NEXT_NODE, srcLine) then
    begin
      listForNextNode := TKMModdingNode(1);
      Continue;
    end;

    if StartsStr(DOC_TAG_MODDING_ATTR_DEFAULT, srcLine) then
    begin
      newAttrDefault := Trim(RightStrAfter(srcLine, DOC_TAG_MODDING_ATTR_DEFAULT));
      Continue;
    end;

    if StartsStr(DOC_TAG_MODDING_ATTR_CARDINALITY, srcLine) then
    begin
      newAttrCardinality := Trim(RightStrAfter(srcLine, DOC_TAG_MODDING_ATTR_CARDINALITY));
      Continue;
    end;

    if StartsStr(DOC_TAG_MODDING_NODE_CARDINALITY, srcLine) then
    begin
      newNodeCardinality := Trim(RightStrAfter(srcLine, DOC_TAG_MODDING_NODE_CARDINALITY));
      Continue;
    end;

    // Accumulate description until we need it
    if StartsStr(DOC_TAG, srcLine) then
    begin
      descAccumulator := descAccumulator + IfThen(descAccumulator <> '', '<br>') + RightStrAfter(srcLine, DOC_TAG + ' ');
      Continue;
    end;

    // Skip normal comments
    if StartsStr('//', srcLine) then
      Continue;

    // Every item must have a description
    // When we have a description, next code line is the type
    if (nodeReference <> '') or (attrReference <> '') or (descAccumulator <> '') then
    begin
      if (nodeReference <> '') and (descAccumulator <> '') then
        raise Exception.Create('Node reference will overwrite any existing description.');

      var line := srcLine;
      if ContainsText(line, '//') then
        line := Trim(LeftStrBefore(srcLine, '//'));

      // Decide the type of the item we have
      var itemType: TKMItemType;
      if listForNextNode = TKMModdingNode(1) then
        itemType := itListForNextNode
      else
      if nodeReference = '' then
        if attrReference = '' then
          itemType := itAttribute
        else
          itemType := itAttributeRef
      else
        if listForNextNode <> nil then
        itemType := itNodeInList
      else
        itemType := itNode;

      case itemType of
        itAttribute:        begin
                              var newAttribute := TKMModdingAttribute.Create(line, descAccumulator, '', newAttrCardinality, newAttrDefault);
            Attributes.Add(newAttribute);
          end;
        itAttributeRef:     begin
                              var newAttribute := TKMModdingAttribute.Create(line, descAccumulator, attrReference, newAttrCardinality, newAttrDefault);
            Attributes.Add(newAttribute);
          end;
        itNode:             begin
                              var newNode := TKMModdingNode.CreateNode(line, descAccumulator, nodeReference);
            Nodes.Add(newNode);
            NodeCardinality.Add(newNodeCardinality);
          end;
        itListForNextNode:  begin
            listForNextNode := TKMModdingNode.CreateList(line, descAccumulator);
            Nodes.Add(listForNextNode);
            NodeCardinality.Add(newNodeCardinality);
          end;
        itNodeInList:       begin
                              var newNode := TKMModdingNode.CreateNode(line, descAccumulator, nodeReference);
            listForNextNode.Nodes.Add(newNode);
            listForNextNode.NodeCardinality.Add(newNodeCardinality);
            listForNextNode := nil;
          end;
      else
        raise Exception.Create('Undefined type');
      end;

      descAccumulator := '';
      nodeReference := '';
      attrReference := '';
      newAttrDefault := '';
      newAttrCardinality := '';
      newNodeCardinality := '';
    end;
  end;
end;


procedure TKMModdingNode.SortFieldsByType;
begin
  // // Special sorting that will preserve relative item positions
  // var sortedFields := TList<TKMModdingAttribute>.Create;
  //
  // for var I := 0 to fFields.Count - 1 do
  // if not fFields[I].IsSubObject then
  // sortedFields.Add(fFields[I]);
  //
  // for var I := 0 to fFields.Count - 1 do
  // if fFields[I].IsSubObject then
  // sortedFields.Add(fFields[I]);
  //
  // fFields.Clear;
  // fFields.AddRange(sortedFields);
  //
  // sortedFields.Free;
end;


procedure TKMModdingNode.CrossLinkWith(aNode: TKMModdingNode);
begin
  for var I := 0 to Attributes.Count - 1 do
    if Attributes[I].ReferenceStr = aNode.TypeName then
      Attributes[I].Reference := aNode;

  for var I := 0 to Nodes.Count - 1 do
  begin
    if Nodes[I].ReferenceStr = aNode.TypeName then
      Nodes[I] := aNode;

    Nodes[I].CrossLinkWith(aNode);
  end;
end;


function TKMModdingNode.ExportListing(const aPad: string): string;
begin
  Result := aPad + Format('%s:%s -> %s', [NodeName, TypeName, ReferenceStr]) + sLineBreak;

  case TypeSpecialty of
    mtsNormal:                  for var I := 0 to Attributes.Count - 1 do
        Result := Result + aPad + ' - ' + Attributes[I].FieldName + sLineBreak;
    mtsSemicolonDelimitedArray:      Result := Result + aPad + ' - ' + NodeName + '_array' +        IntToStr(Attributes.Count) + sLineBreak;
    mtsEnum:      Result := Result + aPad + ' - ' + NodeName + '_enum' + sLineBreak;
    mtsEnumSet:      Result := Result + aPad + ' - ' + NodeName + '_enumset' + sLineBreak;
  end;

  for var I := 0 to Nodes.Count - 1 do
    Result := Result + Nodes[I].ExportListing(aPad + ' ');
end;


function TKMModdingNode.ExportWikiBody: string;
begin
  Result :=
    ExportWikiBody_Header + sLineBreak +
    ExportWikiBody_XmlExample(False) + sLineBreak +
    ExportWikiBody_XmlExample(True) + sLineBreak +
    ExportWikiBody_Table('', '1') + sLineBreak;
end;


function TKMModdingNode.ExportWikiBody_Header: string;
begin
  Result := Format('### <a id="%s">%s</a>', [TypeName, Caption]) + sLineBreak + sLineBreak +
            Description + sLineBreak;
end;


function TKMModdingNode.ExportWikiBody_XmlExample(aFull: Boolean): string;
begin
  var xmlBody := '';
  if IsRoot then
  begin
    // Root includes xml header for clarity
    xmlBody := xmlBody + '<?xml version="1.0" encoding="UTF-8"?>' + sLineBreak +
      '<Root>' + sLineBreak;
  end;

  xmlBody := xmlBody + ParagraphPad(GetXmlExample(aFull), '  ');

  if IsRoot then
    xmlBody := xmlBody + '</Root>' + sLineBreak;

  xmlBody := ParagraphWordWrap(xmlBody, 112);

  if aFull then
    Result :=
      '<details>' + sLineBreak +
      '<summary>Full XML layout example:</summary>' + sLineBreak + sLineBreak +
      '```xml' + sLineBreak +
      xmlBody +
      '```' + sLineBreak +
      '</details>' + sLineBreak
  else
    Result :=
      'Minimal XML layout example:' + sLineBreak +
      '```xml' + sLineBreak +
      xmlBody +
      '```' + sLineBreak;
end;


function TKMModdingNode.GetXmlExample(aFull: Boolean): string;
begin
  if (Attributes.Count = 0) and (Nodes.Count = 0) then Exit('');

  // Attributes
  var attributeString := '';
  for var I := 0 to Attributes.Count - 1 do
    if aFull or not ContainsStr(Attributes[I].Cardinality, '0') then
    attributeString := attributeString + IfThen(attributeString > '', ' ') + Attributes[I].GetXmlExample;

  var xmlString := '';
  if Attributes.Count > 0 then
  begin
    xmlString := '<' + NodeName + ' ' + attributeString;

    if Nodes.Count > 0 then
      xmlString := xmlString + '>' + sLineBreak
    else
      xmlString := xmlString + '/>' + sLineBreak;
  end else
    xmlString := xmlString + '<' + NodeName + '>' + sLineBreak;

  // Sub-objects
  if Nodes.Count > 0 then
  begin
    var nodesString := '';

    for var I := 0 to Nodes.Count - 1 do
      if aFull or not ContainsStr(NodeCardinality[I], '0') then
        nodesString := nodesString + Nodes[I].GetXmlExample(aFull);

    if TypeSpecialty = mtsList then
      nodesString := nodesString + '...' + sLineBreak;

    nodesString := ParagraphPad(nodesString, '  ');

    xmlString := xmlString + nodesString + '</' + NodeName + '>' + sLineBreak;
  end;

  Result := xmlString;
end;


function TKMModdingNode.ExportWikiBody_Table(const aParent, aCardinality: string): string;
const
  TEMPLATE_HEADER      = '| Parent | Kind | Cardinality | Attribute name | Type | Default | Description |';
  TEMPLATE_HEADER_LINE = '| ------ |:----:|:-----------:|:--------------:|:----:|:-------:| ----------- |';
  TEMPLATE = '| %s | %s | %s | %s | %s | %s | %s |';
begin
  Result := '';

  if aParent = '' then
    Result := TEMPLATE_HEADER + sLineBreak +
              TEMPLATE_HEADER_LINE + sLineBreak;

  // Self
  Result := Result + Format(TEMPLATE, [aParent, 'node', aCardinality, NodeName, '', '', GetTableDescription]) + sLineBreak;

  if Attributes.Count + Nodes.Count = 0 then Exit;

  // Attributes
  for var I := 0 to Attributes.Count - 1 do
  begin
    var attrCardinality := Attributes[I].Cardinality;
    var attrDefault := IfThen(Attributes[I].Default <> '', '`' + Attributes[I].Default + '`');
    Result := Result + Format(TEMPLATE, [aParent + '.' + NodeName, 'attr.', attrCardinality, Attributes[I].FieldName, Attributes[I].GetTableType, attrDefault, Attributes[I].GetTableDescription]) + sLineBreak;
  end;

  // Nodes
  var struct := aParent + IfThen(aParent <> '', '.') + NodeName;
  for var I := 0 to Nodes.Count - 1 do
    Result := Result + Nodes[I].ExportWikiBody_Table(struct, NodeCardinality[I]);
end;


function TKMModdingNode.ExportWikiLink: string;
const
  TEMPLATE = '* [%s](#%s)';
begin
  Result := Format(TEMPLATE, [Caption, TypeName]);
end;


function TKMModdingNode.GetTableCardinality: string;
begin
  if IsRoot then
    Result := '1'
  else
    Result := '-?-';
end;


function TKMModdingNode.GetTableType: string;
begin
  case TypeSpecialty of
    mtsNormal:                  Result := '-';
    mtsSemicolonDelimitedArray: Result := 'String' + IntToStr(Attributes.Count);
    mtsEnum:                    Result := 'String<br>(enum)';
    mtsEnumSet:                 Result := 'String<br>(enum set)';
  end;
end;


function TKMModdingNode.GetTableDescription: string;
begin
  case TypeSpecialty of
    mtsNormal,
    mtsList:         Result := Description;
    mtsSemicolonDelimitedArray: begin
                                  Result := Description;
                                  for var I := 0 to Attributes.Count - 1 do
                                    Result := Result + IfThen(Result <> '', '<br>') + ' - ' + Attributes[I].Description;
                                end;
    mtsEnum:                    begin
                                  Result := Description;
                                  for var I := 0 to Attributes.Count - 1 do
                                    Result := Result + IfThen(Result <> '', '<br>') + ' - `"' + Attributes[I].FieldName + '"` - ' + Attributes[I].Description;
                                end;
    mtsEnumSet:                 begin
                                  Result := Description;
                                  for var I := 0 to Attributes.Count - 1 do
                                    Result := Result + IfThen(Result <> '', '<br>') + ' - `"' + Attributes[I].FieldName + '"` - ' + Attributes[I].Description;
                                end;
  end;
end;


{ TKMModdingFactory }
class function TKMModdingFactory.NewTypeFromStringList(aSource: TStringList): TKMModdingNode;
begin
  Result := TKMModdingNode.Create;

  for var I := 0 to aSource.Count - 1 do
  begin
    var srcLine := Trim(aSource[I]);

    // Skip empty lines
    if srcLine = '' then
      Continue;

    if StartsStr(DOC_TAG_MODDING_TYPE_IS_ROOT, srcLine) then
    begin
      Result.IsRoot := True;
      Continue;
    end;

    // Name of the type
    if StartsStr(DOC_TAG_MODDING_TYPE_NAME, srcLine) then
    begin
      Result.TypeName := Trim(RightStrAfter(srcLine, DOC_TAG_MODDING_TYPE_NAME));
      Continue;
    end;

    if StartsStr('procedure ', srcLine) then
    begin
      Result.TypeName := FirstStrBetween(srcLine, 'procedure ', '.');
      Continue;
    end;

    if StartsStr(DOC_TAG_MODDING_TYPE_NODENAME, srcLine) then
    begin
      Result.NodeName := FirstStrBetween(aSource[I + 1], #39, #39);
      Continue;
    end;

    if StartsStr(DOC_TAG_MODDING_TYPE_CAPTION, srcLine) then
    begin
      Result.Caption := Trim(RightStrAfter(srcLine, DOC_TAG_MODDING_TYPE_CAPTION));
      Continue;
    end;

    if StartsStr(DOC_TAG_MODDING_TYPE_DESCRIPTION, srcLine) then
    begin
      Result.Description := Result.Description + IfThen(Result.Description <> '', '<br>') + Trim(RightStrAfter(srcLine, DOC_TAG_MODDING_TYPE_DESCRIPTION));
      Continue;
    end;

    if StartsStr(DOC_TAG_MODDING_TYPE_SPECIALTY, srcLine) then
    begin
      if ContainsText(srcLine, MODDING_TYPE_SPECIALTY_NAME[mtsSemicolonDelimitedArray]) then
        Result.TypeSpecialty := mtsSemicolonDelimitedArray
      else
      if ContainsText(srcLine, MODDING_TYPE_SPECIALTY_NAME[mtsList]) then
        Result.TypeSpecialty := mtsList
      else
      if ContainsText(srcLine, MODDING_TYPE_SPECIALTY_NAME[mtsEnumSet]) then
        Result.TypeSpecialty := mtsEnumSet
      else
      if ContainsText(srcLine, MODDING_TYPE_SPECIALTY_NAME[mtsEnum]) then
        Result.TypeSpecialty := mtsEnum
      else
        raise Exception.CreateFmt('Unexpected tag value - "%s"', [srcLine]);

      Continue;
    end;

    // Now begin attributes and nodes
    if StartsStr(DOC_TAG, srcLine) then
    begin
      // Delete parsed data
      var firstNonHeaderLine := I;
      for var K := firstNonHeaderLine - 1 downto 0 do
        aSource.Delete(K);

      // There is only one type
      Result.LoadFromStringList(aSource);
      Exit;
    end;
  end;

  // We did not exit earlier
  aSource.Clear;
end;

end.
