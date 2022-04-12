unit KM_ScriptingTypes;
interface
uses
  Classes, SysUtils, Types, Generics.Collections, Generics.Defaults,
  Math, StrUtils,
  KM_ParserTypes;

type
  // There are these base types:
  TKMTypeType = (ttEnum, ttRecord, ttArray, ttSetOfType, ttSetOfEnum);

  TKMScriptTypeElement = class
  private
    fName: string;
    fDesc: string;
  public
    constructor Create(const aName, aDesc: string);
    function ExportWikiBody: string;
  end;

  TKMScriptTypeElements = class
  private
    fList: TList<TKMScriptTypeElement>;
  public
    constructor Create;
    destructor Destroy; override;
    procedure ParseFromStringList(aType: TKMTypeType; aStrings: TStringList);
    function ExportCode(aType: TKMTypeType): string;
    function ExportWikiBody: string;
  end;

  // Single type info
  TKMScriptType = class
  private
    fName: string;
    fType: TKMTypeType;
    fDescription: string;
    fElements: TKMScriptTypeElements;
  public
    constructor Create;
    destructor Destroy; override;
    procedure LoadFromStringList(aSource: TStringList);
    function ExportCode: string;
    function ExportWikiBody: string;
    function ExportWikiLink: string;
  end;

  // List of types
  TKMScriptTypes = class
  private
    fList: TObjectList<TKMScriptType>;
    function ExportWikiBody: string;
    function ExportWikiLinks: string;
    function GetCount: Integer;
  public
    constructor Create;
    destructor Destroy; override;

    procedure Clear;
    property Count: Integer read GetCount;
    procedure LoadFromFile(const aInputFile: string);
    procedure SortByName;
    procedure ExportCode(const aCodeFile: string; out aCountReg: Integer);
    function ExportWiki(const aTemplateFile: string; out aCountWiki: Integer): string;
  end;


implementation
uses
  KM_ScriptingConsts, KM_StringUtils;


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
  I: Integer;
  comment: string;
  colonPos, commentPos: Integer;
  declaration: string;
  elements: TStringDynArray;
  K: Integer;
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
                  declaration := aStrings[0];

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
                      Result := Result + '      '#39 + fList[I].fName + '; '#39 + ' +' + sLineBreak;

                    Result := Result + '      '#39'end;'#39;
                  end;
    ttArray:      Result := #39 + fList[0].fName + #39;
    ttSetOfType: ; //todo: ttSetOfType
    ttSetOfEnum: ; //todo: ttSetOfEnum
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

//    if StartsStr('//* Version:', srcLine) then
//    begin
//      fVersion := Trim(RightStrAfter(srcLine, ':'));
//      Inc(I);
//      srcLine := aSource[I];
//    end;

    // Descriptions are only added by lines starting with "//*"
    // Repeat until no description tags are found
    while StartsStr('//*', srcLine) do
    begin
      details.Add(RightStrAfter(srcLine, '* '));
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
      until Pos(')', srcLine) <> 0;
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
begin
  Result := #39 + fName + #39', ' + fElements.ExportCode(fType);
end;


function TKMScriptType.ExportWikiBody: string;
const
  TEMPLATE = '| - | <sub>%s</sub> | <a id="%s">%s</a><sub>%s</sub> |';
  TYPE_NAME: array [TKMTypeType] of string = ('enum', 'record', 'array', 'set', 'set');
begin
  Result := Format(TEMPLATE, [TYPE_NAME[fType], fName, fName, fDescription]) + fElements.ExportWikiBody;
end;


function TKMScriptType.ExportWikiLink: string;
begin
  Result := '* <a href="#' + fName + '">' + fName + '</a>';
end;


{ TKMScriptTypes }
procedure TKMScriptTypes.Clear;
begin
  fList.Clear;
end;


constructor TKMScriptTypes.Create;
begin
  inherited Create;

  fList := TObjectList<TKMScriptType>.Create(
    TComparer<TKMScriptType>.Construct(
      function(const A, B: TKMScriptType): Integer
      begin
        // Case-sensitive compare, since we use CamelCase and it looks nicer that way
        Result := CompareText(A.fName, B.fName);
      end));
end;


destructor TKMScriptTypes.Destroy;
begin
  FreeAndNil(fList);

  inherited;
end;


// Scans source contents and puts it all in proper formatting for most wikis.
procedure TKMScriptTypes.LoadFromFile(const aInputFile: string);
var
  slSource: TStringList;
  I: Integer;
  srcLine: string;
  sl: TStringList;
  sectionStarted: Boolean;
  recordStarted: Boolean;
begin
  slSource := TStringList.Create;
  try
    slSource.LoadFromFile(aInputFile);

    // Assemble method sections 1 by 1

    {
    //* Enum
    TKMSomeType = (stNone,
      //
      stSomething);

    //* Record
    // ignore this comment
    TKMSomeType = record
      A,B: Integer;
      function Some: Byte;
    end;

    //* Array of
    TKMSomeType = array of TKMSomething;

    //* Set of
    TKMSomeType = set of TKMSomething;
    }

    sectionStarted := False;
    recordStarted := False;

    sl := TStringList.Create;
    for I := 0 to slSource.Count - 1 do
    begin
      srcLine := Trim(slSource[I]);

      if not sectionStarted and StartsStr('//* ', srcLine) then
      begin
        sectionStarted := True;
        sl.Clear;
      end;

      //if aInputFile = '..\..\..\..\kam_remake.rey\src\scripting\KM_ScriptingActions.pas' then
      //if I = 1350 then
      //  Sleep(0);

      if sectionStarted then
        if not StartsStr('//', srcLine) or StartsStr('//*', srcLine) then
          sl.Append(srcLine);

      if sectionStarted and not StartsStr('//', srcLine) and (Pos('record', srcLine) > 0) then
        recordStarted := True;

      if sectionStarted and not recordStarted and (StartsStr('procedure', srcLine) or StartsStr('function', srcLine)) then
        sectionStarted := False;

      if sectionStarted and recordStarted and (Pos('end;', srcLine) > 0) then
        recordStarted := False;

      if sectionStarted and not recordStarted and not StartsStr('//*', srcLine) and (Pos(';', srcLine) > 0) then
      begin
        sectionStarted := False;

        fList.Add(TKMScriptType.Create);
        fList.Last.LoadFromStringList(sl);
      end;
    end;
    sl.Free;
  finally
    slSource.Free;
  end;
end;


function TKMScriptTypes.ExportWikiBody: string;
var
  I: Integer;
begin
  Result := '';

  for I := 0 to fList.Count - 1 do
    Result := Result + IfThen(I > 0, sLineBreak) + fList[I].ExportWikiBody;
end;


function TKMScriptTypes.ExportWikiLinks: string;
var
  I: Integer;
begin
  Result := '';

  for I := 0 to fList.Count - 1 do
    Result := Result + IfThen(I > 0, sLineBreak) + fList[I].ExportWikiLink;
end;


function TKMScriptTypes.GetCount: Integer;
begin
  Result := fList.Count;
end;


procedure TKMScriptTypes.SortByName;
begin
  fList.Sort;
end;


procedure TKMScriptTypes.ExportCode(const aCodeFile: string; out aCountReg: Integer);
var
  sl: TStringList;
  secStart, secEnd, pad: Integer;
  I: Integer;
begin
  aCountReg := 0;

  if not FileExists(aCodeFile) then Exit;

  sl := TStringList.Create;
  try
    sl.LoadFromFile(aCodeFile);

    FindStartAndFinish(sl, AREA_REG_TAG[paTypes], secStart, secEnd, pad);

    if secStart <> -1 then
    begin
      for I := secEnd downto secStart do
        sl.Delete(I);

      for I := fList.Count - 1 downto 0 do
      begin
        sl.Insert(secStart, DupeString(' ', pad) + 'Sender.AddTypeS(' + fList[I].ExportCode + ');');
        Inc(aCountReg);
      end;
    end;

    sl.SaveToFile(aCodeFile);
  finally
    sl.Free;
  end;
end;


function TKMScriptTypes.ExportWiki(const aTemplateFile: string; out aCountWiki: Integer): string;
var
  sl: TStringList;
begin
  sl := TStringList.Create;

  sl.LoadFromFile(aTemplateFile);

  sl.Text := StringReplace(sl.Text, '{LINKS}', ExportWikiLinks, []);
  sl.Text := StringReplace(sl.Text, '{TITLE}', AREA_TITLE[paTypes], []);
  sl.Text := StringReplace(sl.Text, '{BODY}', ExportWikiBody, []);

  Result := sl.Text;

  sl.Free;

  // No surprises here, everything gets exported
  aCountWiki := Count;
end;


end.
