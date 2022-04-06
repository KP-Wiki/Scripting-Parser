program ScriptingParser;

uses
  Vcl.Forms,
  Main in 'Main.pas' {Form1},
  KM_ScriptingCommands in 'KM_ScriptingCommands.pas',
  KM_ScriptingConsts in 'KM_ScriptingConsts.pas',
  KM_ScriptingParameters in 'KM_ScriptingParameters.pas',
  KM_ScriptingParser in 'KM_ScriptingParser.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
