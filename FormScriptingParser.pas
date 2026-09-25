unit FormScriptingParser;
interface
uses
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtDlgs, System.SysUtils, Winapi.Windows,
  System.Classes, Vcl.StdCtrls, System.StrUtils, System.Types, System.IniFiles, Vcl.ComCtrls,
  KM_DocumenterTypes, KM_ScriptingPaths, Vcl.ExtCtrls;

type
  TfmScriptingParser = class(TForm)
    btnReyKMR: TButton;
    btnKromKMR: TButton;
    btnKromKP: TButton;
    btnGenerateWiki: TButton;
    btnGenerateXML: TButton;
    gbScripting: TGroupBox;
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
    btnScriptingLintMessages: TButton;
    gbModding: TGroupBox;
    Label10: TLabel;
    Label14: TLabel;
    Label15: TLabel;
    Label16: TLabel;
    edResIn: TEdit;
    edResOut: TEdit;
    edResTemplate: TEdit;
    btnGenerateResWiki: TButton;
    procedure FormCreate(Sender: TObject);
    procedure btnGenerateWikiClick(Sender: TObject);
    procedure edtOnTextChange(Sender: TObject);
    procedure btnReyKMRClick(Sender: TObject);
    procedure btnKromKPClick(Sender: TObject);
    procedure btnKromKMRClick(Sender: TObject);
    procedure btnGenerateXMLClick(Sender: TObject);
    procedure btnGenerateCodeClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure btnScriptingLintMessagesClick(Sender: TObject);
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
uses
  KM_ScriptingParser;

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
    // Scripting
    edActionsIn.Text       := fScriptingPaths.PathsScripting[paActions].SourceInput;
    edEventsIn.Text        := fScriptingPaths.PathsScripting[paEvents].SourceInput;
    edStatesIn.Text        := fScriptingPaths.PathsScripting[paStates].SourceInput;
    edUtilsIn.Text         := fScriptingPaths.PathsScripting[paUtils].SourceInput;
    edTypesIn.Text         := fScriptingPaths.PathsScripting[paTypes].SourceInput;

    edActionsTemplate.Text := fScriptingPaths.PathsScripting[paActions].WikiTemplate;
    edEventsTemplate.Text  := fScriptingPaths.PathsScripting[paEvents].WikiTemplate;
    edStatesTemplate.Text  := fScriptingPaths.PathsScripting[paStates].WikiTemplate;
    edUtilsTemplate.Text   := fScriptingPaths.PathsScripting[paUtils].WikiTemplate;
    edTypesTemplate.Text   := fScriptingPaths.PathsScripting[paTypes].WikiTemplate;

    edActionsOut.Text      := fScriptingPaths.PathsScripting[paActions].WikiOutput;
    edEventsOut.Text       := fScriptingPaths.PathsScripting[paEvents].WikiOutput;
    edStatesOut.Text       := fScriptingPaths.PathsScripting[paStates].WikiOutput;
    edUtilsOut.Text        := fScriptingPaths.PathsScripting[paUtils].WikiOutput;
    edTypesOut.Text        := fScriptingPaths.PathsScripting[paTypes].WikiOutput;

    edActionsCode.Text     := fScriptingPaths.PathsScripting[paActions].SourceOutput1;
    edEventsCode.Text      := fScriptingPaths.PathsScripting[paEvents].SourceOutput1;
    edEventsCode2.Text     := fScriptingPaths.PathsScripting[paEvents].SourceOutput2;
    edStatesCode.Text      := fScriptingPaths.PathsScripting[paStates].SourceOutput1;
    edUtilsCode.Text       := fScriptingPaths.PathsScripting[paUtils].SourceOutput1;
    edTypesCode.Text       := fScriptingPaths.PathsScripting[paTypes].SourceOutput1;

    // Modding
//    edResIn.Text        :=
//    edResTemplate.Text  :=
//    edResOut.Text       :=
  finally
    fUpdating := False;
  end;
end;


procedure TfmScriptingParser.btnScriptingLintMessagesClick(Sender: TObject);
begin
  meLog.Clear;
  DoLog('Linting messages for ' + GAME_INFO[fParsingGame].Name + ':');
  DoLog(DupeString('-', 50));

  // It is more KISS to create and use one instance for one job
  var documenterScripting := TKMDocumenterScripting.Create(fParsingGame, DoLog);
  documenterScripting.LintMessages(fScriptingPaths);
  documenterScripting.Free;
end;


procedure TfmScriptingParser.btnGenerateCodeClick(Sender: TObject);
begin
  meLog.Clear;
  DoLog('Generating code for ' + GAME_INFO[fParsingGame].Name + ':');
  DoLog(DupeString('-', 50));

  // It is more KISS to create and use one instance for one job
  var documenterScripting := TKMDocumenterScripting.Create(fParsingGame, DoLog);
  documenterScripting.GenerateCode(fScriptingPaths);
  documenterScripting.Free;
end;


procedure TfmScriptingParser.btnGenerateWikiClick(Sender: TObject);
begin
  meLog.Clear;
  DoLog('Generating wiki for ' + GAME_INFO[fParsingGame].Name + ':');
  DoLog(DupeString('-', 50));

  // It is more KISS to create and use one instance for one job
  var documenterScripting := TKMDocumenterScripting.Create(fParsingGame, DoLog);
  documenterScripting.GenerateWiki(fScriptingPaths);
  documenterScripting.Free;
end;


procedure TfmScriptingParser.btnGenerateXMLClick(Sender: TObject);
begin
  meLog.Clear;

  // It is more KISS to create and use instance for the job
  var documenterScripting := TKMDocumenterScripting.Create(fParsingGame, DoLog);
  documenterScripting.GenerateXML(fScriptingPaths);
  documenterScripting.Free;
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
  // Scripting
  fScriptingPaths.PathsScripting[paActions].SourceInput  := edActionsIn.Text;
  fScriptingPaths.PathsScripting[paEvents].SourceInput  := edEventsIn.Text;
  fScriptingPaths.PathsScripting[paStates].SourceInput  := edStatesIn.Text;
  fScriptingPaths.PathsScripting[paUtils].SourceInput  := edUtilsIn.Text;
  fScriptingPaths.PathsScripting[paTypes].SourceInput  := edTypesIn.Text;

  fScriptingPaths.PathsScripting[paActions].WikiTemplate := edActionsTemplate.Text;
  fScriptingPaths.PathsScripting[paEvents].WikiTemplate := edEventsTemplate.Text;
  fScriptingPaths.PathsScripting[paStates].WikiTemplate := edStatesTemplate.Text;
  fScriptingPaths.PathsScripting[paUtils].WikiTemplate := edUtilsTemplate.Text;
  fScriptingPaths.PathsScripting[paTypes].WikiTemplate := edTypesTemplate.Text;

  fScriptingPaths.PathsScripting[paActions].WikiOutput := edActionsOut.Text;
  fScriptingPaths.PathsScripting[paEvents].WikiOutput := edEventsOut.Text;
  fScriptingPaths.PathsScripting[paStates].WikiOutput := edStatesOut.Text;
  fScriptingPaths.PathsScripting[paUtils].WikiOutput := edUtilsOut.Text;
  fScriptingPaths.PathsScripting[paTypes].WikiOutput := edTypesOut.Text;

  fScriptingPaths.PathsScripting[paActions].SourceOutput1 := edActionsCode.Text;
  fScriptingPaths.PathsScripting[paEvents].SourceOutput1 := edEventsCode.Text;
  fScriptingPaths.PathsScripting[paEvents].SourceOutput2 := edEventsCode2.Text;
  fScriptingPaths.PathsScripting[paStates].SourceOutput1 := edStatesCode.Text;
  fScriptingPaths.PathsScripting[paUtils].SourceOutput1 := edUtilsCode.Text;
  fScriptingPaths.PathsScripting[paTypes].SourceOutput1 := edTypesCode.Text;

  // Modding
//    edResIn.Text        :=
//    edResTemplate.Text  :=
//    edResOut.Text       :=

  fScriptingPaths.SaveToINI(fSettingsPath);
end;


end.

