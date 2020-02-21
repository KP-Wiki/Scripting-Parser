####Utils

| Ver<br>sion | Utility function<br>Description | Parameters<br>and types | Returns |
| ------- | --------------- | -------------------- | ------- |
| 5422 | AbsI<br><sub> Returns absolute value of specified integer</sub> | <sub>**aValue**: Integer;</sub> | <sub>Integer</sub> |
| 5422 | AbsS<br><sub> Returns absolute value of specified single number</sub> | <sub>**aValue**: Single;</sub> | <sub>Single</sub> |
| 5422 | ArrayElementCount<br><sub> Checks how many times specified string comes in requested array</sub> | <sub>**aElement**: String; <br> **aArray**: array of String;</sub> | <sub>Integer</sub> |
| 5422 | ArrayElementCountI<br><sub> Checks how many times specified integer comes in requested array</sub> | <sub>**aElement**: Integer; <br> **aArray**: array of Integer;</sub> | <sub>Integer</sub> |
| 5422 | ArrayElementCountI<br><sub> Checks how many times specified boolean comes in requested array</sub> | <sub>**aElement**: Integer; <br> **aArray**: array of Integer;</sub> | <sub>Integer</sub> |
| 5422 | ArrayElementCountS<br><sub> Checks how many times specified single comes in requested array</sub> | <sub>**aElement**: Single; <br> **aArray**: array of Single;</sub> | <sub>Integer</sub> |
| 5422 | ArrayHasElement<br><sub> Checks whether requested array has specified string</sub> | <sub>**aElement**: String; <br> **aArray**: array of String;</sub> | <sub>Boolean</sub> |
| 5422 | ArrayHasElementI<br><sub> Checks whether requested array has specified integer</sub> | <sub>**aElement**: Integer; <br> **aArray**: array of Integer;</sub> | <sub>Boolean</sub> |
| 5422 | ArrayHasElementI<br><sub> Checks whether requested array has specified boolean</sub> | <sub>**aElement**: Integer; <br> **aArray**: array of Integer;</sub> | <sub>Boolean</sub> |
| 5422 | ArrayHasElementS<br><sub> Checks whether requested array has specified single number</sub> | <sub>**aElement**: Single; <br> **aArray**: array of Single;</sub> | <sub>Boolean</sub> |
| 5422 | EnsureRangeI<br><sub> Returns the closest to aValue integer that is in interval [aMin..aMax]</sub> | <sub>**aValue**: Integer; <br> **aMin**: Integer; <br> **aMax**: Integer;</sub> | <sub>Integer</sub> |
| 5422 | EnsureRangeS<br><sub> Returns the closest to aValue single number that is in interval [aMin..aMax]</sub> | <sub>**aValue**: Single; <br> **aMin**: Single; <br> **aMax**: Single;</sub> | <sub>Single</sub> |
| 5422 | Format<br><sub> Wrapper for pascal Format function Formats aFormat string with specified aArgs array of arguments</sub> | <sub>**aFormat**: String; <br> **aArgs**: array of const;</sub> | <sub>string</sub> |
| 5422 | HexToInt<br><sub> Converts hex string into a number</sub> | <sub>**aHexString**: String; //_HexString should be in form "1234AB", without $ or 0x prefix_</sub> | <sub>Integer</sub> |
| 5422 | IfThen<br><sub> Checks condition aBool and returns aTrue/aFalse string depending on check result</sub> | <sub>**aBool**: Boolean; <br> **aTrue**: String; <br> **aFalse**: String;</sub> | <sub>string</sub> |
| 5422 | IfThenI<br><sub> Checks condition aBool and returns aTrue/aFalse integer depending on check result</sub> | <sub>**aBool**: Boolean; <br> **aTrue**: Integer; <br> **aFalse**: Integer;</sub> | <sub>Integer</sub> |
| 5422 | IfThenS<br><sub> Checks condition aBool and returns aTrue/aFalse single number depending on check result</sub> | <sub>**aBool**: Boolean; <br> **aTrue**: Single; <br> **aFalse**: Single;</sub> | <sub>Single</sub> |
| 5422 | InAreaI<br><sub> 2D variant of InRange, can be used for unit locs checks</sub> | <sub>**aX**: Integer; <br> **aY**: Integer; <br> **aXMin**: Integer; <br> **aYMin**: Integer; <br> **aXMax**: Integer; <br> **aYMax**: Integer;</sub> | <sub>Boolean</sub> |
| 5422 | InAreaS<br><sub> 2D variant of InRange</sub> | <sub>**aX**: Single; <br> **aY**: Single; <br> **aXMin**: Single; <br> **aYMin**: Single; <br> **aXMax**: Single; <br> **aYMax**: Single;</sub> | <sub>Boolean</sub> |
| 5422 | InRangeI<br><sub> Checks whether specified aValue is in interval [aMin..aMax]</sub> | <sub>**aValue**: Integer; <br> **aMin**: Integer; <br> **aMax**: Integer;</sub> | <sub>Boolean</sub> |
| 5422 | InRangeS<br><sub> Checks whether specified aValue is in interval [aMin..aMax]</sub> | <sub>**aValue**: Single; <br> **aMin**: Single; <br> **aMax**: Single;</sub> | <sub>Boolean</sub> |
| 5422 | MaxI<br><sub> Returns max number of two specified</sub> | <sub>**A**: Integer; <br> **B**: Integer;</sub> | <sub>Integer</sub> |
| 5422 | MaxInArrayI<br><sub> Returns max number of array elements</sub> | <sub>**aArray**: array of Integer;</sub> | <sub>Integer</sub> |
| 5422 | MaxInArrayS<br><sub> Returns max number of array elements</sub> | <sub>**aArray**: array of Single;</sub> | <sub>Single</sub> |
| 5422 | MaxS<br><sub> Returns max number of two specified</sub> | <sub>**A**: Single; <br> **B**: Single;</sub> | <sub>Single</sub> |
| 5422 | MinI<br><sub> Returns min number of two specified</sub> | <sub>**A**: Integer; <br> **B**: Integer;</sub> | <sub>Integer</sub> |
| 5422 | MinInArrayI<br><sub> Returns min number of array elements</sub> | <sub>**aArray**: array of Integer;</sub> | <sub>Integer</sub> |
| 5422 | MinInArrayS<br><sub> Returns min number of array elements</sub> | <sub>**aArray**: array of Single;</sub> | <sub>Single</sub> |
| 5422 | MinS<br><sub> Returns min number of two specified</sub> | <sub>**A**: Single; <br> **B**: Single;</sub> | <sub>Single</sub> |
| 5422 | Power<br><sub></sub> | <sub>**Base**: Extended; <br> **Exp**: Extended; //_xponentation, returns base "Base" raised to power "Exp". F.e. Power(3, 2) = 3^2 = 9_</sub> | <sub>Extended</sub> |
| 6683 | Random<br><sub> Returns random float within 0..1</sub> | <sub></sub> | <sub>Single</sub> |
| 6683 | RandomI<br><sub> Returns random integer within 0..aMax-1</sub> | <sub>**aMax**: Integer;</sub> | <sub>Integer</sub> |
| 5422 | Sqr<br><sub> Returns A^2 = A*A</sub> | <sub>**A**: Extended;</sub> | <sub>Extended</sub> |
| 5422 | SumI<br><sub> Returns sum of the elements of requested array</sub> | <sub>**aArray**: array of Integer;</sub> | <sub>Integer</sub> |
| 5422 | SumS<br><sub> Returns sum of the elements of requested array</sub> | <sub>**aArray**: array of Single;</sub> | <sub>Single</sub> |
| 5422 | TimeToString<br><sub> Converts game ticks count into string: HH:MM:SS Can be used for scripted timers</sub> | <sub>**aTicks**: Integer;</sub> | <sub>string</sub> |
