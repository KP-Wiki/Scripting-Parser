unit KM_StringUtils;
interface
uses
  System.Classes, System.SysUtils, System.Types, System.StrUtils;


// These function were replacements for string functions introduced after XE2 (XE5 probably)
// Names are the same as in new Delphi versions, but with 'Str' prefix
// We kept them here to support pre-XE5 compilation
//todo: Now we dont support old compilers and they can be removed
function RightStrAfter(const aStr, aSeparator: string): string; deprecated;
function StrSubstring(const aStr: string; aFrom: Integer): string; deprecated;
function StrLastIndexOf(const aStr, aSubStr: string): Integer; deprecated;
function StrTrimRightSeparators(const aStr: string): string; deprecated;
procedure StrSplit(const aStr, aDelimiters: string; aStrings: TStringList); deprecated;
procedure FindStartAndFinish(aStringList: TStringList; aMarker: string; out aLineStart, aLineFinish, aPad: Integer); deprecated;


implementation


// Copy everything on the right of the separator
// 123:mystring:3 -> mystring:3
function RightStrAfter(const aStr, aSeparator: string): string;
begin
  Result := Copy(aStr, Pos(aSeparator, aStr) + Length(aSeparator), MaxInt);
end;


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


procedure FindStartAndFinish(aStringList: TStringList; aMarker: string; out aLineStart, aLineFinish, aPad: Integer);
begin
  aLineStart := -1;
  repeat
    Inc(aLineStart);
    if aLineStart >= aStringList.Count then
    begin
      aLineStart := -1;
      Exit;
    end;
  until (Trim(aStringList[aLineStart]) = aMarker);

  aPad := Pos(aMarker, aStringList[aLineStart]) - 1;

  Inc(aLineStart);

  aLineFinish := aLineStart;
  repeat
    Inc(aLineFinish);

    if aLineFinish >= aStringList.Count then
      Exit;
  until (Trim(aStringList[aLineFinish]) = aMarker);

  Dec(aLineFinish);
end;


end.
