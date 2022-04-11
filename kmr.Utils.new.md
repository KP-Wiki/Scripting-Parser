#### Utils

Utility methods
<br /><br />
To invoke some utility method just call to **Utils.UTIL_NAME(UTIL_PARAMS)** or **U.UTIL_NAME(UTIL_PARAMS)**, like so
```pascal
    if Utils.InRangeI(x,0,5) then //Check x is in range of [0;5]
      ...
```
or, in short form 
```pascal
    if U.InRangeI(x,0,5) then //Check x is in range of [0;5]
      ...
```

***

Other scripts functions:
* [Events](https://github.com/reyandme/kam_remake/wiki/Events-(Mission-Script-Dynamic))
* [Actions](https://github.com/reyandme/kam_remake/wiki/Actions-(Mission-Script-Dynamic))
* [States](https://github.com/reyandme/kam_remake/wiki/States-(Mission-Script-Dynamic))

Dynamic scripts usefull info:
* [Tutorial](https://github.com/reyandme/kam_remake/wiki/Tutorial-(Mission-Script-Dynamic))
* [Types](https://github.com/reyandme/kam_remake/wiki/Types-(Mission-Script-Dynamic))
* [Lookup Tables](https://github.com/reyandme/kam_remake/wiki/Lookup-Tables-(Mission-Script-Dynamic))
* [Advanced Features](https://github.com/reyandme/kam_remake/wiki/Advanced-Features-(Mission-Script-Dynamic))
* [Custom Console Commands](https://github.com/reyandme/kam_remake/wiki/Custom-Console-Commands-(Mission-Script-Dynamic))


***

* <a href="#AbsI">AbsI</a>
* <a href="#AbsS">AbsS</a>
* <a href="#ArrayElementCount">ArrayElementCount</a>
* <a href="#ArrayElementCountB">ArrayElementCountB</a>
* <a href="#ArrayElementCountI">ArrayElementCountI</a>
* <a href="#ArrayElementCountS">ArrayElementCountS</a>
* <a href="#ArrayHasElement">ArrayHasElement</a>
* <a href="#ArrayHasElementB">ArrayHasElementB</a>
* <a href="#ArrayHasElementI">ArrayHasElementI</a>
* <a href="#ArrayHasElementS">ArrayHasElementS</a>
* <a href="#ArrayRemoveIndexI">ArrayRemoveIndexI</a>
* <a href="#ArrayRemoveIndexS">ArrayRemoveIndexS</a>
* <a href="#BoolToStr">BoolToStr</a>
* <a href="#CeilTo">CeilTo</a>
* <a href="#ColorBrightness">ColorBrightness</a>
* <a href="#CompareString">CompareString</a>
* <a href="#CompareText">CompareText</a>
* <a href="#CopyString">CopyString</a>
* <a href="#DeleteString">DeleteString</a>
* <a href="#EnsureRangeI">EnsureRangeI</a>
* <a href="#EnsureRangeS">EnsureRangeS</a>
* <a href="#FloorTo">FloorTo</a>
* <a href="#Format">Format</a>
* <a href="#FormatFloat">FormatFloat</a>
* <a href="#IfThen">IfThen</a>
* <a href="#IfThenI">IfThenI</a>
* <a href="#IfThenS">IfThenS</a>
* <a href="#InAreaI">InAreaI</a>
* <a href="#InAreaS">InAreaS</a>
* <a href="#InRangeI">InRangeI</a>
* <a href="#InRangeS">InRangeS</a>
* <a href="#InsertString">InsertString</a>
* <a href="#KMPoint">KMPoint</a>
* <a href="#LowerCase">LowerCase</a>
* <a href="#MaxI">MaxI</a>
* <a href="#MaxInArrayI">MaxInArrayI</a>
* <a href="#MaxInArrayS">MaxInArrayS</a>
* <a href="#MaxS">MaxS</a>
* <a href="#MinI">MinI</a>
* <a href="#MinInArrayI">MinInArrayI</a>
* <a href="#MinInArrayS">MinInArrayS</a>
* <a href="#MinS">MinS</a>
* <a href="#MoveString">MoveString</a>
* <a href="#Pos">Pos</a>
* <a href="#Power">Power</a>
* <a href="#RandomRangeI">RandomRangeI</a>
* <a href="#RGBDecToBGRHex">RGBDecToBGRHex</a>
* <a href="#RGBToBGRHex">RGBToBGRHex</a>
* <a href="#RoundTo">RoundTo</a>
* <a href="#Sqr">Sqr</a>
* <a href="#StringReplace">StringReplace</a>
* <a href="#SumI">SumI</a>
* <a href="#SumS">SumS</a>
* <a href="#TimeToString">TimeToString</a>
* <a href="#TimeToTick">TimeToTick</a>
* <a href="#Trim">Trim</a>
* <a href="#TrimLeft">TrimLeft</a>
* <a href="#TrimRight">TrimRight</a>
* <a href="#TruncTo">TruncTo</a>
* <a href="#UpperCase">UpperCase</a>
<br />

| Ver<br/>sion | Utility function<br/> description | Parameters<br/>and types | Returns |
| ------- | ------------------------------------ | -------------- | ------- |
| 7000+ | <a id="AbsI">AbsI</a><sub><br/>Returns absolute value of specified integer</sub> | <sub>**aValue**: Integer;</sub> | <sub>Integer</sub> |
| 7000+ | <a id="AbsS">AbsS</a><sub><br/>Returns absolute value of specified single number</sub> | <sub>**aValue**: Single;</sub> | <sub>Single</sub> |
| 7000+ | <a id="ArrayElementCount">ArrayElementCount</a><sub><br/>Checks how many times specified string comes in requested array</sub> | <sub>**aElement**: AnsiString; <br/> **aArray**: array of String;</sub> | <sub>Integer</sub> |
| 7000+ | <a id="ArrayElementCountB">ArrayElementCountB</a><sub><br/>Checks how many times specified boolean comes in requested array</sub> | <sub>**aElement**: Boolean; <br/> **aArray**: array of Boolean;</sub> | <sub>Integer</sub> |
| 7000+ | <a id="ArrayElementCountI">ArrayElementCountI</a><sub><br/>Checks how many times specified integer comes in requested array</sub> | <sub>**aElement**: Integer; <br/> **aArray**: array of Integer;</sub> | <sub>Integer</sub> |
| 7000+ | <a id="ArrayElementCountS">ArrayElementCountS</a><sub><br/>Checks how many times specified single comes in requested array</sub> | <sub>**aElement**: Single; <br/> **aArray**: array of Single;</sub> | <sub>Integer</sub> |
| 7000+ | <a id="ArrayHasElement">ArrayHasElement</a><sub><br/>Checks whether requested array has specified string</sub> | <sub>**aElement**: AnsiString; <br/> **aArray**: array of String;</sub> | <sub>Boolean</sub> |
| 7000+ | <a id="ArrayHasElementB">ArrayHasElementB</a><sub><br/>Checks whether requested array has specified boolean</sub> | <sub>**aElement**: Boolean; <br/> **aArray**: array of Boolean;</sub> | <sub>Boolean</sub> |
| 7000+ | <a id="ArrayHasElementI">ArrayHasElementI</a><sub><br/>Checks whether requested array has specified integer</sub> | <sub>**aElement**: Integer; <br/> **aArray**: array of Integer;</sub> | <sub>Boolean</sub> |
| 7000+ | <a id="ArrayHasElementS">ArrayHasElementS</a><sub><br/>Checks whether requested array has specified single number</sub> | <sub>**aElement**: Single; <br/> **aArray**: array of Single;</sub> | <sub>Boolean</sub> |
| 7000+ | <a id="ArrayRemoveIndexI">ArrayRemoveIndexI</a><sub><br/>Removes element on specified index in specified array of integer.<br/>Integer array should be declared as TIntegerArray instead of array of integer.</sub> | <sub>**aIndex**: Integer; <br/> **aArray**: TIntegerArray;</sub> | <sub>TIntegerArray</sub> |
| 7000+ | <a id="ArrayRemoveIndexS">ArrayRemoveIndexS</a><sub><br/>Removes element on specified index in specified array of string.<br/>String array should be declared as TAnsiStringArray instead of array of AnsiString.</sub> | <sub>**aIndex**: Integer; <br/> **aArray**: TAnsiStringArray;</sub> | <sub>TAnsiStringArray</sub> |
| 7000+ | <a id="BoolToStr">BoolToStr</a><sub><br/>Return string representation of Boolean value: 'True' or 'False'</sub> | <sub>**aBool**: Boolean;</sub> | <sub>AnsiString</sub> |
| 7000+ | <a id="CeilTo">CeilTo</a><sub><br/>Rounds specified single number aValue to nearest multiple of specified base aBase. Rounding up.<br/>F.e. CeilTo(11.7, 5) = 15 while CeilTo(-11.7, 5) = -10</sub> | <sub>**aValue**: Single; <br/> **aBase**: Integer;</sub> | <sub>Integer</sub> |
| 10940 | <a id="ColorBrightness">ColorBrightness</a><sub><br/>Get Color Brightness from HEX BGR color</sub> | <sub>**aHexColor**: String;</sub> | <sub>Single // Color Brightness OR -1 if aHexColor not equal to HEX BGR</sub> |
| 11750 | <a id="CompareString">CompareString</a><sub><br/>Compares Str1 to Str2, with case-sensitivity.</sub> | <sub>**Str1**: String; <br/> **Str2**: String;</sub> | <sub>Integer // The return value is less than 0 if Str1 is less than Str2, 0 if Str1 equals Str2, or greater than 0 if Str1 is greater than Str2.</sub> |
| 11750 | <a id="CompareText">CompareText</a><sub><br/>Compares Str1 to Str2, without case-sensitivity.</sub> | <sub>**Str1**: String; <br/> **Str2**: String;</sub> | <sub>Integer // The return value is less than 0 if Str1 is less than Str2, 0 if Str1 equals Str2, or greater than 0 if Str1 is greater than Str2.</sub> |
| 11750 | <a id="CopyString">CopyString</a><sub><br/>Creates a copy of part of a string<br/>The first character of a string has index = 1.<br/>Up to Count characters are copied from the Index of the Str string to the returned string.<br/>Less than Count characters will be copied, if the end of the Str string is encountered before Count characters.</sub> | <sub>**Str**: String; <br/> **Index**: Integer; <br/> **Count**: Integer;</sub> | <sub>String // Copy of part of a Str string</sub> |
| 11750 | <a id="DeleteString">DeleteString</a><sub><br/>Deletes up to Count characters from the Str string starting from position Index<br/>The first character of a string has index = 1.<br/>If the Index is before the first, or after the last character of Str, then no characters are deleted<br/>No error is produced if Count exceeds the remaining character count of Str.</sub> | <sub>**var Str**: String; <br/> **Index**: Integer; <br/> **Count**: Integer;</sub> | <sub></sub> |
| 7000+ | <a id="EnsureRangeI">EnsureRangeI</a><sub><br/>Returns the closest to aValue integer that is in interval [aMin..aMax]</sub> | <sub>**aValue**: Integer; <br/> **aMin, aMax**: Integer;</sub> | <sub>Integer</sub> |
| 7000+ | <a id="EnsureRangeS">EnsureRangeS</a><sub><br/>Returns the closest to aValue single number that is in interval [aMin..aMax]</sub> | <sub>**aValue**: Single; <br/> **aMin, aMax**: Single;</sub> | <sub>Single</sub> |
| 7000+ | <a id="FloorTo">FloorTo</a><sub><br/>Rounds specified single number aValue to nearest multiple of specified base aBase. Rounding down.<br/>F.e. FloorTo(11.7, 5) = 10 while FloorTo(-11.7, 5) = -15</sub> | <sub>**aValue**: Single; <br/> **aBase**: Integer;</sub> | <sub>Integer</sub> |
| 7000+ | <a id="Format">Format</a><sub><br/>Wrapper for pascal Format function<br/>Formats aFormatting string with specified aData array of parameters</sub> | <sub>**aFormatting**: String; <br/> **aData**: array of const;</sub> | <sub>string</sub> |
| 11000 | <a id="FormatFloat">FormatFloat</a><sub><br/>Wrapper for pascal FormatFloat function<br/>Formats aValue with specified aFormat</sub> | <sub>**aFormat**: String; <br/> **aValue**: Single;</sub> | <sub>string</sub> |
| 7000+ | <a id="IfThen">IfThen</a><sub><br/>Checks condition aBool and returns aTrue/aFalse string depending on check result</sub> | <sub>**aBool**: Boolean; <br/> **aTrue**: AnsiString; <br/> **aFalse**: AnsiString;</sub> | <sub>AnsiString</sub> |
| 7000+ | <a id="IfThenI">IfThenI</a><sub><br/>Checks condition aBool and returns aTrue/aFalse integer depending on check result</sub> | <sub>**aBool**: Boolean; <br/> **aTrue**: Integer; <br/> **aFalse**: Integer;</sub> | <sub>Integer</sub> |
| 7000+ | <a id="IfThenS">IfThenS</a><sub><br/>Checks condition aBool and returns aTrue/aFalse single number depending on check result</sub> | <sub>**aBool**: Boolean; <br/> **aTrue**: Single; <br/> **aFalse**: Single;</sub> | <sub>Single</sub> |
| 7000+ | <a id="InAreaI">InAreaI</a><sub><br/>2D variant of InRange, can be used for unit locs checks</sub> | <sub>**aX, aY**: Integer; <br/> **aXMin**: Integer; <br/> **aYMin**: Integer; <br/> **aXMax**: Integer; <br/> **aYMax**: Integer;</sub> | <sub>Boolean</sub> |
| 7000+ | <a id="InAreaS">InAreaS</a><sub><br/>2D variant of InRange</sub> | <sub>**aX, aY**: Single; <br/> **aXMin**: Single; <br/> **aYMin**: Single; <br/> **aXMax**: Single; <br/> **aYMax**: Single;</sub> | <sub>Boolean</sub> |
| 7000+ | <a id="InRangeI">InRangeI</a><sub><br/>Checks whether specified aValue is in interval [aMin..aMax]</sub> | <sub>**aValue**: Integer; <br/> **aMin, aMax**: Integer;</sub> | <sub>Boolean</sub> |
| 7000+ | <a id="InRangeS">InRangeS</a><sub><br/>Checks whether specified aValue is in interval [aMin..aMax]</sub> | <sub>**aValue**: Single; <br/> **aMin, aMax**: Single;</sub> | <sub>Boolean</sub> |
| 11750 | <a id="InsertString">InsertString</a><sub><br/>Inserts one string, Source into another string, Target at the given position Index.<br/>The first character of a string has index = 1.<br/>The Target string characters from the Index character are moved right to make way for the Source string.<br/>The length of Target string is now the sum of the length of the two strings.<br/>To insert into the start of Target, set Index to 1 or less.<br/>To append to the end of Target, set Index after the last character of Target.</sub> | <sub>**Source**: String; <br/> **var Target**: String; <br/> **Index**: Integer;</sub> | <sub></sub> |
| 7000+ | <a id="KMPoint">KMPoint</a><sub><br/>Returns point record with specified coordinates</sub> | <sub>**X, Y**: Integer;</sub> | <sub>TKMPoint</sub> |
| 11750 | <a id="LowerCase">LowerCase</a><sub><br/>Changes upper case characters in a string Str to lower case</sub> | <sub>**Str**: String;</sub> | <sub>String</sub> |
| 7000+ | <a id="MaxI">MaxI</a><sub><br/>Returns max number of two specified</sub> | <sub>**A, B**: Integer;</sub> | <sub>Integer</sub> |
| 7000+ | <a id="MaxInArrayI">MaxInArrayI</a><sub><br/>Returns max number of array elements</sub> | <sub>**aArray**: array of Integer;</sub> | <sub>Integer</sub> |
| 7000+ | <a id="MaxInArrayS">MaxInArrayS</a><sub><br/>Returns max number of array elements</sub> | <sub>**aArray**: array of Single;</sub> | <sub>Single</sub> |
| 7000+ | <a id="MaxS">MaxS</a><sub><br/>Returns max number of two specified</sub> | <sub>**A, B**: Single;</sub> | <sub>Single</sub> |
| 7000+ | <a id="MinI">MinI</a><sub><br/>Returns min number of two specified</sub> | <sub>**A, B**: Integer;</sub> | <sub>Integer</sub> |
| 7000+ | <a id="MinInArrayI">MinInArrayI</a><sub><br/>Returns min number of array elements</sub> | <sub>**aArray**: array of Integer;</sub> | <sub>Integer</sub> |
| 7000+ | <a id="MinInArrayS">MinInArrayS</a><sub><br/>Returns min number of array elements</sub> | <sub>**aArray**: array of Single;</sub> | <sub>Single</sub> |
| 7000+ | <a id="MinS">MinS</a><sub><br/>Returns min number of two specified</sub> | <sub>**A, B**: Single;</sub> | <sub>Single</sub> |
| 11750 | <a id="MoveString">MoveString</a><sub><br/>Copy data from a Source to a Destination<br/>Count characters are copied from storage referenced by Source and written to Destination<br/>It can be used to take a copy of a substring from one string and overlay it on top of part of another string.</sub> | <sub>**Source**: String; <br/> **var Destination**: String; <br/> **Count**: Integer;</sub> | <sub></sub> |
| 11750 | <a id="Pos">Pos</a><sub><br/>Searches for a substring, SubStr, in a string, Str.<br/>Returns an integer value that is the index of the first character of SubStr within Str.<br/>Function is case-sensitive.<br/>If SubStr is not found, Result = 0</sub> | <sub>**SubStr**: String; <br/> **Str**: String;</sub> | <sub>Integer</sub> |
| 7000+ | <a id="Power">Power</a><sub><br/>Exponentation, base 'Base' raised to power 'Exp'.<br/>F.e. Power(3, 2) = 3^2 = 9<br/>Returns base "Base" raised to power "Exp"</sub> | <sub>**aBase**: Extended; <br/> **aExp**: Extended;</sub> | <sub>Extended</sub> |
| 11000 | <a id="RandomRangeI">RandomRangeI</a><sub><br/>Generates a random number in requested range aFrom..aTo (inclusive)</sub> | <sub>**aFrom**: Integer; <br/> **aTo**: Integer;</sub> | <sub>Integer</sub> |
| 10940 | <a id="RGBDecToBGRHex">RGBDecToBGRHex</a><sub><br/>Converts RGB to HEX BGR color<br/>Example<br/>VAR := RGBDecToBGRHex(255, 255, 0);<br/>The result of the VAR will be 00FFFF</sub> | <sub>**aR**: Byte; <br/> **aG**: Byte; <br/> **aB**: Byte;</sub> | <sub>AnsiString // HEX BGR Color</sub> |
| 10940 | <a id="RGBToBGRHex">RGBToBGRHex</a><sub><br/>Converts HEX RGB to HEX BGR color<br/>Example<br/>VAR := RGBToBGRHex('#FFFF00');<br/>The result of the VAR will be 00FFFF</sub> | <sub>**aHexColor**: String;</sub> | <sub>AnsiString // HEX BGR Color or '' if aHexColor not equal to HEX RGB</sub> |
| 12400+ | <a id="RoundTo">RoundTo</a><sub><br/>Rounds specified single number aValue to nearest multiple of specified base aBase. Rounding to the nearest integer.<br/>If the number is exactly midway between two integers, then it rounds towards the even one (multiplied on aBase).<br/>F.e. RoundTo(11.7, 5) = 10 while RoundTo(-11.7, 5) = -10<br/>RoundTo(12.5, 5) = 10 while RoundTo(17.5, 5) = 20</sub> | <sub>**aValue**: Single; <br/> **aBase**: Integer;</sub> | <sub>Integer</sub> |
| 7000+ | <a id="Sqr">Sqr</a><sub><br/>Returns A^2 = A*A</sub> | <sub>**A**: Extended;</sub> | <sub>Extended</sub> |
| 11750 | <a id="StringReplace">StringReplace</a><sub><br/>Replaces the first or all occurences of a substring OldPattern in Str string with NewPattern according to Flags settings<br/>The changed string is returned as Result<br/>The Flags may be none, one, or both of these set values:<br/>rfReplaceAll: Change all occurrences<br/>rfIgnoreCase: Ignore case when searching</sub> | <sub>**Str**: String; <br/> **OldPattern**: String; <br/> **NewPattern**: String; <br/> **Flags**: TReplaceFlags;</sub> | <sub>String</sub> |
| 7000+ | <a id="SumI">SumI</a><sub><br/>Returns sum of the elements of requested array</sub> | <sub>**aArray**: array of Integer;</sub> | <sub>Integer</sub> |
| 7000+ | <a id="SumS">SumS</a><sub><br/>Returns sum of the elements of requested array</sub> | <sub>**aArray**: array of Single;</sub> | <sub>Single</sub> |
| 7000+ | <a id="TimeToString">TimeToString</a><sub><br/>Converts game ticks count into string: HH:MM:SS<br/>Can be used for scripted timers</sub> | <sub>**aTicks**: Integer;</sub> | <sub>AnsiString</sub> |
| 10940 | <a id="TimeToTick">TimeToTick</a><sub><br/>Converts Time in game ticks</sub> | <sub>**aHours**: Integer; <br/> **aMinutes**: Integer; <br/> **aSeconds**: Integer;</sub> | <sub>Cardinal // game ticks</sub> |
| 11750 | <a id="Trim">Trim</a><sub><br/>Removes blank and control characters (such as line feed) from the start and end of a string.</sub> | <sub>**Str**: String;</sub> | <sub>String</sub> |
| 11750 | <a id="TrimLeft">TrimLeft</a><sub><br/>Removes blank and control characters (such as line feed) from the start of a string.</sub> | <sub>**Str**: String;</sub> | <sub>String</sub> |
| 11750 | <a id="TrimRight">TrimRight</a><sub><br/>Removes blank and control characters (such as line feed) from the end of a string.</sub> | <sub>**Str**: String;</sub> | <sub>String</sub> |
| 12400+ | <a id="TruncTo">TruncTo</a><sub><br/>Rounds specified single number aValue to nearest multiple of specified base aBase. Rounding to zero.<br/>F.e. TruncTo(11.7, 5) = 10 while TruncTo(-11.7, 5) = -10</sub> | <sub>**aValue**: Single; <br/> **aBase**: Integer;</sub> | <sub>Integer</sub> |
| 11750 | <a id="UpperCase">UpperCase</a><sub><br/>Changes lower case characters in a string Str to upper case</sub> | <sub>**Str**: String;</sub> | <sub>String</sub> |
