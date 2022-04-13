### Utils

Version column description:  
<sub>"-" Means this util was added from the start.</sub>  
<sub>"5678" Means this util was introduced in revision 5678.</sub>  
<sub>"-5678" Means this util was removed in revision 5678.</sub>


***

* <a href="#AbsI">AbsI</a>
* <a href="#AbsS">AbsS</a>
* <a href="#ArrayElementCount">ArrayElementCount</a>
* <a href="#ArrayElementCountI">ArrayElementCountI</a>
* <a href="#ArrayElementCountS">ArrayElementCountS</a>
* <a href="#ArrayHasElement">ArrayHasElement</a>
* <a href="#ArrayHasElementI">ArrayHasElementI</a>
* <a href="#ArrayHasElementS">ArrayHasElementS</a>
* <a href="#EnsureRangeI">EnsureRangeI</a>
* <a href="#EnsureRangeS">EnsureRangeS</a>
* <a href="#Format">Format</a>
* <a href="#HexToInt">HexToInt</a>
* <a href="#IfThen">IfThen</a>
* <a href="#IfThenI">IfThenI</a>
* <a href="#IfThenS">IfThenS</a>
* <a href="#InAreaI">InAreaI</a>
* <a href="#InAreaS">InAreaS</a>
* <a href="#InRangeI">InRangeI</a>
* <a href="#InRangeS">InRangeS</a>
* <a href="#MaxI">MaxI</a>
* <a href="#MaxInArrayI">MaxInArrayI</a>
* <a href="#MaxInArrayS">MaxInArrayS</a>
* <a href="#MaxS">MaxS</a>
* <a href="#MinI">MinI</a>
* <a href="#MinInArrayI">MinInArrayI</a>
* <a href="#MinInArrayS">MinInArrayS</a>
* <a href="#MinS">MinS</a>
* <a href="#Power">Power</a>
* <a href="#Random">Random</a>
* <a href="#RandomI">RandomI</a>
* <a href="#Sqr">Sqr</a>
* <a href="#SumI">SumI</a>
* <a href="#SumS">SumS</a>
* <a href="#TimeToString">TimeToString</a>
<br />

| Ver<br/>sion | Utility function<br/>description | Parameters<br/>and types | Returns |
| ------- | ------------------------------------ | -------------- | ------- |
| 5422 | <a id="AbsI">AbsI</a><sub><br/>Returns absolute value of specified integer</sub> | <sub>**aValue**: Integer;</sub> | <sub>Integer</sub> |
| 5422 | <a id="AbsS">AbsS</a><sub><br/>Returns absolute value of specified single number</sub> | <sub>**aValue**: Single;</sub> | <sub>Single</sub> |
| 5422 | <a id="ArrayElementCount">ArrayElementCount</a><sub><br/>Checks how many times specified string comes in requested array</sub> | <sub>**aElement**: string; <br/> **aArray**: array of String;</sub> | <sub>Integer</sub> |
| 5422 | <a id="ArrayElementCountI">ArrayElementCountI</a><sub><br/>Checks how many times specified integer comes in requested array</sub> | <sub>**aElement**: Integer; <br/> **aArray**: array of Integer;</sub> | <sub>Integer</sub> |
| 5422 | <a id="ArrayElementCountS">ArrayElementCountS</a><sub><br/>Checks how many times specified single comes in requested array</sub> | <sub>**aElement**: Single; <br/> **aArray**: array of Single;</sub> | <sub>Integer</sub> |
| 5422 | <a id="ArrayHasElement">ArrayHasElement</a><sub><br/>Checks whether requested array has specified string</sub> | <sub>**aElement**: string; <br/> **aArray**: array of String;</sub> | <sub>Boolean</sub> |
| 5422 | <a id="ArrayHasElementI">ArrayHasElementI</a><sub><br/>Checks whether requested array has specified integer</sub> | <sub>**aElement**: Integer; <br/> **aArray**: array of Integer;</sub> | <sub>Boolean</sub> |
| 5422 | <a id="ArrayHasElementS">ArrayHasElementS</a><sub><br/>Checks whether requested array has specified single number</sub> | <sub>**aElement**: Single; <br/> **aArray**: array of Single;</sub> | <sub>Boolean</sub> |
| 5422 | <a id="EnsureRangeI">EnsureRangeI</a><sub><br/>Returns the closest to aValue integer that is in interval [aMin..aMax]</sub> | <sub>**aValue**: Integer; <br/> **aMin, aMax**: Integer;</sub> | <sub>Integer</sub> |
| 5422 | <a id="EnsureRangeS">EnsureRangeS</a><sub><br/>Returns the closest to aValue single number that is in interval [aMin..aMax]</sub> | <sub>**aValue**: Single; <br/> **aMin, aMax**: Single;</sub> | <sub>Single</sub> |
| 5422 | <a id="Format">Format</a><sub><br/>Wrapper for pascal Format function<br/>Formats aFormat string with specified aArgs array of arguments</sub> | <sub>**aFormat**: string; <br/> **aArgs**: array of const;</sub> | <sub>string</sub> |
| 5422 | <a id="HexToInt">HexToInt</a><sub><br/>Converts hex string into a number</sub> | <sub>**aHexString**: string; // _should be in form "1234AB", without $ or 0x prefix_</sub> | <sub>Integer</sub> |
| 5422 | <a id="IfThen">IfThen</a><sub><br/>Checks condition aBool and returns aTrue/aFalse string depending on check result</sub> | <sub>**aBool**: Boolean; <br/> **aTrue**: string; <br/> **aFalse**: string;</sub> | <sub>string</sub> |
| 5422 | <a id="IfThenI">IfThenI</a><sub><br/>Checks condition aBool and returns aTrue/aFalse integer depending on check result</sub> | <sub>**aBool**: Boolean; <br/> **aTrue**: Integer; <br/> **aFalse**: Integer;</sub> | <sub>Integer</sub> |
| 5422 | <a id="IfThenS">IfThenS</a><sub><br/>Checks condition aBool and returns aTrue/aFalse single number depending on check result</sub> | <sub>**aBool**: Boolean; <br/> **aTrue**: Single; <br/> **aFalse**: Single;</sub> | <sub>Single</sub> |
| 5422 | <a id="InAreaI">InAreaI</a><sub><br/>2D variant of InRange, can be used for unit locs checks</sub> | <sub>**aX, aY**: Integer; <br/> **aXMin**: Integer; <br/> **aYMin**: Integer; <br/> **aXMax**: Integer; <br/> **aYMax**: Integer;</sub> | <sub>Boolean</sub> |
| 5422 | <a id="InAreaS">InAreaS</a><sub><br/>2D variant of InRange</sub> | <sub>**aX, aY**: Single; <br/> **aXMin**: Single; <br/> **aYMin**: Single; <br/> **aXMax**: Single; <br/> **aYMax**: Single;</sub> | <sub>Boolean</sub> |
| 5422 | <a id="InRangeI">InRangeI</a><sub><br/>Checks whether specified aValue is in interval [aMin..aMax]</sub> | <sub>**aValue**: Integer; <br/> **aMin, aMax**: Integer;</sub> | <sub>Boolean</sub> |
| 5422 | <a id="InRangeS">InRangeS</a><sub><br/>Checks whether specified aValue is in interval [aMin..aMax]</sub> | <sub>**aValue**: Single; <br/> **aMin, aMax**: Single;</sub> | <sub>Boolean</sub> |
| 5422 | <a id="MaxI">MaxI</a><sub><br/>Returns max number of two specified</sub> | <sub>**A, B**: Integer;</sub> | <sub>Integer</sub> |
| 5422 | <a id="MaxInArrayI">MaxInArrayI</a><sub><br/>Returns max number of array elements</sub> | <sub>**aArray**: array of Integer;</sub> | <sub>Integer</sub> |
| 5422 | <a id="MaxInArrayS">MaxInArrayS</a><sub><br/>Returns max number of array elements</sub> | <sub>**aArray**: array of Single;</sub> | <sub>Single</sub> |
| 5422 | <a id="MaxS">MaxS</a><sub><br/>Returns max number of two specified</sub> | <sub>**A, B**: Single;</sub> | <sub>Single</sub> |
| 5422 | <a id="MinI">MinI</a><sub><br/>Returns min number of two specified</sub> | <sub>**A, B**: Integer;</sub> | <sub>Integer</sub> |
| 5422 | <a id="MinInArrayI">MinInArrayI</a><sub><br/>Returns min number of array elements</sub> | <sub>**aArray**: array of Integer;</sub> | <sub>Integer</sub> |
| 5422 | <a id="MinInArrayS">MinInArrayS</a><sub><br/>Returns min number of array elements</sub> | <sub>**aArray**: array of Single;</sub> | <sub>Single</sub> |
| 5422 | <a id="MinS">MinS</a><sub><br/>Returns min number of two specified</sub> | <sub>**A, B**: Single;</sub> | <sub>Single</sub> |
| 5422 | <a id="Power">Power</a><sub><br/>Exponentation, returns base "Base" raised to power "Exp". F.e. Power(3, 2) = 3^2 = 9</sub> | <sub>**Base**: Extended; <br/> **Exp**: Extended;</sub> | <sub>Extended</sub> |
| 6683 | <a id="Random">Random</a><sub><br/>Returns random float within 0..1</sub> | <sub></sub> | <sub>Single</sub> |
| 6683 | <a id="RandomI">RandomI</a><sub><br/>Returns random integer within 0..aMax-1</sub> | <sub>**aMax**: Integer;</sub> | <sub>Integer</sub> |
| 5422 | <a id="Sqr">Sqr</a><sub><br/>Returns A^2 = A*A</sub> | <sub>**A**: Extended;</sub> | <sub>Extended</sub> |
| 5422 | <a id="SumI">SumI</a><sub><br/>Returns sum of the elements of requested array</sub> | <sub>**aArray**: array of Integer;</sub> | <sub>Integer</sub> |
| 5422 | <a id="SumS">SumS</a><sub><br/>Returns sum of the elements of requested array</sub> | <sub>**aArray**: array of Single;</sub> | <sub>Single</sub> |
| 5422 | <a id="TimeToString">TimeToString</a><sub><br/>Converts game ticks count into string: HH:MM:SS<br/>Can be used for scripted timers</sub> | <sub>**aTicks**: Integer;</sub> | <sub>string</sub> |
