unit KM_ScriptingCommon;
interface
uses
  System.SysUtils,
  KM_ParserTypes;

type
  // Documenter > Scripting > common
  TKMScriptingCommon = class
  protected
    fGame: TKMParsingGame;
    fArea: TKMScriptingArea;
    fOnLog: TProc<string>;
  public
    constructor Create(aGame: TKMParsingGame; aArea: TKMScriptingArea; aOnLog: TProc<string>); virtual;

    procedure GenerateCode(const aSourceFile, aFilename1, aFilename2: string); virtual;
    procedure GenerateWiki(const aSourceFile, aTemplateFile, aOutputFile: string); virtual;
    procedure LintLogMessages(const aSourceFile: string); virtual;
  end;


implementation


{ TKMScriptingCommon }
constructor TKMScriptingCommon.Create(aGame: TKMParsingGame; aArea: TKMScriptingArea; aOnLog: TProc<string>);
begin
  inherited Create;

  fGame := aGame;
  fArea := aArea;
  fOnLog := aOnLog;
end;


procedure TKMScriptingCommon.GenerateCode(const aSourceFile, aFilename1, aFilename2: string);
begin
  //
end;


procedure TKMScriptingCommon.GenerateWiki(const aSourceFile, aTemplateFile, aOutputFile: string);
begin
  //
end;


procedure TKMScriptingCommon.LintLogMessages(const aSourceFile: string);
begin
  //
end;


end.
