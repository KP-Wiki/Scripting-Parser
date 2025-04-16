program ScriptingParser;
uses
  Vcl.Forms,
  FormScriptingParser in 'FormScriptingParser.pas' {fmScriptingParser},
  KM_ParserTypes in 'KM_ParserTypes.pas',
  KM_ScriptingConsts in 'KM_ScriptingConsts.pas',
  KM_ScriptingMethods in 'KM_ScriptingMethods.pas',
  KM_ScriptingParameters in 'KM_ScriptingParameters.pas',
  KM_ScriptingParser in 'KM_ScriptingParser.pas',
  KM_ScriptingPaths in 'KM_ScriptingPaths.pas',
  KM_ScriptingTypes in 'KM_ScriptingTypes.pas',
  KM_StringUtils in 'KM_StringUtils.pas';

{$R *.res}

var
  fmScriptingParser: TfmScriptingParser;

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TfmScriptingParser, fmScriptingParser);
  Application.Run;
end.
