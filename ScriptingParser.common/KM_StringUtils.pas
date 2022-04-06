unit KM_StringUtils;
interface
uses
  Classes, SysUtils, Types, StrUtils;


function StrSubstring(const aStr: string; aFrom: Integer): string;
function StrLastIndexOf(const aStr, aSubStr: string): Integer;
function StrTrimRightSeparators(const aStr: string): string;
procedure StrSplit(const aStr, aDelimiters: string; aStrings: TStringList);


implementation


// string functions
// These function are replacements for string functions introduced after XE2 (XE5 probably)
// Names are the same as in new Delphi versions, but with 'Str' prefix
// We keep them here to support pre-XE5 compilation
function StrSubstring(const aStr: string; aFrom: Integer): string;
begin
  Result := Copy(aStr, aFrom + 1, Length(aStr));
end;


function StrLastIndexOf(const aStr, aSubStr: string): Integer;
var
  I: Integer;
begin
  Result := -1;
  for I := 1 to Length(aStr) do
    if AnsiPos(aSubStr, StrSubstring(aStr, I-1)) <> 0 then
      Result := I - 1;
end;


function StrTrimRightSeparators(const aStr: string): string;
var
  I, K: Integer;
begin
  K := 0;
  for I := Length(aStr) downto 1 do
  if not (aStr[I] in [',', ':', ';']) then
  begin
    K := I;
    Break;
  end;
  Result := Copy(aStr, 1, K);
end;


procedure StrSplit(const aStr, aDelimiters: string; aStrings: TStringList);
var
  StrArray: TStringDynArray;
  I: Integer;
begin
  StrArray := SplitString(aStr, aDelimiters);
  for I := Low(StrArray) to High(StrArray) do
  if StrArray[I] <> '' then
    aStrings.Add(StrArray[I]);
end;


end.
