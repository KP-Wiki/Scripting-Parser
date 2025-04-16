unit FormScriptingParser;
interface
uses
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtDlgs, System.SysUtils, Winapi.Windows,
  System.Classes, Vcl.StdCtrls, System.StrUtils, System.Types, System.IniFiles, Vcl.ComCtrls,
  KM_ScriptingParser, KM_ParserTypes, KM_ScriptingPaths;

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
    procedure btnGenerateCodeClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    fParsingGame: TKMParsingGame;
    fSettingsPath: string;
    fScriptingPaths: TKMScriptingPaths;
    fUpdating: Boolean;
    procedure LoadSettings;
    procedure SaveSettings;
    procedure DoLog(aMsg: string);
  end;


implementation
{$R *.dfm}


{ TfmScriptingParser }
procedure TfmScriptingParser.FormCreate(Sender: TObject);
begin
  fScriptingPaths := TKMScriptingPaths.Create;
  btnReyKMR.Click;
end;


procedure TfmScriptingParser.FormDestroy(Sender: TObject);
begin
  FreeAndNil(fScriptingPaths);
end;


procedure TfmScriptingParser.DoLog(aMsg: string);
begin
  meLog.Lines.Append(aMsg);
end;


procedure TfmScriptingParser.LoadSettings;
begin
  fScriptingPaths.LoadFromINI(fSettingsPath);

  // Blit settings to UI
  fUpdating := True;
  try
    edActionsIn.Text       := fScriptingPaths.Paths[paActions].SourceInput;
    edEventsIn.Text        := fScriptingPaths.Paths[paEvents].SourceInput;
    edStatesIn.Text        := fScriptingPaths.Paths[paStates].SourceInput;
    edUtilsIn.Text         := fScriptingPaths.Paths[paUtils].SourceInput;
    edTypesIn.Text         := fScriptingPaths.Paths[paTypes].SourceInput;

    edActionsTemplate.Text := fScriptingPaths.Paths[paActions].WikiTemplate;
    edEventsTemplate.Text  := fScriptingPaths.Paths[paEvents].WikiTemplate;
    edStatesTemplate.Text  := fScriptingPaths.Paths[paStates].WikiTemplate;
    edUtilsTemplate.Text   := fScriptingPaths.Paths[paUtils].WikiTemplate;
    edTypesTemplate.Text   := fScriptingPaths.Paths[paTypes].WikiTemplate;

    edActionsOut.Text      := fScriptingPaths.Paths[paActions].WikiOutput;
    edEventsOut.Text       := fScriptingPaths.Paths[paEvents].WikiOutput;
    edStatesOut.Text       := fScriptingPaths.Paths[paStates].WikiOutput;
    edUtilsOut.Text        := fScriptingPaths.Paths[paUtils].WikiOutput;
    edTypesOut.Text        := fScriptingPaths.Paths[paTypes].WikiOutput;

    edActionsCode.Text     := fScriptingPaths.Paths[paActions].SourceOutputCheck;
    edEventsCode.Text      := fScriptingPaths.Paths[paEvents].SourceOutputCheck;
    edEventsCode2.Text     := fScriptingPaths.Paths[paEvents].SourceOutputReg;
    edStatesCode.Text      := fScriptingPaths.Paths[paStates].SourceOutputCheck;
    edUtilsCode.Text       := fScriptingPaths.Paths[paUtils].SourceOutputCheck;
    edTypesCode.Text       := fScriptingPaths.Paths[paTypes].SourceOutputCheck;
  finally
    fUpdating := False;
  end;
end;


procedure TfmScriptingParser.btnGenerateCodeClick(Sender: TObject);
begin
  meLog.Clear;
  meLog.Lines.Append(GAME_INFO[fParsingGame].Name + ' code export:');
  meLog.Lines.Append(DupeString('-', 50));

  // For now it is more KISS to create and use instance for the job
  var scriptingParser := TKMScriptingParser.Create(fParsingGame, DoLog);
  scriptingParser.GenerateCode(paActions, edActionsIn.Text, edActionsCode.Text, edActionsCode.Text);
  scriptingParser.GenerateCode(paEvents,  edEventsIn.Text,  edEventsCode.Text, edEventsCode2.Text);
  scriptingParser.GenerateCode(paStates,  edStatesIn.Text,  edStatesCode.Text, edStatesCode.Text);
  scriptingParser.GenerateCode(paUtils,   edUtilsIn.Text,   edUtilsCode.Text, edUtilsCode.Text);
  scriptingParser.GenerateCode(paTypes,   edTypesIn.Text,   edTypesCode.Text, edTypesCode.Text);
  scriptingParser.Free;
end;


procedure TfmScriptingParser.btnGenerateWikiClick(Sender: TObject);
begin
  meLog.Clear;
  meLog.Lines.Append(GAME_INFO[fParsingGame].Name + ' wiki export:');
  meLog.Lines.Append(DupeString('-', 50));

  // For now it is more KISS to create and use instance for the job
  var scriptingParser := TKMScriptingParser.Create(fParsingGame, DoLog);
  scriptingParser.GenerateWiki(paActions, edActionsIn.Text, edActionsTemplate.Text, edActionsOut.Text);
  scriptingParser.GenerateWiki(paEvents,  edEventsIn.Text,  edEventsTemplate.Text,  edEventsOut.Text);
  scriptingParser.GenerateWiki(paStates,  edStatesIn.Text,  edStatesTemplate.Text,  edStatesOut.Text);
  scriptingParser.GenerateWiki(paUtils,   edUtilsIn.Text,   edUtilsTemplate.Text,   edUtilsOut.Text);
  scriptingParser.GenerateWiki(paTypes,   edTypesIn.Text,   edTypesTemplate.Text,   edTypesOut.Text);
  scriptingParser.Free;
end;


procedure TfmScriptingParser.btnGenerateXMLClick(Sender: TObject);
begin
  meLog.Clear;

  // For now it is more KISS to create and use instance for the job
  var scriptingParser := TKMScriptingParser.Create(fParsingGame, DoLog);
  scriptingParser.GenerateXML;
  scriptingParser.Free;
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
begin
  fScriptingPaths.Paths[paActions].SourceInput        := edActionsIn.Text;
  fScriptingPaths.Paths[paEvents].SourceInput         := edEventsIn.Text;
  fScriptingPaths.Paths[paStates].SourceInput         := edStatesIn.Text;
  fScriptingPaths.Paths[paUtils].SourceInput          := edUtilsIn.Text;
  fScriptingPaths.Paths[paTypes].SourceInput          := edTypesIn.Text;

  fScriptingPaths.Paths[paActions].WikiTemplate       := edActionsTemplate.Text;
  fScriptingPaths.Paths[paEvents].WikiTemplate        := edEventsTemplate.Text;
  fScriptingPaths.Paths[paStates].WikiTemplate        := edStatesTemplate.Text;
  fScriptingPaths.Paths[paUtils].WikiTemplate         := edUtilsTemplate.Text;
  fScriptingPaths.Paths[paTypes].WikiTemplate         := edTypesTemplate.Text;

  fScriptingPaths.Paths[paActions].WikiOutput         := edActionsOut.Text;
  fScriptingPaths.Paths[paEvents].WikiOutput          := edEventsOut.Text;
  fScriptingPaths.Paths[paStates].WikiOutput          := edStatesOut.Text;
  fScriptingPaths.Paths[paUtils].WikiOutput           := edUtilsOut.Text;
  fScriptingPaths.Paths[paTypes].WikiOutput           := edTypesOut.Text;

  fScriptingPaths.Paths[paActions].SourceOutputCheck  := edActionsCode.Text;
  fScriptingPaths.Paths[paEvents].SourceOutputCheck   := edEventsCode.Text;
  fScriptingPaths.Paths[paEvents].SourceOutputReg     := edEventsCode2.Text;
  fScriptingPaths.Paths[paStates].SourceOutputCheck   := edStatesCode.Text;
  fScriptingPaths.Paths[paUtils].SourceOutputCheck    := edUtilsCode.Text;
  fScriptingPaths.Paths[paTypes].SourceOutputCheck    := edTypesCode.Text;

  fScriptingPaths.SaveToINI(fSettingsPath);
end;


end.

