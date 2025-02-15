unit FormScriptingParser;
interface
uses
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtDlgs, SysUtils, Windows,
  Classes, StdCtrls, StrUtils, Types, INIFiles, Vcl.ComCtrls,
  KM_ScriptingParser, KM_ParserTypes;

type
  TfmScriptingParser = class(TForm)
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
    edActionsCode: TEdit;
    edEventsCode: TEdit;
    edStatesCode: TEdit;
    edUtilsCode: TEdit;
    edTypesCode: TEdit;
    btnGenerateCode: TButton;
    meLog: TMemo;
    edEventsCode2: TEdit;
    procedure FormCreate(Sender: TObject);
    procedure btnGenerateWikiClick(Sender: TObject);
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


implementation
{$R *.dfm}


{ TfmScriptingParser }
procedure TfmScriptingParser.FormCreate(Sender: TObject);
begin
  fScriptingParser := TKMScriptingParser.Create(
    procedure (aMsg: string)
    begin
      meLog.Lines.Append(aMsg);
    end);

  btnReyKMR.Click;
end;


procedure TfmScriptingParser.FormDestroy(Sender: TObject);
begin
  FreeAndNil(fScriptingParser);
end;


procedure TfmScriptingParser.LoadSettings;
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
  edActionsCode.Text := ini.ReadString('CODE', 'Actions', '.pas');
  edEventsCode.Text  := ini.ReadString('CODE', 'Events',  '.pas');
  edEventsCode2.Text  := ini.ReadString('CODE', 'Events2',  '.pas');
  edStatesCode.Text  := ini.ReadString('CODE', 'States',  '.pas');
  edUtilsCode.Text   := ini.ReadString('CODE', 'Utils',   '.pas');
  edTypesCode.Text   := ini.ReadString('CODE', 'Types',   '.pas');

  FreeAndNil(ini);

  fUpdating := False;

  if not FileExists(fSettingsPath) then
    SaveSettings;
end;


procedure TfmScriptingParser.btnGenerateCodeClick(Sender: TObject);
begin
  meLog.Clear;
  meLog.Lines.Append(GAME_INFO[fParsingGame].Name + ' code export:');
  meLog.Lines.Append(DupeString('-', 50));

  fScriptingParser.GenerateCode(fParsingGame, paActions, edActionsIn.Text, edActionsCode.Text, '');
  fScriptingParser.GenerateCode(fParsingGame, paEvents,  edEventsIn.Text,  edEventsCode.Text, edEventsCode2.Text);
  fScriptingParser.GenerateCode(fParsingGame, paStates,  edStatesIn.Text,  edStatesCode.Text, '');
  fScriptingParser.GenerateCode(fParsingGame, paUtils,   edUtilsIn.Text,   edUtilsCode.Text, '');
  fScriptingParser.GenerateCode(fParsingGame, paTypes,   edTypesIn.Text,   edTypesCode.Text, '');
end;


procedure TfmScriptingParser.btnGenerateWikiClick(Sender: TObject);
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


procedure TfmScriptingParser.btnGenerateXMLClick(Sender: TObject);
begin
  meLog.Clear;

  fScriptingParser.GenerateXML;
end;


procedure TfmScriptingParser.btnReyKMRClick(Sender: TObject);
begin
  // Rey KaM
  fParsingGame := pgKaMRemake;
  fSettingsPath := ExtractFilePath(ParamStr(0)) + 'ScriptingParser.rey.kmr.ini';
  LoadSettings;
end;


procedure TfmScriptingParser.btnKromKMRClick(Sender: TObject);
begin
  // Krom KaM
  fParsingGame := pgKaMRemake;
  fSettingsPath := ExtractFilePath(ParamStr(0)) + 'ScriptingParser.krom.kmr.ini';
  LoadSettings;
end;


procedure TfmScriptingParser.btnKromKPClick(Sender: TObject);
begin
  // Krom KP
  fParsingGame := pgKnightsProvince;
  fSettingsPath := ExtractFilePath(ParamStr(0)) + 'ScriptingParser.krom.kp.ini';
  LoadSettings;
end;


procedure TfmScriptingParser.edtOnTextChange(Sender: TObject);
begin
  if fUpdating then Exit;

  SaveSettings;
end;


procedure TfmScriptingParser.SaveSettings;
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
  ini.WriteString('CODE', 'Actions', edActionsCode.Text);
  ini.WriteString('CODE', 'Events',  edEventsCode.Text);
  ini.WriteString('CODE', 'Events2',  edEventsCode2.Text);
  ini.WriteString('CODE', 'States',  edStatesCode.Text);
  ini.WriteString('CODE', 'Utils',   edUtilsCode.Text);
  ini.WriteString('CODE', 'Types',   edTypesCode.Text);

  FreeAndNil(ini);
end;


end.

