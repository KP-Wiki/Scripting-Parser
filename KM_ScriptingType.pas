unit KM_ScriptingType;
interface
uses
  System.Classes, System.Generics.Collections;

type
  // There are these base types we want to share in the Wiki:
  TKMTypeType = (ttEnum, ttRecord, ttArray, ttSetOfType, ttSetOfEnum);

  TKMSortType = (stByAlphabet, stByDependancy);

  // Single type element (
  TKMScriptTypeElement = class
  private
    fName: string; // Name of the element
    fDesc: string; // Description of the element
  public
    constructor Create(const aName, aDesc: string);
    function ExportWikiBody: string;

    property Name: string read fName;
    property Desc: string read fDesc;
  end;

  // Collection of elements (e.g. enum)
  TKMScriptTypeElements = class
  private
    fList: TList<TKMScriptTypeElement>;
  public
    constructor Create;
    destructor Destroy; override;
    procedure ParseFromStringList(aType: TKMTypeType; aStrings: TStringList);
    function ExportCode(aType: TKMTypeType): string;
    function ExportWikiBody: string;

    property List: TList<TKMScriptTypeElement> read fList;
  end;

  // Single type info
  // Documenter > Scripting > Type
  TKMScriptType = class
  private
    fName: string;
    fType: TKMTypeType;
    fDescription: string;
    fElements: TKMScriptTypeElements;
  public
    SortPriority: Integer;
    constructor Create;
    destructor Destroy; override;
    procedure LoadFromStringList(aSource: TStringList);
    function ExportCode: string;
    function ExportWikiBody: string;
    function ExportWikiLink: string;

    property Name: string read fName;
    property Typ: TKMTypeType read fType;
    property Elements: TKMScriptTypeElements read fElements;
  end;


implementation
uses
  System.Math, System.StrUtils, System.SysUtils, System.Types,
  KM_StringUtils,
  KM_ParserTypes;


{ TKMScriptTypeElement }
constructor TKMScriptTypeElement.Create(const aName, aDesc: string);
begin
  inherited Create;

  fName := aName;
  fDesc := aDesc;
end;


function TKMScriptTypeElement.ExportWikiBody: string;
begin
  Result := '<sub>**' + fName + '**' + IfThen(fDesc <> '', ' // ' + fDesc) + '</sub>';
end;


{ TKMScriptTypeElements }
constructor TKMScriptTypeElements.Create;
begin
  inherited;

  fList := TList<TKMScriptTypeElement>.Create;
end;


destructor TKMScriptTypeElements.Destroy;
begin
  FreeAndNil(fList);

  inherited;
end;


procedure TKMScriptTypeElements.ParseFromStringList(aType: TKMTypeType; aStrings: TStringList);
var
  I, K: Integer;
  comment: string;
  colonPos, commentPos: Integer;
  declaration: string;
  elements: TStringDynArray;
begin
  case aType of
    ttEnum:     begin
                  aStrings[0] := ReplaceStr(aStrings[0], '(', '');
                  aStrings[aStrings.Count - 1] := ReplaceStr(aStrings[aStrings.Count - 1], ');', '');

                  for I := 0 to aStrings.Count - 1 do
                  if aStrings[I] <> '' then
                  begin
                    commentPos := Pos('//', aStrings[I]);
                    if commentPos > 0 then
                    begin
                      comment := Trim(RightStr(aStrings[I], Length(aStrings[I]) - commentPos - 1));
                      declaration := LeftStr(aStrings[I], commentPos - 1);
                    end else
                    begin
                      comment := '';
                      declaration := aStrings[I];
                    end;

                    elements := SplitString(declaration, ',');

                    for K := Low(elements) to High(elements) do
                    if Trim(elements[K]) <> '' then
                      fList.Add(TKMScriptTypeElement.Create(Trim(elements[K]), comment));
                  end;
                end;
    ttRecord:   for I := 0 to aStrings.Count - 1 do
                if (aStrings[I] <> '') and (Pos(':', aStrings[I]) > 0) then
                begin
                  colonPos := Pos(':', aStrings[I]);
                  commentPos := Pos('//', aStrings[I]);

                  if (Pos('(', aStrings[I]) > colonPos)
                  or (Pos(')', aStrings[I]) > colonPos)
                  or InRange(Pos('function', aStrings[I]), 1, colonPos)
                  or InRange(Pos('procedure', aStrings[I]), 1, colonPos) then
                    Continue;

                  if commentPos > 0 then
                  begin
                    comment := Trim(RightStr(aStrings[I], Length(aStrings[I]) - commentPos - 1));
                    declaration := LeftStr(aStrings[I], commentPos - 1);
                  end else
                  begin
                    comment := '';
                    declaration := aStrings[I];
                  end;

                  // Trim trailing ";" for nicer look
                  declaration := Trim(ReplaceStr(declaration, ';', ''));

                  fList.Add(TKMScriptTypeElement.Create(declaration, comment));
                end;
    ttArray:    begin
                  Assert(aStrings.Count = 1);
                  commentPos := Pos('//', aStrings[0]);

                  if commentPos > 0 then
                  begin
                    comment := Trim(RightStr(aStrings[0], Length(aStrings[0]) - commentPos - 1));
                    declaration := LeftStr(aStrings[0], commentPos - 1);
                  end else
                  begin
                    comment := '';
                    declaration := aStrings[0];
                  end;

                  declaration := Trim(ReplaceStr(declaration, ';', ''));

                  fList.Add(TKMScriptTypeElement.Create(declaration, comment));
                end;
    ttSetOfType:begin
                  Assert(aStrings.Count = 1);

                  // Single type declaration needs no comments
                  declaration := ReplaceStr(aStrings[0], ';', '');

                  fList.Add(TKMScriptTypeElement.Create(declaration, ''));
                end;
    ttSetOfEnum:begin
                  aStrings[0] := ReplaceStr(aStrings[0], 'set of', '');
                  aStrings[0] := ReplaceStr(aStrings[0], '(', '');
                  aStrings[aStrings.Count - 1] := ReplaceStr(aStrings[aStrings.Count - 1], ');', '');

                  for I := 0 to aStrings.Count - 1 do
                  if aStrings[I] <> '' then
                  begin
                    commentPos := Pos('//', aStrings[I]);
                    if commentPos > 0 then
                    begin
                      comment := Trim(RightStr(aStrings[I], Length(aStrings[I]) - commentPos - 1));
                      declaration := LeftStr(aStrings[I], commentPos - 1);
                    end else
                    begin
                      comment := '';
                      declaration := aStrings[I];
                    end;

                    elements := SplitString(declaration, ',');

                    for K := Low(elements) to High(elements) do
                    if Trim(elements[K]) <> '' then
                      fList.Add(TKMScriptTypeElement.Create(Trim(elements[K]), comment));
                  end;
                end;
  end;
end;


function TKMScriptTypeElements.ExportCode(aType: TKMTypeType): string;
const
  WRAP_AROUND_COUNT = 5;
var
  I: Integer;
begin
  case aType of
    ttEnum:       begin
                    Result := #39'(';
                    for I := 0 to fList.Count - 1 do
                    begin
                      if (I > 0) and (I mod WRAP_AROUND_COUNT = 0) then
                        Result := Result + #39' +' + sLineBreak + '      '#39;

                      Result := Result + fList[I].fName + IfThen(I < fList.Count - 1, ', ');
                    end;
                    Result := Result + ')'#39;
                  end;
    ttRecord:     begin
                    Result := #39 + 'record '#39 + ' +' + sLineBreak;

                    for I := 0 to fList.Count - 1 do
                      Result := Result + '        '#39 + fList[I].fName + '; '#39 + ' +' + sLineBreak;

                    Result := Result + '      '#39'end;'#39;
                  end;
    ttArray:      Result := #39 + fList[0].fName + #39;
    ttSetOfType:  Result := #39 + fList[0].fName + #39;
    ttSetOfEnum:  begin
                    Result := #39'set of (';
                    for I := 0 to fList.Count - 1 do
                    begin
                      if (I > 0) and (I mod WRAP_AROUND_COUNT = 0) then
                        Result := Result + #39' +' + sLineBreak + '      '#39;

                      Result := Result + fList[I].fName + IfThen(I < fList.Count - 1, ', ');
                    end;
                    Result := Result + ')'#39;
                  end;
  end;
end;


function TKMScriptTypeElements.ExportWikiBody: string;
var
  I: Integer;
begin
  Result := '';
  for I := 0 to fList.Count - 1 do
    Result := Result + IfThen(I > 0, '<br/>') + fList[I].ExportWikiBody;
end;


{ TKMScriptType }
constructor TKMScriptType.Create;
begin
  inherited;

  fElements := TKMScriptTypeElements.Create;
end;


destructor TKMScriptType.Destroy;
begin
  FreeAndNil(fElements);

  inherited;
end;


procedure TKMScriptType.LoadFromStringList(aSource: TStringList);
var
  I: Integer;
  srcLine: string;
  enumStr: TStringList; // Needs to be a list because of comments
  details: TStringList;
begin
  details := TStringList.Create;
  enumStr := TStringList.Create;
  try
    I := 0;
    srcLine := aSource[I];

//    if StartsStr(DOC_TAG_VERSION, srcLine) then
//    begin
//      fVersion := Trim(RightStrAfter(srcLine, ':'));
//      Inc(I);
//      srcLine := aSource[I];
//    end;

    // Descriptions are only added by lines starting with "//*"
    // Repeat until no description tags are found
    while StartsStr(DOC_TAG, srcLine) do
    begin
      details.Add(RightStrAfter(srcLine, DOC_TAG + ' '));

      Inc(I);
      srcLine := aSource[I];
    end;

    // Skip empty or "faulty" lines (e.g. comments not intended for wiki)
    // until we get a type declaration (must start with T)
    while not StartsStr('T', srcLine) do
    begin
      Inc(I);
      srcLine := aSource[I];
    end;

    // Parse enum - detected by "("
    if Pos('(', srcLine) > 0 then
    begin
      fType := ttEnum;

      enumStr.Text := srcLine;
      if I < aSource.Count - 1 then
      repeat
        Inc(I);
        srcLine := aSource[I];
        enumStr.Append(srcLine);

        // Ignore closing brackets if they are in comments
      until ((Pos(')', srcLine) <> 0) and (Pos('//', srcLine) = 0))
         or ((Pos(')', srcLine) <> 0) and (Pos('//', srcLine) <> 0) and (Pos(')', srcLine) < Pos('//', srcLine)));
    end;

    // Parse record - detected by "record"
    if Pos('record', srcLine) > 0 then
    begin
      fType := ttRecord;

      enumStr.Text := srcLine;
      if I < aSource.Count - 1 then
      repeat
        Inc(I);
        srcLine := aSource[I];
        enumStr.Append(srcLine);
      until Pos('end;', srcLine) <> 0;
    end;

    // Parse array - detected by "array of"
    if Pos('array of', srcLine) > 0 then
    begin
      fType := ttArray;
      enumStr.Text := srcLine;
    end;

    // Parse set of type - detected by "set of A;"
    if (Pos('set of', srcLine) > 0) and ((Pos('(', srcLine) = 0)) then
    begin
      fType := ttSetOfType;
      enumStr.Text := srcLine;
    end;

    // Parse set of enum - detected by "set of (a, b);"
    if (Pos('set of', srcLine) > 0) and ((Pos('(', srcLine) > 0)) then
    begin
      fType := ttSetOfEnum;
      enumStr.Text := srcLine;
    end;

    // Name is the first word
    fName := Trim(LeftStr(enumStr[0], Pos('=', enumStr[0]) - 1));
    enumStr[0] := Trim(RightStrAfter(enumStr[0], '='));

    fElements.ParseFromStringList(fType, enumStr);

    // Now we can assemble Description, after we have detected and removed fParameters descriptions from it
    for I := 0 to details.Count - 1 do
      fDescription := fDescription + '<br/>' + details[I];
  finally
    details.Free;
    enumStr.Free;
  end;
end;


function TKMScriptType.ExportCode: string;
const
  TEMPLATE = 'Sender.AddTypeS(''%s'', %s);';
begin
  Result := Format(TEMPLATE, [fName, fElements.ExportCode(fType)]);
end;


function TKMScriptType.ExportWikiBody: string;
const
  TEMPLATE = '| - | <sub>%s</sub> | <a id="%s">%s</a><sub>%s</sub> |';
  TYPE_NAME: array [TKMTypeType] of string = ('enum', 'record', 'array', 'set', 'set');
begin
  Result := Format(TEMPLATE, [TYPE_NAME[fType], fName, fName, fDescription]) + fElements.ExportWikiBody;
end;


function TKMScriptType.ExportWikiLink: string;
const
  TEMPLATE = '* <a href="#%s">%s</a>';
begin
  Result := Format(TEMPLATE, [fName, fName]);
end;


end.
