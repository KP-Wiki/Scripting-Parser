unit KM_StringUtils;
interface
uses
  System.Classes;


// These function were replacements for string functions introduced after XE2 (XE5 probably)
// Names are the same as in new Delphi versions, but with 'Str' prefix
// We kept them here to support pre-XE5 compilation
function RightStrAfter(const aStr, aSeparator: string): string;
function LeftStrBefore(const aStr, aSeparator: string): string;

function FirstStrBetween(const aStr, aFrom, aTo: string): string;

procedure FindRegionBounds(aStringList: TStringList; aMarker: string; out aLineFrom, aLineTo, aPadLevel: Integer);

function ExtractFunctionResultType(aStr: string): string;

function ParagraphWordWrap(const aStr: string; aMaxLength: Integer = 120): string;
function ParagraphPad(const aStr, aPad: string): string;

implementation
uses
  System.SysUtils, System.Types, System.StrUtils;


// Copy everything on the left of the separator
// 123:mystring:3 -> 123
function LeftStrBefore(const aStr, aSeparator: string): string;
begin
  Result := Copy(aStr, 1, Pos(aSeparator, aStr) - 1);
end;


// Copy everything on the right of the separator
// 123:mystring:3 -> mystring:3
function RightStrAfter(const aStr, aSeparator: string): string;
begin
  Result := Copy(aStr, Pos(aSeparator, aStr) + Length(aSeparator), MaxInt);
end;


function FirstStrBetween(const aStr, aFrom, aTo: string): string;
begin
  Result := LeftStrBefore(RightStrAfter(aStr, aFrom), aTo);
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


function ParagraphWordWrap(const aStr: string; aMaxLength: Integer = 120): string;

  function WrapLine(const aLine: string): string;
  begin
    Result := '';

    // Get indentation of the original line
    var indentLen := 0;
    while (indentLen < Length(aLine)) and (aLine[indentLen + 1] in [' ', #9]) do
      Inc(indentLen);

    var indent := Copy(aLine, 1, indentLen);
    var startPos := 1;

    while Length(aLine) - startPos + 1 > aMaxLength do
    begin
      // Continuation lines already contain the indentation,
      // so account for it when calculating the available width
      var wedgePos := startPos + aMaxLength - Length(indent) - 1;

      // The first line already contains its indentation
      if startPos = 1 then
        wedgePos := startPos + aMaxLength - 1;

      // Find the last space within the allowed line length
      var spacePos := wedgePos;
      while (spacePos >= startPos) and (aLine[spacePos] <> ' ') do
        Dec(spacePos);

      // No space found: force a break at the maximum length
      if spacePos < startPos then
        spacePos := wedgePos + 1;

      Result := Result + Copy(aLine, startPos, spacePos - startPos) + sLineBreak + indent;

      // Skip the space used for wrapping
      if (spacePos <= Length(aLine)) and (aLine[spacePos] = ' ') then
        startPos := spacePos + 1
      else
        startPos := spacePos;
    end;

    Result := Result + Copy(aLine, startPos, MaxInt);
  end;
begin
  // Preserve existing line breaks and wrap each line separately
  var lines := aStr.Split([sLineBreak]);

  Result := '';

  for var I := 0 to High(lines) do
  begin
    if I > 0 then
      Result := Result + sLineBreak;

    Result := Result + WrapLine(lines[I]);
  end;
end;


function ParagraphPad(const aStr, aPad: string): string;
begin
  // Preserve existing line breaks and pad each line separately
  var lines := aStr.Split([sLineBreak]);

  for var I := 0 to High(lines) do
  begin
    if I > 0 then
      Result := Result + sLineBreak;

    Result := Result + IfThen(lines[I] <> '', aPad) + lines[I];
  end;
end;


end.
