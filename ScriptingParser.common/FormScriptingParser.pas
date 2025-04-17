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
    btnCheckMessages: TButton;
    procedure FormCreate(Sender: TObject);
    procedure btnGenerateWikiClick(Sender: TObject);
    procedure edtOnTextChange(Sender: TObject);
    procedure btnReyKMRClick(Sender: TObject);
    procedure btnKromKPClick(Sender: TObject);
    procedure btnKromKMRClick(Sender: TObject);
    procedure btnGenerateXMLClick(Sender: TObject);
    procedure btnGenerateCodeClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure btnCheckMessagesClick(Sender: TObject);
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
    edActionsIn.Text       := fScriptingPaths.PathsA.SourceInput;
    edEventsIn.Text        := fScriptingPaths.PathsE.SourceInput;
    edStatesIn.Text        := fScriptingPaths.PathsS.SourceInput;
    edUtilsIn.Text         := fScriptingPaths.PathsU.SourceInput;
    edTypesIn.Text         := fScriptingPaths.PathsT.SourceInput;

    edActionsTemplate.Text := fScriptingPaths.PathsA.WikiTemplate;
    edEventsTemplate.Text  := fScriptingPaths.PathsE.WikiTemplate;
    edStatesTemplate.Text  := fScriptingPaths.PathsS.WikiTemplate;
    edUtilsTemplate.Text   := fScriptingPaths.PathsU.WikiTemplate;
    edTypesTemplate.Text   := fScriptingPaths.PathsT.WikiTemplate;

    edActionsOut.Text      := fScriptingPaths.PathsA.WikiOutput;
    edEventsOut.Text       := fScriptingPaths.PathsE.WikiOutput;
    edStatesOut.Text       := fScriptingPaths.PathsS.WikiOutput;
    edUtilsOut.Text        := fScriptingPaths.PathsU.WikiOutput;
    edTypesOut.Text        := fScriptingPaths.PathsT.WikiOutput;

    edActionsCode.Text     := fScriptingPaths.PathsA.SourceOutputCheckAndReg;
    edEventsCode.Text      := fScriptingPaths.PathsE.SourceOutputCheck;
    edEventsCode2.Text     := fScriptingPaths.PathsE.SourceOutputReg;
    edStatesCode.Text      := fScriptingPaths.PathsS.SourceOutputCheckAndReg;
    edUtilsCode.Text       := fScriptingPaths.PathsU.SourceOutputCheckAndReg;
    edTypesCode.Text       := fScriptingPaths.PathsT.SourceOutputReg;
  finally
    fUpdating := False;
  end;
end;


procedure TfmScriptingParser.btnCheckMessagesClick(Sender: TObject);
begin
  meLog.Clear;
  meLog.Lines.Append(GAME_INFO[fParsingGame].Name + ' checking messages:');
  meLog.Lines.Append(DupeString('-', 50));

  // For now it is more KISS to create and use instance for the job
  var scriptingParser := TKMScriptingParser.Create(fParsingGame, DoLog);
  scriptingParser.ParseCode(fScriptingPaths);
  scriptingParser.CheckMessages(fScriptingPaths);
  scriptingParser.Free;
end;


procedure TfmScriptingParser.btnGenerateCodeClick(Sender: TObject);
begin
  meLog.Clear;
  meLog.Lines.Append(GAME_INFO[fParsingGame].Name + ' code export:');
  meLog.Lines.Append(DupeString('-', 50));

  // For now it is more KISS to create and use instance for the job
  var scriptingParser := TKMScriptingParser.Create(fParsingGame, DoLog);
  scriptingParser.ParseCode(fScriptingPaths);
  scriptingParser.GenerateCode(fScriptingPaths);
  scriptingParser.Free;
end;


procedure TfmScriptingParser.btnGenerateWikiClick(Sender: TObject);
begin
  meLog.Clear;
  meLog.Lines.Append(GAME_INFO[fParsingGame].Name + ' wiki export:');
  meLog.Lines.Append(DupeString('-', 50));

  // For now it is more KISS to create and use instance for the job
  var scriptingParser := TKMScriptingParser.Create(fParsingGame, DoLog);
  scriptingParser.ParseCode(fScriptingPaths);
  scriptingParser.GenerateWiki(fScriptingPaths);
  scriptingParser.Free;
end;


procedure TfmScriptingParser.btnGenerateXMLClick(Sender: TObject);
begin
  meLog.Clear;

  // For now it is more KISS to create and use instance for the job
  var scriptingParser := TKMScriptingParser.Create(fParsingGame, DoLog);
  scriptingParser.ParseCode(fScriptingPaths);
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
  fScriptingPaths.PathsA.SourceInput  := edActionsIn.Text;
  fScriptingPaths.PathsE.SourceInput  := edEventsIn.Text;
  fScriptingPaths.PathsS.SourceInput  := edStatesIn.Text;
  fScriptingPaths.PathsU.SourceInput  := edUtilsIn.Text;
  fScriptingPaths.PathsT.SourceInput  := edTypesIn.Text;

  fScriptingPaths.PathsA.WikiTemplate := edActionsTemplate.Text;
  fScriptingPaths.PathsE.WikiTemplate := edEventsTemplate.Text;
  fScriptingPaths.PathsS.WikiTemplate := edStatesTemplate.Text;
  fScriptingPaths.PathsU.WikiTemplate := edUtilsTemplate.Text;
  fScriptingPaths.PathsT.WikiTemplate := edTypesTemplate.Text;

  fScriptingPaths.PathsA.WikiOutput := edActionsOut.Text;
  fScriptingPaths.PathsE.WikiOutput := edEventsOut.Text;
  fScriptingPaths.PathsS.WikiOutput := edStatesOut.Text;
  fScriptingPaths.PathsU.WikiOutput := edUtilsOut.Text;
  fScriptingPaths.PathsT.WikiOutput := edTypesOut.Text;

  fScriptingPaths.PathsA.SourceOutputCheckAndReg  := edActionsCode.Text;
  fScriptingPaths.PathsE.SourceOutputCheck        := edEventsCode.Text;
  fScriptingPaths.PathsE.SourceOutputReg          := edEventsCode2.Text;
  fScriptingPaths.PathsS.SourceOutputCheckAndReg  := edStatesCode.Text;
  fScriptingPaths.PathsU.SourceOutputCheckAndReg  := edUtilsCode.Text;
  fScriptingPaths.PathsT.SourceOutputReg          := edTypesCode.Text;

  fScriptingPaths.SaveToINI(fSettingsPath);
end;


end.

