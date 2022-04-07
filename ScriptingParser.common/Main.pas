unit Main;
interface
uses
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtDlgs, SysUtils, Windows,
  Classes, StdCtrls, StrUtils, Types, INIFiles, Vcl.ComCtrls,
  KM_ScriptingParser, KM_ScriptingTypes;

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
    edtTemplateFileActions: TEdit;
    edtTemplateFileEvents: TEdit;
    edtTemplateFileStates: TEdit;
    edtTemplateFileUtils: TEdit;
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
  edtTemplateFileActions.Text := ini.ReadString('TEMPLATE', 'Actions', 'template\Actions.template');
  edtTemplateFileEvents.Text  := ini.ReadString('TEMPLATE', 'Events',  'template\Events.template');
  edtTemplateFileStates.Text  := ini.ReadString('TEMPLATE', 'States',  'template\States.template');
  edtTemplateFileUtils.Text   := ini.ReadString('TEMPLATE', 'Utils',   'template\Utils.template');
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
    edtActionsFile.Text, edtTemplateFileActions.Text, edtOutputFileActions.Text,
    edtEventsFile.Text, edtTemplateFileEvents.Text, edtOutputFileEvents.Text,
    edtStatesFile.Text, edtTemplateFileStates.Text, edtOutputFileStates.Text,
    edtUtilsFile.Text, edtTemplateFileUtils.Text, edtOutputFileUtils.Text
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
  ini.WriteString('TEMPLATE', 'Actions', edtTemplateFileActions.Text);
  ini.WriteString('TEMPLATE', 'Events',  edtTemplateFileEvents.Text);
  ini.WriteString('TEMPLATE', 'States',  edtTemplateFileStates.Text);
  ini.WriteString('TEMPLATE', 'Utils',   edtTemplateFileUtils.Text);
  ini.WriteString('OUTPUT', 'Actions', edtOutputFileActions.Text);
  ini.WriteString('OUTPUT', 'Events',  edtOutputFileEvents.Text);
  ini.WriteString('OUTPUT', 'States',  edtOutputFileStates.Text);
  ini.WriteString('OUTPUT', 'Utils',   edtOutputFileUtils.Text);

  FreeAndNil(ini);
end;


end.

