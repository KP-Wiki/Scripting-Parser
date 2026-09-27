unit FormScriptingParser;
interface
uses
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtDlgs, System.SysUtils, Winapi.Windows,
  System.Classes, Vcl.StdCtrls, System.StrUtils, System.Types, System.IniFiles, Vcl.ComCtrls,
  KM_DocumenterTypes, KM_DocumenterPaths, Vcl.ExtCtrls;

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
    btnModdingGenerateWiki: TButton;
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
    procedure btnModdingGenerateWikiClick(Sender: TObject);
  private
    fParsingGame: TKMParsingGame;
    fSettingsPath: string;
    fDocumenterPaths: TKMDocumenterPaths;
    fUpdating: Boolean;
    procedure LoadSettings;
    procedure SaveSettings;
    procedure DoLog(aMsg: string);
  end;


implementation
uses
  KM_DocumenterModding,
  KM_ScriptingParser;

{$R *.dfm}


{ TfmScriptingParser }
procedure TfmScriptingParser.FormCreate(Sender: TObject);
begin
  fDocumenterPaths := TKMDocumenterPaths.Create;
  btnKromKP.Click;
  //btnModdingGenerateWiki.Click;
  //Halt;
end;


procedure TfmScriptingParser.FormDestroy(Sender: TObject);
begin
  FreeAndNil(fDocumenterPaths);
end;


procedure TfmScriptingParser.DoLog(aMsg: string);
begin
  meLog.Lines.Append(aMsg);
end;


procedure TfmScriptingParser.LoadSettings;
begin
  fDocumenterPaths.LoadFromINI(fSettingsPath);

  // Blit settings to UI
  fUpdating := True;
  try
    // Scripting
    edActionsIn.Text       := fDocumenterPaths.Scripting[paActions].SourceInput;
    edEventsIn.Text        := fDocumenterPaths.Scripting[paEvents].SourceInput;
    edStatesIn.Text        := fDocumenterPaths.Scripting[paStates].SourceInput;
    edUtilsIn.Text         := fDocumenterPaths.Scripting[paUtils].SourceInput;
    edTypesIn.Text         := fDocumenterPaths.Scripting[paTypes].SourceInput;

    edActionsTemplate.Text := fDocumenterPaths.Scripting[paActions].WikiTemplate;
    edEventsTemplate.Text  := fDocumenterPaths.Scripting[paEvents].WikiTemplate;
    edStatesTemplate.Text  := fDocumenterPaths.Scripting[paStates].WikiTemplate;
    edUtilsTemplate.Text   := fDocumenterPaths.Scripting[paUtils].WikiTemplate;
    edTypesTemplate.Text   := fDocumenterPaths.Scripting[paTypes].WikiTemplate;

    edActionsOut.Text      := fDocumenterPaths.Scripting[paActions].WikiOutput;
    edEventsOut.Text       := fDocumenterPaths.Scripting[paEvents].WikiOutput;
    edStatesOut.Text       := fDocumenterPaths.Scripting[paStates].WikiOutput;
    edUtilsOut.Text        := fDocumenterPaths.Scripting[paUtils].WikiOutput;
    edTypesOut.Text        := fDocumenterPaths.Scripting[paTypes].WikiOutput;

    edActionsCode.Text     := fDocumenterPaths.Scripting[paActions].SourceOutput1;
    edEventsCode.Text      := fDocumenterPaths.Scripting[paEvents].SourceOutput1;
    edEventsCode2.Text     := fDocumenterPaths.Scripting[paEvents].SourceOutput2;
    edStatesCode.Text      := fDocumenterPaths.Scripting[paStates].SourceOutput1;
    edUtilsCode.Text       := fDocumenterPaths.Scripting[paUtils].SourceOutput1;
    edTypesCode.Text       := fDocumenterPaths.Scripting[paTypes].SourceOutput1;

    // Modding
    edResIn.Text        := fDocumenterPaths.Modding.SourceInput;
    edResTemplate.Text  := fDocumenterPaths.Modding.WikiTemplate;
    edResOut.Text       := fDocumenterPaths.Modding.WikiOutput;
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
  documenterScripting.LintMessages(fDocumenterPaths.Scripting);
  documenterScripting.Free;
end;


procedure TfmScriptingParser.btnGenerateCodeClick(Sender: TObject);
begin
  meLog.Clear;
  DoLog('Generating code for ' + GAME_INFO[fParsingGame].Name + ':');
  DoLog(DupeString('-', 50));

  // It is more KISS to create and use one instance for one job
  var documenterScripting := TKMDocumenterScripting.Create(fParsingGame, DoLog);
  documenterScripting.GenerateCode(fDocumenterPaths.Scripting);
  documenterScripting.Free;
end;


procedure TfmScriptingParser.btnGenerateWikiClick(Sender: TObject);
begin
  meLog.Clear;
  DoLog('Generating wiki for ' + GAME_INFO[fParsingGame].Name + ':');
  DoLog(DupeString('-', 50));

  // It is more KISS to create and use one instance for one job
  var documenterScripting := TKMDocumenterScripting.Create(fParsingGame, DoLog);
  documenterScripting.GenerateWiki(fDocumenterPaths.Scripting);
  documenterScripting.Free;
end;


procedure TfmScriptingParser.btnGenerateXMLClick(Sender: TObject);
begin
  meLog.Clear;

  // It is more KISS to create and use instance for the job
  var documenterScripting := TKMDocumenterScripting.Create(fParsingGame, DoLog);
  documenterScripting.GenerateXML(fDocumenterPaths.Scripting);
  documenterScripting.Free;
end;


procedure TfmScriptingParser.btnModdingGenerateWikiClick(Sender: TObject);
begin
  meLog.Clear;

  // It is more KISS to create and use instance for the job
  var documenterModding := TKMDocumenterModding.Create(fParsingGame, DoLog);
  documenterModding.GenerateWiki(fDocumenterPaths.Modding);
  documenterModding.Free;
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
  fDocumenterPaths.Scripting[paActions].SourceInput  := edActionsIn.Text;
  fDocumenterPaths.Scripting[paEvents].SourceInput  := edEventsIn.Text;
  fDocumenterPaths.Scripting[paStates].SourceInput  := edStatesIn.Text;
  fDocumenterPaths.Scripting[paUtils].SourceInput  := edUtilsIn.Text;
  fDocumenterPaths.Scripting[paTypes].SourceInput  := edTypesIn.Text;

  fDocumenterPaths.Scripting[paActions].WikiTemplate := edActionsTemplate.Text;
  fDocumenterPaths.Scripting[paEvents].WikiTemplate := edEventsTemplate.Text;
  fDocumenterPaths.Scripting[paStates].WikiTemplate := edStatesTemplate.Text;
  fDocumenterPaths.Scripting[paUtils].WikiTemplate := edUtilsTemplate.Text;
  fDocumenterPaths.Scripting[paTypes].WikiTemplate := edTypesTemplate.Text;

  fDocumenterPaths.Scripting[paActions].WikiOutput := edActionsOut.Text;
  fDocumenterPaths.Scripting[paEvents].WikiOutput := edEventsOut.Text;
  fDocumenterPaths.Scripting[paStates].WikiOutput := edStatesOut.Text;
  fDocumenterPaths.Scripting[paUtils].WikiOutput := edUtilsOut.Text;
  fDocumenterPaths.Scripting[paTypes].WikiOutput := edTypesOut.Text;

  fDocumenterPaths.Scripting[paActions].SourceOutput1 := edActionsCode.Text;
  fDocumenterPaths.Scripting[paEvents].SourceOutput1 := edEventsCode.Text;
  fDocumenterPaths.Scripting[paEvents].SourceOutput2 := edEventsCode2.Text;
  fDocumenterPaths.Scripting[paStates].SourceOutput1 := edStatesCode.Text;
  fDocumenterPaths.Scripting[paUtils].SourceOutput1 := edUtilsCode.Text;
  fDocumenterPaths.Scripting[paTypes].SourceOutput1 := edTypesCode.Text;

  // Modding
  fDocumenterPaths.Modding.SourceInput := edResIn.Text;
  fDocumenterPaths.Modding.WikiTemplate := edResTemplate.Text;
  fDocumenterPaths.Modding.WikiOutput := edResOut.Text;

  fDocumenterPaths.SaveToINI(fSettingsPath);
end;


end.

