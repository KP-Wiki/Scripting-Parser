### Dynamic Mission Script Types


There are several KMR types that could be used in the Mission Dynamic scripts and that are required for some [Actions](https://github.com/reyandme/kam_remake/wiki/Actions-(Mission-Script-Dynamic)), [States](https://github.com/reyandme/kam_remake/wiki/States-(Mission-Script-Dynamic)) or [Events](https://github.com/reyandme/kam_remake/wiki/Events-(Mission-Script-Dynamic)).

***

* <a href="#TAnsiStringArray">TAnsiStringArray</a>
* <a href="#TByteSet">TByteSet</a>
* <a href="#TIntegerArray">TIntegerArray</a>
* <a href="#TKMAIAttackInfo">TKMAIAttackInfo</a>
* <a href="#TKMAIAttackTarget">TKMAIAttackTarget</a>
* <a href="#TKMAIAttackType">TKMAIAttackType</a>
* <a href="#TKMAIDefencePosType">TKMAIDefencePosType</a>
* <a href="#TKMAIRepairMode">TKMAIRepairMode</a>
* <a href="#TKMArmyType">TKMArmyType</a>
* <a href="#TKMAudioFormat">TKMAudioFormat</a>
* <a href="#TKMDefencePositionInfo">TKMDefencePositionInfo</a>
* <a href="#TKMDeliveryMode">TKMDeliveryMode</a>
* <a href="#TKMDirection">TKMDirection</a>
* <a href="#TKMFieldType">TKMFieldType</a>
* <a href="#TKMFont">TKMFont</a>
* <a href="#TKMGroupOrder">TKMGroupOrder</a>
* <a href="#TKMGroupType">TKMGroupType</a>
* <a href="#TKMGroupTypeSet">TKMGroupTypeSet</a>
* <a href="#TKMHandHouseLock">TKMHandHouseLock</a>
* <a href="#TKMHouseType">TKMHouseType</a>
* <a href="#TKMHouseTypeSet">TKMHouseTypeSet</a>
* <a href="#TKMMissionDifficulty">TKMMissionDifficulty</a>
* <a href="#TKMMissionDifficultySet">TKMMissionDifficultySet</a>
* <a href="#TKMPoint">TKMPoint</a>
* <a href="#TKMTerrainKind">TKMTerrainKind</a>
* <a href="#TKMTerrainPassability">TKMTerrainPassability</a>
* <a href="#TKMTerrainTileBrief">TKMTerrainTileBrief</a>
* <a href="#TKMTileMaskKind">TKMTileMaskKind</a>
* <a href="#TKMTileOverlay">TKMTileOverlay</a>
* <a href="#TKMUnitType">TKMUnitType</a>
* <a href="#TKMUnitTypeSet">TKMUnitTypeSet</a>
* <a href="#TKMWareType">TKMWareType</a>
* <a href="#TKMWareTypeSet">TKMWareTypeSet</a>
* <a href="#TKMWoodcutterMode">TKMWoodcutterMode</a>
* <a href="#TReplaceFlags">TReplaceFlags</a>

| Version | Type name | Elements |
| ------- | ------------------------------------ | -------------- |
| - | <a id="TAnsiStringArray">TAnsiStringArray</a><sub><br/>array of string values</sub> | <sub>**array of AnsiString;**</sub>
| - | <a id="TByteSet">TByteSet</a><sub><br/>Array of bytes</sub> | <sub>**set of Byte; ** // Legacy support for old scripts</sub>
| - | <a id="TIntegerArray">TIntegerArray</a><sub><br/>array of integer values</sub> | <sub>**array of Integer;**</sub>
| - | <a id="TKMAIAttackInfo">TKMAIAttackInfo</a><sub><br/>AI attack setup</sub> | <sub>**UID: Integer;**</sub><br/><sub>**AttackType: TKMAIAttackType;**</sub><br/><sub>**HasOccured: Boolean;**</sub><br/><sub>**Delay: Cardinal;**</sub><br/><sub>**TotalMen: Integer;**</sub><br/><sub>**MeleeGroupCount: Integer;**</sub><br/><sub>**AntiHorseGroupCount: Integer;**</sub><br/><sub>**RangedGroupCount: Integer;**</sub><br/><sub>**MountedGroupCount: Integer;**</sub><br/><sub>**RandomGroups: Boolean;**</sub><br/><sub>**Target: TKMAIAttackTarget;**</sub><br/><sub>**CustomPosition: TKMPoint;**</sub>
| - | <a id="TKMAIAttackTarget">TKMAIAttackTarget</a><sub><br/>AI attack target</sub> | <sub>**attClosestUnit** // Closest enemy unit untested as to whether this is relative to army or start position)</sub><br/><sub>**attClosestBuildingFromArmy** // Closest building from the group(s) lauching the attack</sub>
| - | <a id="TKMAIAttackType">TKMAIAttackType</a><sub><br/>AI attack type</sub> | <sub>**aatOnce** // Attack will occur once (after the set time has passed and if they have enough troops</sub><br/><sub>**aatRepeating** // Attack will happen multiple times, (after delay time) whenever the AI has enough troops</sub>
| - | <a id="TKMAIDefencePosType">TKMAIDefencePosType</a><sub><br/>AI defence position type</sub> | <sub>**dtFrontLine** // Front line troops may not go on attacks, they are for defence</sub><br/><sub>**dtBackLine** // Back line troops may attack</sub>
| - | <a id="TKMAIRepairMode">TKMAIRepairMode</a><sub><br/>House repair mode</sub> | <sub>**rmNone**</sub><br/><sub>**rmRepairNever** // disable AI repair for all houses</sub><br/><sub>**rmRepairAlways** // enable AI repair for all houses</sub><br/><sub>**rmRepairManual** // repair state is set by script manually via Actions.HouseRepairEnable</sub>
| - | <a id="TKMArmyType">TKMArmyType</a><sub><br/>AI army type</sub> | <sub>**atIronThenLeather**</sub><br/><sub>**atLeather**</sub><br/><sub>**atIron**</sub><br/><sub>**atIronAndLeather**</sub>
| - | <a id="TKMAudioFormat">TKMAudioFormat</a><sub><br/>Audio file format</sub> | <sub>**afWav**</sub><br/><sub>**afOgg**</sub>
| - | <a id="TKMDefencePositionInfo">TKMDefencePositionInfo</a><sub><br/>AI defence position setup</sub> | <sub>**UID: Integer;**</sub><br/><sub>**X, Y: Integer;**</sub><br/><sub>**Radius: Integer;**</sub><br/><sub>**GroupID: Integer;**</sub><br/><sub>**Dir: TKMDirection;**</sub><br/><sub>**GroupType: TKMGroupType;**</sub><br/><sub>**PositionType: TKMAIDefencePosType;**</sub>
| - | <a id="TKMDeliveryMode">TKMDeliveryMode</a><sub><br/>Delivery mode</sub> | <sub>**dmClosed**</sub><br/><sub>**dmDelivery**</sub><br/><sub>**dmTakeOut**</sub>
| - | <a id="TKMDirection">TKMDirection</a><sub><br/>Facing direction</sub> | <sub>**dirNA**</sub><br/><sub>**dirN**</sub><br/><sub>**dirNE**</sub><br/><sub>**dirE**</sub><br/><sub>**dirSE**</sub><br/><sub>**dirS**</sub><br/><sub>**dirSW**</sub><br/><sub>**dirW**</sub><br/><sub>**dirNW**</sub>
| - | <a id="TKMFieldType">TKMFieldType</a><sub><br/>Field type</sub> | <sub>**ftNone**</sub><br/><sub>**ftRoad**</sub><br/><sub>**ftCorn**</sub><br/><sub>**ftWine**</sub><br/><sub>**ftInitWine** // Reset rotation and set grapes ground, but without Grapes yet</sub>
| - | <a id="TKMFont">TKMFont</a><sub><br/>Font type</sub> | <sub>**fntAntiqua**</sub><br/><sub>**fntGame**</sub><br/><sub>**fntGrey**</sub><br/><sub>**fntMetal**</sub><br/><sub>**fntMini**</sub><br/><sub>**fntOutline**</sub><br/><sub>**fntArial** // Arial for MP chat</sub><br/><sub>**fntMonospaced** // Debug overlay font (Consolas 8. Set WordSpacing to any Char.Width)</sub>
| - | <a id="TKMGroupOrder">TKMGroupOrder</a><sub><br/>Group order</sub> | <sub>**goNone** // Last order was executed and now we have nothing to do</sub><br/><sub>**goWalkTo** // Ordered to walk somewhere or just change formation</sub><br/><sub>**goAttackHouse** // Attack house</sub><br/><sub>**goAttackUnit** // Attack specific unit</sub><br/><sub>**goStorm** // Run forward</sub>
| - | <a id="TKMGroupType">TKMGroupType</a><sub><br/>Group type</sub> | <sub>**gtNone**</sub><br/><sub>**gtAny**</sub><br/><sub>**gtMelee**</sub><br/><sub>**gtAntiHorse**</sub><br/><sub>**gtRanged**</sub><br/><sub>**gtMounted**</sub>
| - | <a id="TKMGroupTypeSet">TKMGroupTypeSet</a><sub><br/>Group type set</sub> | <sub>**set of TKMGroupType;**</sub>
| - | <a id="TKMHandHouseLock">TKMHandHouseLock</a><sub><br/>House lock state</sub> | <sub>**hlNone**</sub><br/><sub>**hlDefault**</sub><br/><sub>**hlBlocked** // Never allowed</sub><br/><sub>**hlGranted** // Always allowed</sub>
| - | <a id="TKMHouseType">TKMHouseType</a><sub><br/>House type</sub> | <sub>**htNone**</sub><br/><sub>**htAny**</sub><br/><sub>**htArmorSmithy**</sub><br/><sub>**htArmorWorkshop**</sub><br/><sub>**htBakery**</sub><br/><sub>**htBarracks**</sub><br/><sub>**htButchers**</sub><br/><sub>**htCoalMine**</sub><br/><sub>**htFarm**</sub><br/><sub>**htFishermans**</sub><br/><sub>**htGoldMine**</sub><br/><sub>**htInn**</sub><br/><sub>**htIronMine**</sub><br/><sub>**htIronSmithy**</sub><br/><sub>**htMarket**</sub><br/><sub>**htMetallurgists**</sub><br/><sub>**htMill**</sub><br/><sub>**htQuarry**</sub><br/><sub>**htSawmill**</sub><br/><sub>**htSchool**</sub><br/><sub>**htSiegeWorkshop**</sub><br/><sub>**htStables**</sub><br/><sub>**htStore**</sub><br/><sub>**htSwine**</sub><br/><sub>**htTannery**</sub><br/><sub>**htTownHall**</sub><br/><sub>**htWatchTower**</sub><br/><sub>**htWeaponSmithy**</sub><br/><sub>**htWeaponWorkshop**</sub><br/><sub>**htVineyard**</sub><br/><sub>**htWoodcutters**</sub>
| - | <a id="TKMHouseTypeSet">TKMHouseTypeSet</a><sub><br/>House type set</sub> | <sub>**set of TKMHouseType;**</sub>
| - | <a id="TKMMissionDifficulty">TKMMissionDifficulty</a><sub><br/>Mission difficulty</sub> | <sub>**mdNone**</sub><br/><sub>**mdEasy3**</sub><br/><sub>**mdEasy2**</sub><br/><sub>**mdEasy1**</sub><br/><sub>**mdNormal**</sub><br/><sub>**mdHard1**</sub><br/><sub>**mdHard2**</sub><br/><sub>**mdHard3**</sub>
| - | <a id="TKMMissionDifficultySet">TKMMissionDifficultySet</a><sub><br/>Set of mission difficulties</sub> | <sub>**set of TKMMissionDifficulty;**</sub>
| - | <a id="TKMPoint">TKMPoint</a><sub><br/>Point with integer coordinates X and Y</sub> | <sub>**X,Y: Integer;**</sub>
| - | <a id="TKMTerrainKind">TKMTerrainKind</a><sub><br/>Terrain kind</sub> | <sub>**tkCustom** // 0</sub><br/><sub>**tkGrass** // 1</sub><br/><sub>**tkMoss** // 2</sub><br/><sub>**tkPaleGrass** // 3</sub><br/><sub>**tkCoastSand** // 4</sub><br/><sub>**tkGrassSand1** // 5</sub><br/><sub>**tkGrassSand2** // 6</sub><br/><sub>**tkGrassSand3** // 7</sub><br/><sub>**tkSand** // 8</sub><br/><sub>**tkGrassDirt** // 9</sub><br/><sub>**tkDirt** // 10</sub><br/><sub>**tkCobbleStone** // 11</sub><br/><sub>**tkGrassyWater** // 12</sub><br/><sub>**tkSwamp** // 13</sub><br/><sub>**tkIce** // 14</sub><br/><sub>**tkSnowOnGrass** // 15</sub><br/><sub>**tkSnowOnDirt** // 16</sub><br/><sub>**tkSnow** // 17</sub><br/><sub>**tkDeepSnow** // 18</sub><br/><sub>**tkStone** // 19</sub><br/><sub>**tkGoldMount** // 20</sub><br/><sub>**tkIronMount** // 21</sub><br/><sub>**tkAbyss** // 22</sub><br/><sub>**tkGravel** // 23</sub><br/><sub>**tkCoal** // 24</sub><br/><sub>**tkGold** // 25</sub><br/><sub>**tkIron** // 26</sub><br/><sub>**tkWater** // 27</sub><br/><sub>**tkFastWater** // 28</sub><br/><sub>**tkLava** // 29</sub>
| - | <a id="TKMTerrainPassability">TKMTerrainPassability</a><sub><br/>terrain passability</sub> | <sub>**tpNone**</sub><br/><sub>**tpWalk** // General passability of tile for any walking units</sub><br/><sub>**tpWalkRoad** // Type of passability for Serfs when transporting wares, only roads have it</sub><br/><sub>**tpBuildNoObj** // Can we build a house on this tile after removing an object on the tile or house near it?</sub><br/><sub>**tpBuild** // Can we build a house on this tile?</sub><br/><sub>**tpMakeRoads** // Thats less strict than house building, roads Can be placed almost everywhere where units Can walk, except e.g. bridges</sub><br/><sub>**tpCutTree** // Can tree be cut</sub><br/><sub>**tpFish** // Water tiles where fish Can move around</sub><br/><sub>**tpCrab** // Sand tiles where crabs Can move around</sub><br/><sub>**tpWolf** // Soil tiles where wolfs Can move around</sub><br/><sub>**tpElevate** // Nodes which are forbidden to be elevated by workers (house basements, water, etc..)</sub>
| - | <a id="TKMTerrainTileBrief">TKMTerrainTileBrief</a><sub><br/>Brief terrain tile info</sub> | <sub>**X,Y: Byte;**</sub><br/><sub>**Terrain: Word;**</sub><br/><sub>**Rotation: Byte;**</sub><br/><sub>**Height: Byte;**</sub><br/><sub>**Obj: Word;**</sub><br/><sub>**UpdateTerrain, UpdateRotation, UpdateHeight, UpdateObject: Boolean;**</sub>
| - | <a id="TKMTileMaskKind">TKMTileMaskKind</a><sub><br/>Terrain mask kind</sub> | <sub>**mkNone**</sub><br/><sub>**mkSoft1**</sub><br/><sub>**mkSoft2**</sub><br/><sub>**mkSoft3**</sub><br/><sub>**mkStraight**</sub><br/><sub>**mkGradient**</sub>
| - | <a id="TKMTileOverlay">TKMTileOverlay</a><sub><br/>Tile overlay type</sub> | <sub>**toNone**</sub><br/><sub>**toDig1**</sub><br/><sub>**toDig2**</sub><br/><sub>**toDig3**</sub><br/><sub>**toDig4**</sub><br/><sub>**toRoad**</sub>
| - | <a id="TKMUnitType">TKMUnitType</a><sub><br/>Unit type</sub> | <sub>**utNone**</sub><br/><sub>**utAny**</sub><br/><sub>**utSerf**</sub><br/><sub>**utWoodcutter**</sub><br/><sub>**utMiner**</sub><br/><sub>**utAnimalBreeder**</sub><br/><sub>**utFarmer**</sub><br/><sub>**utCarpenter**</sub><br/><sub>**utBaker**</sub><br/><sub>**utButcher**</sub><br/><sub>**utFisher**</sub><br/><sub>**utBuilder**</sub><br/><sub>**utStonemason**</sub><br/><sub>**utSmith**</sub><br/><sub>**utMetallurgist**</sub><br/><sub>**utRecruit**</sub><br/><sub>**utMilitia**</sub><br/><sub>**utAxeFighter**</sub><br/><sub>**utSwordFighter**</sub><br/><sub>**utBowman**</sub><br/><sub>**utCrossbowman**</sub><br/><sub>**utLanceCarrier**</sub><br/><sub>**utPikeman**</sub><br/><sub>**utScout**</sub><br/><sub>**utKnight**</sub><br/><sub>**utBarbarian**</sub><br/><sub>**utRebel**</sub><br/><sub>**utRogue**</sub><br/><sub>**utWarrior**</sub><br/><sub>**utVagabond**</sub><br/><sub>**utWolf**</sub><br/><sub>**utFish**</sub><br/><sub>**utWatersnake**</sub><br/><sub>**utSeastar**</sub><br/><sub>**utCrab**</sub><br/><sub>**utWaterflower**</sub><br/><sub>**utWaterleaf**</sub><br/><sub>**utDuck**</sub>
| - | <a id="TKMUnitTypeSet">TKMUnitTypeSet</a><sub><br/>Unit type set</sub> | <sub>**set of TKMUnitType;**</sub>
| - | <a id="TKMWareType">TKMWareType</a><sub><br/>Ware type</sub> | <sub>**wtNone**</sub><br/><sub>**wtTrunk**</sub><br/><sub>**wtStone**</sub><br/><sub>**wtTimber**</sub><br/><sub>**wtIronOre**</sub><br/><sub>**wtGoldOre**</sub><br/><sub>**wtCoal**</sub><br/><sub>**wtIron**</sub><br/><sub>**wtGold**</sub><br/><sub>**wtWine**</sub><br/><sub>**wtCorn**</sub><br/><sub>**wtBread**</sub><br/><sub>**wtFlour**</sub><br/><sub>**wtLeather**</sub><br/><sub>**wtSausage**</sub><br/><sub>**wtPig**</sub><br/><sub>**wtSkin**</sub><br/><sub>**wtWoodenShield**</sub><br/><sub>**wtIronShield**</sub><br/><sub>**wtLeatherArmor**</sub><br/><sub>**wtIronArmor**</sub><br/><sub>**wtAxe**</sub><br/><sub>**wtSword**</sub><br/><sub>**wtLance**</sub><br/><sub>**wtPike**</sub><br/><sub>**wtBow**</sub><br/><sub>**wtCrossbow**</sub><br/><sub>**wtHorse**</sub><br/><sub>**wtFish**</sub><br/><sub>**wtAll**</sub><br/><sub>**wtWarfare**</sub><br/><sub>**wtFood**</sub>
| - | <a id="TKMWareTypeSet">TKMWareTypeSet</a><sub><br/>Ware type set</sub> | <sub>**set of TKMWareType;**</sub>
| - | <a id="TKMWoodcutterMode">TKMWoodcutterMode</a><sub><br/>Woodcutting mode</sub> | <sub>**wmChopAndPlant**</sub><br/><sub>**wmChop**</sub><br/><sub>**wmPlant**</sub>
| - | <a id="TReplaceFlags">TReplaceFlags</a><sub><br/>Replace flags</sub> | <sub>**rfReplaceAll**</sub><br/><sub>**rfIgnoreCase**</sub>
