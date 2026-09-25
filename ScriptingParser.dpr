program ScriptingParser;
uses
  Vcl.Forms,
  FormScriptingParser in 'FormScriptingParser.pas' {fmScriptingParser},
  KM_DocumenterTypes in 'KM_DocumenterTypes.pas',
  KM_ScriptingCommon in 'KM_ScriptingCommon.pas',
  KM_ScriptingMethod in 'KM_ScriptingMethod.pas',
  KM_ScriptingMethods in 'KM_ScriptingMethods.pas',
  KM_ScriptingMethodConsts in 'KM_ScriptingMethodConsts.pas',
  KM_ScriptingMethodParameters in 'KM_ScriptingMethodParameters.pas',
  KM_ScriptingParser in 'KM_ScriptingParser.pas',
  KM_ScriptingPaths in 'KM_ScriptingPaths.pas',
  KM_ScriptingType in 'KM_ScriptingType.pas',
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
