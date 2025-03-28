### Types

Description of custom Knights Province types used in the scripting.

***

* <a href="#TKMFenceType">TKMFenceType</a>
* <a href="#TKMGroupType">TKMGroupType</a>
* <a href="#TKMGroupTypeSet">TKMGroupTypeSet</a>
* <a href="#TKMHouseFace">TKMHouseFace</a>
* <a href="#TKMHouseType">TKMHouseType</a>
* <a href="#TKMHouseTypeSet">TKMHouseTypeSet</a>
* <a href="#TKMIntegerArray">TKMIntegerArray</a>
* <a href="#TKMInteractionType">TKMInteractionType</a>
* <a href="#TKMObjectiveStatus">TKMObjectiveStatus</a>
* <a href="#TKMObjectiveType">TKMObjectiveType</a>
* <a href="#TKMPoint">TKMPoint</a>
* <a href="#TKMPointArray">TKMPointArray</a>
* <a href="#TKMSingleArray">TKMSingleArray</a>
* <a href="#TKMStringArray">TKMStringArray</a>
* <a href="#TKMUnitType">TKMUnitType</a>
* <a href="#TKMUnitTypeSet">TKMUnitTypeSet</a>
* <a href="#TKMWareType">TKMWareType</a>
* <a href="#TKMWareTypeSet">TKMWareTypeSet</a>
<br />

| Version | Type | Type name | Elements |
| ------- | ------- | ------------------------------------ | -------------- |
| - | <sub>enum</sub> | <a id="TKMFenceType">TKMFenceType</a><sub><br/>Player buildable fences</sub> |<sub>**fctNone**</sub><br/><sub>**fctWood**</sub><br/><sub>**fctWoodStone**</sub><br/><sub>**fctHouseArea**</sub><br/><sub>**fctHouseAreaGates**</sub><br/><sub>**fctOrchard**</sub><br/><sub>**fctGrain**</sub>
| - | <sub>enum</sub> | <a id="TKMGroupType">TKMGroupType</a><sub><br/>Warrior group type</sub> |<sub>**gtNone**</sub><br/><sub>**gtMelee**</sub><br/><sub>**gtAntiHorse**</sub><br/><sub>**gtRanged**</sub><br/><sub>**gtMounted**</sub>
| - | <sub>set</sub> | <a id="TKMGroupTypeSet">TKMGroupTypeSet</a><sub><br/>Set of group types</sub> |<sub>**set of TKMGroupType**</sub>
| - | <sub>enum</sub> | <a id="TKMHouseFace">TKMHouseFace</a><sub><br/>Direction to which house shall face</sub> |<sub>**toSouth**</sub><br/><sub>**toWest**</sub><br/><sub>**toNorth**</sub><br/><sub>**toEast**</sub>
| - | <sub>enum</sub> | <a id="TKMHouseType">TKMHouseType</a><sub><br/>Type of the house</sub> |<sub>**htNone**</sub><br/><sub>**htFoundry**</sub><br/><sub>**htWeaponSmithy**</sub><br/><sub>**htCoalmakers**</sub><br/><sub>**htIronMine**</sub><br/><sub>**htGoldMine**</sub><br/><sub>**htFisherHut**</sub><br/><sub>**htBakery**</sub><br/><sub>**htFarm**</sub><br/><sub>**htWoodcutters**</sub><br/><sub>**htArmorSmithy**</sub><br/><sub>**htCamp**</sub><br/><sub>**htStables**</sub><br/><sub>**htSchool**</sub><br/><sub>**htStonecutters**</sub><br/><sub>**htMint**</sub><br/><sub>**htCattleFarm**</sub><br/><sub>**htTowerArrow**</sub><br/><sub>**htRangerShop**</sub><br/><sub>**htWeaponWorkshop**</sub><br/><sub>**htArmorWorkshop**</sub><br/><sub>**htBarracks**</sub><br/><sub>**htMill**</sub><br/><sub>**htSiegeWorkshop**</sub><br/><sub>**htButchers**</sub><br/><sub>**htTannery**</sub><br/><sub>**htStore**</sub><br/><sub>**htTavern**</sub><br/><sub>**htBrewery**</sub><br/><sub>**htMarketplace**</sub><br/><sub>**htFort**</sub><br/><sub>**htTowerBolt**</sub><br/><sub>**htCiderMaker**</sub><br/><sub>**htSawmill**</sub><br/><sub>**htSheepyard**</sub><br/><sub>**htClothMaker**</sub><br/><sub>**htCampfire**</sub><br/><sub>**htCottage**</sub><br/><sub>**htWolfsDen**</sub><br/><sub>**htBearsDen**</sub><br/><sub>**htAny** // Abstract type used in requests, when any house type will do</sub>
| - | <sub>set</sub> | <a id="TKMHouseTypeSet">TKMHouseTypeSet</a><sub><br/>Set of house types</sub> |<sub>**set of TKMHouseType**</sub>
| - | <sub>array</sub> | <a id="TKMIntegerArray">TKMIntegerArray</a><sub><br/>Array of integers</sub> |<sub>**array of Integer**</sub>
| - | <sub>enum</sub> | <a id="TKMInteractionType">TKMInteractionType</a><sub><br/>Type of the interaction marker</sub> |<sub>**itExclamation**</sub><br/><sub>**itInfo**</sub><br/><sub>**itQuestion**</sub>
| - | <sub>enum</sub> | <a id="TKMObjectiveStatus">TKMObjectiveStatus</a><sub><br/>Status of the objective</sub> |<sub>**osHidden** // Objective is not displayed</sub><br/><sub>**osActive** // Objective is active</sub><br/><sub>**osFailed** // Objective has been failed</sub><br/><sub>**osCompleted** // Objective has been completed</sub>
| - | <sub>enum</sub> | <a id="TKMObjectiveType">TKMObjectiveType</a><sub><br/>Type of the objective</sub> |<sub>**otMain** // Shown in main section</sub><br/><sub>**otAdditional** // Shown in additional section</sub>
| - | <sub>record</sub> | <a id="TKMPoint">TKMPoint</a><sub><br/>Point with X and Y components<br/>Typically gets used for tile coordinates</sub> |<sub>**X,Y: Integer**</sub>
| - | <sub>array</sub> | <a id="TKMPointArray">TKMPointArray</a><sub><br/>Array of points</sub> |<sub>**array of TKMPoint**</sub>
| - | <sub>array</sub> | <a id="TKMSingleArray">TKMSingleArray</a><sub><br/>Array of singles</sub> |<sub>**array of Single**</sub>
| - | <sub>array</sub> | <a id="TKMStringArray">TKMStringArray</a><sub><br/>Array of strings</sub> |<sub>**array of string**</sub>
| - | <sub>enum</sub> | <a id="TKMUnitType">TKMUnitType</a><sub><br/>Type of the unit</sub> |<sub>**utNone**</sub><br/><sub>**utPeasant**</sub><br/><sub>**utPorter**</sub><br/><sub>**utBuilder**</sub><br/><sub>**utWoodcutter**</sub><br/><sub>**utMiner**</sub><br/><sub>**utBreeder**</sub><br/><sub>**utFarmer**</sub><br/><sub>**utCarpenter**</sub><br/><sub>**utBaker**</sub><br/><sub>**utButcher**</sub><br/><sub>**utTailor**</sub><br/><sub>**utBrewer**</sub><br/><sub>**utFisher**</sub><br/><sub>**utStonecutter**</sub><br/><sub>**utSmith**</sub><br/><sub>**utMetallurgist**</sub><br/><sub>**utRecruit**</sub><br/><sub>**utMilitia**</sub><br/><sub>**utAxeFighter**</sub><br/><sub>**utSwordsman**</sub><br/><sub>**utBowman**</sub><br/><sub>**utArbaletman**</sub><br/><sub>**utPikeman**</sub><br/><sub>**utHalberdier**</sub><br/><sub>**utHorseScout**</sub><br/><sub>**utCavalry**</sub><br/><sub>**utSkeletonAxe**</sub><br/><sub>**utSkeletonSword**</sub><br/><sub>**utSkeletonBow**</sub><br/><sub>**utRebelFork**</sub><br/><sub>**utSkeleton**</sub><br/><sub>**utWagon**</sub><br/><sub>**utWagon2**</sub><br/><sub>**utCatapult**</sub><br/><sub>**utBallista**</sub><br/><sub>**utWolf**</sub><br/><sub>**utFish**</sub><br/><sub>**utWatersnake**</sub><br/><sub>**utSeastar**</sub><br/><sub>**utCrab**</sub><br/><sub>**utWaterflower**</sub><br/><sub>**utWaterleaf**</sub><br/><sub>**utDuck**</sub><br/><sub>**utDeer**</sub><br/><sub>**utBoar**</sub><br/><sub>**utBear**</sub><br/><sub>**utDuck2**</sub><br/><sub>**utHorse**</sub><br/><sub>**utSheep**</sub><br/><sub>**utAny** // Abstract type used in requests, when any unit type will do</sub>
| - | <sub>set</sub> | <a id="TKMUnitTypeSet">TKMUnitTypeSet</a><sub><br/>Set of unit types</sub> |<sub>**set of TKMUnitType**</sub>
| - | <sub>enum</sub> | <a id="TKMWareType">TKMWareType</a><sub><br/>Type of the ware</sub> |<sub>**wtNone**</sub><br/><sub>**wtTrunk**</sub><br/><sub>**wtStone**</sub><br/><sub>**wtWood**</sub><br/><sub>**wtIronOre**</sub><br/><sub>**wtGoldOre**</sub><br/><sub>**wtCoal**</sub><br/><sub>**wtSteel**</sub><br/><sub>**wtGold**</sub><br/><sub>**wtAle**</sub><br/><sub>**wtGrain**</sub><br/><sub>**wtBread**</sub><br/><sub>**wtFlour**</sub><br/><sub>**wtLeather**</sub><br/><sub>**wtSausages**</sub><br/><sub>**wtBeef**</sub><br/><sub>**wtCowhide**</sub><br/><sub>**wtShield**</sub><br/><sub>**wtMetalShield**</sub><br/><sub>**wtArmor**</sub><br/><sub>**wtMetalArmor**</sub><br/><sub>**wtAxe**</sub><br/><sub>**wtSword**</sub><br/><sub>**wtPike**</sub><br/><sub>**wtHalberd**</sub><br/><sub>**wtBow**</sub><br/><sub>**wtArbalet**</sub><br/><sub>**wtHorse**</sub><br/><sub>**wtFish**</sub><br/><sub>**wtClub**</sub><br/><sub>**wtCider**</sub><br/><sub>**wtWool**</sub><br/><sub>**wtCloth**</sub><br/><sub>**wtGambeson**</sub><br/><sub>**wtAll** // All wares, for resulting charts</sub><br/><sub>**wtWarfare** // Everything warfare (weapons, horses)</sub><br/><sub>**wtFood** // Generic food ware (e.g. for warriors, we don't know what food will is be till Porter picks it from Camp)</sub>
| - | <sub>set</sub> | <a id="TKMWareTypeSet">TKMWareTypeSet</a><sub><br/>Set of ware types</sub> |<sub>**set of TKMWareType**</sub>
