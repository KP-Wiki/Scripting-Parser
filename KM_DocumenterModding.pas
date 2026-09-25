unit KM_DocumenterModding;
interface
uses
  System.Classes, System.SysUtils, System.Types, Vcl.Forms, Winapi.Windows, System.Generics.Collections, System.IOUtils,
  System.StrUtils,
  KM_ModdingTypes,
  KM_DocumenterTypes;

type
  // Documenter > Modding
  TKMDocumenterModding = class
  private const
    DBG_COPY_FOR_REFERENCE = True;
  private
    fOnLog: TProc<string>;
    fModdingTypes: TKMModdingTypes;
    procedure CopyForReference(const aFilename: string);
  public
    constructor Create(aParsingGame: TKMParsingGame; aOnLog: TProc<string>);
    destructor Destroy; override;

    procedure GenerateWiki(aPaths: TKMDocumenterPathSet);
  end;


implementation


{ TKMDocumenterModding }
constructor TKMDocumenterModding.Create(aParsingGame: TKMParsingGame; aOnLog: TProc<string>);
begin
  inherited Create;

  fOnLog := aOnLog;

  fModdingTypes := TKMModdingTypes.Create(fOnLog);
end;


destructor TKMDocumenterModding.Destroy;
begin
  FreeAndNil(fModdingTypes);

  inherited;
end;


procedure TKMDocumenterModding.CopyForReference(const aFilename: string);
var
  tgtPath: string;
begin
  tgtPath := ExtractFilePath(Application.ExeName) + 'kp.modding.new.md';
  Winapi.Windows.CopyFile(PChar(aFilename), PChar(tgtPath), False);
end;


procedure TKMDocumenterModding.GenerateWiki(aPaths: TKMDocumenterPathSet);
begin
  fModdingTypes.GenerateWiki(aPaths.SourceInput, aPaths.WikiTemplate, aPaths.WikiOutput);

  if DBG_COPY_FOR_REFERENCE then
    CopyForReference(aPaths.WikiOutput);
end;


end.
