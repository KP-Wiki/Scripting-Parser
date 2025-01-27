### Utils

Version column description:  
<sub>"-" Means this util was added from the start.</sub>  
<sub>"5678" Means this util was introduced in revision 5678.</sub>  
<sub>"-5678" Means this util was removed in revision 5678.</sub>


***

* <a href="#AbsI">AbsI</a>
* <a href="#AbsS">AbsS</a>
* <a href="#ArrayAppend">ArrayAppend</a>
* <a href="#ArrayAppendI">ArrayAppendI</a>
* <a href="#ArrayAppendS">ArrayAppendS</a>
* <a href="#ArrayElementCount">&#x274C; ArrayElementCount</a>
* <a href="#ArrayElementCount">ArrayElementCount</a>
* <a href="#ArrayElementCountI">&#x274C; ArrayElementCountI</a>
* <a href="#ArrayElementCountI">ArrayElementCountI</a>
* <a href="#ArrayElementCountS">&#x274C; ArrayElementCountS</a>
* <a href="#ArrayElementCountS">ArrayElementCountS</a>
* <a href="#ArrayFindMaxI">ArrayFindMaxI</a>
* <a href="#ArrayFindMaxS">ArrayFindMaxS</a>
* <a href="#ArrayFindMinI">ArrayFindMinI</a>
* <a href="#ArrayFindMinS">ArrayFindMinS</a>
* <a href="#ArrayHasElement">&#x274C; ArrayHasElement</a>
* <a href="#ArrayHasElement">ArrayHasElement</a>
* <a href="#ArrayHasElementI">&#x274C; ArrayHasElementI</a>
* <a href="#ArrayHasElementI">ArrayHasElementI</a>
* <a href="#ArrayHasElementS">&#x274C; ArrayHasElementS</a>
* <a href="#ArrayHasElementS">ArrayHasElementS</a>
* <a href="#ArraySumI">ArraySumI</a>
* <a href="#ArraySumS">ArraySumS</a>
* <a href="#ColorFromHSB">ColorFromHSB</a>
* <a href="#ColorFromHSV">ColorFromHSV</a>
* <a href="#ColorFromRGB">ColorFromRGB</a>
* <a href="#DistanceI">DistanceI</a>
* <a href="#DistanceS">DistanceS</a>
* <a href="#EnsureRangeI">EnsureRangeI</a>
* <a href="#EnsureRangeS">EnsureRangeS</a>
* <a href="#FMod">FMod</a>
* <a href="#Format">Format</a>
* <a href="#HexToInt">HexToInt</a>
* <a href="#IfThen">IfThen</a>
* <a href="#IfThenI">IfThenI</a>
* <a href="#IfThenS">IfThenS</a>
* <a href="#InAreaI">InAreaI</a>
* <a href="#InAreaS">InAreaS</a>
* <a href="#InRangeI">InRangeI</a>
* <a href="#InRangeS">InRangeS</a>
* <a href="#Lerp">Lerp</a>
* <a href="#LerpXY">LerpXY</a>
* <a href="#MapRange">MapRange</a>
* <a href="#MaxI">MaxI</a>
* <a href="#MaxInArrayI">&#x274C; MaxInArrayI</a>
* <a href="#MaxInArrayS">&#x274C; MaxInArrayS</a>
* <a href="#MaxS">MaxS</a>
* <a href="#MinI">MinI</a>
* <a href="#MinInArrayI">&#x274C; MinInArrayI</a>
* <a href="#MinInArrayS">&#x274C; MinInArrayS</a>
* <a href="#MinS">MinS</a>
* <a href="#Power">Power</a>
* <a href="#Random">Random</a>
* <a href="#RandomI">RandomI</a>
* <a href="#Sqr">Sqr</a>
* <a href="#SumI">&#x274C; SumI</a>
* <a href="#SumS">&#x274C; SumS</a>
* <a href="#TimeToString">TimeToString</a>
<br />

| Ver<br/>sion | Utility function<br/>description | Parameters<br/>and types | Returns |
| ------- | ------------------------------------ | -------------- | ------- |
| 5422 | <a id="AbsI">AbsI</a><sub><br/>Returns absolute value of specified integer</sub> | <sub>**aValue**: Integer;</sub> | <sub>Integer</sub> |
| 5422 | <a id="AbsS">AbsS</a><sub><br/>Returns absolute value of specified single number</sub> | <sub>**aValue**: Single;</sub> | <sub>Single</sub> |
| 15066 | <a id="ArrayAppend">ArrayAppend</a><sub><br/>Appends value to an array of string and returns new array.<br/>String array should be declared as TKMStringArray instead of "array of string".</sub> | <sub>**var aArray**: TKMStringArray; <br/> **aValue**: string;</sub> | <sub></sub> |
| 15066 | <a id="ArrayAppendI">ArrayAppendI</a><sub><br/>Appends value to an array of integer and returns new array.<br/>Integer array should be declared as TKMIntegerArray instead of "array of integer".</sub> | <sub>**var aArray**: TKMIntegerArray; <br/> **aValue**: Integer;</sub> | <sub></sub> |
| 15066 | <a id="ArrayAppendS">ArrayAppendS</a><sub><br/>Appends value to an array of single and returns new array.<br/>Single array should be declared as TKMSingleArray instead of "array of single".</sub> | <sub>**var aArray**: TKMSingleArray; <br/> **aValue**: Single;</sub> | <sub></sub> |
| 5422 | <a id="ArrayElementCount">ArrayElementCount</a><br/>&#x274C;`Removed`<br/><sub>*Method was removed, use <a href="#ArrayElementCount">ArrayElementCount</a> instead*</sub><sub></sub> | <sub>**aArray**: array of String; <br/> **aElement**: string;</sub> | <sub>Integer</sub> |
| 15136 | <a id="ArrayElementCount">ArrayElementCount</a><sub><br/>Checks how many times specified string comes in requested array</sub> | <sub>**aArray**: array of String; <br/> **aElement**: string;</sub> | <sub>Integer</sub> |
| 5422 | <a id="ArrayElementCountI">ArrayElementCountI</a><br/>&#x274C;`Removed`<br/><sub>*Method was removed, use <a href="#ArrayElementCountI">ArrayElementCountI</a> instead*</sub><sub></sub> | <sub>**aArray**: array of Integer; <br/> **aElement**: Integer;</sub> | <sub>Integer</sub> |
| 15136 | <a id="ArrayElementCountI">ArrayElementCountI</a><sub><br/>Checks how many times specified integer comes in requested array</sub> | <sub>**aArray**: array of Integer; <br/> **aElement**: Integer;</sub> | <sub>Integer</sub> |
| 5422 | <a id="ArrayElementCountS">ArrayElementCountS</a><br/>&#x274C;`Removed`<br/><sub>*Method was removed, use <a href="#ArrayElementCountS">ArrayElementCountS</a> instead*</sub><sub></sub> | <sub>**aArray**: array of Single; <br/> **aElement**: Single;</sub> | <sub>Integer</sub> |
| 15136 | <a id="ArrayElementCountS">ArrayElementCountS</a><sub><br/>Checks how many times specified single comes in requested array</sub> | <sub>**aArray**: array of Single; <br/> **aElement**: Single;</sub> | <sub>Integer</sub> |
| 15136 | <a id="ArrayFindMaxI">ArrayFindMaxI</a><sub><br/>Returns max number of array elements</sub> | <sub>**aArray**: array of Integer;</sub> | <sub>Integer</sub> |
| 15136 | <a id="ArrayFindMaxS">ArrayFindMaxS</a><sub><br/>Returns max number of array elements</sub> | <sub>**aArray**: array of Single;</sub> | <sub>Single</sub> |
| 15136 | <a id="ArrayFindMinI">ArrayFindMinI</a><sub><br/>Returns min number of array elements</sub> | <sub>**aArray**: array of Integer;</sub> | <sub>Integer</sub> |
| 15136 | <a id="ArrayFindMinS">ArrayFindMinS</a><sub><br/>Returns min number of array elements</sub> | <sub>**aArray**: array of Single;</sub> | <sub>Single</sub> |
| 5422 | <a id="ArrayHasElement">ArrayHasElement</a><br/>&#x274C;`Removed`<br/><sub>*Method was removed, use <a href="#ArrayHasElement">ArrayHasElement</a> instead*</sub><sub></sub> | <sub>**aArray**: array of String; <br/> **aElement**: string;</sub> | <sub>Boolean</sub> |
| 15136 | <a id="ArrayHasElement">ArrayHasElement</a><sub><br/>Checks whether requested array has specified string</sub> | <sub>**aArray**: array of String; <br/> **aElement**: string;</sub> | <sub>Boolean</sub> |
| 5422 | <a id="ArrayHasElementI">ArrayHasElementI</a><br/>&#x274C;`Removed`<br/><sub>*Method was removed, use <a href="#ArrayHasElementI">ArrayHasElementI</a> instead*</sub><sub></sub> | <sub>**aArray**: array of Integer; <br/> **aElement**: Integer;</sub> | <sub>Boolean</sub> |
| 15136 | <a id="ArrayHasElementI">ArrayHasElementI</a><sub><br/>Checks whether requested array has specified integer</sub> | <sub>**aArray**: array of Integer; <br/> **aElement**: Integer;</sub> | <sub>Boolean</sub> |
| 5422 | <a id="ArrayHasElementS">ArrayHasElementS</a><br/>&#x274C;`Removed`<br/><sub>*Method was removed, use <a href="#ArrayHasElementS">ArrayHasElementS</a> instead*</sub><sub></sub> | <sub>**aArray**: array of Single; <br/> **aElement**: Single;</sub> | <sub>Boolean</sub> |
| 15136 | <a id="ArrayHasElementS">ArrayHasElementS</a><sub><br/>Checks whether requested array has specified single number</sub> | <sub>**aArray**: array of Single; <br/> **aElement**: Single;</sub> | <sub>Boolean</sub> |
| 15136 | <a id="ArraySumI">ArraySumI</a><sub><br/>Returns sum of the elements of requested array</sub> | <sub>**aArray**: array of Integer;</sub> | <sub>Integer</sub> |
| 15136 | <a id="ArraySumS">ArraySumS</a><sub><br/>Returns sum of the elements of requested array</sub> | <sub>**aArray**: array of Single;</sub> | <sub>Single</sub> |
| 14387 | <a id="ColorFromHSB">ColorFromHSB</a><sub><br/>Create RGB color from Hue, Saturation and Brightness<br/>Hue goes from 0.0 to 1.0 (RoyG.Biv)<br/>Saturation goes from 0.0 to 1.0 (Grey to Colorful)<br/>Brightness goes from 0.0 to 1.0 (Black to Bright to White)<br/>Returns RGB color value</sub> | <sub>**H**: Single; <br/> **S**: Single; <br/> **B**: Single;</sub> | <sub>Integer</sub> |
| 14387 | <a id="ColorFromHSV">ColorFromHSV</a><sub><br/>Create RGB color from Hue, Saturation and Volume<br/>Hue goes from 0.0 to 1.0 (RoyG.Biv)<br/>Saturation goes from 0.0 to 1.0 (Grey to Colorful)<br/>Volume goes from 0.0 to 1.0 (Black to Bright)<br/>Returns RGB color value</sub> | <sub>**H**: Single; <br/> **S**: Single; <br/> **V**: Single;</sub> | <sub>Integer</sub> |
| 14387 | <a id="ColorFromRGB">ColorFromRGB</a><sub><br/>Create RGB color from Red, Green and Blue components<br/>All values need to be in the range 0.0 to 1.0<br/>Returns RGB color value</sub> | <sub>**R**: Single; <br/> **G**: Single; <br/> **B**: Single;</sub> | <sub>Integer</sub> |
| 14363 | <a id="DistanceI">DistanceI</a><sub><br/>Returns the length of the vector. Sqrt(x * x + y * y)</sub> | <sub>**aX, aY**: Integer;</sub> | <sub>Single</sub> |
| 14363 | <a id="DistanceS">DistanceS</a><sub><br/>Returns the length of the vector. Sqrt(x * x + y * y)</sub> | <sub>**aX, aY**: Single;</sub> | <sub>Single</sub> |
| 5422 | <a id="EnsureRangeI">EnsureRangeI</a><sub><br/>Returns the closest to aValue integer that is in interval [aMin..aMax]</sub> | <sub>**aValue**: Integer; <br/> **aMin, aMax**: Integer;</sub> | <sub>Integer</sub> |
| 5422 | <a id="EnsureRangeS">EnsureRangeS</a><sub><br/>Returns the closest to aValue single number that is in interval [aMin..aMax]</sub> | <sub>**aValue**: Single; <br/> **aMin, aMax**: Single;</sub> | <sub>Single</sub> |
| 15658 | <a id="FMod">FMod</a><sub><br/>Returns floating point remainder of aNumerator / aDenominator (like mod in integers) with the same sign as aNumerator.</sub> | <sub>**aNumerator**: Single; <br/> **aDenominator**: Single;</sub> | <sub>Single</sub> |
| 5422 | <a id="Format">Format</a><sub><br/>Wrapper for pascal Format function<br/>Formats aFormat string with specified aArgs array of arguments</sub> | <sub>**aFormat**: string; <br/> **aArgs**: array of const;</sub> | <sub>string</sub> |
| 5422 | <a id="HexToInt">HexToInt</a><sub><br/>Converts hex string into a number</sub> | <sub>**aHexString**: string; // _should be in form "1234AB", without $ or 0x prefix_</sub> | <sub>Integer</sub> |
| 5422 | <a id="IfThen">IfThen</a><sub><br/>Checks condition aBool and returns aTrue/aFalse string depending on check result</sub> | <sub>**aBool**: Boolean; <br/> **aTrue**: string; <br/> **aFalse**: string;</sub> | <sub>string</sub> |
| 5422 | <a id="IfThenI">IfThenI</a><sub><br/>Checks condition aBool and returns aTrue/aFalse integer depending on check result</sub> | <sub>**aBool**: Boolean; <br/> **aTrue**: Integer; <br/> **aFalse**: Integer;</sub> | <sub>Integer</sub> |
| 5422 | <a id="IfThenS">IfThenS</a><sub><br/>Checks condition aBool and returns aTrue/aFalse single number depending on check result</sub> | <sub>**aBool**: Boolean; <br/> **aTrue**: Single; <br/> **aFalse**: Single;</sub> | <sub>Single</sub> |
| 5422 | <a id="InAreaI">InAreaI</a><sub><br/>2D variant of InRange, can be used for unit locs checks</sub> | <sub>**aX, aY**: Integer; <br/> **aXMin**: Integer; <br/> **aYMin**: Integer; <br/> **aXMax**: Integer; <br/> **aYMax**: Integer;</sub> | <sub>Boolean</sub> |
| 5422 | <a id="InAreaS">InAreaS</a><sub><br/>2D variant of InRange</sub> | <sub>**aX, aY**: Single; <br/> **aXMin**: Single; <br/> **aYMin**: Single; <br/> **aXMax**: Single; <br/> **aYMax**: Single;</sub> | <sub>Boolean</sub> |
| 5422 | <a id="InRangeI">InRangeI</a><sub><br/>Checks whether specified aValue is in interval [aMin..aMax]</sub> | <sub>**aValue**: Integer; <br/> **aMin, aMax**: Integer;</sub> | <sub>Boolean</sub> |
| 5422 | <a id="InRangeS">InRangeS</a><sub><br/>Checks whether specified aValue is in interval [aMin..aMax]</sub> | <sub>**aValue**: Single; <br/> **aMin, aMax**: Single;</sub> | <sub>Boolean</sub> |
| 14995 | <a id="Lerp">Lerp</a><sub><br/>Interpolates linearly between A and B.<br/>The function will work with any value of aFraction, but usually it must be between 0.0 and 1.0</sub> | <sub>**A, B**: Single; <br/> **aFrac**: Single;</sub> | <sub>Single</sub> |
| 14995 | <a id="LerpXY">LerpXY</a><sub><br/>Interpolates linearly between two sets of X and Y values.<br/>The function will work with any value of aFrac, but usually it must be between 0.0 and 1.0</sub> | <sub>**aX1**: Single; <br/> **aX2**: Single; <br/> **aY1**: Single; <br/> **aY2**: Single; <br/> **aFracX**: Single; <br/> **aFracY**: Single;</sub> | <sub>Single</sub> |
| 14995 | <a id="MapRange">MapRange</a><sub><br/>Maps a value proportionally from one range to another</sub> | <sub>**aValue**: Single; <br/> **aFromMin**: Single; <br/> **aFromMax**: Single; <br/> **aToMin**: Single; <br/> **aToMax**: Single;</sub> | <sub>Single</sub> |
| 5422 | <a id="MaxI">MaxI</a><sub><br/>Returns max number of two specified</sub> | <sub>**A, B**: Integer;</sub> | <sub>Integer</sub> |
| 5422 | <a id="MaxInArrayI">MaxInArrayI</a><br/>&#x274C;`Removed`<br/><sub>*Method was removed, use <a href="#ArrayFindMaxI">ArrayFindMaxI</a> instead*</sub><sub></sub> | <sub>**aArray**: array of Integer;</sub> | <sub>Integer</sub> |
| 5422 | <a id="MaxInArrayS">MaxInArrayS</a><br/>&#x274C;`Removed`<br/><sub>*Method was removed, use <a href="#ArrayFindMaxS">ArrayFindMaxS</a> instead*</sub><sub></sub> | <sub>**aArray**: array of Single;</sub> | <sub>Single</sub> |
| 5422 | <a id="MaxS">MaxS</a><sub><br/>Returns max number of two specified</sub> | <sub>**A, B**: Single;</sub> | <sub>Single</sub> |
| 5422 | <a id="MinI">MinI</a><sub><br/>Returns min number of two specified</sub> | <sub>**A, B**: Integer;</sub> | <sub>Integer</sub> |
| 5422 | <a id="MinInArrayI">MinInArrayI</a><br/>&#x274C;`Removed`<br/><sub>*Method was removed, use <a href="#ArrayFindMinI">ArrayFindMinI</a> instead*</sub><sub></sub> | <sub>**aArray**: array of Integer;</sub> | <sub>Integer</sub> |
| 5422 | <a id="MinInArrayS">MinInArrayS</a><br/>&#x274C;`Removed`<br/><sub>*Method was removed, use <a href="#ArrayFindMinS">ArrayFindMinS</a> instead*</sub><sub></sub> | <sub>**aArray**: array of Single;</sub> | <sub>Single</sub> |
| 5422 | <a id="MinS">MinS</a><sub><br/>Returns min number of two specified</sub> | <sub>**A, B**: Single;</sub> | <sub>Single</sub> |
| 5422 | <a id="Power">Power</a><sub><br/>Exponentation, returns base "aBase" raised to power "aExp". F.e. Power(3, 2) = 3^2 = 9</sub> | <sub>**aBase**: Extended; <br/> **aExp**: Extended;</sub> | <sub>Extended</sub> |
| 6683 | <a id="Random">Random</a><sub><br/>Returns random float within 0..1</sub> | <sub></sub> | <sub>Single</sub> |
| 6683 | <a id="RandomI">RandomI</a><sub><br/>Returns random integer within 0..aMax-1</sub> | <sub>**aMax**: Integer;</sub> | <sub>Integer</sub> |
| 5422 | <a id="Sqr">Sqr</a><sub><br/>Returns A^2 = A*A</sub> | <sub>**A**: Extended;</sub> | <sub>Extended</sub> |
| 5422 | <a id="SumI">SumI</a><br/>&#x274C;`Removed`<br/><sub>*Method was removed, use <a href="#ArraySumI">ArraySumI</a> instead*</sub><sub></sub> | <sub>**aArray**: array of Integer;</sub> | <sub>Integer</sub> |
| 5422 | <a id="SumS">SumS</a><br/>&#x274C;`Removed`<br/><sub>*Method was removed, use <a href="#ArraySumS">ArraySumS</a> instead*</sub><sub></sub> | <sub>**aArray**: array of Single;</sub> | <sub>Single</sub> |
| 5422 | <a id="TimeToString">TimeToString</a><sub><br/>Converts game ticks count into string: HH:MM:SS<br/>Can be used for scripted timers</sub> | <sub>**aTicks**: Integer;</sub> | <sub>string</sub> |
