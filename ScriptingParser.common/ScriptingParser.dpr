program ScriptingParser;

uses
  Vcl.Forms,
  Main in 'Main.pas' {Form1},
  KM_ScriptingParser in 'KM_ScriptingParser.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
