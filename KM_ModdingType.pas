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
    IsRequired: Boolean;
    Default: string;
    Description: string; // Description of the field

    ReferenceStr: string;
    Reference: TKMModdingNode;

    constructor Create(const aDeclaration, aDescription, aAttrReference: string);
    function GetXmlExample: string;
    function GetTableType: string;
    function GetTableDescription: string;
  end;

  TKMModdingNode = class
  private
    function ExportWikiBody_Header: string;
    function ExportWikiBody_Table(const aParent: string): string;
  public
    TypeName: string;   // TKMSomething
    NodeName: string;   // Decals

    IsRoot: Boolean;
    Caption: string;
    TypeSpecialty: TKMModdingTypeSpecialty;

    Description: string;
    ReferenceStr: string;

    Attributes: TList<TKMModdingAttribute>;
    Nodes: TList<TKMModdingNode>;

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

    function GetXmlExample: string;
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
constructor TKMModdingAttribute.Create(const aDeclaration, aDescription, aAttrReference: string);
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


function TKMModdingAttribute.GetTableType: string;
begin
  Result := FieldType;
  if Reference <> nil then
    Result := Reference.GetTableType;
end;


function TKMModdingAttribute.GetTableDescription: string;
begin
  if Reference <> nil then
    Result := Reference.GetTableDescription + IfThen(Reference.GetTableDescription <> '', '<br>') + Description
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
end;


constructor TKMModdingNode.CreateNode(const aDeclaration, aDescription, aNodeReference: string);
begin
  Create;

  NodeName := Trim(FirstStrBetween(aDeclaration, #39, #39));
  Description := aDescription;
  ReferenceStr := aNodeReference;
end;


constructor TKMModdingNode.CreateList(const aDeclaration, aDescription: string);
begin
  Create;

  NodeName := Trim(FirstStrBetween(aDeclaration, #39, #39));
  Description := aDescription;
  TypeName := 'list';
  TypeSpecialty := mtsList;
end;


destructor TKMModdingNode.Destroy;
begin
  FreeAndNil(Attributes);
  FreeAndNil(Nodes);

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

    if StartsStr(DOC_TAG_MODDING_LIST, srcLine) then
    begin
      listForNextNode := TKMModdingNode(1);
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
    if (nodeReference <> '') or (descAccumulator <> '') then
    begin
      if (nodeReference <> '') and (descAccumulator <> '') then
        raise Exception.Create('Node reference will overwrite any existing description.');

      var line := srcLine;
      if ContainsText(line, '//') then
        line := Trim(LeftStrBefore(srcLine, '//'));

      // Decide the type of the item we have
      var itemType := itUndefined;

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
                              var newAttribute := TKMModdingAttribute.Create(line, descAccumulator, '');
                              Attributes.Add(newAttribute);
                            end;
        itAttributeRef:     begin
                              var newAttribute := TKMModdingAttribute.Create(line, descAccumulator, attrReference);
                              Attributes.Add(newAttribute);
                            end;
        itNode:             begin
                              var newNode := TKMModdingNode.CreateNode(line, descAccumulator, nodeReference);
                              Nodes.Add(newNode);
                            end;
        itListForNextNode:  begin
                              listForNextNode := TKMModdingNode.CreateList(line, descAccumulator);
                              Nodes.Add(listForNextNode);
                            end;
        itNodeInList:       begin
                              var newNode := TKMModdingNode.CreateNode(line, descAccumulator, nodeReference);
                              listForNextNode.Nodes.Add(newNode);
                              listForNextNode := nil;
                            end;
      else
        raise Exception.Create('Undefined type');
      end;

      descAccumulator := '';
      nodeReference := '';
      attrReference := '';
    end;
  end;
end;


procedure TKMModdingNode.SortFieldsByType;
begin
//  // Special sorting that will preserve relative item positions
//  var sortedFields := TList<TKMModdingAttribute>.Create;
//
//  for var I := 0 to fFields.Count - 1 do
//    if not fFields[I].IsSubObject then
//      sortedFields.Add(fFields[I]);
//
//  for var I := 0 to fFields.Count - 1 do
//    if fFields[I].IsSubObject then
//      sortedFields.Add(fFields[I]);
//
//  fFields.Clear;
//  fFields.AddRange(sortedFields);
//
//  sortedFields.Free;
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
    mtsSemicolonDelimitedArray: Result := Result + aPad + ' - ' + NodeName + '_array' + IntToStr(Attributes.Count) + sLineBreak;
  end;

  for var I := 0 to Nodes.Count - 1 do
    Result := Result + Nodes[I].ExportListing(aPad + ' ');
end;


function TKMModdingNode.ExportWikiBody: string;
begin
  Result := ExportWikiBody_Header + sLineBreak;

  var xmlText := '';

  if IsRoot then
  begin
    // Root includes xml header for clarity
    xmlText := xmlText + '<?xml version="1.0" encoding="UTF-8"?>' + sLineBreak +
    '<Root>' + sLineBreak;
  end;

  var xmlBody := GetXmlExample;

  xmlBody := ParagraphPad(xmlBody, '  ');

  xmlText := xmlText + xmlBody;

  if IsRoot then
    xmlText := xmlText + '</Root>' + sLineBreak;

  xmlText := ParagraphWordWrap(xmlText, 112);

  Result := Result +
    'XML layout example:' + sLineBreak +
    '```xml' + sLineBreak +
    xmlText +
    '```' + sLineBreak;

  Result := Result + ExportWikiBody_Table('Root') + sLineBreak;
end;


function TKMModdingNode.ExportWikiBody_Header: string;
begin
  Result := Format('### <a id="%s">%s</a>', [TypeName, Caption]) + sLineBreak + sLineBreak +
            Description + sLineBreak;
end;


function TKMModdingNode.GetXmlExample: string;
begin
  if (Attributes.Count = 0) and (Nodes.Count = 0) then Exit('');

  // Attributes
  var attributeString := '';
  for var I := 0 to Attributes.Count - 1 do
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
      nodesString := nodesString + Nodes[I].GetXmlExample;

    if TypeSpecialty = mtsList then
      nodesString := nodesString + '...' + sLineBreak;

    nodesString := ParagraphPad(nodesString, '  ');

    xmlString := xmlString + nodesString + '<' + NodeName + '/>' + sLineBreak;
  end;

  Result := xmlString;
end;


function TKMModdingNode.ExportWikiBody_Table(const aParent: string): string;
const
  TEMPLATE_HEADER      = '| Structure | A/N | Attribute name | Type | Required / Default | Description |';
  TEMPLATE_HEADER_LINE = '| --------- |:---:|:--------------:|:----:|:------------------:| ----------- |';
  TEMPLATE = '| %s | %s | %s | %s | %s | %s |';
begin
  Result := '';

  if aParent = 'Root' then
    Result := TEMPLATE_HEADER + sLineBreak +
              TEMPLATE_HEADER_LINE + sLineBreak;

  // Self
  Result := Result + Format(TEMPLATE, [aParent, 'node', NodeName, '', '', GetTableDescription]) + sLineBreak;

  if Attributes.Count + Nodes.Count = 0 then Exit;

  // Attributes
  for var I := 0 to Attributes.Count - 1 do
  begin
    var req := IfThen(Attributes[I].IsRequired, '**Required**', '`"' + Attributes[I].Default + '"`');
    Result := Result + Format(TEMPLATE, [aParent + '.' + NodeName, 'attr', Attributes[I].FieldName, Attributes[I].GetTableType, req, Attributes[I].GetTableDescription]) + sLineBreak;
  end;

  // Nodes
  for var I := 0 to Nodes.Count - 1 do
    Result := Result + Nodes[I].ExportWikiBody_Table(aParent + '.' + NodeName);
end;


function TKMModdingNode.ExportWikiLink: string;
const
  TEMPLATE = '* [%s](#%s)';
begin
  Result := Format(TEMPLATE, [Caption, TypeName]);
end;


function TKMModdingNode.GetTableType: string;
begin
  case TypeSpecialty of
    mtsNormal:                  Result := '-';
    mtsSemicolonDelimitedArray: Result := 'String' + IntToStr(Attributes.Count);
  end;
end;


function TKMModdingNode.GetTableDescription: string;
begin
  case TypeSpecialty of
    mtsNormal,
    mtsList:                    Result := Description;
    mtsSemicolonDelimitedArray: begin
                                  Result := Description;
                                  for var I := 0 to Attributes.Count - 1 do
                                    Result := Result + IfThen(Result <> '', '<br>') + ' - ' + Attributes[I].Description;
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
      Result.NodeName := FirstStrBetween(aSource[I+1], #39, #39);
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
