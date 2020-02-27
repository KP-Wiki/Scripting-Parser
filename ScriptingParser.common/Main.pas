unit Main;
interface
uses
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtDlgs, SysUtils,
  Classes, StdCtrls, StrUtils, Types, INIFiles, Vcl.ComCtrls;

type
  TForm1 = class(TForm)
    btnKMR: TButton;
    btnKP: TButton;
    btnGenerateWiki: TButton;
    btnGenerateXML: TButton;
    gbSettings: TGroupBox;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label8: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    edtActionsFile: TEdit;
    edtEventsFile: TEdit;
    edtStatesFile: TEdit;
    edtOutputFileActions: TEdit;
    edtOutputFileEvents: TEdit;
    edtOutputFileStates: TEdit;
    edtOutputFileUtils: TEdit;
    edtUtilsFile: TEdit;
    edtHeaderFileActions: TEdit;
    edtHeaderFileEvents: TEdit;
    edtHeaderFileStates: TEdit;
    edtHeaderFileUtils: TEdit;
    TabControl1: TTabControl;
    txtParserOutput: TMemo;
    procedure FormCreate(Sender: TObject);
    procedure btnGenerateWikiClick(Sender: TObject);
    procedure txtParserOutputKeyPress(Sender: TObject; var Key: Char);
    procedure edtOnTextChange(Sender: TObject);
    procedure btnKMRClick(Sender: TObject);
    procedure btnKPClick(Sender: TObject);
    procedure btnGenerateXMLClick(Sender: TObject);
    procedure TabControl1Change(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    fListActions, fListEvents, fListStates, fListUtils: TStringList;
    fSettingsPath: string;
    fUpdating: Boolean;
    procedure ParseText(aFile: string; aList: TStringList; aHasReturn: Boolean);
    function ParseParams(aString: string; aDescriptions: TStringList): string;
    procedure LoadSettings;
    procedure SaveSettings;
    procedure GenerateWiki;
    procedure GenerateXML;
  end;

  TParamHolder = record
    Name, varType: string;
  end;

  TCommandInfo = record
    Version: string;
    Name: string;
    Description: string;
    Parameters: string;
    Return: string;
    ReturnDesc: string;
  end;

  TKMTypeInfo = record
    Name: string;
    Alias: string;
  end;

const
  VAR_TYPE_COUNT = 45;

  VAR_MODIFIERS: array[0..1] of String = ('out', 'var');
  VAR_TYPE_INFO: array[0..VAR_TYPE_COUNT-1] of TKMTypeInfo = (
    // Simple types
    (Name: 'Byte'),       (Name: 'Shortint'),   (Name: 'Smallint'),   (Name: 'Word'),
    (Name: 'Integer'),    (Name: 'Cardinal'),   (Name: 'Single'),     (Name: 'Extended'),
    (Name: 'Boolean'),    (Name: 'AnsiString'), (Name: 'String'),
    (Name: 'array of const'),      (Name: 'array of Boolean'),
    (Name: 'array of String'),     (Name: 'array of AnsiString'),
    (Name: 'array of Integer'),    (Name: 'array of Single'),
    (Name: 'array of Extended'),
    // Custom types
    (Name: 'TKMPoint'), (Name: 'TKMHouseType'), (Name: 'TKMWareType'), (Name: 'TKMFieldType'), (Name: 'TKMUnitType'),
    // KMR
    (Name: 'TKMArmyType'), (Name: 'TKMGroupOrder'),
    (Name: 'TKMTerrainTileBrief'), (Name: 'TKMMissionDifficulty'), (Name: 'TKMMissionDifficultySet'),
    (Name: 'array of TKMTerrainTileBrief'), (Name: 'TKMAudioFormat'), (Name: 'TKMAIAttackTarget'),
    // KP
    (Name: 'TKMHouseFace'), (Name: 'TKMObjectiveStatus'), (Name: 'TKMObjectiveType'),
    // Werewolf types
    (Name: 'TByteSet'; Alias: 'set of Byte'), (Name: 'TIntegerArray'; Alias: 'array of Integer'), (Name: 'TAnsiStringArray'; Alias: 'array of AnsiString'),
    (Name: 'TKMHouse'; Alias: 'Integer'), (Name: 'TKMUnit'; Alias: 'Integer'), (Name: 'TKMUnitGroup'; Alias: 'Integer'),
    // KMR
    (Name: 'TKMHandID'; Alias: 'Integer'), (Name: 'array of TKMHandID'; Alias: 'array of Integer'),
    // KP
    (Name: 'TKMEntity'; Alias: 'Integer'), (Name: 'TKMHandIndex'; Alias: 'Integer'), (Name: 'array of TKMHandIndex'; Alias: 'array of Integer')
  );

var
  Form1: TForm1;

  function StrSubstring(const aStr: String; aFrom: Integer): String;


implementation
{$R *.dfm}


{String functions
These function are replacements for String functions introduced after XE2 (XE5 probably)
Names are the same as in new Delphi versions, but with 'Str' prefix
We keep them here to support pre-XE5 compilation
}
function StrIndexOf(const aStr, aSubStr: String): Integer;
begin
  //Todo refactor:
  //@Krom: Why not just replace StrIndexOf with Pos everywhere in code?
  Result := Pos(aSubStr, aStr) - 1;
end;


function StrLastIndexOf(const aStr, aSubStr: String): Integer;
var I: Integer;
begin
  Result := -1;
  for I := 1 to Length(aStr) do
    if AnsiPos(aSubStr, StrSubstring(aStr, I-1)) <> 0 then
      Result := I - 1;
end;


function StrSubstring(const aStr: String; aFrom: Integer): String;
begin
  //Todo refactor:
  //@Krom: Why not just replace StrSubstring with RightStr everywhere in code?
  Result := Copy(aStr, aFrom + 1, Length(aStr));
end;


function StrTrimRightSeparators(const aStr: String): String;
var
  I, K: Integer;
begin
  K := 0;
  for I := Length(aStr) downto 1 do
  if not (aStr[I] in [',', ':', ';']) then
  begin
    K := I;
    Break;
  end;
  Result := Copy(aStr, 1, K);
end;


procedure StrSplit(const aStr, aDelimiters: String; aStrings: TStringList);
var
  StrArray: TStringDynArray;
  I: Integer;
begin
  StrArray := SplitString(aStr, aDelimiters);
  for I := Low(StrArray) to High(StrArray) do
    aStrings.Add(StrArray[I]);
end;


{ TForm1 }
procedure TForm1.FormCreate(Sender: TObject);
begin
  fListActions := TStringList.Create;
  fListEvents := TStringList.Create;
  fListStates := TStringList.Create;
  fListUtils := TStringList.Create;

  btnKMR.Click;
end;


procedure TForm1.FormDestroy(Sender: TObject);
begin
  FreeAndNil(fListActions);
  FreeAndNil(fListEvents);
  FreeAndNil(fListStates);
  FreeAndNil(fListUtils);
end;


procedure TForm1.LoadSettings;
var
  ini: TINIFile;
begin
  ini := TINIFile.Create(fSettingsPath);

  fUpdating := True;

  edtActionsFile.Text       := ini.ReadString('INPUT',  'Actions', '..\..\src\scripting\KM_ScriptingActions.pas');
  edtEventsFile.Text        := ini.ReadString('INPUT',  'Events',  '..\..\src\scripting\KM_ScriptingEvents.pas');
  edtStatesFile.Text        := ini.ReadString('INPUT',  'States',  '..\..\src\scripting\KM_ScriptingStates.pas');
  edtUtilsFile.Text         := ini.ReadString('INPUT',  'Utils',   '..\..\src\scripting\KM_ScriptingUtils.pas');
  edtHeaderFileActions.Text := ini.ReadString('HEADER', 'Actions', 'header\Actions.header');
  edtHeaderFileEvents.Text  := ini.ReadString('HEADER', 'Events',  'header\Events.header');
  edtHeaderFileStates.Text  := ini.ReadString('HEADER', 'States',  'header\States.header');
  edtHeaderFileUtils.Text   := ini.ReadString('HEADER', 'Utils',   'header\Utils.header');
  edtOutputFileActions.Text := ini.ReadString('OUTPUT', 'Actions', 'Actions.wiki');
  edtOutputFileEvents.Text  := ini.ReadString('OUTPUT', 'Events',  'Events.wiki');
  edtOutputFileStates.Text  := ini.ReadString('OUTPUT', 'States',  'States.wiki');
  edtOutputFileUtils.Text   := ini.ReadString('OUTPUT', 'Utils',   'Utils.wiki');

  FreeAndNil(ini);

  fUpdating := False;

  if not FileExists(fSettingsPath) then
    SaveSettings;
end;


procedure TForm1.TabControl1Change(Sender: TObject);
begin
  txtParserOutput.Lines.Clear;
  case TabControl1.TabIndex of
    0: txtParserOutput.Lines.AddStrings(fListActions);
    1: txtParserOutput.Lines.AddStrings(fListEvents);
    2: txtParserOutput.Lines.AddStrings(fListStates);
    3: txtParserOutput.Lines.AddStrings(fListUtils);
  end;
end;

{
  Parses the param string into prefered wiki-format.
  Results:
  1 - [name]: [type];
  2 - etc
}
function TForm1.ParseParams(aString: string; aDescriptions: TStringList): string;
var
  i, j, K, nextType: Integer;
  isParam: Boolean;
  listTokens, paramList, typeList: TStringList;
  paramHolder: array of TParamHolder;
  lastType: string;
  nextVarModifier: String;
begin
  Result := '';

  listTokens := TStringList.Create;
  paramList := TStringList.Create;
  typeList  := TStringList.Create;
  try
    // If not set to -1 it skips the first variable
    nextType := -1;
    nextVarModifier := '';

    StrSplit(aString, ' ', listTokens);

    // Re-combine type arrays
    for i := 0 to listTokens.Count - 1 do
    begin
      listTokens[i] := StrTrimRightSeparators(listTokens[i]);

      if SameText(listTokens[i], 'array') then
      begin
        nextType := i + 2;
        // For some reason this kept giving 'array of Integer;' hence the trim
        paramList.Add(StrTrimRightSeparators(listTokens[i] + ' ' + listTokens[nextType - 1] + ' ' + listTokens[nextType]));
      end else
        // Skip unused stuff
        if not ((SameText(listTokens[i], 'of'))
             or (SameText(listTokens[i], 'const'))
             or (i = nextType)) then
          paramList.Add(listTokens[i]);
    end;

    //Check for 'out' and 'var' variables modifiers (they are in paramList now)
    nextVarModifier := '';
    for i := 0 to paramList.Count - 1 do
    begin
      // See if this token is a Type
      isParam := True;
      for K := 0 to High(VAR_MODIFIERS) do
        if SameText(VAR_MODIFIERS[K], paramList[i]) then
        begin
          nextVarModifier := VAR_MODIFIERS[K];
          paramList[i] := ''; //modifier is not a param
          isParam := False;
          Break;
        end;

      //Update var names until first type found
      if isParam then
        for K := 0 to High(VAR_TYPE_INFO) do
          if SameText(VAR_TYPE_INFO[K].Name, paramList[i]) then
          begin
            nextVarModifier := '';
            isParam := False;
            Break;
          end;

      //Update var name (add modifier to it)
      if isParam and (nextVarModifier <> '') then
        paramList[i] := nextVarModifier + ' ' + paramList[i];
    end;

    // Bind variable names to their type
    // Use reverse scan, so that we can remember last met type and apply it to all preceeding parameters
    lastType := '';
    for i := paramList.Count - 1 downto 0 do
    begin
      if paramList[i] = '' then // Skip empty params (f.e. modifiers "var" or "out")
        Continue;

      // See if this token is a Type
      isParam := True;
      for K := 0 to High(VAR_TYPE_INFO) do
        if SameText(VAR_TYPE_INFO[K].Name, paramList[i]) then
        begin
          lastType := IfThen(VAR_TYPE_INFO[K].Alias <> '', VAR_TYPE_INFO[K].Alias, VAR_TYPE_INFO[K].Name);
          isParam := False;
          Break;
        end;

      if isParam then
      begin
        SetLength(paramHolder, Length(paramHolder) + 1);
        paramHolder[High(paramHolder)].Name := paramList[i];
        paramHolder[High(paramHolder)].varType := lastType;
      end;
    end;

    // Add line-breaks
    for i := High(paramHolder) downto 0 do
    begin
      Result := Result + '**' + paramHolder[i].Name + '**: ' + paramHolder[i].varType + ';';

      // Add micro descriptions to the parameters and remove them from the stringlist.
      for j := aDescriptions.Count - 1 downto 0 do
        if StartsStr(paramHolder[i].Name, aDescriptions[j]) then
        begin
          Result := Result + ' //_' + StrSubstring(aDescriptions[j], StrIndexOf(aDescriptions[j], ':') + 2) + '_';
          aDescriptions.Delete(j);
          Break;
        end;

      if i <> 0 then
        Result := Result + ' <br/> ';
    end;
  finally
    FreeAndNil(listTokens);
    FreeAndNil(paramList);
    FreeAndNil(typeList);
  end;
end;


// Scans file's contents and puts it all in proper formatting for most wikis.
procedure TForm1.ParseText(aFile: string; aList: TStringList; aHasReturn: Boolean);
var
  i, j, iPlus: Integer;
  restStr: string;
  slSourceText, descrTxt: TStringList;
  srcLine: string;
  res: TCommandInfo;
begin
  slSourceText := TStringList.Create;
  descrTxt  := TStringList.Create;
  try
    slSourceText.LoadFromFile(aFile);

    for i := 0 to slSourceText.Count - 1 do
    begin
      // Reset old values
      res := default(TCommandInfo);
      iPlus := 0;
      descrTxt.Clear;

      //* Version: 1234
      //* Large description of the method, optional
      //* aX: Small optional description of parameter
      //* aY: Small optional description of parameter
      //* Result: Small optional description of returned value

      // Before anything it should start with "//* Version:"
      if StartsStr('//* Version:', slSourceText[i]) then
      begin
        restStr := Trim(StrSubstring(slSourceText[i], StrIndexOf(slSourceText[i], ':') + 2));
        res.Version := IfThen(restStr = '', '-', restStr);
        Inc(iPlus);
        srcLine := slSourceText[i+iPlus];

        // Descriptions are only added by lines starting with "//*"
        // Repeat until no description tags are found
        while StartsStr('//*', srcLine) do
        begin
          // Handle Result description separately to keep the output clean.
          if StartsStr('//* Result:', srcLine) then
            res.ReturnDesc := StrSubstring(srcLine, StrIndexOf(srcLine, ':') + 2)
          else
            descrTxt.Add(StrSubstring(srcLine, StrIndexOf(srcLine, '*') + 2));
          Inc(iPlus);
          srcLine := slSourceText[i+iPlus];
        end;

        // Skip empty or "faulty" lines
        while not StartsStr('procedure', srcLine)
        and not StartsStr('function', srcLine) do
        begin
          Inc(iPlus);
          srcLine := slSourceText[i+iPlus];
        end;

        // Format procedures
        if StartsStr('procedure', srcLine) then
        begin
          if Pos('(', srcLine) <> 0 then
          begin
            restStr := Copy(srcLine, StrIndexOf(srcLine, '.') + 2,
                            StrIndexOf(srcLine, '(') - (StrIndexOf(srcLine, '.') + 1));
            res.Name := ReplaceStr(restStr, 'Proc', 'On');
            res.Parameters := ParseParams(Copy(srcLine, StrIndexOf(srcLine, '(') + 2,
                                                                   StrIndexOf(srcLine, ')') - (
                                                                   StrIndexOf(srcLine, '(') + 1)), descrTxt);
          end else
          begin
            restStr := Copy(srcLine, StrIndexOf(srcLine, '.') + 2,
                            StrIndexOf(srcLine, ';') - (StrIndexOf(srcLine, '.') + 1));
            res.Name := ReplaceStr(restStr, 'Proc', 'On');
          end;
        end;

        // Format functions
        if StartsStr('function', srcLine) then
        begin
          if Pos('(', srcLine) <> 0 then
          begin
            restStr := Copy(srcLine, StrIndexOf(srcLine, '.') + 2,
                            StrIndexOf(srcLine, '(') - (StrIndexOf(srcLine, '.') + 1));
            res.Name := ReplaceStr(restStr, 'Func', 'On');
            res.Parameters := ParseParams(Copy(srcLine, StrIndexOf(srcLine, '(') + 2,
                                                                   StrIndexOf(srcLine, ')') - (
                                                                   StrIndexOf(srcLine, '(') + 1)), descrTxt);
          end else
          begin
            restStr := Copy(srcLine, StrIndexOf(srcLine, '.') + 2,
                            StrIndexOf(srcLine, ':') - (StrIndexOf(srcLine, '.') + 1));
            res.Name := ReplaceStr(restStr, 'Func', 'On');
          end;

          restStr  := StrTrimRightSeparators(StrSubstring(srcLine, StrLastIndexOf(srcLine, ':') + 2));
          res.Return  := IfThen(SameText(restStr, 'TIntegerArray'), 'array of Integer', restStr);
        end;

        // Now we can assemble Description, after we have detected and removed parameters descriptions from it
        for j := 0 to descrTxt.Count - 1 do
          // We don't need <br/> after </pre> since </pre> has an automatic visual "br" after it
          if (j > 0) and (RightStr(descrTxt[j-1],6) = '</pre>') then
            res.Description := res.Description + descrTxt[j]
          else
            res.Description := res.Description + '<br/>' + descrTxt[j];


        // Now we have all the parts and can combine them however we like
        aList.Add('| ' + res.Version + ' | ' + res.Name + '<sub>' + res.Description + '</sub>' +
                  ' | <sub>' + res.Parameters + '</sub>' +
                  IfThen(aHasReturn, ' | <sub>' + res.Return + IfThen(res.ReturnDesc <> '', ' //' + res.ReturnDesc) + '</sub>') +
                  ' |');
      end;
    end;
  finally
    FreeAndNil(slSourceText);
    FreeAndNil(descrTxt);
  end;
end;


function DoSort(List: TStringList; Index1, Index2: Integer): Integer;
var
  A, B: string;
begin
  A := List[Index1];
  B := List[Index2];
  // Sort in assumption that method name is in the second || clause
  A := Copy(A, PosEx('| ', A, 2) + 2, 40);
  B := Copy(B, PosEx('| ', B, 2) + 2, 40);
  Result := CompareText(A, B);
end;


procedure TForm1.btnGenerateWikiClick(Sender: TObject);
begin
  GenerateWiki;
end;


procedure TForm1.GenerateWiki;

  procedure ParseList(aName: String; aResultList: TStringList; aInputFile,aHeaderFile,aOutputFile: String; aHasReturn: Boolean = True);
  var
    tmpList: TStringList;
    Path: String;
  begin
    if not FileExists(aInputFile) then Exit;

    tmpList := TStringList.Create;

    aResultList.Clear;
    tmpList.Clear;
    ParseText(aInputFile, tmpList, aHasReturn);
    tmpList.CustomSort(DoSort);

    if FileExists(aHeaderFile) then
      aResultList.LoadFromFile(aHeaderFile);

    if aHasReturn then
    begin
      aResultList.Add('| Ver<br/>sion | ' + aName + ' Description | Parameters<br/>and types | Returns |');
      aResultList.Add('| ------- | ------------------------------------ | -------------- | ------- |');
    end else begin
      aResultList.Add('| Ver<br/>sion | ' + aName + ' Description | Parameters<br/>and types |');
      aResultList.Add('| ------- | ------------------------------------ | -------------- |');
    end;

    aResultList.AddStrings(tmpList);

    if aOutputFile <> '' then
    begin
      Path := ExpandFileName(ExtractFilePath(ParamStr(0)) + aOutputFile);
      if not DirectoryExists(ExtractFileDir(Path)) then
        ForceDirectories(ExtractFileDir(Path));
      aResultList.SaveToFile(aOutputFile);
    end;

    FreeAndNil(tmpList);
  end;

begin
  ParseList('Action', fListActions, edtActionsFile.Text, edtHeaderFileActions.Text, edtOutputFileActions.Text);
  ParseList('Event', fListEvents, edtEventsFile.Text, edtHeaderFileEvents.Text, edtOutputFileEvents.Text, False);
  ParseList('State', fListStates, edtStatesFile.Text, edtHeaderFileStates.Text, edtOutputFileStates.Text);
  ParseList('Utility function<br/>', fListUtils, edtUtilsFile.Text, edtHeaderFileUtils.Text, edtOutputFileUtils.Text);

  TabControl1Change(nil);
end;


procedure TForm1.btnGenerateXMLClick(Sender: TObject);
begin
  GenerateXML;
end;


procedure TForm1.GenerateXML;
begin
  //
end;


procedure TForm1.txtParserOutputKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = ^A then
  begin
    (Sender as TMemo).SelectAll;
    Key := #0;
  end;
end;


procedure TForm1.btnKMRClick(Sender: TObject);
begin
  // KaM
  fSettingsPath := ExtractFilePath(ParamStr(0)) + 'ScriptingParser.kmr.ini';
  LoadSettings;
end;


procedure TForm1.btnKPClick(Sender: TObject);
begin
  // KP
  fSettingsPath := ExtractFilePath(ParamStr(0)) + 'ScriptingParser.kp.ini';
  LoadSettings;
end;


procedure TForm1.edtOnTextChange(Sender: TObject);
begin
  if fUpdating then Exit;

  SaveSettings;
end;


procedure TForm1.SaveSettings;
var
  ini: TINIFile;
begin
  ini := TINIFile.Create(fSettingsPath);

  ini.WriteString('INPUT',  'Actions', edtActionsFile.Text);
  ini.WriteString('INPUT',  'Events',  edtEventsFile.Text);
  ini.WriteString('INPUT',  'States',  edtStatesFile.Text);
  ini.WriteString('INPUT',  'Utils',   edtUtilsFile.Text);
  ini.WriteString('HEADER', 'Actions', edtHeaderFileActions.Text);
  ini.WriteString('HEADER', 'Events',  edtHeaderFileEvents.Text);
  ini.WriteString('HEADER', 'States',  edtHeaderFileStates.Text);
  ini.WriteString('HEADER', 'Utils',   edtHeaderFileUtils.Text);
  ini.WriteString('OUTPUT', 'Actions', edtOutputFileActions.Text);
  ini.WriteString('OUTPUT', 'Events',  edtOutputFileEvents.Text);
  ini.WriteString('OUTPUT', 'States',  edtOutputFileStates.Text);
  ini.WriteString('OUTPUT', 'Utils',   edtOutputFileUtils.Text);

  FreeAndNil(ini);
end;


end.
