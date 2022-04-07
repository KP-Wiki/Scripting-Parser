program ScriptingParser;

uses
  Vcl.Forms,
  Main in 'Main.pas' {Form1},
  KM_ScriptingConsts in 'KM_ScriptingConsts.pas',
  KM_ScriptingMethods in 'KM_ScriptingMethods.pas',
  KM_ScriptingParameters in 'KM_ScriptingParameters.pas',
  KM_ScriptingParser in 'KM_ScriptingParser.pas',
  KM_ScriptingTypes in 'KM_ScriptingTypes.pas',
  KM_StringUtils in 'KM_StringUtils.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
