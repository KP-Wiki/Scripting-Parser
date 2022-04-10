unit KM_ScriptingTypes;
interface
uses
  Classes, SysUtils, Types, Vcl.Forms, Windows, Generics.Collections, Generics.Defaults,
  Math, StrUtils,
  KM_ScriptingParameters, KM_ParserTypes;

type
  // There are these base types:
  TKMTypeType = (tEnum, tRecord, tArray, tSet);

  TKMScriptTypeElement = class
  private
    fName: string;
    fDesc: string;
  public
    constructor Create(const aName, aDesc: string);
    function ExportBody: string;
  end;

  TKMScriptTypeElements = class
  private
    fList: TList<TKMScriptTypeElement>;
  public
    constructor Create;
    destructor Destroy; override;
    procedure ParseFromStringList(aType: TKMTypeType; aStrings: TStringList);
    function ExportBody: string;
  end;

  // Single type info
  TKMTypeInfo = class
  private
    fName: string;
    fType: TKMTypeType;
    fDescription: string;
    fElements: TKMScriptTypeElements;
  public
    constructor Create;
    destructor Destroy; override;
    procedure LoadFromStringList(aSource: TStringList);
    function ExportBody: string;
    function ExportLink: string;
  end;

  // List of types
  TKMScriptTypes = class
  private
    fList: TObjectList<TKMTypeInfo>;
    function ExportBody: string;
    function ExportLinks: string;
  public
    constructor Create;
    destructor Destroy; override;

    procedure Clear;
    procedure LoadFromFile(const aInputFile: string);
    procedure SortByName;
    function ExportWiki(const aTemplateFile: string): string;
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


function TKMScriptTypeElement.ExportBody: string;
begin
  Result := '<sub>' + fName + IfThen(fDesc <> '', ' // ' + fDesc) + '</sub>';
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
    tEnum:  begin
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
    tRecord:for I := 0 to aStrings.Count - 1 do
            if (aStrings[I] <> '')
            and (Pos(':', aStrings[I]) > 0) then
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

              fList.Add(TKMScriptTypeElement.Create(declaration, comment));
            end;
    tArray: begin
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

              fList.Add(TKMScriptTypeElement.Create(declaration, comment));
            end;
    tSet:   begin
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

              fList.Add(TKMScriptTypeElement.Create(declaration, comment));
            end;
  end;
end;


function TKMScriptTypeElements.ExportBody: string;
var
  I: Integer;
begin
  Result := '';
  for I := 0 to fList.Count - 1 do
    Result := Result + IfThen(I > 0, '<br/>') + fList[I].ExportBody;
end;


{ TKMTypeInfo }
constructor TKMTypeInfo.Create;
begin
  inherited;

  fElements := TKMScriptTypeElements.Create;
end;


destructor TKMTypeInfo.Destroy;
begin
  FreeAndNil(fElements);

  inherited;
end;


procedure TKMTypeInfo.LoadFromStringList(aSource: TStringList);
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
      fType := tEnum;

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
      fType := tRecord;

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
      fType := tArray;
      enumStr.Text := srcLine;
    end;

    // Parse array - detected by "set of"
    if Pos('set of', srcLine) > 0 then
    begin
      fType := tSet;
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


function TKMTypeInfo.ExportBody: string;
begin
  Result :=
    '| - | <a id="' + fName + '">' + fName + '</a>' +
    '<sub>' + fDescription + '</sub>' + ' | ';

  Result := Result + fElements.ExportBody;
end;


function TKMTypeInfo.ExportLink: string;
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

  fList := TObjectList<TKMTypeInfo>.Create(
    TComparer<TKMTypeInfo>.Construct(
      function(const A, B: TKMTypeInfo): Integer
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

        fList.Add(TKMTypeInfo.Create);
        fList.Last.LoadFromStringList(sl);
      end;
    end;
    sl.Free;
  finally
    slSource.Free;
  end;
end;


function TKMScriptTypes.ExportBody: string;
var
  I: Integer;
begin
  Result := '';

  for I := 0 to fList.Count - 1 do
    Result := Result + IfThen(I > 0, sLineBreak) + fList[I].ExportBody;
end;


function TKMScriptTypes.ExportLinks: string;
var
  I: Integer;
begin
  Result := '';

  for I := 0 to fList.Count - 1 do
    Result := Result + IfThen(I > 0, sLineBreak) + fList[I].ExportLink;
end;


procedure TKMScriptTypes.SortByName;
begin
  fList.Sort;
end;


function TKMScriptTypes.ExportWiki(const aTemplateFile: string): string;
var
  sl: TStringList;
begin
  sl := TStringList.Create;

  sl.LoadFromFile(aTemplateFile);

  sl.Text := StringReplace(sl.Text, '{LINKS}', ExportLinks, []);
  sl.Text := StringReplace(sl.Text, '{TITLE}', AREA_TITLE[paTypes], []);
  sl.Text := StringReplace(sl.Text, '{BODY}', ExportBody, []);

  Result := sl.Text;

  sl.Free;
end;


end.
