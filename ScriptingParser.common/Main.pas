unit Main;
interface
uses
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtDlgs, SysUtils, Windows,
  Classes, StdCtrls, StrUtils, Types, INIFiles, Vcl.ComCtrls,
  KM_ScriptingParser;

type
  TForm1 = class(TForm)
    btnReyKMR: TButton;
    btnKromKMR: TButton;
    btnKromKP: TButton;
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
    procedure btnReyKMRClick(Sender: TObject);
    procedure btnKromKPClick(Sender: TObject);
    procedure btnKromKMRClick(Sender: TObject);
    procedure btnGenerateXMLClick(Sender: TObject);
    procedure TabControl1Change(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    fScriptingParser: TKMScriptingParser;
    fParsingGame: TKMParsingGame;
    fSettingsPath: string;
    fUpdating: Boolean;
    procedure LoadSettings;
    procedure SaveSettings;
  end;

var
  Form1: TForm1;


implementation
{$R *.dfm}


{ TForm1 }
procedure TForm1.FormCreate(Sender: TObject);
begin
  fScriptingParser := TKMScriptingParser.Create;

  btnReyKMR.Click;
end;


procedure TForm1.FormDestroy(Sender: TObject);
begin
  FreeAndNil(fScriptingParser);
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
  txtParserOutput.Text := fScriptingParser.GetText(TKMParsingArea(TabControl1.TabIndex));
end;


procedure TForm1.btnGenerateWikiClick(Sender: TObject);
begin
  fScriptingParser.GenerateWiki(
    fParsingGame,
    edtActionsFile.Text, edtHeaderFileActions.Text, edtOutputFileActions.Text,
    edtEventsFile.Text, edtHeaderFileEvents.Text, edtOutputFileEvents.Text,
    edtStatesFile.Text, edtHeaderFileStates.Text, edtOutputFileStates.Text,
    edtUtilsFile.Text, edtHeaderFileUtils.Text, edtOutputFileUtils.Text
  );

  TabControl1Change(nil);
end;


procedure TForm1.btnGenerateXMLClick(Sender: TObject);
begin
  fScriptingParser.GenerateXML;
end;


procedure TForm1.txtParserOutputKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = ^A then
  begin
    (Sender as TMemo).SelectAll;
    Key := #0;
  end;
end;


procedure TForm1.btnReyKMRClick(Sender: TObject);
begin
  // Rey KaM
  fParsingGame := pgKaMRemake;
  fSettingsPath := ExtractFilePath(ParamStr(0)) + 'ScriptingParser.rey.kmr.ini';
  LoadSettings;
end;


procedure TForm1.btnKromKMRClick(Sender: TObject);
begin
  // Krom KaM
  fParsingGame := pgKaMRemake;
  fSettingsPath := ExtractFilePath(ParamStr(0)) + 'ScriptingParser.krom.kmr.ini';
  LoadSettings;
end;


procedure TForm1.btnKromKPClick(Sender: TObject);
begin
  // Krom KP
  fParsingGame := pgKnightsProvince;
  fSettingsPath := ExtractFilePath(ParamStr(0)) + 'ScriptingParser.krom.kp.ini';
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
