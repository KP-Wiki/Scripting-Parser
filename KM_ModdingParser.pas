unit KM_ModdingParser;
interface
uses
  System.Classes, System.SysUtils, System.Types, Vcl.Forms, Winapi.Windows, System.Generics.Collections, System.IOUtils,
  System.StrUtils,
  KM_DocumenterTypes;

type
  // Documenter > Modding
  TKMDocumenterModding = class
  private const
    DBG_COPY_FOR_REFERENCE = True;
  private
    fParsingGame: TKMParsingGame;
    fOnLog: TProc<string>;
    procedure CopyForReference(const aFilename: string; aArea: TKMScriptingArea);
  public
    constructor Create(aParsingGame: TKMParsingGame; aOnLog: TProc<string>);
    destructor Destroy; override;

    procedure GenerateWiki(aPaths: TKMScriptingPaths);
  end;


implementation


{ TKMDocumenterModding }
constructor TKMDocumenterModding.Create(aParsingGame: TKMParsingGame; aOnLog: TProc<string>);
begin
  inherited Create;

  fParsingGame := aParsingGame;
  fOnLog := aOnLog;
end;


destructor TKMDocumenterModding.Destroy;
begin
  for var I := Low(TKMScriptingArea) to High(TKMScriptingArea) do
    FreeAndNil(fMethods[I]);

  inherited;
end;


procedure TKMDocumenterModding.CopyForReference(const aFilename: string; aArea: TKMScriptingArea);
var
  tgtPath: string;
begin
  tgtPath := ExtractFilePath(Application.ExeName) + GAME_INFO[fParsingGame].Ext + '.' + SCRIPTING_AREA_SPEC[aArea].Name + '.new.md';
  Winapi.Windows.CopyFile(PChar(aFilename), PChar(tgtPath), False);
end;


procedure TKMDocumenterModding.GenerateWiki(aPaths: TKMScriptingPaths);
begin
  for var I := Low(TKMScriptingArea) to High(TKMScriptingArea) do
    fMethods[I].GenerateWiki(aPaths.PathsScripting[I].SourceInput, aPaths.PathsScripting[I].WikiTemplate, aPaths.PathsScripting[I].WikiOutput);

  if DBG_COPY_FOR_REFERENCE then
    for var I := Low(TKMScriptingArea) to High(TKMScriptingArea) do
      CopyForReference(aPaths.PathsScripting[I].WikiOutput, I);
end;


end.
