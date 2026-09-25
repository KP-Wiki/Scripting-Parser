unit KM_ScriptingCommon;
interface
uses
  System.SysUtils,
  KM_ParserTypes;

type
  // Documenter > Scripting > common
  TKMScriptCommon = class
  protected
    fGame: TKMParsingGame;
    fArea: TKMParsingArea;
    fOnLog: TProc<string>;
    procedure LoadFromFile(const aSourceFile: string); virtual;
  public
    constructor Create(aGame: TKMParsingGame; aArea: TKMParsingArea; aOnLog: TProc<string>);

    procedure GenerateCode(const aSourceFile, aFilename1, aFilename2: string); virtual;
    procedure GenerateWiki(const aSourceFile, aTemplateFile, aOutputFile: string); virtual;
    procedure LintLogMessages(const aSourceFile: string); virtual;
  end;


implementation


{ TKMScriptCommon }
constructor TKMScriptCommon.Create(aGame: TKMParsingGame; aArea: TKMParsingArea; aOnLog: TProc<string>);
begin
  inherited Create;

  fGame := aGame;
  fArea := aArea;
  fOnLog := aOnLog;
end;


procedure TKMScriptCommon.LoadFromFile(const aSourceFile: string);
begin
  //
end;


procedure TKMScriptCommon.GenerateCode(const aSourceFile, aFilename1, aFilename2: string);
begin
  //
end;


procedure TKMScriptCommon.GenerateWiki(const aSourceFile, aTemplateFile, aOutputFile: string);
begin
  //
end;


procedure TKMScriptCommon.LintLogMessages(const aSourceFile: string);
begin
  //
end;


end.
