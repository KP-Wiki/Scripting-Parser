unit Main;
interface
uses
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtDlgs, SysUtils, Windows,
  Classes, StdCtrls, StrUtils, Types, INIFiles, Vcl.ComCtrls,
  KM_ScriptingParser, KM_ParserTypes;

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
    edActionsIn: TEdit;
    edEventsIn: TEdit;
    edStatesIn: TEdit;
    edActionsOut: TEdit;
    edEventsOut: TEdit;
    edStatesOut: TEdit;
    edUtilsOut: TEdit;
    edUtilsIn: TEdit;
    edActionsTemplate: TEdit;
    edEventsTemplate: TEdit;
    edStatesTemplate: TEdit;
    edUtilsTemplate: TEdit;
    Label7: TLabel;
    edTypesOut: TEdit;
    edTypesIn: TEdit;
    edTypesTemplate: TEdit;
    Label9: TLabel;
    edActionsVerify: TEdit;
    edEventsVerify: TEdit;
    edStatesVerify: TEdit;
    edUtilsVerify: TEdit;
    edTypesVerify: TEdit;
    btnGenerateCode: TButton;
    meLog: TMemo;
    procedure FormCreate(Sender: TObject);
    procedure btnGenerateWikiClick(Sender: TObject);
    procedure txtParserOutputKeyPress(Sender: TObject; var Key: Char);
    procedure edtOnTextChange(Sender: TObject);
    procedure btnReyKMRClick(Sender: TObject);
    procedure btnKromKPClick(Sender: TObject);
    procedure btnKromKMRClick(Sender: TObject);
    procedure btnGenerateXMLClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure btnGenerateCodeClick(Sender: TObject);
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
  fScriptingParser := TKMScriptingParser.Create(
    procedure (aMsg: string)
    begin
      meLog.Lines.Append(aMsg);
    end);

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

  edActionsIn.Text       := ini.ReadString('INPUT',  'Actions', '..\..\src\scripting\KM_ScriptingActions.pas');
  edEventsIn.Text        := ini.ReadString('INPUT',  'Events',  '..\..\src\scripting\KM_ScriptingEvents.pas');
  edStatesIn.Text        := ini.ReadString('INPUT',  'States',  '..\..\src\scripting\KM_ScriptingStates.pas');
  edUtilsIn.Text         := ini.ReadString('INPUT',  'Utils',   '..\..\src\scripting\KM_ScriptingUtils.pas');
  edTypesIn.Text         := ini.ReadString('INPUT',  'Types',   '..\..\src\scripting\KM_ScriptingEnginePS.pas');
  edActionsTemplate.Text := ini.ReadString('TEMPLATE', 'Actions', 'template\Actions.template');
  edEventsTemplate.Text  := ini.ReadString('TEMPLATE', 'Events',  'template\Events.template');
  edStatesTemplate.Text  := ini.ReadString('TEMPLATE', 'States',  'template\States.template');
  edUtilsTemplate.Text   := ini.ReadString('TEMPLATE', 'Utils',   'template\Utils.template');
  edTypesTemplate.Text   := ini.ReadString('TEMPLATE', 'Types',   'template\Types.template');
  edActionsOut.Text := ini.ReadString('OUTPUT', 'Actions', 'Actions.wiki');
  edEventsOut.Text  := ini.ReadString('OUTPUT', 'Events',  'Events.wiki');
  edStatesOut.Text  := ini.ReadString('OUTPUT', 'States',  'States.wiki');
  edUtilsOut.Text   := ini.ReadString('OUTPUT', 'Utils',   'Utils.wiki');
  edTypesOut.Text   := ini.ReadString('OUTPUT', 'Types',   'Types.wiki');
  edActionsVerify.Text := ini.ReadString('VERIFY', 'Actions', '.pas');
  edEventsVerify.Text  := ini.ReadString('VERIFY', 'Events',  '.pas');
  edStatesVerify.Text  := ini.ReadString('VERIFY', 'States',  '.pas');
  edUtilsVerify.Text   := ini.ReadString('VERIFY', 'Utils',   '.pas');
  edTypesVerify.Text   := ini.ReadString('VERIFY', 'Types',   '.pas');

  FreeAndNil(ini);

  fUpdating := False;

  if not FileExists(fSettingsPath) then
    SaveSettings;
end;


procedure TForm1.btnGenerateCodeClick(Sender: TObject);
begin
  meLog.Clear;
  meLog.Lines.Append(GAME_INFO[fParsingGame].Name + ' code export:');
  meLog.Lines.Append(DupeString('-', 50));

  fScriptingParser.GenerateCode(fParsingGame, paActions, edActionsIn.Text, edActionsVerify.Text);
  fScriptingParser.GenerateCode(fParsingGame, paEvents,  edEventsIn.Text,  edEventsVerify.Text);
  fScriptingParser.GenerateCode(fParsingGame, paStates,  edStatesIn.Text,  edStatesVerify.Text);
  fScriptingParser.GenerateCode(fParsingGame, paUtils,   edUtilsIn.Text,   edUtilsVerify.Text);
  fScriptingParser.GenerateCode(fParsingGame, paTypes,   edTypesIn.Text,   edTypesVerify.Text);
end;


procedure TForm1.btnGenerateWikiClick(Sender: TObject);
begin
  meLog.Clear;
  meLog.Lines.Append(GAME_INFO[fParsingGame].Name + ' wiki export:');
  meLog.Lines.Append(DupeString('-', 50));

  fScriptingParser.GenerateWiki(fParsingGame, paActions, edActionsIn.Text, edActionsTemplate.Text, edActionsOut.Text);
  fScriptingParser.GenerateWiki(fParsingGame, paEvents,  edEventsIn.Text,  edEventsTemplate.Text,  edEventsOut.Text);
  fScriptingParser.GenerateWiki(fParsingGame, paStates,  edStatesIn.Text,  edStatesTemplate.Text,  edStatesOut.Text);
  fScriptingParser.GenerateWiki(fParsingGame, paUtils,   edUtilsIn.Text,   edUtilsTemplate.Text,   edUtilsOut.Text);
  fScriptingParser.GenerateWiki(fParsingGame, paTypes,   edTypesIn.Text,   edTypesTemplate.Text,   edTypesOut.Text);
end;


procedure TForm1.btnGenerateXMLClick(Sender: TObject);
begin
  meLog.Clear;

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

  ini.WriteString('INPUT',  'Actions', edActionsIn.Text);
  ini.WriteString('INPUT',  'Events',  edEventsIn.Text);
  ini.WriteString('INPUT',  'States',  edStatesIn.Text);
  ini.WriteString('INPUT',  'Utils',   edUtilsIn.Text);
  ini.WriteString('INPUT',  'Types',   edTypesIn.Text);
  ini.WriteString('TEMPLATE', 'Actions', edActionsTemplate.Text);
  ini.WriteString('TEMPLATE', 'Events',  edEventsTemplate.Text);
  ini.WriteString('TEMPLATE', 'States',  edStatesTemplate.Text);
  ini.WriteString('TEMPLATE', 'Utils',   edUtilsTemplate.Text);
  ini.WriteString('TEMPLATE', 'Types',   edTypesTemplate.Text);
  ini.WriteString('OUTPUT', 'Actions', edActionsOut.Text);
  ini.WriteString('OUTPUT', 'Events',  edEventsOut.Text);
  ini.WriteString('OUTPUT', 'States',  edStatesOut.Text);
  ini.WriteString('OUTPUT', 'Utils',   edUtilsOut.Text);
  ini.WriteString('OUTPUT', 'Types',   edTypesOut.Text);
  ini.WriteString('VERIFY', 'Actions', edActionsVerify.Text);
  ini.WriteString('VERIFY', 'Events',  edEventsVerify.Text);
  ini.WriteString('VERIFY', 'States',  edStatesVerify.Text);
  ini.WriteString('VERIFY', 'Utils',   edUtilsVerify.Text);
  ini.WriteString('VERIFY', 'Types',   edTypesVerify.Text);

  FreeAndNil(ini);
end;


end.

