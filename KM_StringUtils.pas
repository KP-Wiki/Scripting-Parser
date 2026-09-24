unit KM_StringUtils;
interface
uses
  System.Classes;


// These function were replacements for string functions introduced after XE2 (XE5 probably)
// Names are the same as in new Delphi versions, but with 'Str' prefix
// We kept them here to support pre-XE5 compilation
//todo: Now we dont support old compilers and they can be removed
function RightStrAfter(const aStr, aSeparator: string): string; deprecated;
function StrSubstring(const aStr: string; aFrom: Integer): string; deprecated;
procedure StrSplit(const aStr, aDelimiters: string; aStrings: TStringList); deprecated;
procedure FindRegionBounds(aStringList: TStringList; aMarker: string; out aLineFrom, aLineTo, aPadLevel: Integer);

function ExtractFunctionResultType(aStr: string): string;

implementation
uses
  System.SysUtils, System.Types, System.StrUtils;


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


procedure FindRegionBounds(aStringList: TStringList; aMarker: string; out aLineFrom, aLineTo, aPadLevel: Integer);
begin
  aLineFrom := -1;
  repeat
    Inc(aLineFrom);
    if aLineFrom >= aStringList.Count then
    begin
      aLineFrom := -1;
      Exit;
    end;
  until (Trim(aStringList[aLineFrom]) = aMarker);

  aPadLevel := Pos(aMarker, aStringList[aLineFrom]) - 1;

  Inc(aLineFrom);

  aLineTo := aLineFrom;
  repeat
    Inc(aLineTo);

    if aLineTo >= aStringList.Count then
      Exit;
  until (Trim(aStringList[aLineTo]) = aMarker);

  Dec(aLineTo);
end;


// "function MyMethod: Integer;" -> Integer
// "function MyMethod(a: Byte; B: string): Integer;" -> Integer
function ExtractFunctionResultType(aStr: string): string;
begin
  var posColon := LastDelimiter(':', aStr);
  var posSemicolon := Pos(';', aStr, posColon);
  var tail := Copy(aStr, posColon + 1, posSemicolon - posColon - 1);
  Result := Trim(tail);
end;


end.
