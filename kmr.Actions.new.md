#### Actions

All action parameters are numeric and get mapped to unit/house types according to default tables used in DAT scripts.

Actions are placed in a form **Actions.ACT_NAME(ACT_PARAMETERS);** like so:
```pascal
    if States.GameTime = 300 then
      Actions.PlayerDefeat(0); //Defeat 1st player
```
Also there is a short name for Actions: just **A**, so you could use it as
```pascal
  A.PlayerDefeat(0); //Defeat 1st player
```

<sub>"-" Means this will not be implemented.</sub>

***

Other scripts functions:
* [Events](https://github.com/reyandme/kam_remake/wiki/Events-(Mission-Script-Dynamic))
* [States](https://github.com/reyandme/kam_remake/wiki/States-(Mission-Script-Dynamic))
* [Utils](https://github.com/reyandme/kam_remake/wiki/Utils-(Mission-Script-Dynamic))

Dynamic scripts usefull info:
* [Tutorial](https://github.com/reyandme/kam_remake/wiki/Tutorial-(Mission-Script-Dynamic))
* [Types](https://github.com/reyandme/kam_remake/wiki/Types-(Mission-Script-Dynamic))
* [Lookup Tables](https://github.com/reyandme/kam_remake/wiki/Lookup-Tables-(Mission-Script-Dynamic))
* [Advanced Features](https://github.com/reyandme/kam_remake/wiki/Advanced-Features-(Mission-Script-Dynamic))
* [Custom Console Commands](https://github.com/reyandme/kam_remake/wiki/Custom-Console-Commands-(Mission-Script-Dynamic))


***

* <a href="#AAIAttackHouseTypesSet">AAIAttackHouseTypesSet</a>
* <a href="#AIArmyType">AIArmyType</a>
* <a href="#AIAttackAdd">AIAttackAdd</a>
* <a href="#AIAttackAddEx">AIAttackAddEx</a>
* <a href="#AIAttackRemove">AIAttackRemove</a>
* <a href="#AIAttackRemoveAll">AIAttackRemoveAll</a>
* <a href="#AIAutoAttack">AIAutoAttack</a>
* <a href="#AIAutoAttackRange">AIAutoAttackRange</a>
* <a href="#AIAutoBuild">AIAutoBuild</a>
* <a href="#AIAutoDefence">AIAutoDefence</a>
* <a href="#AIAutoRepair">AIAutoRepair</a>
* <a href="#AIDefencePositionAdd">AIDefencePositionAdd</a>
* <a href="#AIDefencePositionAddEx">AIDefencePositionAddEx</a>
* <a href="#AIDefencePositionRemove">AIDefencePositionRemove</a>
* <a href="#AIDefencePositionRemoveAll">AIDefencePositionRemoveAll</a>
* <a href="#AIDefencePositionRemoveByUID">AIDefencePositionRemoveByUID</a>
* <a href="#AIDefendAllies">AIDefendAllies</a>
* <a href="#AIEquipRate">AIEquipRate</a>
* <a href="#AIGroupsFormationSet">AIGroupsFormationSet</a>
* <a href="#AIGroupsFormationSetEx">AIGroupsFormationSetEx</a>
* <a href="#AIRecruitDelay">AIRecruitDelay</a>
* <a href="#AIRecruitLimit">AIRecruitLimit</a>
* <a href="#AIRepairMode">AIRepairMode</a>
* <a href="#AISerfsPerHouse">AISerfsPerHouse</a>
* <a href="#AISoldiersLimit">AISoldiersLimit</a>
* <a href="#AIStartPosition">AIStartPosition</a>
* <a href="#AIWorkerLimit">AIWorkerLimit</a>
* <a href="#CinematicEnd">CinematicEnd</a>
* <a href="#CinematicPanTo">CinematicPanTo</a>
* <a href="#CinematicStart">CinematicStart</a>
* <a href="#FogCoverAll">FogCoverAll</a>
* <a href="#FogCoverCircle">FogCoverCircle</a>
* <a href="#FogCoverRect">FogCoverRect</a>
* <a href="#FogRevealAll">FogRevealAll</a>
* <a href="#FogRevealCircle">FogRevealCircle</a>
* <a href="#FogRevealRect">FogRevealRect</a>
* <a href="#GameSpeed">GameSpeed</a>
* <a href="#GameSpeedChangeAllowed">GameSpeedChangeAllowed</a>
* <a href="#GiveAnimal">GiveAnimal</a>
* <a href="#GiveAnimalEx">GiveAnimalEx</a>
* <a href="#GiveField">GiveField</a>
* <a href="#GiveFieldAged">GiveFieldAged</a>
* <a href="#GiveGroup">GiveGroup</a>
* <a href="#GiveGroupEx">GiveGroupEx</a>
* <a href="#GiveHouse">GiveHouse</a>
* <a href="#GiveHouseEx">GiveHouseEx</a>
* <a href="#GiveHouseSite">GiveHouseSite</a>
* <a href="#GiveHouseSiteEx">GiveHouseSiteEx</a>
* <a href="#GiveRoad">GiveRoad</a>
* <a href="#GiveUnit">GiveUnit</a>
* <a href="#GiveUnitEx">GiveUnitEx</a>
* <a href="#GiveWares">GiveWares</a>
* <a href="#GiveWaresEx">GiveWaresEx</a>
* <a href="#GiveWeapons">GiveWeapons</a>
* <a href="#GiveWeaponsEx">GiveWeaponsEx</a>
* <a href="#GiveWineField">GiveWineField</a>
* <a href="#GiveWineFieldAged">GiveWineFieldAged</a>
* <a href="#GroupAllowAllyToSelect">GroupAllowAllyToSelect</a>
* <a href="#GroupBlockOrders">GroupBlockOrders</a>
* <a href="#GroupDisableHungryMessage">GroupDisableHungryMessage</a>
* <a href="#GroupHungerSet">GroupHungerSet</a>
* <a href="#GroupKillAll">GroupKillAll</a>
* <a href="#GroupOrderAttackHouse">GroupOrderAttackHouse</a>
* <a href="#GroupOrderAttackUnit">GroupOrderAttackUnit</a>
* <a href="#GroupOrderFood">GroupOrderFood</a>
* <a href="#GroupOrderHalt">GroupOrderHalt</a>
* <a href="#GroupOrderLink">GroupOrderLink</a>
* <a href="#GroupOrderSplit">GroupOrderSplit</a>
* <a href="#GroupOrderSplitUnit">GroupOrderSplitUnit</a>
* <a href="#GroupOrderStorm">GroupOrderStorm</a>
* <a href="#GroupOrderWalk">GroupOrderWalk</a>
* <a href="#GroupOrderWalkEx">GroupOrderWalkEx</a>
* <a href="#GroupSetFormation">GroupSetFormation</a>
* <a href="#HandHouseLock">HandHouseLock</a>
* <a href="#HandTradeAllowed">HandTradeAllowed</a>
* <a href="#HandUnitCanTrain">HandUnitCanTrain</a>
* <a href="#HandWareDistribution">HandWareDistribution</a>
* <a href="#HouseAddBuildingMaterials">HouseAddBuildingMaterials</a>
* <a href="#HouseAddBuildingMaterialsEx">HouseAddBuildingMaterialsEx</a>
* <a href="#HouseAddBuildingProgress">HouseAddBuildingProgress</a>
* <a href="#HouseAddBuildingProgressEx">HouseAddBuildingProgressEx</a>
* <a href="#HouseAddDamage">HouseAddDamage</a>
* <a href="#HouseAddRepair">HouseAddRepair</a>
* <a href="#HouseAddWaresTo">HouseAddWaresTo</a>
* <a href="#HouseAddWaresToEx">HouseAddWaresToEx</a>
* <a href="#HouseAllow">HouseAllow</a>
* <a href="#HouseAllowAllyToSelect">HouseAllowAllyToSelect</a>
* <a href="#HouseAllowAllyToSelectAll">HouseAllowAllyToSelectAll</a>
* <a href="#HouseBarracksEquip">HouseBarracksEquip</a>
* <a href="#HouseBarracksEquipEx">HouseBarracksEquipEx</a>
* <a href="#HouseBarracksGiveRecruit">HouseBarracksGiveRecruit</a>
* <a href="#HouseBarracksGiveRecruits">HouseBarracksGiveRecruits</a>
* <a href="#HouseBarracksRecruitBlock">HouseBarracksRecruitBlock</a>
* <a href="#HouseDeliveryBlock">HouseDeliveryBlock</a>
* <a href="#HouseDeliveryMode">HouseDeliveryMode</a>
* <a href="#HouseDestroy">HouseDestroy</a>
* <a href="#HouseDisableUnoccupiedMessage">HouseDisableUnoccupiedMessage</a>
* <a href="#HouseRepairEnable">HouseRepairEnable</a>
* <a href="#HouseSchoolQueueAdd">HouseSchoolQueueAdd</a>
* <a href="#HouseSchoolQueueAddEx">HouseSchoolQueueAddEx</a>
* <a href="#HouseSchoolQueueRemove">HouseSchoolQueueRemove</a>
* <a href="#HouseTakeWaresFrom">HouseTakeWaresFrom</a>
* <a href="#HouseTakeWaresFromEx">HouseTakeWaresFromEx</a>
* <a href="#HouseTownHallEquip">HouseTownHallEquip</a>
* <a href="#HouseTownHallEquipEx">HouseTownHallEquipEx</a>
* <a href="#HouseTownHallMaxGold">HouseTownHallMaxGold</a>
* <a href="#HouseUnlock">HouseUnlock</a>
* <a href="#HouseWareBlock">HouseWareBlock</a>
* <a href="#HouseWareBlockEx">HouseWareBlockEx</a>
* <a href="#HouseWareBlockTakeOut">HouseWareBlockTakeOut</a>
* <a href="#HouseWeaponsOrderSet">HouseWeaponsOrderSet</a>
* <a href="#HouseWeaponsOrderSetEx">HouseWeaponsOrderSetEx</a>
* <a href="#HouseWoodcutterChopOnly">HouseWoodcutterChopOnly</a>
* <a href="#HouseWoodcutterMode">HouseWoodcutterMode</a>
* <a href="#Log">Log</a>
* <a href="#LogLinesMaxCnt">LogLinesMaxCnt</a>
* <a href="#MapBrush">MapBrush</a>
* <a href="#MapBrushElevation">MapBrushElevation</a>
* <a href="#MapBrushEqualize">MapBrushEqualize</a>
* <a href="#MapBrushFlatten">MapBrushFlatten</a>
* <a href="#MapBrushMagicWater">MapBrushMagicWater</a>
* <a href="#MapBrushWithMask">MapBrushWithMask</a>
* <a href="#MapTileHeightSet">MapTileHeightSet</a>
* <a href="#MapTileObjectSet">MapTileObjectSet</a>
* <a href="#MapTileOverlaySet">MapTileOverlaySet</a>
* <a href="#MapTilesArraySet">MapTilesArraySet</a>
* <a href="#MapTilesArraySetS">MapTilesArraySetS</a>
* <a href="#MapTileSet">MapTileSet</a>
* <a href="#MarketSetTrade">MarketSetTrade</a>
* <a href="#MarketSetTradeEx">MarketSetTradeEx</a>
* <a href="#OverlayTextAppend">OverlayTextAppend</a>
* <a href="#OverlayTextAppendFormatted">OverlayTextAppendFormatted</a>
* <a href="#OverlayTextSet">OverlayTextSet</a>
* <a href="#OverlayTextSetFont">OverlayTextSetFont</a>
* <a href="#OverlayTextSetFormatted">OverlayTextSetFormatted</a>
* <a href="#OverlayTextSetWordWrap">OverlayTextSetWordWrap</a>
* <a href="#Peacetime">Peacetime</a>
* <a href="#PlanAddField">PlanAddField</a>
* <a href="#PlanAddHouse">PlanAddHouse</a>
* <a href="#PlanAddHouseEx">PlanAddHouseEx</a>
* <a href="#PlanAddRoad">PlanAddRoad</a>
* <a href="#PlanAddWinefield">PlanAddWinefield</a>
* <a href="#PlanConnectRoad">PlanConnectRoad</a>
* <a href="#PlanRemove">PlanRemove</a>
* <a href="#PlayerAddDefaultGoals">PlayerAddDefaultGoals</a>
* <a href="#PlayerAllianceChange">PlayerAllianceChange</a>
* <a href="#PlayerAllianceNFogChange">PlayerAllianceNFogChange</a>
* <a href="#PlayerDefeat">PlayerDefeat</a>
* <a href="#PlayerGoalsRemoveAll">PlayerGoalsRemoveAll</a>
* <a href="#PlayerShareBeacons">PlayerShareBeacons</a>
* <a href="#PlayerShareFog">PlayerShareFog</a>
* <a href="#PlayerShareFogCompliment">PlayerShareFogCompliment</a>
* <a href="#PlayerWareDistribution">PlayerWareDistribution</a>
* <a href="#PlayerWin">PlayerWin</a>
* <a href="#PlayOGG">PlayOGG</a>
* <a href="#PlayOGGAtLocation">PlayOGGAtLocation</a>
* <a href="#PlayOGGAtLocationLooped">PlayOGGAtLocationLooped</a>
* <a href="#PlayOGGFadeMusic">PlayOGGFadeMusic</a>
* <a href="#PlayOGGLooped">PlayOGGLooped</a>
* <a href="#PlaySound">PlaySound</a>
* <a href="#PlaySoundAtLocation">PlaySoundAtLocation</a>
* <a href="#PlayWAV">PlayWAV</a>
* <a href="#PlayWAVAtLocation">PlayWAVAtLocation</a>
* <a href="#PlayWAVAtLocationLooped">PlayWAVAtLocationLooped</a>
* <a href="#PlayWAVFadeMusic">PlayWAVFadeMusic</a>
* <a href="#PlayWAVLooped">PlayWAVLooped</a>
* <a href="#RemoveRoad">RemoveRoad</a>
* <a href="#SetTradeAllowed">SetTradeAllowed</a>
* <a href="#ShowMsg">ShowMsg</a>
* <a href="#ShowMsgFormatted">ShowMsgFormatted</a>
* <a href="#ShowMsgGoto">ShowMsgGoto</a>
* <a href="#ShowMsgGotoFormatted">ShowMsgGotoFormatted</a>
* <a href="#StopLoopedOGG">StopLoopedOGG</a>
* <a href="#StopLoopedWAV">StopLoopedWAV</a>
* <a href="#StopSound">StopSound</a>
* <a href="#UnitAllowAllyToSelect">UnitAllowAllyToSelect</a>
* <a href="#UnitBlock">UnitBlock</a>
* <a href="#UnitDirectionSet">UnitDirectionSet</a>
* <a href="#UnitDirectionSetEx">UnitDirectionSetEx</a>
* <a href="#UnitDismiss">UnitDismiss</a>
* <a href="#UnitDismissableSet">UnitDismissableSet</a>
* <a href="#UnitDismissCancel">UnitDismissCancel</a>
* <a href="#UnitHPChange">UnitHPChange</a>
* <a href="#UnitHPSetInvulnerable">UnitHPSetInvulnerable</a>
* <a href="#UnitHungerSet">UnitHungerSet</a>
* <a href="#UnitKill">UnitKill</a>
* <a href="#UnitOrderWalk">UnitOrderWalk</a>
<br />

| Ver<br/>sion | Action description | Parameters<br/>and types | Returns |
| ------- | ------------------------------------ | -------------- | ------- |
| 14600 | <a id="AAIAttackHouseTypesSet">AAIAttackHouseTypesSet</a><sub><br/>Sets set of house types, houses of which Advanced AI should attack<br/>By default those house types are [htBarracks, htStore, htSchool, htTownhall]</sub> | <sub>**aHand**: Byte; <br/> **aHouses**: TKMHouseTypeSet;</sub> | <sub></sub> |
| 7000+ | <a id="AIArmyType">AIArmyType</a><sub><br/>Sets AI army type</sub> | <sub>**aHand**: Byte; <br/> **aType**: TKMArmyType; // _(atIronThenLeather, atLeather, atIron, atIronAndLeather)_</sub> | <sub></sub> |
| 7000+ | <a id="AIAttackAdd">AIAttackAdd</a><sub><br/>Add AI attack <br/>aMeleeGroupCount, aAntiHorseGroupCount, aRangedGroupCount, aMountedGroupCount: soldiers groups count</sub> | <sub>**aHand**: Integer; // _handID_ <br/> **aRepeating**: Boolean; // _is attack repeating_ <br/> **aDelay**: Cardinal; // _attack delay from the game start (in ticks)_ <br/> **aTotalMen**: Integer; // _total soldiers to attack_ <br/> **aMeleeGroupCount**: Integer; <br/> **aAntiHorseGroupCount**: Integer; <br/> **aRangedGroupCount**: Integer; <br/> **aMountedGroupCount**: Integer; <br/> **aRandomGroups**: Boolean; // _ use random groups for attack_ <br/> **aTarget**: TKMAIAttackTarget; // _attack target of TKMAIAttackTarget type_ <br/> **aCustomPosition**: TKMPoint; // _custom position of attack. Used if attCustomPosition was set up as attack target_</sub> | <sub>Integer // Attack UID, that could be used to remove this attack later on</sub> |
| 13900 | <a id="AIAttackAddEx">AIAttackAddEx</a><sub><br/>Add AI attack for a specified hand (player)<br/>Attack info is set via TKMAIAttackInfo record.</sub> | <sub>**aHand**: Integer; <br/> **var aAttackInfo**: TKMAIAttackInfo;</sub> | <sub>Integer // Attack UID, that could be used to remove this attack later on</sub> |
| 7000+ | <a id="AIAttackRemove">AIAttackRemove</a><sub><br/>Remove AI attack by attack UID</sub> | <sub>**aHand**: Integer; <br/> **aAIAttackUID**: Integer;</sub> | <sub>Boolean // True, if attack was succesfully removed, False, if attack was not found</sub> |
| 7000+ | <a id="AIAttackRemoveAll">AIAttackRemoveAll</a><sub><br/>Remove all AI attacks</sub> | <sub>**aHand**: Integer;</sub> | <sub></sub> |
| 13000 | <a id="AIAutoAttack">AIAutoAttack</a><sub><br/>Sets AI auto attack</sub> | <sub>**aHand**: Byte; <br/> **aAutoAttack**: Boolean;</sub> | <sub></sub> |
| 6251 | <a id="AIAutoAttackRange">AIAutoAttackRange</a><sub><br/>Sets AI auto attack range.<br/>AI groups will automatically attack if you are closer than this many tiles.</sub> | <sub>**aHand**: Byte; <br/> **aRange**: Integer; // _Range (1 to 20)_</sub> | <sub></sub> |
| 5924 | <a id="AIAutoBuild">AIAutoBuild</a><sub><br/>Sets whether the AI should build and manage his own village</sub> | <sub>**aHand**: Byte; <br/> **aAuto**: Boolean;</sub> | <sub></sub> |
| 5924 | <a id="AIAutoDefence">AIAutoDefence</a><sub><br/>Sets whether the AI should position his soldiers automatically</sub> | <sub>**aHand**: Byte; <br/> **aAuto**: Boolean;</sub> | <sub></sub> |
| 5932 | <a id="AIAutoRepair">AIAutoRepair</a><sub><br/>Sets whether the AI should automatically repair damaged buildings</sub> | <sub>**aHand**: Byte; <br/> **aAuto**: Boolean;</sub> | <sub></sub> |
| 5932 | <a id="AIDefencePositionAdd">AIDefencePositionAdd</a><sub><br/>Adds a defence position for the specified AI player<br/>Returns added defence position UID or -1 if it could not be added</sub> | <sub>**aHand**: Byte; <br/> **X, Y**: Integer; <br/> **aDir**: Byte; <br/> **aGroupType**: Byte; <br/> **aRadius**: Integer; <br/> **aDefType**: Byte;</sub> | <sub>Integer</sub> |
| 13900 | <a id="AIDefencePositionAddEx">AIDefencePositionAddEx</a><sub><br/>Adds a defence position for the specified AI player<br/>If aOrder is not in range of [0; Count], then position would be added to the end of the list<br/>Returns added defence position UID or -1 if it could not be added</sub> | <sub>**aHand**: Integer; // _hand (player) ID_ <br/> **aOrder**: Integer; // _order (or priority) of the defence position._ <br/> **var aDefencePosition**: TKMDefencePositionInfo;</sub> | <sub>Integer</sub> |
| 6309 | <a id="AIDefencePositionRemove">AIDefencePositionRemove</a><sub><br/>Removes defence position at X, Y</sub> | <sub>**aHand**: Byte; <br/> **X, Y**: Integer;</sub> | <sub></sub> |
| 6323 | <a id="AIDefencePositionRemoveAll">AIDefencePositionRemoveAll</a><sub><br/>Removes all defence positions for specified AI player</sub> | <sub>**aHand**: Byte;</sub> | <sub></sub> |
| 13900 | <a id="AIDefencePositionRemoveByUID">AIDefencePositionRemoveByUID</a><sub><br/>Removes defence position by its UID</sub> | <sub>**aHand**: Integer; <br/> **aUID**: Integer;</sub> | <sub></sub> |
| 6251 | <a id="AIDefendAllies">AIDefendAllies</a><sub><br/>Sets whether AI should defend units and houses of allies as if they were its own</sub> | <sub>**aHand**: Byte; <br/> **aDefend**: Boolean;</sub> | <sub></sub> |
| 5778 | <a id="AIEquipRate">AIEquipRate</a><sub><br/>Sets the warriors equip rate for AI.</sub> | <sub>**aHand**: Byte; <br/> **aType**: Byte; // _type: 0 - leather, 1 - iron_ <br/> **aRate**: Integer;</sub> | <sub></sub> |
| 5778 | <a id="AIGroupsFormationSet">AIGroupsFormationSet</a><sub><br/>Sets the formation the AI uses for defence positions. Works only for ClassicAI</sub> | <sub>**aHand**: Byte; <br/> **aType**: Byte; <br/> **aCount**: Integer; <br/> **aColumns**: Integer;</sub> | <sub></sub> |
| 13900 | <a id="AIGroupsFormationSetEx">AIGroupsFormationSetEx</a><sub><br/>Sets the formation the AI uses for defence positions. Works only for ClassicAI</sub> | <sub>**aHand**: Integer; // _hand (player) ID_ <br/> **aGroupType**: TKMGroupType; <br/> **aCount**: Integer; <br/> **aColumns**: Integer;</sub> | <sub></sub> |
| 5924 | <a id="AIRecruitDelay">AIRecruitDelay</a><sub><br/>Sets the number of ticks before the specified AI will start training recruits</sub> | <sub>**aHand**: Byte; <br/> **aDelay**: Cardinal;</sub> | <sub></sub> |
| 5345 | <a id="AIRecruitLimit">AIRecruitLimit</a><sub><br/>Sets the number of recruits the AI will keep in each barracks</sub> | <sub>**aHand**: Byte; <br/> **aLimit**: Byte;</sub> | <sub></sub> |
| 13900 | <a id="AIRepairMode">AIRepairMode</a><sub><br/>Sets whether the AI should automatically repair damaged buildings<br/>rmNone - unused<br/>rmRepairNever - disable repair for all houses<br/>rmRepairAlways - enable repair for all houses<br/>rmRepairManual - repair is set by script manually via Actions.HouseRepairEnable</sub> | <sub>**aHand**: Integer; <br/> **aRepairMode**: TKMAIRepairMode; // _One of the values (rmNone, rmRepairNever, rmRepairAlways, rmRepairManual)_</sub> | <sub></sub> |
| 5924 | <a id="AISerfsPerHouse">AISerfsPerHouse</a><sub><br/>Sets the number of serfs the AI will train per house.<br/>Can be a decimal (0.25 for 1 serf per 4 houses)</sub> | <sub>**aHand**: Byte; <br/> **aSerfs**: Single;</sub> | <sub></sub> |
| 5932 | <a id="AISoldiersLimit">AISoldiersLimit</a><sub><br/>Sets the maximum number of soldiers the AI will train, or -1 for unlimited</sub> | <sub>**aHand**: Byte; <br/> **aLimit**: Integer;</sub> | <sub></sub> |
| 6251 | <a id="AIStartPosition">AIStartPosition</a><sub><br/>Sets the AI start position which is used for targeting AI attacks</sub> | <sub>**aHand**: Byte; <br/> **X, Y**: Integer;</sub> | <sub></sub> |
| 5924 | <a id="AIWorkerLimit">AIWorkerLimit</a><sub><br/>Sets the maximum number of laborers the AI will train</sub> | <sub>**aHand**: Byte; <br/> **aLimit**: Byte;</sub> | <sub></sub> |
| 5938 | <a id="CinematicEnd">CinematicEnd</a><sub><br/>Exits cinematic mode</sub> | <sub>**aHand**: Byte;</sub> | <sub></sub> |
| 5938 | <a id="CinematicPanTo">CinematicPanTo</a><sub><br/>Pans the center of the player's screen to the given location over a set number of ticks.<br/>If Duration = 0 then the screen moves instantly.</sub> | <sub>**aHand**: Byte; <br/> **X, Y**: Integer; <br/> **Duration**: Integer;</sub> | <sub></sub> |
| 5938 | <a id="CinematicStart">CinematicStart</a><sub><br/>Puts the player in cinematic mode, blocking user input and allowing the screen to be panned</sub> | <sub>**aHand**: Byte;</sub> | <sub></sub> |
| 5097 | <a id="FogCoverAll">FogCoverAll</a><sub><br/>Covers (un-reveals) the entire map in fog of war for player</sub> | <sub>**aHand**: Byte;</sub> | <sub></sub> |
| 5097 | <a id="FogCoverCircle">FogCoverCircle</a><sub><br/>Reveals a circle in fog of war for player</sub> | <sub>**aHand**: Integer; <br/> **X, Y**: Integer; <br/> **aRadius**: Integer;</sub> | <sub></sub> |
| 5777 | <a id="FogCoverRect">FogCoverRect</a><sub><br/>Covers a rectangular area in fog of war for player</sub> | <sub>**aHand**: Integer; <br/> **X1**: Integer; // _Left coordinate_ <br/> **Y1**: Integer; // _Top coordinate_ <br/> **X2**: Integer; // _Right coordinate_ <br/> **Y2**: Integer; // _Bottom coordinate_</sub> | <sub></sub> |
| 5097 | <a id="FogRevealAll">FogRevealAll</a><sub><br/>Reveals the entire map in fog of war for player</sub> | <sub>**aHand**: Byte;</sub> | <sub></sub> |
| 5097 | <a id="FogRevealCircle">FogRevealCircle</a><sub><br/>Reveals a circle in fog of war for player</sub> | <sub>**aHand**: Integer; <br/> **X, Y**: Integer; <br/> **aRadius**: Integer;</sub> | <sub></sub> |
| 5777 | <a id="FogRevealRect">FogRevealRect</a><sub><br/>Reveals a rectangular area in fog of war for player</sub> | <sub>**aHand**: Integer; <br/> **X1**: Integer; // _Left coordinate_ <br/> **Y1**: Integer; // _Top coordinate_ <br/> **X2**: Integer; // _Right coordinate_ <br/> **Y2**: Integer; // _Bottom coordinate_</sub> | <sub></sub> |
| 11000 | <a id="GameSpeed">GameSpeed</a><sub><br/>Changes game speed</sub> | <sub>**aSpeed**: Single;</sub> | <sub></sub> |
| 11000 | <a id="GameSpeedChangeAllowed">GameSpeedChangeAllowed</a><sub><br/>Allows or blocks game speed change</sub> | <sub>**aAllowed**: Boolean;</sub> | <sub></sub> |
| 5057 | <a id="GiveAnimal">GiveAnimal</a><sub><br/>Adds an animal to the game and returns the unit ID or -1 if the animal was not able to be added</sub> | <sub>**aType**: Integer; <br/> **X, Y**: Integer;</sub> | <sub>Integer</sub> |
| 14000 | <a id="GiveAnimalEx">GiveAnimalEx</a><sub><br/>Adds an animal to the game and returns the unit ID or -1 if the animal was not able to be added</sub> | <sub>**aType**: TKMUnitType; <br/> **X, Y**: Integer;</sub> | <sub>Integer</sub> |
| 6311 | <a id="GiveField">GiveField</a><sub><br/>Adds finished field and returns True if field was successfully added</sub> | <sub>**aHand**: Integer; <br/> **X, Y**: Integer;</sub> | <sub>Boolean</sub> |
| 7000+ | <a id="GiveFieldAged">GiveFieldAged</a><sub><br/>Sets field age if tile is corn field, or adds finished field and sets its age if tile is empty, and returns True if this was successfully done</sub> | <sub>**aHand**: Integer; <br/> **X, Y**: Integer; <br/> **aStage**: Byte; // _0..6, sets the field growth stage. 0 = empty field; 6 = corn has been cut_ <br/> **aRandomAge**: Boolean; // _sets FieldAge to random, according to specified stage. Makes fields more realistic_</sub> | <sub>Boolean</sub> |
| 5057 | <a id="GiveGroup">GiveGroup</a><sub><br/>Give player group of warriors and return the group ID or -1 if the group was not able to be added</sub> | <sub>**aHand**: Integer; <br/> **aType**: Integer; <br/> **X, Y**: Integer; <br/> **aDir**: Integer; <br/> **aCount**: Integer; <br/> **aColumns**: Integer; // _Units per row_</sub> | <sub>Integer</sub> |
| 14000 | <a id="GiveGroupEx">GiveGroupEx</a><sub><br/>Give player group of warriors and return the group ID or -1 if the group was not able to be added</sub> | <sub>**aHand**: Integer; <br/> **aType**: TKMUnitType; <br/> **X, Y**: Integer; <br/> **aDir**: TKMDirection; <br/> **aCount**: Integer; <br/> **aColumns**: Integer; // _Units per row_</sub> | <sub>Integer</sub> |
| 5097 | <a id="GiveHouse">GiveHouse</a><sub><br/>Give player a built house and returns the house ID or -1 if the house was not able to be added</sub> | <sub>**aHand**: Integer; <br/> **aHouseType**: Integer; <br/> **X, Y**: Integer;</sub> | <sub>Integer</sub> |
| 14000 | <a id="GiveHouseEx">GiveHouseEx</a><sub><br/>Give player a built house and returns the house ID or -1 if the house was not able to be added</sub> | <sub>**aHand**: Integer; <br/> **aHouseType**: TKMHouseType; <br/> **X, Y**: Integer;</sub> | <sub>Integer</sub> |
| 6288 | <a id="GiveHouseSite">GiveHouseSite</a><sub><br/>Give player a digged house area and returns House ID or -1 if house site was not able to be added.<br/>If AddMaterials = True, wood and stone will be added</sub> | <sub>**aHand**: Integer; <br/> **aHouseType**: Integer; <br/> **X, Y**: Integer; <br/> **aAddMaterials**: Boolean;</sub> | <sub>Integer</sub> |
| 14000 | <a id="GiveHouseSiteEx">GiveHouseSiteEx</a><sub><br/>Give player a digged house area and returns House ID or -1 if house site was not able to be added.</sub> | <sub>**aHand**: Integer; <br/> **aHouseType**: TKMHouseType; <br/> **X, Y**: Integer; <br/> **aWoodAmount**: Integer; // _number of resources to be added to the site_ <br/> **aStoneAmount**: Integer; // _number of resources to be added to the site_</sub> | <sub>Integer</sub> |
| 6311 | <a id="GiveRoad">GiveRoad</a><sub><br/>Adds finished road and returns True if road was successfully added</sub> | <sub>**aHand**: Integer; <br/> **X, Y**: Integer;</sub> | <sub>Boolean</sub> |
| 5057 | <a id="GiveUnit">GiveUnit</a><sub><br/>Give player a single citizen and returns the unit ID or -1 if the unit was not able to be added</sub> | <sub>**aHand**: Integer; <br/> **aType**: Integer; <br/> **X, Y**: Integer; <br/> **aDir**: Integer;</sub> | <sub>Integer</sub> |
| 14000 | <a id="GiveUnitEx">GiveUnitEx</a><sub><br/>Give player a single citizen and returns the unit ID or -1 if the unit was not able to be added</sub> | <sub>**aHand**: Integer; <br/> **aType**: TKMUnitType; <br/> **X, Y**: Integer; <br/> **aDir**: TKMDirection;</sub> | <sub>Integer</sub> |
| 5057 | <a id="GiveWares">GiveWares</a><sub><br/>Adds amount of wares to players 1st Store<br/>Wares are added to first Store</sub> | <sub>**aHand**: Integer; <br/> **aType**: Integer; <br/> **aCount**: Integer;</sub> | <sub></sub> |
| 14000 | <a id="GiveWaresEx">GiveWaresEx</a><sub><br/>Adds amount of wares to players 1st Store<br/>Wares are added to first Store</sub> | <sub>**aHand**: Integer; <br/> **aType**: TKMWareType; <br/> **aCount**: Integer;</sub> | <sub></sub> |
| 5165 | <a id="GiveWeapons">GiveWeapons</a><sub><br/>Adds amount of weapons to players 1st Barracks<br/>Weapons are added to first Barracks</sub> | <sub>**aHand**: Integer; <br/> **aType**: Integer; <br/> **aCount**: Integer;</sub> | <sub></sub> |
| 14000 | <a id="GiveWeaponsEx">GiveWeaponsEx</a><sub><br/>Adds amount of weapons to players 1st Barracks<br/>Weapons are added to first Barracks</sub> | <sub>**aHand**: Integer; <br/> **aType**: TKMWareType; <br/> **aCount**: Integer;</sub> | <sub></sub> |
| 6311 | <a id="GiveWineField">GiveWineField</a><sub><br/>Adds finished winefield and returns True if winefield was successfully added</sub> | <sub>**aHand**: Integer; <br/> **X, Y**: Integer;</sub> | <sub>Boolean</sub> |
| 7000+ | <a id="GiveWineFieldAged">GiveWineFieldAged</a><sub><br/>Sets winefield age if tile is winefield, or adds finished winefield and sets its age if tile is empty, and returns True if this was successfully done</sub> | <sub>**aHand**: Integer; <br/> **X, Y**: Integer; <br/> **aStage**: Byte; // _0..3, sets the field growth stage. 0 = new fruits; 3 = grapes are ready to be harvested; according to WINE_STAGES_COUNT_ <br/> **aRandomAge**: Boolean; // _sets FieldAge to random, according to specified stage. Makes fields more realistic_</sub> | <sub>Boolean</sub> |
| 12600 | <a id="GroupAllowAllyToSelect">GroupAllowAllyToSelect</a><sub><br/>Allows allies to select and view specified group</sub> | <sub>**aGroupID**: Integer; <br/> **aAllow**: Boolean;</sub> | <sub></sub> |
| 6277 | <a id="GroupBlockOrders">GroupBlockOrders</a><sub><br/>Disables (Disable = True) or enables (Disable = False) control over specifed warriors group</sub> | <sub>**aGroupID**: Integer; <br/> **aBlock**: Boolean;</sub> | <sub></sub> |
| 5993 | <a id="GroupDisableHungryMessage">GroupDisableHungryMessage</a><sub><br/>Sets whether the specified group will alert the player when they become hungry<br/>(True to disable hunger messages, False to enable them)</sub> | <sub>**aGroupID**: Integer; <br/> **aDisable**: Boolean;</sub> | <sub></sub> |
| 5993 | <a id="GroupHungerSet">GroupHungerSet</a><sub><br/>Set hunger level for all group members</sub> | <sub>**aGroupID**: Integer; <br/> **aHungerLevel**: Integer; // _Hunger level (ticks until death)_</sub> | <sub></sub> |
| 5993 | <a id="GroupKillAll">GroupKillAll</a><sub><br/>Kills all members of the specified group</sub> | <sub>**aGroupID**: Integer; <br/> **aSilent**: Boolean;</sub> | <sub></sub> |
| 5057 | <a id="GroupOrderAttackHouse">GroupOrderAttackHouse</a><sub><br/>Order the specified group to attack the specified house</sub> | <sub>**aGroupID**: Integer; <br/> **aHouseID**: Integer;</sub> | <sub></sub> |
| 5057 | <a id="GroupOrderAttackUnit">GroupOrderAttackUnit</a><sub><br/>Order the specified group to attack the specified unit</sub> | <sub>**aGroupID**: Integer; <br/> **aUnitID**: Integer;</sub> | <sub></sub> |
| 5057 | <a id="GroupOrderFood">GroupOrderFood</a><sub><br/>Order the specified group to request food</sub> | <sub>**aGroupID**: Integer;</sub> | <sub></sub> |
| 5057 | <a id="GroupOrderHalt">GroupOrderHalt</a><sub><br/>Order the specified group to halt</sub> | <sub>**aGroupID**: Integer;</sub> | <sub></sub> |
| 5057 | <a id="GroupOrderLink">GroupOrderLink</a><sub><br/>Order the first specified group to link to the second specified group</sub> | <sub>**aGroupID**: Integer; <br/> **aDestGroupID**: Integer;</sub> | <sub></sub> |
| 5057 | <a id="GroupOrderSplit">GroupOrderSplit</a><sub><br/>Order the specified group to split in half.<br/>Return the newly create group ID or -1 if splitting failed (e.g. only 1 member)</sub> | <sub>**aGroupID**: Integer;</sub> | <sub>Integer</sub> |
| 6338 | <a id="GroupOrderSplitUnit">GroupOrderSplitUnit</a><sub><br/>Splits specified unit from the group.<br/>Returns the newly create group ID or -1 if splitting failed (e.g. only 1 member)</sub> | <sub>**aGroupID**: Integer; <br/> **aUnitID**: Integer;</sub> | <sub>Integer</sub> |
| 5057 | <a id="GroupOrderStorm">GroupOrderStorm</a><sub><br/>Order the specified group to storm attack</sub> | <sub>**aGroupID**: Integer;</sub> | <sub></sub> |
| 5057 | <a id="GroupOrderWalk">GroupOrderWalk</a><sub><br/>Order the specified group to walk somewhere</sub> | <sub>**aGroupID**: Integer; <br/> **X, Y**: Integer; <br/> **aDirection**: Integer;</sub> | <sub></sub> |
| 14000 | <a id="GroupOrderWalkEx">GroupOrderWalkEx</a><sub><br/>Order the specified group to walk somewhere</sub> | <sub>**aGroupID**: Integer; <br/> **X, Y**: Integer; <br/> **aDirection**: TKMDirection;</sub> | <sub></sub> |
| 5057 | <a id="GroupSetFormation">GroupSetFormation</a><sub><br/>Sets the number of columns (units per row) for the specified group</sub> | <sub>**aGroupID**: Integer; <br/> **aNumColumns**: Byte;</sub> | <sub></sub> |
| 13900 | <a id="HandHouseLock">HandHouseLock</a><sub><br/>Sets hand (player) house lock aLock for a specified house type aHouseType<br/>if htAny is passed for house type then aLock will be applied to all house types</sub> | <sub>**aHand**: Integer; <br/> **aHouseType**: TKMHouseType; <br/> **aLock**: TKMHandHouseLock;</sub> | <sub></sub> |
| 14000 | <a id="HandTradeAllowed">HandTradeAllowed</a><sub><br/>Sets whether the player is allowed to trade the specified resource.<br/>if aHand = -1, then apply it to all hands (players)</sub> | <sub>**aHand**: Integer; <br/> **aWareType**: TKMWareType; <br/> **aAllowed**: Boolean;</sub> | <sub></sub> |
| 14000 | <a id="HandUnitCanTrain">HandUnitCanTrain</a><sub><br/>Sets whether the specified player can train/equip the specified unit type<br/>if aHand = -1, then apply it to all hands (players)</sub> | <sub>**aHand**: Integer; <br/> **aUnitType**: TKMUnitType; <br/> **aCanTrain**: Boolean;</sub> | <sub></sub> |
| 14000 | <a id="HandWareDistribution">HandWareDistribution</a><sub><br/>Sets ware distribution for the specified resource, house and hand (player).<br/>Note: distribution should be set after 1st tick of the game,<br/>thus it will not make effect to use it in OnMissionStart event handler</sub> | <sub>**aHand**: Integer; <br/> **aWareType**: TKMWareType; <br/> **aHouseType**: TKMHouseType; <br/> **aAmount**: Integer; // _Distribution amount (0..5)_</sub> | <sub></sub> |
| 6510 | <a id="HouseAddBuildingMaterials">HouseAddBuildingMaterials</a><sub><br/>Add all building materials to the specified WIP house area</sub> | <sub>**aHouseID**: Integer;</sub> | <sub></sub> |
| 14000 | <a id="HouseAddBuildingMaterialsEx">HouseAddBuildingMaterialsEx</a><sub><br/>Add or remove building materials to the specified WIP house area<br/>if aWoodAmount or aStoneAmount > 0 then add build wares to the site<br/>if aWoodAmount or aStoneAmount < 0 then remove build wares from the site</sub> | <sub>**aHouseID**: Integer; <br/> **aWoodAmount**: Integer; <br/> **aStoneAmount**: Integer;</sub> | <sub></sub> |
| 6297 | <a id="HouseAddBuildingProgress">HouseAddBuildingProgress</a><sub><br/>Add 5 points of building progress to the specified WIP house area</sub> | <sub>**aHouseID**: Integer;</sub> | <sub></sub> |
| 14000 | <a id="HouseAddBuildingProgressEx">HouseAddBuildingProgressEx</a><sub><br/>Add 5 * aBuildSteps points of building progress to the specified WIP house area</sub> | <sub>**aHouseID**: Integer; <br/> **aBuildSteps**: Integer;</sub> | <sub></sub> |
| 5057 | <a id="HouseAddDamage">HouseAddDamage</a><sub><br/>Add damage to the specified house</sub> | <sub>**aHouseID**: Integer; <br/> **aDamage**: Integer;</sub> | <sub></sub> |
| 5441 | <a id="HouseAddRepair">HouseAddRepair</a><sub><br/>Reduces damage to the specified house</sub> | <sub>**aHouseID**: Integer; <br/> **aRepair**: Integer;</sub> | <sub></sub> |
| 5057 | <a id="HouseAddWaresTo">HouseAddWaresTo</a><sub><br/>Add wares to the specified house</sub> | <sub>**aHouseID**: Integer; <br/> **aType**: Integer; <br/> **aCount**: Integer;</sub> | <sub></sub> |
| 14000 | <a id="HouseAddWaresToEx">HouseAddWaresToEx</a><sub><br/>Add wares to the specified house</sub> | <sub>**aHouseID**: Integer; <br/> **aType**: TKMWareType; <br/> **aCount**: Integer;</sub> | <sub></sub> |
| 5057 | <a id="HouseAllow">HouseAllow</a><sub><br/>Sets whether the player is allowed to build the specified house.<br/>Note: The house must still be unlocked normally (e.g. sawmill for farm), use HouseUnlock to override that.</sub> | <sub>**aHand**: Integer; <br/> **aHouseType**: Integer; <br/> **aAllowed**: Boolean;</sub> | <sub></sub> |
| 10940 | <a id="HouseAllowAllyToSelect">HouseAllowAllyToSelect</a><sub><br/>Allows allies to view specified house</sub> | <sub>**aHouseID**: Integer; <br/> **aAllow**: Boolean;</sub> | <sub></sub> |
| 10940 | <a id="HouseAllowAllyToSelectAll">HouseAllowAllyToSelectAll</a><sub><br/>Allows allies to view all houses of specified player, or for all players, if aHand is -1<br/>This function applies only to already build houses.<br/>New houses will be selectable for allies. To avoid it use OnHouseBuilt event</sub> | <sub>**aHand**: ShortInt; <br/> **aAllow**: Boolean;</sub> | <sub></sub> |
| 5174 | <a id="HouseBarracksEquip">HouseBarracksEquip</a><sub><br/>Equips the specified unit from the specified barracks.<br/>Returns the number of units successfully equipped.</sub> | <sub>**aHouseID**: Integer; <br/> **aUnitType**: Integer; <br/> **aCount**: Integer;</sub> | <sub>Integer</sub> |
| 13900 | <a id="HouseBarracksEquipEx">HouseBarracksEquipEx</a><sub><br/>Equips the specified unit from the specified barracks.<br/>Returns the number of units successfully equipped.</sub> | <sub>**aHouseID**: Integer; <br/> **aUnitType**: TKMUnitType; <br/> **aCount**: Integer;</sub> | <sub>Integer</sub> |
| 6125 | <a id="HouseBarracksGiveRecruit">HouseBarracksGiveRecruit</a><sub><br/>Adds a recruit inside the specified barracks</sub> | <sub>**aHouseID**: Integer;</sub> | <sub></sub> |
| 14000 | <a id="HouseBarracksGiveRecruits">HouseBarracksGiveRecruits</a><sub><br/>Adds aCount recruits inside the specified barracks</sub> | <sub>**aHouseID**: Integer; <br/> **aCount**: Integer;</sub> | <sub></sub> |
| 14000 | <a id="HouseBarracksRecruitBlock">HouseBarracksRecruitBlock</a><sub><br/>Blocks or allows recruit to get into specified Barracks</sub> | <sub>**aHouseID**: Integer; <br/> **aBlocked**: Boolean;</sub> | <sub></sub> |
| 5057 | <a id="HouseDeliveryBlock">HouseDeliveryBlock</a><sub><br/>Sets delivery blocking for the specified house</sub> | <sub>**aHouseID**: Integer; <br/> **aDeliveryBlocked**: Boolean;</sub> | <sub></sub> |
| 13900 | <a id="HouseDeliveryMode">HouseDeliveryMode</a><sub><br/>Sets delivery mode for the specified house</sub> | <sub>**aHouseID**: Integer; <br/> **aDeliveryMode**: TKMDeliveryMode;</sub> | <sub></sub> |
| 5263 | <a id="HouseDestroy">HouseDestroy</a><sub><br/>Destroys the specified house.<br/>Silent means the house will not leave rubble or play destroy sound</sub> | <sub>**aHouseID**: Integer; <br/> **aSilent**: Boolean;</sub> | <sub></sub> |
| 5345 | <a id="HouseDisableUnoccupiedMessage">HouseDisableUnoccupiedMessage</a><sub><br/>Sets whether the specified house displays unoccupied messages to the player</sub> | <sub>**aHouseID**: Integer; <br/> **aDisabled**: Boolean;</sub> | <sub></sub> |
| 5057 | <a id="HouseRepairEnable">HouseRepairEnable</a><sub><br/>Enables house repair for the specified house</sub> | <sub>**aHouseID**: Integer; <br/> **aRepairEnabled**: Boolean;</sub> | <sub></sub> |
| 5174 | <a id="HouseSchoolQueueAdd">HouseSchoolQueueAdd</a><sub><br/>Adds the specified unit to the specified school's queue.<br/>Returns the number of units successfully added to the queue.</sub> | <sub>**aHouseID**: Integer; <br/> **aUnitType**: Integer; <br/> **aCount**: Integer;</sub> | <sub>Integer</sub> |
| 14000 | <a id="HouseSchoolQueueAddEx">HouseSchoolQueueAddEx</a><sub><br/>Adds the specified unit to the specified school's queue.<br/>Returns the number of units successfully added to the queue.</sub> | <sub>**aHouseID**: Integer; <br/> **aUnitType**: TKMUnitType; <br/> **aCount**: Integer;</sub> | <sub>Integer</sub> |
| 5174 | <a id="HouseSchoolQueueRemove">HouseSchoolQueueRemove</a><sub><br/>Removes the unit from the specified slot of the school queue.<br/>Slot 0 is the unit currently training, slots 1..5 are the queue.</sub> | <sub>**aHouseID**: Integer; <br/> **QueueIndex**: Integer;</sub> | <sub></sub> |
| 6015 | <a id="HouseTakeWaresFrom">HouseTakeWaresFrom</a><sub><br/>Remove wares from the specified house.<br/>If a serf was on the way to pick up the ware, the serf will abandon his task</sub> | <sub>**aHouseID**: Integer; <br/> **aType**: Integer; <br/> **aCount**: Integer;</sub> | <sub></sub> |
| 14000 | <a id="HouseTakeWaresFromEx">HouseTakeWaresFromEx</a><sub><br/>Remove wares from the specified house.<br/>If a serf was on the way to pick up the ware, the serf will abandon his task</sub> | <sub>**aHouseID**: Integer; <br/> **aType**: TKMWareType; <br/> **aCount**: Integer;</sub> | <sub></sub> |
| 7000+ | <a id="HouseTownHallEquip">HouseTownHallEquip</a><sub><br/>Equips the specified unit from the specified TownHall.<br/>Returns the number of units successfully equipped.</sub> | <sub>**aHouseID**: Integer; <br/> **aUnitType**: Integer; <br/> **aCount**: Integer;</sub> | <sub>Integer</sub> |
| 14000 | <a id="HouseTownHallEquipEx">HouseTownHallEquipEx</a><sub><br/>Equips the specified unit from the specified TownHall.<br/>Returns the number of units successfully equipped.</sub> | <sub>**aHouseID**: Integer; <br/> **aUnitType**: TKMUnitType; <br/> **aCount**: Integer;</sub> | <sub>Integer</sub> |
| 7000+ | <a id="HouseTownHallMaxGold">HouseTownHallMaxGold</a><sub><br/>Set TownHall Max Gold parameter (how many gold could be delivered in it)</sub> | <sub>**aHouseID**: Integer; <br/> **aMaxGold**: Integer;</sub> | <sub></sub> |
| 5057 | <a id="HouseUnlock">HouseUnlock</a><sub><br/>Allows player to build the specified house even if they don't have the house built that normally unlocks it<br/>(e.g. sawmill for farm).<br/>Note: Does not override blocked houses, use HouseAllow for that.</sub> | <sub>**aHand**: Integer; <br/> **aHouseType**: Integer;</sub> | <sub></sub> |
| 5099 | <a id="HouseWareBlock">HouseWareBlock</a><sub><br/>Blocks a specific ware in a storehouse or barracks</sub> | <sub>**aHouseID**: Integer; <br/> **aWareType**: Integer; <br/> **aBlocked**: Boolean;</sub> | <sub></sub> |
| 14000 | <a id="HouseWareBlockEx">HouseWareBlockEx</a><sub><br/>Blocks a specific ware in a storehouse or barracks</sub> | <sub>**aHouseID**: Integer; <br/> **aWareType**: TKMWareType; <br/> **aBlocked**: Boolean;</sub> | <sub></sub> |
| 14000 | <a id="HouseWareBlockTakeOut">HouseWareBlockTakeOut</a><sub><br/>Blocks taking out of a specific ware from a storehouse or barracks</sub> | <sub>**aHouseID**: Integer; <br/> **aWareType**: TKMWareType; <br/> **aBlocked**: Boolean;</sub> | <sub></sub> |
| 5165 | <a id="HouseWeaponsOrderSet">HouseWeaponsOrderSet</a><sub><br/>Sets the amount of the specified weapon ordered to be produced in the specified house</sub> | <sub>**aHouseID**: Integer; <br/> **aWareType**: Integer; <br/> **aAmount**: Integer;</sub> | <sub></sub> |
| 14000 | <a id="HouseWeaponsOrderSetEx">HouseWeaponsOrderSetEx</a><sub><br/>Sets the amount of the specified weapon ordered to be produced in the specified house</sub> | <sub>**aHouseID**: Integer; <br/> **aWareType**: TKMWareType; <br/> **aAmount**: Integer;</sub> | <sub></sub> |
| 5099 | <a id="HouseWoodcutterChopOnly">HouseWoodcutterChopOnly</a><sub><br/>Sets whether a woodcutter's hut is on chop-only mode</sub> | <sub>**aHouseID**: Integer; <br/> **aChopOnly**: Boolean;</sub> | <sub></sub> |
| 14000 | <a id="HouseWoodcutterMode">HouseWoodcutterMode</a><sub><br/>Sets woodcutter's hut woodcutter mode as TKMWoodcutterMode = (wmChopAndPlant, wmChop, wmPlant)</sub> | <sub>**aHouseID**: Integer; <br/> **aWoodcutterMode**: TKMWoodcutterMode;</sub> | <sub></sub> |
| 6067 | <a id="Log">Log</a><sub><br/>Writes a line of text to the game log file. Useful for debugging.<br/>Note that many calls to this procedure will have a noticeable performance impact,<br/>as well as creating a large log file, so it is recommended you don't use it outside of debugging</sub> | <sub>**aText**: AnsiString;</sub> | <sub></sub> |
| 12989 | <a id="LogLinesMaxCnt">LogLinesMaxCnt</a><sub><br/>Set max number of error lines saved in the logs</sub> | <sub>**aMaxLogLinesCnt**: Integer;</sub> | <sub></sub> |
| 11000 | <a id="MapBrush">MapBrush</a><sub><br/>Apply brush from MapEd to the map</sub> | <sub>**X**: Integer; // _X coodinate_ <br/> **Y**: Integer; // _Y coodinate_ <br/> **aSquare**: Boolean; // _is brush square or circle_ <br/> **aSize**: Integer; // _brush size_ <br/> **aTerKind**: TKMTerrainKind; // _terrain kind_ <br/> **aRandomTiles**: Boolean; // _use random tiles_ <br/> **aOverrideCustomTiles**: Boolean; // _override tiles, that were manually set from tiles table_</sub> | <sub></sub> |
| 11000 | <a id="MapBrushElevation">MapBrushElevation</a><sub><br/>Apply Elevation change brush from MapEd to the map</sub> | <sub>**X**: Integer; // _X coodinate_ <br/> **Y**: Integer; // _Y coodinate_ <br/> **aSquare**: Boolean; // _is brush square or circle_ <br/> **aRaise**: Boolean; // _raise elevation or lower it_ <br/> **aSize**: Integer; // _brush size_ <br/> **aSlope**: Integer; // _elevation slope_ <br/> **aSpeed**: Integer; // _elevation change speed_</sub> | <sub></sub> |
| 11000 | <a id="MapBrushEqualize">MapBrushEqualize</a><sub><br/>Apply Equalize brush from MapEd to the map</sub> | <sub>**X**: Integer; // _X coodinate_ <br/> **Y**: Integer; // _Y coodinate_ <br/> **aSquare**: Boolean; // _is brush square or circle_ <br/> **aSize**: Integer; // _brush size_ <br/> **aSlope**: Integer; // _elevation slope_ <br/> **aSpeed**: Integer; // _elevation change speed_</sub> | <sub></sub> |
| 11000 | <a id="MapBrushFlatten">MapBrushFlatten</a><sub><br/>Apply Flatten brush from MapEd to the map</sub> | <sub>**X**: Integer; // _X coodinate_ <br/> **Y**: Integer; // _Y coodinate_ <br/> **aSquare**: Boolean; // _is brush square or circle_ <br/> **aSize**: Integer; // _brush size_ <br/> **aSlope**: Integer; // _elevation slope_ <br/> **aSpeed**: Integer; // _elevation change speed_</sub> | <sub></sub> |
| 11000 | <a id="MapBrushMagicWater">MapBrushMagicWater</a><sub><br/>Apply magic water brush from MapEd to the map</sub> | <sub>**X**: Integer; // _X coodinate_ <br/> **Y**: Integer; // _Y coodinate_</sub> | <sub></sub> |
| 11000 | <a id="MapBrushWithMask">MapBrushWithMask</a><sub><br/>Apply brush with mask specified from MapEd to the map</sub> | <sub>**X**: Integer; // _X coodinate_ <br/> **Y**: Integer; // _Y coodinate_ <br/> **aSquare**: Boolean; // _is brush square or circle_ <br/> **aSize**: Integer; // _brush size_ <br/> **aTerKind**: TKMTerrainKind; // _terrain kind_ <br/> **aRandomTiles**: Boolean; // _use random tiles_ <br/> **aOverrideCustomTiles**: Boolean; // _override tiles, that were manually set from tiles table_ <br/> **aBrushMask**: TKMTileMaskKind; // _brush mask type_ <br/> **aBlendingLvl**: Integer; // _blending level for masks. Allowed values are from 0 to 15_ <br/> **aUseMagicBrush**: Boolean; // _enable/disable magic brush to change/remove brush mask from the area_</sub> | <sub></sub> |
| 6587 | <a id="MapTileHeightSet">MapTileHeightSet</a><sub><br/>Sets the height of the terrain at the top left corner (vertex) of the tile at the specified XY coordinates.<br/>Returns True if the change succeeded or False if it failed.<br/>The change will fail if it would cause a unit to become stuck or a house to be damaged</sub> | <sub>**X, Y**: Integer; <br/> **Height**: Integer; // _Height (0..100)_</sub> | <sub>Boolean</sub> |
| 6587 | <a id="MapTileObjectSet">MapTileObjectSet</a><sub><br/>Sets the terrain object on the tile at the specified XY coordinates.<br/>Object IDs can be seen in the map editor on the objects tab.<br/>Object 61 is "block walking". To set no object, use object type 255.<br/>Returns True if the change succeeded or False if it failed.<br/>The change will fail if it would cause a unit to become stuck or a house/field to be damaged</sub> | <sub>**X, Y**: Integer; <br/> **Obj**: Integer; // _Object type (0..255)_</sub> | <sub>Boolean</sub> |
| 11000 | <a id="MapTileOverlaySet">MapTileOverlaySet</a><sub><br/>Sets the terrain overlay on the tile at the specified XY coordinates.<br/>aOverwrite: True allows to destroy roads and re-dig fields (like in game we can build road on top of field and when laborer dies there is a digged overlay left)</sub> | <sub>**X, Y**: Integer; <br/> **aOverlay**: TKMTileOverlay; <br/> **aOverwrite**: Boolean; // _False means safe way to change tile overlay, disallowing to set it on top of old fields/roads_</sub> | <sub>Boolean</sub> |
| 7000+ | <a id="MapTilesArraySet">MapTilesArraySet</a><sub><br/>Sets array of tiles info, with possible change of<br/>1. terrain (tile type) and/or rotation (same as for MapTileSet),<br/>2. tile height (same as for MapTileHeightSet)<br/>3. tile object (same as for MapTileObjectSet)<br/>Works much faster, then applying all changes successively for every tile, because pathfinding compute is executed only once after all changes have been done<br/><pre><br/>TKMTerrainTileBrief = record<br/>  X, Y: Word;     // Tile map coordinates<br/>  Terrain: Word;  // Terrain tile type (0..596)<br/>  Rotation: Byte; // Tile rotation (0..3)<br/>  Height: Byte;   // Heigth (0..150)<br/>  Obj: Word;      // Object (0..255)<br/>  UpdateTerrain, UpdateRotation, UpdateHeight, UpdateObject: Boolean; // What part of tile should be updated?<br/>end;<br/></pre>UpdateXXX fields determines what should be changed on tile<br/>F.e. if we want to change terrain type and height, then UpdateTerrain and UpdateHeight should be set to True<br/>Note: aTiles elements should start from 0, as for dynamic array. So f.e. to change map tile 1,1 we should set aTiles[0][0].<br/>Note: Errors are shown as map tiles (f.e. for error while applying aTiles[0][0] tile there will be a message with for map tile 1,1)<br/>/*</sub> | <sub>**aTiles**: array of TKMTerrainTileBrief; // _Check detailed info on this type in description_ <br/> **aRevertOnFail**: Boolean; // _do we need to revert all changes on any error while applying changes. If True, then no changes will be applied on error. If False - we will continue apply changes where possible_ <br/> **aShowDetailedErrors**: Boolean; // _show detailed errors after. Can slow down the execution, because of logging. If aRevertOnFail is set to True, then only first error will be shown_</sub> | <sub>Boolean // True, if there was no errors on any tile. False if there was at least 1 error.</sub> |
| 7000+ | <a id="MapTilesArraySetS">MapTilesArraySetS</a><sub><br/>Sets array of tiles info, like MapTilesArraySet, but parameters are<br/>passed as an TAnsiStringArray instead of array of TKMTerrainTileBrief.<br/>This function is useful if you need to create dynamic map from scratch.<br/>Array must contain strings in following format: 'X,Y,Terrain,Rotation,Height,Obj'<br/>f.e. '1,1,20,2,87,12'<br/>In case of invalid structure detection / failed variable parsing you can find<br/>detailed errors in LOG file.<br/>If you need to skip terrain or rotation/height/obj use -1 as parameter<br/>f.e.<br/>Skipping rotation for tile [7,2]: '7,2,20,-1,87,12'<br/>Skipping obj for tile [7,2]: '7,2,20,2,87,-1'<br/>Skipping height for tile [7,2]: '7,2,20,2,-1,5' etc.</sub> | <sub>**aTilesS**: TAnsiStringArray; <br/> **aRevertOnFail**: Boolean; <br/> **aShowDetailedErrors**: Boolean;</sub> | <sub>Boolean</sub> |
| 6587 | <a id="MapTileSet">MapTileSet</a><sub><br/>Sets the tile type and rotation at the specified XY coordinates.<br/>Tile IDs can be seen by hovering over the tiles on the terrain tiles tab in the map editor.<br/>Returns True if the change succeeded or False if it failed.<br/>The change will fail if it would cause a unit to become stuck or a house/field to be damaged</sub> | <sub>**X, Y**: Integer; <br/> **aType**: Integer; // _Tile type (0..255)_ <br/> **aRotation**: Integer; // _Tile rotation (0..3)_</sub> | <sub>Boolean</sub> |
| 6216 | <a id="MarketSetTrade">MarketSetTrade</a><sub><br/>Sets the trade in the specified market</sub> | <sub>**aMarketID**: Integer; <br/> **aFrom**: Integer; <br/> **aTo**: Integer; <br/> **aAmount**: Integer;</sub> | <sub></sub> |
| 14000 | <a id="MarketSetTradeEx">MarketSetTradeEx</a><sub><br/>Sets the trade in the specified market</sub> | <sub>**aMarketID**: Integer; <br/> **aFrom**: TKMWareType; <br/> **aTo**: TKMWareType; <br/> **aAmount**: Integer;</sub> | <sub></sub> |
| 5333 | <a id="OverlayTextAppend">OverlayTextAppend</a><sub><br/>Appends to text overlaid on top left of screen.<br/>If the player index is -1 it will be appended for all players.</sub> | <sub>**aHand**: ShortInt; <br/> **aText**: AnsiString;</sub> | <sub></sub> |
| 5333 | <a id="OverlayTextAppendFormatted">OverlayTextAppendFormatted</a><sub><br/>Appends to text overlaid on top left of screen with formatted arguments (same as Format function).<br/>If the player index is -1 it will be appended for all players.<br/>Params: Array of arguments</sub> | <sub>**aHand**: ShortInt; <br/> **aText**: AnsiString; <br/> **aParams**: array of const;</sub> | <sub></sub> |
| 5333 | <a id="OverlayTextSet">OverlayTextSet</a><sub><br/>Sets text overlaid on top left of screen.<br/>If the player index is -1 it will be set for all players.</sub> | <sub>**aHand**: ShortInt; <br/> **aText**: AnsiString;</sub> | <sub></sub> |
| 14000 | <a id="OverlayTextSetFont">OverlayTextSetFont</a><sub><br/>Sets text overlay font<br/>Possible values are: fntAntiqua, fntGame, fntGrey, fntMetal, fntMini, fntOutline, fntArial, fntMonospaced<br/>If the player index is -1 it will be set for all players.</sub> | <sub>**aHand**: ShortInt; <br/> **aFont**: TKMFont;</sub> | <sub></sub> |
| 5333 | <a id="OverlayTextSetFormatted">OverlayTextSetFormatted</a><sub><br/>Sets text overlaid on top left of screen with formatted arguments (same as Format function).<br/>If the player index is -1 it will be set for all players.<br/>Params: Array of arguments</sub> | <sub>**aHand**: ShortInt; <br/> **aText**: AnsiString; <br/> **aParams**: array of const;</sub> | <sub></sub> |
| 14000 | <a id="OverlayTextSetWordWrap">OverlayTextSetWordWrap</a><sub><br/>Sets or unsets text overlay word wrap<br/>If the player index is -1 it will be set for all players.</sub> | <sub>**aHand**: ShortInt; <br/> **aWordWrap**: Boolean;</sub> | <sub></sub> |
| 11000 | <a id="Peacetime">Peacetime</a><sub><br/>Sets game peacetime. Peacetime will be set to the value of aPeacetime div 600</sub> | <sub>**aPeacetime**: Cardinal; // _game time in ticks_</sub> | <sub></sub> |
| 5057 | <a id="PlanAddField">PlanAddField</a><sub><br/>Adds a corn field plan.<br/>Returns True if the plan was successfully added or False if it failed (e.g. tile blocked)</sub> | <sub>**aHand**: Integer; <br/> **X, Y**: Integer;</sub> | <sub>Boolean</sub> |
| 5057 | <a id="PlanAddHouse">PlanAddHouse</a><sub><br/>Adds a road plan.<br/>Returns True if the plan was successfully added or False if it failed (e.g. tile blocked)</sub> | <sub>**aHand**: Integer; <br/> **aHouseType**: Integer; <br/> **X, Y**: Integer;</sub> | <sub>Boolean</sub> |
| 14000 | <a id="PlanAddHouseEx">PlanAddHouseEx</a><sub><br/>Adds a road plan.<br/>Returns True if the plan was successfully added or False if it failed (e.g. tile blocked)</sub> | <sub>**aHand**: Integer; <br/> **aHouseType**: TKMHouseType; <br/> **X, Y**: Integer;</sub> | <sub>Boolean</sub> |
| 5057 | <a id="PlanAddRoad">PlanAddRoad</a><sub><br/>Adds a road plan.<br/>Returns True if the plan was successfully added or False if it failed (e.g. tile blocked)</sub> | <sub>**aHand**: Integer; <br/> **X, Y**: Integer;</sub> | <sub>Boolean</sub> |
| 5057 | <a id="PlanAddWinefield">PlanAddWinefield</a><sub><br/>Adds a wine field plan.<br/>Returns True if the plan was successfully added or False if it failed (e.g. tile blocked)</sub> | <sub>**aHand**: Integer; <br/> **X, Y**: Integer;</sub> | <sub>Boolean</sub> |
| 6303 | <a id="PlanConnectRoad">PlanConnectRoad</a><sub><br/>Connects road plans between two points like AI builder and returns True if road plan was successfully added.<br/>If CompletedRoad = True, road will be added instead of plans</sub> | <sub>**aHand**: Integer; <br/> **X1**: Integer; // _Left coordinate_ <br/> **Y1**: Integer; // _Top coordinate_ <br/> **X2**: Integer; // _Right coordinate_ <br/> **Y2**: Integer; // _Bottom coordinate_ <br/> **aCompleted**: Boolean; // _Completed road_</sub> | <sub>Boolean</sub> |
| 5345 | <a id="PlanRemove">PlanRemove</a><sub><br/>Removes house, road or field plans from the specified tile for the specified player<br/>Returns True if the plan was successfully removed or False if it failed (e.g. tile blocked)</sub> | <sub>**aHand**: Integer; <br/> **X, Y**: Integer;</sub> | <sub>Boolean</sub> |
| 5165 | <a id="PlayerAddDefaultGoals">PlayerAddDefaultGoals</a><sub><br/>Add default goals/lost goals for the specified player.<br/>If the parameter buildings is True the goals will be important buildings.<br/>Otherwise it will be troops.</sub> | <sub>**aHand**: Byte; <br/> **aBuildings**: Boolean;</sub> | <sub></sub> |
| 5097 | <a id="PlayerAllianceChange">PlayerAllianceChange</a><sub><br/>Change whether player1 is allied to player2.<br/>If Compliment is True, then it is set both ways (so also whether player2 is allied to player1)</sub> | <sub>**aHand1**: Byte; <br/> **aHand2**: Byte; <br/> **aCompliment**: Boolean; // _Both ways_ <br/> **aAllied**: Boolean;</sub> | <sub></sub> |
| 7000+ | <a id="PlayerAllianceNFogChange">PlayerAllianceNFogChange</a><sub><br/>Change whether player1 is allied to player2.<br/>If Compliment is True, then it is set both ways (so also whether player2 is allied to player1)</sub> | <sub>**aHand1**: Byte; <br/> **aHand2**: Byte; <br/> **aCompliment**: Boolean; // _Both ways_ <br/> **aAllied**: Boolean; <br/> **aSyncAllyFog**: Boolean; // _Synchronize allies fogs of war_</sub> | <sub></sub> |
| 5057 | <a id="PlayerDefeat">PlayerDefeat</a><sub><br/>Proclaims player defeated</sub> | <sub>**aHand**: Integer;</sub> | <sub></sub> |
| 11000 | <a id="PlayerGoalsRemoveAll">PlayerGoalsRemoveAll</a><sub><br/>Remove all player goals</sub> | <sub>**aHand**: Integer; // _PlayerID_ <br/> **aForAllPlayers**: Boolean; // _also remove other player goals, related to this player_</sub> | <sub></sub> |
| 7000+ | <a id="PlayerShareBeacons">PlayerShareBeacons</a><sub><br/>Sets whether player A shares his beacons with player B.<br/>Sharing can still only happen between allied players, but this command lets you disable allies from sharing.</sub> | <sub>**aHand1**: Integer; <br/> **aHand2**: Integer; <br/> **aBothWays**: Boolean; // _share in both ways_ <br/> **aShare**: Boolean;</sub> | <sub></sub> |
| 5345 | <a id="PlayerShareFog">PlayerShareFog</a><sub><br/>Sets whether player A shares his vision with player B (one way, for both ways use PlayerShareFogCompliment).<br/>Sharing can still only happen between allied players, but this command lets you disable allies from sharing.</sub> | <sub>**aHand1**: Integer; <br/> **aHand2**: Integer; <br/> **aShare**: Boolean;</sub> | <sub></sub> |
| 7000+ | <a id="PlayerShareFogCompliment">PlayerShareFogCompliment</a><sub><br/>Sets whether players A and B share their vision (both ways).<br/>Sharing can still only happen between allied players, but this command lets you disable allies from sharing.</sub> | <sub>**aHand1**: Integer; <br/> **aHand2**: Integer; <br/> **aShare**: Boolean;</sub> | <sub></sub> |
| 5345 | <a id="PlayerWareDistribution">PlayerWareDistribution</a><sub><br/>Sets ware distribution for the specified resource, house and player.<br/>Note: distribution should be set after 1st tick of the game,<br/>thus it will not make effect to use it in OnMissionStart event handler</sub> | <sub>**aHand**: Byte; <br/> **aWareType**: Byte; <br/> **aHouseType**: Byte; <br/> **aAmount**: Byte; // _Distribution amount (0..5)_</sub> | <sub></sub> |
| 5057 | <a id="PlayerWin">PlayerWin</a><sub><br/>Set specified player(s) victorious, and all team members of those player(s) if the 2nd parameter TeamVictory is set to True.<br/>All players who were not set to victorious are set to defeated.</sub> | <sub>**aVictors**: array of Integer; // _Array of player IDs_ <br/> **aTeamVictory**: Boolean;</sub> | <sub></sub> |
| 7000+ | <a id="PlayOGG">PlayOGG</a><sub><br/>Plays OGG audio file.<br/>If the player index is -1 the sound will be played to all players.<br/>Mono and stereo OGG files are supported.<br/>OGG file goes in mission folder named: Mission Name.filename.ogg</sub> | <sub>**aHand**: ShortInt; <br/> **aFileName**: AnsiString; <br/> **aVolume**: Single; // _Audio level (0.0 to 1.0)_</sub> | <sub>Integer // SoundIndex of the sound</sub> |
| 7000+ | <a id="PlayOGGAtLocation">PlayOGGAtLocation</a><sub><br/>Plays OGG audio file at a location on the map.<br/>If the player index is -1 the sound will be played to all players.<br/>Radius specifies approximately the distance at which the sound can no longer be heard (normal game sounds use radius 32).<br/>Only mono OGG files are supported.<br/>OGG file goes in mission folder named: Mission Name.filename.ogg.<br/>Will not play if the location is not revealed to the player.<br/>Higher volume range is allowed than PlayOGG as positional sounds are quieter</sub> | <sub>**aHand**: ShortInt; <br/> **aFileName**: AnsiString; <br/> **aVolume**: Single; // _Audio level (0.0 to 4.0)_ <br/> **aRadius**: Single; // _Radius (minimum 28)_ <br/> **aX, aY**: Integer;</sub> | <sub>Integer // SoundIndex of the sound</sub> |
| 7000+ | <a id="PlayOGGAtLocationLooped">PlayOGGAtLocationLooped</a><sub><br/>Plays looped audio file at a location on the map.<br/>If the player index is -1 the sound will be played to all players.<br/>aRadius specifies approximately the distance at which the sound can no longer be heard (normal game sounds use aRadius 32).<br/>Only mono OGG files are supported.<br/>OGG file goes in mission folder named: Mission Name.filename.ogg.<br/>Will not play if the location is not revealed to the player (will start playing automatically when it is revealed).<br/>Higher aVolume range is allowed than PlayOGG as positional sounds are quieter.<br/>The sound will continue to loop if the game is paused and will restart automatically when the game is loaded.</sub> | <sub>**aHand**: ShortInt; <br/> **aFileName**: AnsiString; <br/> **aVolume**: Single; // _Audio level (0.0 to 4.0)_ <br/> **aRadius**: Single; // _aRadius (minimum 28)_ <br/> **aX, aY**: Integer;</sub> | <sub>Integer // SoundIndex of the sound</sub> |
| 7000+ | <a id="PlayOGGFadeMusic">PlayOGGFadeMusic</a><sub><br/>Same as PlayOGG except music will fade then mute while the OGG is playing, then fade back in afterwards.<br/>You should leave a small gap at the start of your OGG file to give the music time to fade</sub> | <sub>**aHand**: ShortInt; <br/> **aFileName**: AnsiString; <br/> **aVolume**: Single; // _Audio level (0.0 to 1.0)_</sub> | <sub>Integer // SoundIndex of the sound</sub> |
| 7000+ | <a id="PlayOGGLooped">PlayOGGLooped</a><sub><br/>Plays looped OGG audio file.<br/>If the player index is -1 the sound will be played to all players.<br/>Mono or stereo OGG files are supported.<br/>OGG file goes in mission folder named: Mission Name.filename.ogg.<br/>The sound will continue to loop if the game is paused and will restart automatically when the game is loaded.</sub> | <sub>**aHand**: ShortInt; <br/> **aFileName**: AnsiString; <br/> **aVolume**: Single; // _Audio level (0.0 to 1.0)_</sub> | <sub>Integer // SoundIndex of the sound</sub> |
| 7000+ | <a id="PlaySound">PlaySound</a><sub><br/>Plays audio file.<br/>If the player index is -1 the sound will be played to all players.<br/>Possible to specify Looped or FadeMusic parameter<br/>Mono and stereo WAV and OGG files are supported.<br/>To specify audio format use afWav or afOgg<br/>WAV file goes in mission folder named: Mission Name.filename.wav.<br/>OGG file goes in mission folder named: Mission Name.filename.ogg<br/>If MusicFaded then sound will fade then mute while the file is playing, then fade back in afterwards.<br/>If looped, the sound will continue to loop if the game is paused and will restart automatically when the game is loaded.</sub> | <sub>**aHand**: ShortInt; <br/> **aFileName**: AnsiString; <br/> **aAudioFormat**: TKMAudioFormat; // _afWav or afOgg_ <br/> **aVolume**: Single; // _Audio level (0.0 to 1.0)_ <br/> **aFadeMusic**: Boolean; <br/> **aLooped**: Boolean;</sub> | <sub>Integer // SoundIndex of the sound</sub> |
| 7000+ | <a id="PlaySoundAtLocation">PlaySoundAtLocation</a><sub><br/>Plays audio file at a location on the map.<br/>If the player index is -1 the sound will be played to all players.<br/>Possible to specify Looped or FadeMusic parameter<br/>aRadius specifies approximately the distance at which the sound can no longer be heard (normal game sounds use aRadius 32).<br/>Only mono WAV or OGG files are supported.<br/>To specify audio format use afWav or afOgg<br/>WAV file goes in mission folder named: Mission Name.filename.wav.<br/>OGG file goes in mission folder named: Mission Name.filename.ogg.<br/>Will not play if the location is not revealed to the player (will start playing automatically when it is revealed).<br/>Higher aVolume range is allowed than PlaySound as positional sounds are quieter.<br/>If looped, the sound will continue to loop if the game is paused and will restart automatically when the game is loaded.</sub> | <sub>**aHand**: ShortInt; <br/> **aFileName**: AnsiString; <br/> **aAudioFormat**: TKMAudioFormat; // _afWav or afOgg_ <br/> **aVolume**: Single; // _Audio level (0.0 to 4.0)_ <br/> **aFadeMusic**: Boolean; <br/> **aLooped**: Boolean; <br/> **aRadius**: Single; // _aRadius (minimum 28)_ <br/> **aX, aY**: Integer;</sub> | <sub>Integer // SoundIndex of the sound</sub> |
| 5309 | <a id="PlayWAV">PlayWAV</a><sub><br/>Plays WAV audio file.<br/>If the player index is -1 the sound will be played to all players.<br/>Mono and stereo WAV files are supported.<br/>WAV file goes in mission folder named: Mission Name.filename.wav</sub> | <sub>**aHand**: ShortInt; <br/> **aFileName**: AnsiString; <br/> **aVolume**: Single; // _Audio level (0.0 to 1.0)_</sub> | <sub>Integer // SoundIndex of the sound</sub> |
| 5309 | <a id="PlayWAVAtLocation">PlayWAVAtLocation</a><sub><br/>Plays WAV audio file at a location on the map.<br/>If the player index is -1 the sound will be played to all players.<br/>Radius specifies approximately the distance at which the sound can no longer be heard (normal game sounds use radius 32).<br/>Only mono WAV files are supported.<br/>WAV file goes in mission folder named: Mission Name.filename.wav.<br/>Will not play if the location is not revealed to the player.<br/>Higher volume range is allowed than PlayWAV as positional sounds are quieter</sub> | <sub>**aHand**: ShortInt; <br/> **aFileName**: AnsiString; <br/> **aVolume**: Single; // _Audio level (0.0 to 4.0)_ <br/> **aRadius**: Single; // _Radius (minimum 28)_ <br/> **aX, aY**: Integer;</sub> | <sub>Integer // SoundIndex of the sound</sub> |
| 6222 | <a id="PlayWAVAtLocationLooped">PlayWAVAtLocationLooped</a><sub><br/>Plays looped WAV audio file at a location on the map.<br/>If the player index is -1 the sound will be played to all players.<br/>aRadius specifies approximately the distance at which the sound can no longer be heard (normal game sounds use aRadius 32).<br/>Only mono WAV files are supported.<br/>WAV file goes in mission folder named: Mission Name.filename.wav.<br/>Will not play if the location is not revealed to the player (will start playing automatically when it is revealed).<br/>Higher aVolume range is allowed than PlayWAV as positional sounds are quieter.<br/>The sound will continue to loop if the game is paused and will restart automatically when the game is loaded.</sub> | <sub>**aHand**: ShortInt; <br/> **aFileName**: AnsiString; <br/> **aVolume**: Single; // _Audio level (0.0 to 4.0)_ <br/> **aRadius**: Single; // _aRadius (minimum 28)_ <br/> **aX, aY**: Integer;</sub> | <sub>Integer // SoundIndex of the sound</sub> |
| 6220 | <a id="PlayWAVFadeMusic">PlayWAVFadeMusic</a><sub><br/>Same as PlayWAV except music will fade then mute while the WAV is playing, then fade back in afterwards.<br/>You should leave a small gap at the start of your WAV file to give the music time to fade</sub> | <sub>**aHand**: ShortInt; <br/> **aFileName**: AnsiString; <br/> **aVolume**: Single; // _Audio level (0.0 to 1.0)_</sub> | <sub>Integer // SoundIndex of the sound</sub> |
| 6222 | <a id="PlayWAVLooped">PlayWAVLooped</a><sub><br/>Plays looped audio file.<br/>If the player index is -1 the sound will be played to all players.<br/>Mono or stereo WAV files are supported.<br/>WAV file goes in mission folder named: Mission Name.filename.wav.<br/>The sound will continue to loop if the game is paused and will restart automatically when the game is loaded.</sub> | <sub>**aHand**: ShortInt; <br/> **aFileName**: AnsiString; <br/> **aVolume**: Single; // _Audio level (0.0 to 1.0)_</sub> | <sub>Integer // SoundIndex of the sound</sub> |
| 5927 | <a id="RemoveRoad">RemoveRoad</a><sub><br/>Removes road</sub> | <sub>**X, Y**: Integer;</sub> | <sub></sub> |
| 5057 | <a id="SetTradeAllowed">SetTradeAllowed</a><sub><br/>Sets whether the player is allowed to trade the specified resource.</sub> | <sub>**aHand**: Integer; <br/> **aResType**: Integer; <br/> **aAllowed**: Boolean;</sub> | <sub></sub> |
| 5057 | <a id="ShowMsg">ShowMsg</a><sub><br/>Displays a message to a player.<br/>If the player index is -1 the message will be shown to all players.</sub> | <sub>**aHand**: ShortInt; <br/> **aText**: AnsiString;</sub> | <sub></sub> |
| 5333 | <a id="ShowMsgFormatted">ShowMsgFormatted</a><sub><br/>Displays a message to a player with formatted arguments (same as Format function).<br/>If the player index is -1 the message will be shown to all players.</sub> | <sub>**aHand**: ShortInt; <br/> **aText**: AnsiString; <br/> **Params**: array of const; // _Array of arguments_</sub> | <sub></sub> |
| 5345 | <a id="ShowMsgGoto">ShowMsgGoto</a><sub><br/>Displays a message to a player with a goto button that takes the player to the specified location.<br/>If the player index is -1 the message will be shown to all players.</sub> | <sub>**aHand**: ShortInt; <br/> **aX, aY**: Integer; <br/> **aText**: AnsiString;</sub> | <sub></sub> |
| 5345 | <a id="ShowMsgGotoFormatted">ShowMsgGotoFormatted</a><sub><br/>Displays a message to a player with formatted arguments (same as Format function)<br/>and a goto button that takes the player to the specified location.<br/>If the player index is -1 the message will be shown to all players.</sub> | <sub>**aHand**: ShortInt; <br/> **aX, aY**: Integer; <br/> **aText**: AnsiString; <br/> **Params**: array of const; // _Array of arguments_</sub> | <sub></sub> |
| 7000+ | <a id="StopLoopedOGG">StopLoopedOGG</a><sub><br/>Stops playing a looped sound that was previously started with either Actions.PlayOGGLooped or Actions.PlayOGGAtLocationLooped.</sub> | <sub>**aSoundIndex**: Integer; // _value that was returned by either of those functions when the looped sound was started._</sub> | <sub></sub> |
| 6222 | <a id="StopLoopedWAV">StopLoopedWAV</a><sub><br/>Stops playing a looped sound that was previously started with either Actions.PlayWAVLooped or Actions.PlayWAVAtLocationLooped.</sub> | <sub>**aSoundIndex**: Integer; // _value that was returned by either of those functions when the looped sound was started._</sub> | <sub></sub> |
| 7000+ | <a id="StopSound">StopSound</a><sub><br/>Stops playing any sound that was previously started by any of PlayWAV***, PlayOGG*** or PlaySound*** functions</sub> | <sub>**aSoundIndex**: Integer; // _value that was returned by either of those functions when the sound was started._</sub> | <sub></sub> |
| 12600 | <a id="UnitAllowAllyToSelect">UnitAllowAllyToSelect</a><sub><br/>Allows allies to select and view specified unit<br/>For warriors: allow to select their group</sub> | <sub>**aUnitID**: Integer; <br/> **aAllow**: Boolean;</sub> | <sub></sub> |
| 5993 | <a id="UnitBlock">UnitBlock</a><sub><br/>Sets whether the specified player can train/equip the specified unit type</sub> | <sub>**aHand**: Byte; <br/> **aType**: Integer; <br/> **aBlock**: Boolean;</sub> | <sub></sub> |
| 5057 | <a id="UnitDirectionSet">UnitDirectionSet</a><sub><br/>Makes the specified unit face a certain direction.<br/>Note: Only works on idle units so as not to interfere with game logic and cause crashes.<br/>Returns True on success or False on failure.</sub> | <sub>**aUnitID**: Integer; <br/> **aDirection**: Integer;</sub> | <sub>Boolean</sub> |
| 14000 | <a id="UnitDirectionSetEx">UnitDirectionSetEx</a><sub><br/>Makes the specified unit face a certain direction.<br/>Note: Only works on idle units so as not to interfere with game logic and cause crashes.<br/>Returns True on success or False on failure.</sub> | <sub>**aUnitID**: Integer; <br/> **aDirection**: TKMDirection;</sub> | <sub>Boolean</sub> |
| 7000+ | <a id="UnitDismiss">UnitDismiss</a><sub><br/>Dismiss the specified unit</sub> | <sub>**aUnitID**: Integer;</sub> | <sub></sub> |
| 7000+ | <a id="UnitDismissableSet">UnitDismissableSet</a><sub><br/>Makes the specified unit 'dismiss' command available</sub> | <sub>**aUnitID**: Integer; <br/> **aDismissable**: Boolean;</sub> | <sub></sub> |
| 7000+ | <a id="UnitDismissCancel">UnitDismissCancel</a><sub><br/>Cancel dismiss task for the specified unit</sub> | <sub>**aUnitID**: Integer;</sub> | <sub></sub> |
| 7000+ | <a id="UnitHPChange">UnitHPChange</a><sub><br/>Heals/Wounds specified unit for aHP HP</sub> | <sub>**aUnitID**: Integer; <br/> **aHP**: Integer;</sub> | <sub></sub> |
| 7000+ | <a id="UnitHPSetInvulnerable">UnitHPSetInvulnerable</a><sub><br/>Makes the unit invulnerable. Such unit can not be killed or die from hunger.</sub> | <sub>**aUnitID**: Integer; <br/> **aInvulnerable**: Boolean;</sub> | <sub></sub> |
| 5057 | <a id="UnitHungerSet">UnitHungerSet</a><sub><br/>Sets the hunger level of the specified unit in ticks until death</sub> | <sub>**aUnitID**: Integer; <br/> **aHungerLevel**: Integer; // _Hunger level (ticks until death)_</sub> | <sub></sub> |
| 5099 | <a id="UnitKill">UnitKill</a><sub><br/>Kills the specified unit.<br/>Silent means the death animation (ghost) and sound won't play</sub> | <sub>**aUnitID**: Integer; <br/> **aSilent**: Boolean;</sub> | <sub></sub> |
| 5057 | <a id="UnitOrderWalk">UnitOrderWalk</a><sub><br/>Order the specified unit to walk somewhere.<br/>Note: Only works on idle units so as not to interfere with game logic and cause crashes.<br/>Returns True on success or False on failure.</sub> | <sub>**aUnitID**: Integer; <br/> **X, Y**: Integer;</sub> | <sub>Boolean</sub> |
