####Utils

| Ver<br/>sion | Utility function<br/> description | Parameters<br/>and types | Returns |
| ------- | ------------------------------------ | -------------- | ------- |
| 5422 | AbsI<sub><br/>Returns absolute value of specified integer</sub> | <sub>**aValue**: Integer;</sub> | <sub>Integer</sub> |
| 5422 | AbsS<sub><br/>Returns absolute value of specified single number</sub> | <sub>**aValue**: Single;</sub> | <sub>Single</sub> |
| 5422 | ArrayElementCount<sub><br/>Checks how many times specified string comes in requested array</sub> | <sub>**aElement**: String; <br/> **aArray**: array of String;</sub> | <sub>Integer</sub> |
| 5422 | ArrayElementCountI<sub><br/>Checks how many times specified integer comes in requested array</sub> | <sub>**aElement**: Integer; <br/> **aArray**: array of Integer;</sub> | <sub>Integer</sub> |
| 5422 | ArrayElementCountI<sub><br/>Checks how many times specified boolean comes in requested array</sub> | <sub>**aElement**: Integer; <br/> **aArray**: array of Integer;</sub> | <sub>Integer</sub> |
| 5422 | ArrayElementCountS<sub><br/>Checks how many times specified single comes in requested array</sub> | <sub>**aElement**: Single; <br/> **aArray**: array of Single;</sub> | <sub>Integer</sub> |
| 5422 | ArrayHasElement<sub><br/>Checks whether requested array has specified string</sub> | <sub>**aElement**: String; <br/> **aArray**: array of String;</sub> | <sub>Boolean</sub> |
| 5422 | ArrayHasElementI<sub><br/>Checks whether requested array has specified integer</sub> | <sub>**aElement**: Integer; <br/> **aArray**: array of Integer;</sub> | <sub>Boolean</sub> |
| 5422 | ArrayHasElementI<sub><br/>Checks whether requested array has specified boolean</sub> | <sub>**aElement**: Integer; <br/> **aArray**: array of Integer;</sub> | <sub>Boolean</sub> |
| 5422 | ArrayHasElementS<sub><br/>Checks whether requested array has specified single number</sub> | <sub>**aElement**: Single; <br/> **aArray**: array of Single;</sub> | <sub>Boolean</sub> |
| 5422 | EnsureRangeI<sub><br/>Returns the closest to aValue integer that is in interval [aMin..aMax]</sub> | <sub>**aValue**: Integer; <br/> **aMin**: Integer; <br/> **aMax**: Integer;</sub> | <sub>Integer</sub> |
| 5422 | EnsureRangeS<sub><br/>Returns the closest to aValue single number that is in interval [aMin..aMax]</sub> | <sub>**aValue**: Single; <br/> **aMin**: Single; <br/> **aMax**: Single;</sub> | <sub>Single</sub> |
| 5422 | Format<sub><br/>Wrapper for pascal Format function<br/>Formats aFormat string with specified aArgs array of arguments</sub> | <sub>**aFormat**: String; <br/> **aArgs**: array of const;</sub> | <sub>string</sub> |
| 5422 | HexToInt<sub><br/>Converts hex string into a number</sub> | <sub>**aHexString**: String; //_HexString should be in form "1234AB", without $ or 0x prefix_</sub> | <sub>Integer</sub> |
| 5422 | IfThen<sub><br/>Checks condition aBool and returns aTrue/aFalse string depending on check result</sub> | <sub>**aBool**: Boolean; <br/> **aTrue**: String; <br/> **aFalse**: String;</sub> | <sub>string</sub> |
| 5422 | IfThenI<sub><br/>Checks condition aBool and returns aTrue/aFalse integer depending on check result</sub> | <sub>**aBool**: Boolean; <br/> **aTrue**: Integer; <br/> **aFalse**: Integer;</sub> | <sub>Integer</sub> |
| 5422 | IfThenS<sub><br/>Checks condition aBool and returns aTrue/aFalse single number depending on check result</sub> | <sub>**aBool**: Boolean; <br/> **aTrue**: Single; <br/> **aFalse**: Single;</sub> | <sub>Single</sub> |
| 5422 | InAreaI<sub><br/>2D variant of InRange, can be used for unit locs checks</sub> | <sub>**aX**: Integer; <br/> **aY**: Integer; <br/> **aXMin**: Integer; <br/> **aYMin**: Integer; <br/> **aXMax**: Integer; <br/> **aYMax**: Integer;</sub> | <sub>Boolean</sub> |
| 5422 | InAreaS<sub><br/>2D variant of InRange</sub> | <sub>**aX**: Single; <br/> **aY**: Single; <br/> **aXMin**: Single; <br/> **aYMin**: Single; <br/> **aXMax**: Single; <br/> **aYMax**: Single;</sub> | <sub>Boolean</sub> |
| 5422 | InRangeI<sub><br/>Checks whether specified aValue is in interval [aMin..aMax]</sub> | <sub>**aValue**: Integer; <br/> **aMin**: Integer; <br/> **aMax**: Integer;</sub> | <sub>Boolean</sub> |
| 5422 | InRangeS<sub><br/>Checks whether specified aValue is in interval [aMin..aMax]</sub> | <sub>**aValue**: Single; <br/> **aMin**: Single; <br/> **aMax**: Single;</sub> | <sub>Boolean</sub> |
| 5422 | MaxI<sub><br/>Returns max number of two specified</sub> | <sub>**A**: Integer; <br/> **B**: Integer;</sub> | <sub>Integer</sub> |
| 5422 | MaxInArrayI<sub><br/>Returns max number of array elements</sub> | <sub>**aArray**: array of Integer;</sub> | <sub>Integer</sub> |
| 5422 | MaxInArrayS<sub><br/>Returns max number of array elements</sub> | <sub>**aArray**: array of Single;</sub> | <sub>Single</sub> |
| 5422 | MaxS<sub><br/>Returns max number of two specified</sub> | <sub>**A**: Single; <br/> **B**: Single;</sub> | <sub>Single</sub> |
| 5422 | MinI<sub><br/>Returns min number of two specified</sub> | <sub>**A**: Integer; <br/> **B**: Integer;</sub> | <sub>Integer</sub> |
| 5422 | MinInArrayI<sub><br/>Returns min number of array elements</sub> | <sub>**aArray**: array of Integer;</sub> | <sub>Integer</sub> |
| 5422 | MinInArrayS<sub><br/>Returns min number of array elements</sub> | <sub>**aArray**: array of Single;</sub> | <sub>Single</sub> |
| 5422 | MinS<sub><br/>Returns min number of two specified</sub> | <sub>**A**: Single; <br/> **B**: Single;</sub> | <sub>Single</sub> |
| 5422 | Power<sub></sub> | <sub>**Base**: Extended; <br/> **Exp**: Extended; //_xponentation, returns base "Base" raised to power "Exp". F.e. Power(3, 2) = 3^2 = 9_</sub> | <sub>Extended</sub> |
| 6683 | Random<sub><br/>Returns random float within 0..1</sub> | <sub></sub> | <sub>Single</sub> |
| 6683 | RandomI<sub><br/>Returns random integer within 0..aMax-1</sub> | <sub>**aMax**: Integer;</sub> | <sub>Integer</sub> |
| 5422 | Sqr<sub><br/>Returns A^2 = A*A</sub> | <sub>**A**: Extended;</sub> | <sub>Extended</sub> |
| 5422 | SumI<sub><br/>Returns sum of the elements of requested array</sub> | <sub>**aArray**: array of Integer;</sub> | <sub>Integer</sub> |
| 5422 | SumS<sub><br/>Returns sum of the elements of requested array</sub> | <sub>**aArray**: array of Single;</sub> | <sub>Single</sub> |
| 5422 | TimeToString<sub><br/>Converts game ticks count into string: HH:MM:SS<br/>Can be used for scripted timers</sub> | <sub>**aTicks**: Integer;</sub> | <sub>string</sub> |
