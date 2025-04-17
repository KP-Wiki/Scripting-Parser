### States

States are queried in a form `States.STATE_NAME(STATE_PARAMETERS)` like so:
```pascal
    if States.StatPlayerCount > 5 then
      unitCnt := States.StatUnitCount(1);
```

Version column description:  
<sub>"-" Means this state was added from the start.</sub>  
<sub>"5678" Means this state was introduced in revision 5678.</sub>  
<sub>"-5678" Means this state was removed in revision 5678.</sub>


***

* <a href="#CampaignMissionCount">CampaignMissionCount</a>
* <a href="#CampaignMissionWon">CampaignMissionWon</a>
* <a href="#EntityType">EntityType</a>
* <a href="#FogRevealed">&#x274C; FogRevealed</a>
* <a href="#GamePeaceTime">GamePeaceTime</a>
* <a href="#GroupAt">GroupAt</a>
* <a href="#GroupBannerDisplay">GroupBannerDisplay</a>
* <a href="#GroupCanTakeOrders">GroupCanTakeOrders</a>
* <a href="#GroupColumnCount">GroupColumnCount</a>
* <a href="#GroupDead">GroupDead</a>
* <a href="#GroupIsIdle">GroupIsIdle</a>
* <a href="#GroupMember">GroupMember</a>
* <a href="#GroupMemberCount">GroupMemberCount</a>
* <a href="#GroupOwner">GroupOwner</a>
* <a href="#GroupType">GroupType</a>
* <a href="#GroupTypeName">GroupTypeName</a>
* <a href="#HouseAt">HouseAt</a>
* <a href="#HouseDamage">HouseDamage</a>
* <a href="#HouseDeliveryBlocked">&#x274C; HouseDeliveryBlocked</a>
* <a href="#HouseDestroyed">HouseDestroyed</a>
* <a href="#HouseHasOccupant">&#x274C; HouseHasOccupant</a>
* <a href="#HouseHasWorker">HouseHasWorker</a>
* <a href="#HouseIsComplete">HouseIsComplete</a>
* <a href="#HouseOwner">HouseOwner</a>
* <a href="#HousePosition">HousePosition</a>
* <a href="#HousePositionDoorstep">HousePositionDoorstep</a>
* <a href="#HousePositionX">HousePositionX</a>
* <a href="#HousePositionY">HousePositionY</a>
* <a href="#HouseRepair">HouseRepair</a>
* <a href="#HouseSheepyardHasPasture">HouseSheepyardHasPasture</a>
* <a href="#HouseTrainQueuePeek">HouseTrainQueuePeek</a>
* <a href="#HouseType">HouseType</a>
* <a href="#HouseTypeName">HouseTypeName</a>
* <a href="#HouseWareBlock">HouseWareBlock</a>
* <a href="#HouseWareInside">HouseWareInside</a>
* <a href="#HouseWareInType">HouseWareInType</a>
* <a href="#HouseWareInTypeCount">HouseWareInTypeCount</a>
* <a href="#HouseWareOutType">HouseWareOutType</a>
* <a href="#HouseWareOutTypeCount">HouseWareOutTypeCount</a>
* <a href="#HouseWaresBlock">HouseWaresBlock</a>
* <a href="#HouseWeaponsOrdered">HouseWeaponsOrdered</a>
* <a href="#HouseWoodcutterChopOnly">&#x274C; HouseWoodcutterChopOnly</a>
* <a href="#HouseWoodcutterMode">HouseWoodcutterMode</a>
* <a href="#IsFieldAt">IsFieldAt</a>
* <a href="#IsOrchardAt">IsOrchardAt</a>
* <a href="#IsRoadAt">IsRoadAt</a>
* <a href="#PlayerAIDispositionCount">PlayerAIDispositionCount</a>
* <a href="#PlayerAIDispositionGet">PlayerAIDispositionGet</a>
* <a href="#PlayerAIDispositionGroup">PlayerAIDispositionGroup</a>
* <a href="#PlayerAIDispositionUIDGet">PlayerAIDispositionUIDGet</a>
* <a href="#PlayerAIDispositionUIDGroup">PlayerAIDispositionUIDGroup</a>
* <a href="#PlayerAllianceCheck">PlayerAllianceCheck</a>
* <a href="#PlayerColorText">PlayerColorText</a>
* <a href="#PlayerDefeated">PlayerDefeated</a>
* <a href="#PlayerEnabled">PlayerEnabled</a>
* <a href="#PlayerFogRevealed">PlayerFogRevealed</a>
* <a href="#PlayerGetAllGroups">PlayerGetAllGroups</a>
* <a href="#PlayerGetAllGroupsFilter">PlayerGetAllGroupsFilter</a>
* <a href="#PlayerGetAllHouses">PlayerGetAllHouses</a>
* <a href="#PlayerGetAllObjectives">PlayerGetAllObjectives</a>
* <a href="#PlayerGetAllRoads">PlayerGetAllRoads</a>
* <a href="#PlayerGetAllUnits">PlayerGetAllUnits</a>
* <a href="#PlayerGetAllUnitsFilter">PlayerGetAllUnitsFilter</a>
* <a href="#PlayerGetHouses">PlayerGetHouses</a>
* <a href="#PlayerHouseBlocked">PlayerHouseBlocked</a>
* <a href="#PlayerHouseCanBuild">PlayerHouseCanBuild</a>
* <a href="#PlayerHouseGranted">PlayerHouseGranted</a>
* <a href="#PlayerIsNeutral">PlayerIsNeutral</a>
* <a href="#PlayerName">PlayerName</a>
* <a href="#PlayerObjectiveStatus">PlayerObjectiveStatus</a>
* <a href="#PlayerObjectiveType">PlayerObjectiveType</a>
* <a href="#PlayerVictorious">PlayerVictorious</a>
* <a href="#PlayerWareDistribution">PlayerWareDistribution</a>
* <a href="#StatArmyCount">StatArmyCount</a>
* <a href="#StatCitizenCount">StatCitizenCount</a>
* <a href="#StatHouseTypeCount">StatHouseTypeCount</a>
* <a href="#StatPlayerCount">StatPlayerCount</a>
* <a href="#StatUnitCount">StatUnitCount</a>
* <a href="#StatUnitKilledCount">StatUnitKilledCount</a>
* <a href="#StatUnitLostCount">StatUnitLostCount</a>
* <a href="#StatUnitTypeCount">StatUnitTypeCount</a>
* <a href="#StatWaresBalance">StatWaresBalance</a>
* <a href="#StatWaresProduced">StatWaresProduced</a>
* <a href="#StatWaresProducedValue">StatWaresProducedValue</a>
* <a href="#SysRandom">&#x274C; SysRandom</a>
* <a href="#SysRandomI">&#x274C; SysRandomI</a>
* <a href="#TerrainObjectState">TerrainObjectState</a>
* <a href="#UnitAt">UnitAt</a>
* <a href="#UnitCarryCount">UnitCarryCount</a>
* <a href="#UnitCarryType">UnitCarryType</a>
* <a href="#UnitDamageMax">UnitDamageMax</a>
* <a href="#UnitDamageMin">UnitDamageMin</a>
* <a href="#UnitDead">UnitDead</a>
* <a href="#UnitDirection">UnitDirection</a>
* <a href="#UnitGroup">UnitGroup</a>
* <a href="#UnitHitpoints">UnitHitpoints</a>
* <a href="#UnitHitpointsMax">UnitHitpointsMax</a>
* <a href="#UnitHunger">UnitHunger</a>
* <a href="#UnitHungerLow">UnitHungerLow</a>
* <a href="#UnitHungerMax">UnitHungerMax</a>
* <a href="#UnitInHouse">UnitInHouse</a>
* <a href="#UnitOwner">UnitOwner</a>
* <a href="#UnitPositionX">UnitPositionX</a>
* <a href="#UnitPositionY">UnitPositionY</a>
* <a href="#UnitsAt">UnitsAt</a>
* <a href="#UnitType">UnitType</a>
* <a href="#UnitTypeName">UnitTypeName</a>
* <a href="#WareTypeName">WareTypeName</a>
<br />

| Ver<br/>sion | State description | Parameters<br/>and types | Returns |
| ------- | ------------------------------------ | -------------- | ------- |
| 8721 | <a id="CampaignMissionCount">CampaignMissionCount</a><sub><br/>Get total number of missions in the current campaign. Campaign-only action!</sub> | <sub></sub> | <sub>Integer</sub> |
| 8723 | <a id="CampaignMissionWon">CampaignMissionWon</a><sub><br/>See if the mission was won. Campaign-only action!</sub> | <sub>**aMission**: Integer; // _mission index to check_</sub> | <sub>Boolean</sub> |
| 7969 | <a id="EntityType">EntityType</a><sub><br/>Get the entity type by its UID (0 - unknown or none, 1 - Unit, 2 - House, 3 - UnitGroup, 4 - Stockpile)</sub> | <sub>**aEntityID**: Integer;</sub> | <sub>Integer</sub> |
| -8743 | <a id="FogRevealed">FogRevealed</a><br/>&#x274C;`Removed`<br/><sub>*Method was removed, use <a href="#PlayerFogRevealed">PlayerFogRevealed</a> instead*</sub><sub></sub> | <sub>**aPlayer**: Integer; <br/> **aX, aY**: Word;</sub> | <sub>Boolean</sub> |
| - | <a id="GamePeaceTime">GamePeaceTime</a><sub><br/>Get the peacetime duration (in game ticks)</sub> | <sub></sub> | <sub>Cardinal</sub> |
| - | <a id="GroupAt">GroupAt</a><sub><br/>Return UID of a group at requested coordinates</sub> | <sub>**aX, aY**: Word;</sub> | <sub>Integer</sub> |
| 14898 | <a id="GroupBannerDisplay">GroupBannerDisplay</a><sub><br/>Returns state of the groups banner display. False if the group is already dead</sub> | <sub>**aGroupID**: Integer;</sub> | <sub>Boolean</sub> |
| 15640 | <a id="GroupCanTakeOrders">GroupCanTakeOrders</a><sub><br/>See if the group can take orders (i.e. not in a fight)</sub> | <sub>**aGroupID**: Integer;</sub> | <sub>Boolean</sub> |
| - | <a id="GroupColumnCount">GroupColumnCount</a><sub><br/>Returns 0 if group does not exist</sub> | <sub>**aGroupID**: Integer;</sub> | <sub>Integer</sub> |
| - | <a id="GroupDead">GroupDead</a><sub><br/>See if the group is dead (all members are dead)</sub> | <sub>**aGroupID**: Integer;</sub> | <sub>Boolean</sub> |
| 5632 | <a id="GroupIsIdle">GroupIsIdle</a><sub><br/>See if the group has no active orders</sub> | <sub>**aGroupID**: Integer;</sub> | <sub>Boolean</sub> |
| - | <a id="GroupMember">GroupMember</a><sub><br/>Get N-th group member</sub> | <sub>**aGroupID**: Integer; <br/> **aMemberIndex**: Integer;</sub> | <sub>Integer</sub> |
| - | <a id="GroupMemberCount">GroupMemberCount</a><sub><br/>Returns how many member there are in this group</sub> | <sub>**aGroupID**: Integer;</sub> | <sub>Integer</sub> |
| - | <a id="GroupOwner">GroupOwner</a><sub><br/>Returns to which Hand this group belongs</sub> | <sub>**aGroupID**: Integer;</sub> | <sub>Integer</sub> |
| 14509 | <a id="GroupType">GroupType</a><sub><br/>Returns group type</sub> | <sub>**aGroupID**: Integer;</sub> | <sub>TKMGroupType</sub> |
| 15658 | <a id="GroupTypeName">GroupTypeName</a><sub><br/>Returns group type name as used in the game engine<br/>Intended to be used for debug purposes</sub> | <sub>**aGroupType**: TKMGroupType;</sub> | <sub>string</sub> |
| - | <a id="HouseAt">HouseAt</a><sub><br/>Get the house at coordinates</sub> | <sub>**aX, aY**: Word;</sub> | <sub>Integer</sub> |
| - | <a id="HouseDamage">HouseDamage</a><sub><br/>Check house damage<br/>-1 if house does not exist</sub> | <sub>**aHouseID**: Integer;</sub> | <sub>Integer</sub> |
| -7015 | <a id="HouseDeliveryBlocked">HouseDeliveryBlocked</a><br/>&#x274C;`Removed`<br/><sub>*Method was removed, use <a href="#HouseWareBlock">HouseWareBlock</a> instead*</sub><sub></sub> | <sub>**aHouseID**: Integer; <br/> **aWareType**: TKMWareType;</sub> | <sub>Boolean</sub> |
| - | <a id="HouseDestroyed">HouseDestroyed</a><sub></sub> | <sub>**aHouseID**: Integer;</sub> | <sub>Boolean</sub> |
| -6102 | <a id="HouseHasOccupant">HouseHasOccupant</a><br/>&#x274C;`Removed`<br/><sub>*Method was removed, use <a href="#HouseHasWorker">HouseHasWorker</a> instead*</sub><sub></sub> | <sub>**aHouseID**: Integer;</sub> | <sub></sub> |
| 6102 | <a id="HouseHasWorker">HouseHasWorker</a><sub><br/>Check if the house has a worker assigned to it</sub> | <sub>**aHouseID**: Integer;</sub> | <sub>Boolean</sub> |
| - | <a id="HouseIsComplete">HouseIsComplete</a><sub><br/>Check if house is complete</sub> | <sub>**aHouseID**: Integer;</sub> | <sub>Boolean</sub> |
| - | <a id="HouseOwner">HouseOwner</a><sub><br/>See to which player the house belongs</sub> | <sub>**aHouseID**: Integer;</sub> | <sub>Integer</sub> |
| 15016 | <a id="HousePosition">HousePosition</a><sub><br/>Returns location of the house <br/>X:-1, Y:-1 if house does not exist</sub> | <sub>**aHouseID**: Integer;</sub> | <sub>TKMPoint</sub> |
| 15016 | <a id="HousePositionDoorstep">HousePositionDoorstep</a><sub><br/>Returns location of the tile in front of the house main entrance, taking house facing direction into account<br/>X:-1, Y:-1 if house does not exist</sub> | <sub>**aHouseID**: Integer;</sub> | <sub>TKMPoint</sub> |
| - | <a id="HousePositionX">HousePositionX</a><sub><br/>-1 if house does not exist</sub> | <sub>**aHouseID**: Integer;</sub> | <sub>Integer</sub> |
| - | <a id="HousePositionY">HousePositionY</a><sub><br/>-1 if house does not exist</sub> | <sub>**aHouseID**: Integer;</sub> | <sub>Integer</sub> |
| - | <a id="HouseRepair">HouseRepair</a><sub><br/>Check if house repair is enabled</sub> | <sub>**aHouseID**: Integer;</sub> | <sub>Boolean</sub> |
| 13134 | <a id="HouseSheepyardHasPasture">HouseSheepyardHasPasture</a><sub><br/>Check if the sheepyard has a pasture built (fenced area by the back door)</sub> | <sub>**aHouseID**: Integer;</sub> | <sub>Boolean</sub> |
| 4820 | <a id="HouseTrainQueuePeek">HouseTrainQueuePeek</a><sub><br/>Get the unit type in the houses training queue (School/Fort/Barracks)</sub> | <sub>**aHouseID**: Integer; <br/> **QueueIndex**: Integer;</sub> | <sub>TKMUnitType</sub> |
| - | <a id="HouseType">HouseType</a><sub><br/>Get the house type</sub> | <sub>**aHouseID**: Integer;</sub> | <sub>TKMHouseType</sub> |
| 15658 | <a id="HouseTypeName">HouseTypeName</a><sub><br/>Returns house type name as used in the game engine<br/>Intended to be used for debug purposes</sub> | <sub>**aHouseType**: TKMHouseType;</sub> | <sub>string</sub> |
| 7021 | <a id="HouseWareBlock">HouseWareBlock</a><sub><br/>Lookup spacious house ware delivery policy. Works only for spacious houses (Camp, Fort, Store, Barracks)</sub> | <sub>**aHouseID**: Integer; <br/> **aWareType**: TKMWareType;</sub> | <sub>Integer // 0 - allow, 1 - block, 2 - evacuate</sub> |
| - | <a id="HouseWareInside">HouseWareInside</a><sub><br/>See the total amount of wares (input and output) in a house<br/>-1 if house does not exist or ware can not be in that house</sub> | <sub>**aHouseID**: Integer; <br/> **aWareType**: TKMWareType;</sub> | <sub>Integer</sub> |
| 15065 | <a id="HouseWareInType">HouseWareInType</a><sub><br/>Get the ware type in the house input<br/>For spacious houses ware types are listed both for input and output<br/>Returns wtNone in case of an error</sub> | <sub>**aHouseType**: TKMHouseType; <br/> **aIndex**: Integer;</sub> | <sub>TKMWareType</sub> |
| 15065 | <a id="HouseWareInTypeCount">HouseWareInTypeCount</a><sub><br/>Get the number of ware types in the house input<br/>For spacious houses ware types are listed both for input and output<br/>Returns -1 in case of an error</sub> | <sub>**aHouseType**: TKMHouseType;</sub> | <sub>Integer</sub> |
| 15065 | <a id="HouseWareOutType">HouseWareOutType</a><sub><br/>Get the ware type in the house output<br/>For spacious houses ware types are listed both for input and output<br/>Returns wtNone in case of an error</sub> | <sub>**aHouseType**: TKMHouseType; <br/> **aIndex**: Integer;</sub> | <sub>TKMWareType</sub> |
| 15065 | <a id="HouseWareOutTypeCount">HouseWareOutTypeCount</a><sub><br/>Get the number of ware types in the house output<br/>For spacious houses ware types are listed both for input and output<br/>Returns -1 in case of an error</sub> | <sub>**aHouseType**: TKMHouseType;</sub> | <sub>Integer</sub> |
| 10399 | <a id="HouseWaresBlock">HouseWaresBlock</a><sub><br/>Lookup common ware delivery policy. Works only for common houses</sub> | <sub>**aHouseID**: Integer;</sub> | <sub>Integer // 0 - allow, 1 - block</sub> |
| - | <a id="HouseWeaponsOrdered">HouseWeaponsOrdered</a><sub><br/>Get the amount of weapons ordered in the house</sub> | <sub>**aHouseID**: Integer; <br/> **aWareType**: TKMWareType;</sub> | <sub>Integer</sub> |
| -15056 | <a id="HouseWoodcutterChopOnly">HouseWoodcutterChopOnly</a><br/>&#x274C;`Removed`<br/><sub>*Method was removed, use <a href="#HouseWoodcutterMode">HouseWoodcutterMode</a> instead*</sub><sub></sub> | <sub>**aHouseID**: Integer;</sub> | <sub>Boolean</sub> |
| 15057 | <a id="HouseWoodcutterMode">HouseWoodcutterMode</a><sub><br/>Modes are: -1 for error, 0 - cut and plant, 1 - chop only, 2 - plant only</sub> | <sub>**aHouseID**: Integer;</sub> | <sub>Integer</sub> |
| - | <a id="IsFieldAt">IsFieldAt</a><sub><br/>Check if there is a field owned by player at coordinates</sub> | <sub>**aPlayer**: Integer; // _player to whom field must belong. -1 stands for any player_ <br/> **aX, aY**: Word;</sub> | <sub>Boolean</sub> |
| - | <a id="IsOrchardAt">IsOrchardAt</a><sub><br/>Check if there is a orchard owned by player at coordinates</sub> | <sub>**aPlayer**: Integer; // _player to whom orchard must belong. -1 stands for any player_ <br/> **aX, aY**: Word;</sub> | <sub>Boolean</sub> |
| - | <a id="IsRoadAt">IsRoadAt</a><sub><br/>Check if there is a road owned by player at coordinates</sub> | <sub>**aPlayer**: Integer; // _player to whom road must belong. -1 stands for any player_ <br/> **aX, aY**: Word;</sub> | <sub>Boolean</sub> |
| 14370 | <a id="PlayerAIDispositionCount">PlayerAIDispositionCount</a><sub><br/>Return how many dispositions AI has<br/>-1 if the player does not exist or is not AI</sub> | <sub>**aPlayer**: Integer;</sub> | <sub>Integer</sub> |
| 15082 | <a id="PlayerAIDispositionGet">PlayerAIDispositionGet</a><sub><br/>Returns disposition details<br/>All returned values will be zero if the player does not exist or is not AI, or Index is wrong</sub> | <sub>**aPlayer**: Integer; <br/> **aIndex**: Integer; <br/> **out aUID**: Integer; <br/> **out aX, aY**: Integer; <br/> **out aDir**: Integer; <br/> **out aGroupType**: TKMGroupType; <br/> **out aNumUnits**: Integer; <br/> **out aUnitsPerRow**: Integer; <br/> **out aGuardRadius**: Integer;</sub> | <sub></sub> |
| 14405 | <a id="PlayerAIDispositionGroup">PlayerAIDispositionGroup</a><sub><br/>Returns group currently assigned to the disposition<br/>Returns zero if the player does not exist or is not AI, or Index is wrong</sub> | <sub>**aPlayer**: Integer; <br/> **aIndex**: Integer;</sub> | <sub>Integer</sub> |
| 15082 | <a id="PlayerAIDispositionUIDGet">PlayerAIDispositionUIDGet</a><sub><br/>Returns disposition details<br/>All returned values will be zero if the player does not exist or is not AI, or aDispositionUID is unknown</sub> | <sub>**aPlayer**: Integer; <br/> **aDispositionUID**: Integer; <br/> **out aX, aY**: Integer; <br/> **out aDir**: Integer; <br/> **out aGroupType**: TKMGroupType; <br/> **out aNumUnits**: Integer; <br/> **out aUnitsPerRow**: Integer; <br/> **out aGuardRadius**: Integer;</sub> | <sub></sub> |
| 15082 | <a id="PlayerAIDispositionUIDGroup">PlayerAIDispositionUIDGroup</a><sub><br/>Returns group currently assigned to the disposition<br/>Returns zero if the player does not exist or is not AI, or aDispositionUID is unknown</sub> | <sub>**aPlayer**: Integer; <br/> **aDispositionUID**: Integer;</sub> | <sub>Integer</sub> |
| - | <a id="PlayerAllianceCheck">PlayerAllianceCheck</a><sub><br/>Checking alliances with Neutral will always return True (despite some animals being agressive)</sub> | <sub>**aPlayer1**: Integer; <br/> **aPlayer2**: Integer;</sub> | <sub>Boolean</sub> |
| - | <a id="PlayerColorText">PlayerColorText</a><sub><br/>Get the string with color code of the player (adjusted brighter for text display)</sub> | <sub>**aPlayer**: Integer;</sub> | <sub>string</sub> |
| - | <a id="PlayerDefeated">PlayerDefeated</a><sub></sub> | <sub>**aPlayer**: Integer;</sub> | <sub>Boolean</sub> |
| - | <a id="PlayerEnabled">PlayerEnabled</a><sub><br/>Check if hand is enabled (chosen to be played by anyone on mission start)<br/>Will return false for any non-existent hands too</sub> | <sub>**aPlayer**: Integer;</sub> | <sub>Boolean</sub> |
| 8743 | <a id="PlayerFogRevealed">PlayerFogRevealed</a><sub><br/>See if tile is revealed to the player (known or live)</sub> | <sub>**aPlayer**: Integer; <br/> **aX, aY**: Integer;</sub> | <sub>Boolean</sub> |
| - | <a id="PlayerGetAllGroups">PlayerGetAllGroups</a><sub><br/>Get list of all players groups</sub> | <sub>**aPlayer**: Integer;</sub> | <sub>TKMIntegerArray</sub> |
| 14495 | <a id="PlayerGetAllGroupsFilter">PlayerGetAllGroupsFilter</a><sub><br/>Get list of all players groups</sub> | <sub>**aPlayer**: Integer; <br/> **aGroupType**: TKMGroupTypeSet;</sub> | <sub>TKMIntegerArray</sub> |
| - | <a id="PlayerGetAllHouses">PlayerGetAllHouses</a><sub><br/>Return all players houses that are not destroyed</sub> | <sub>**aPlayer**: Integer;</sub> | <sub>TKMIntegerArray</sub> |
| 14892 | <a id="PlayerGetAllObjectives">PlayerGetAllObjectives</a><sub><br/>Return all players objectives</sub> | <sub>**aPlayer**: Integer;</sub> | <sub>TKMIntegerArray</sub> |
| - | <a id="PlayerGetAllRoads">PlayerGetAllRoads</a><sub><br/>Get list of all players roads</sub> | <sub>**aPlayer**: Integer; // _player to whom roads must belong. 0..N-1_</sub> | <sub>TKMPointArray</sub> |
| - | <a id="PlayerGetAllUnits">PlayerGetAllUnits</a><sub><br/>Return all players units that are not dead and not in training</sub> | <sub>**aPlayer**: Integer;</sub> | <sub>TKMIntegerArray</sub> |
| 14495 | <a id="PlayerGetAllUnitsFilter">PlayerGetAllUnitsFilter</a><sub><br/>Return all players units that are not dead and not in training</sub> | <sub>**aPlayer**: Integer; <br/> **aUnitTypes**: TKMUnitTypeSet;</sub> | <sub>TKMIntegerArray</sub> |
| 12942 | <a id="PlayerGetHouses">PlayerGetHouses</a><sub><br/>Return all players houses of certain type that are not destroyed</sub> | <sub>**aPlayer**: Integer; <br/> **aHouseType**: TKMHouseType; // _house type to return. htAny for all houses_ <br/> **aOnlyCompleted**: Boolean; // _return only completed houses_</sub> | <sub>TKMIntegerArray</sub> |
| 10697 | <a id="PlayerHouseBlocked">PlayerHouseBlocked</a><sub><br/>Check if Player has the house type explicitly blocked from being built</sub> | <sub>**aPlayer**: Integer; <br/> **aHouseType**: TKMHouseType;</sub> | <sub>Boolean</sub> |
| - | <a id="PlayerHouseCanBuild">PlayerHouseCanBuild</a><sub><br/>Check if Player can build certain house type</sub> | <sub>**aPlayer**: Integer; <br/> **aHouseType**: TKMHouseType;</sub> | <sub>Boolean</sub> |
| 10697 | <a id="PlayerHouseGranted">PlayerHouseGranted</a><sub><br/>Check if Player has the house explicitly granted (allowed to be built<br/>If house is both granted and blocked - it will be blocked</sub> | <sub>**aPlayer**: Integer; <br/> **aHouseType**: TKMHouseType;</sub> | <sub>Boolean</sub> |
| 10470 | <a id="PlayerIsNeutral">PlayerIsNeutral</a><sub><br/>Check if the player is neutral (animals)</sub> | <sub>**aPlayer**: Integer;</sub> | <sub>Boolean</sub> |
| - | <a id="PlayerName">PlayerName</a><sub><br/>Get the players full name</sub> | <sub>**aPlayer**: Integer;</sub> | <sub>string</sub> |
| 14892 | <a id="PlayerObjectiveStatus">PlayerObjectiveStatus</a><sub><br/>Get the objective status<br/>Returns osHidden in case of fail</sub> | <sub>**aPlayer**: Integer; <br/> **aObjectiveId**: Integer;</sub> | <sub>TKMObjectiveStatus</sub> |
| 14892 | <a id="PlayerObjectiveType">PlayerObjectiveType</a><sub><br/>Get the objective type<br/>Returns otMain in case of fail</sub> | <sub>**aPlayer**: Integer; <br/> **aObjectiveId**: Integer;</sub> | <sub>TKMObjectiveType</sub> |
| - | <a id="PlayerVictorious">PlayerVictorious</a><sub></sub> | <sub>**aPlayer**: Integer;</sub> | <sub>Boolean</sub> |
| - | <a id="PlayerWareDistribution">PlayerWareDistribution</a><sub></sub> | <sub>**aPlayer**: Integer; <br/> **aWareType**: TKMWareType; <br/> **aHouseType**: TKMHouseType;</sub> | <sub>Byte</sub> |
| - | <a id="StatArmyCount">StatArmyCount</a><sub></sub> | <sub>**aPlayer**: Integer;</sub> | <sub>Integer</sub> |
| - | <a id="StatCitizenCount">StatCitizenCount</a><sub></sub> | <sub>**aPlayer**: Integer;</sub> | <sub>Integer</sub> |
| - | <a id="StatHouseTypeCount">StatHouseTypeCount</a><sub><br/>Return number of completed houses of specified type that player has at this moment</sub> | <sub>**aPlayer**: Integer; <br/> **aHouseType**: TKMHouseType;</sub> | <sub>Integer</sub> |
| - | <a id="StatPlayerCount">StatPlayerCount</a><sub><br/>See how many enabled players there are in the mission (chosen to be played by anyone on mission start)</sub> | <sub></sub> | <sub>Integer</sub> |
| - | <a id="StatUnitCount">StatUnitCount</a><sub><br/>See how many units player has alive</sub> | <sub>**aPlayer**: Integer;</sub> | <sub>Integer</sub> |
| - | <a id="StatUnitKilledCount">StatUnitKilledCount</a><sub><br/>See how many units player has killed</sub> | <sub>**aPlayer**: Integer; <br/> **aUnitType**: TKMUnitType;</sub> | <sub>Integer</sub> |
| - | <a id="StatUnitLostCount">StatUnitLostCount</a><sub><br/>See how many units player has lost</sub> | <sub>**aPlayer**: Integer; <br/> **aUnitType**: TKMUnitType;</sub> | <sub>Integer</sub> |
| - | <a id="StatUnitTypeCount">StatUnitTypeCount</a><sub><br/>See how many units of certain type player has alive</sub> | <sub>**aPlayer**: Integer; <br/> **aUnitType**: TKMUnitType;</sub> | <sub>Integer</sub> |
| 5606 | <a id="StatWaresBalance">StatWaresBalance</a><sub><br/>See how many wares player has at the moment</sub> | <sub>**aPlayer**: Integer; <br/> **aWareType**: TKMWareType;</sub> | <sub>Integer</sub> |
| 5606 | <a id="StatWaresProduced">StatWaresProduced</a><sub><br/>See how many wares were produced by the player</sub> | <sub>**aPlayer**: Integer; <br/> **aWareType**: TKMWareType;</sub> | <sub>Integer</sub> |
| 8785 | <a id="StatWaresProducedValue">StatWaresProducedValue</a><sub><br/>Get total value of all wares produced by player</sub> | <sub>**aPlayer**: Integer;</sub> | <sub>Integer</sub> |
| -6683 | <a id="SysRandom">SysRandom</a><br/>&#x274C;`Removed`<br/><sub>*Method was removed, use <a href="#Utils.Random">Utils.Random</a> instead*</sub><sub></sub> | <sub></sub> | <sub>Single</sub> |
| -6683 | <a id="SysRandomI">SysRandomI</a><br/>&#x274C;`Removed`<br/><sub>*Method was removed, use <a href="#Utils.RandomI">Utils.RandomI</a> instead*</sub><sub></sub> | <sub>**aMax**: Integer;</sub> | <sub>Integer</sub> |
| 14250 | <a id="TerrainObjectState">TerrainObjectState</a><sub><br/>Get the state of the terrain object<br/>If there's no object - default state of 0 is returned</sub> | <sub>**aX, aY**: Integer; <br/> **aCoord**: Byte;</sub> | <sub>Byte</sub> |
| - | <a id="UnitAt">UnitAt</a><sub><br/>Return UID of the unit on requested coordinates on terrain<br/>Units inside houses do not count</sub> | <sub>**aX, aY**: Word;</sub> | <sub>Integer</sub> |
| - | <a id="UnitCarryCount">UnitCarryCount</a><sub><br/>See how many wares that unit (porter or wagon) is carrying</sub> | <sub>**aUnitID**: Integer; <br/> **aWareType**: TKMWareType;</sub> | <sub>Integer</sub> |
| - | <a id="UnitCarryType">UnitCarryType</a><sub><br/>See ware type that unit (porter or wagon) is carrying</sub> | <sub>**aUnitID**: Integer;</sub> | <sub>TKMWareType</sub> |
| 15556 | <a id="UnitDamageMax">UnitDamageMax</a><sub><br/>Returns maximum damage of a unit. 0 if unit can not deal damage. -1 if there's no such unit</sub> | <sub>**aUnitID**: Integer;</sub> | <sub>Integer</sub> |
| 15556 | <a id="UnitDamageMin">UnitDamageMin</a><sub><br/>Returns minimum damage of a unit. 0 if unit can not deal damage. -1 if there's no such unit</sub> | <sub>**aUnitID**: Integer;</sub> | <sub>Integer</sub> |
| - | <a id="UnitDead">UnitDead</a><sub><br/>Check if unit is dead</sub> | <sub>**aUnitID**: Integer;</sub> | <sub>Boolean</sub> |
| - | <a id="UnitDirection">UnitDirection</a><sub><br/>See unit facing direction (0 .. 7)<br/>-1 if direction is uninitialized</sub> | <sub>**aUnitID**: Integer;</sub> | <sub>Integer</sub> |
| 4829 | <a id="UnitGroup">UnitGroup</a><sub><br/>Return UID of a group to which requested Unit belongs</sub> | <sub>**aUnitID**: Integer;</sub> | <sub>Integer</sub> |
| 14497 | <a id="UnitHitpoints">UnitHitpoints</a><sub><br/>See current unit hitpoints</sub> | <sub>**aUnitID**: Integer;</sub> | <sub>Integer</sub> |
| 14497 | <a id="UnitHitpointsMax">UnitHitpointsMax</a><sub><br/>See maximum unit hitpoints</sub> | <sub>**aUnitID**: Integer;</sub> | <sub>Integer</sub> |
| 6692 | <a id="UnitHunger">UnitHunger</a><sub><br/>See unit hunger condition in seconds remaining till death<br/>Result within 0 and 2700 (45min)</sub> | <sub>**aUnitID**: Integer;</sub> | <sub>Integer</sub> |
| 6692 | <a id="UnitHungerLow">UnitHungerLow</a><sub><br/>Return fullness level of a unit when it becomes hungry, in seconds</sub> | <sub></sub> | <sub>Integer</sub> |
| 6692 | <a id="UnitHungerMax">UnitHungerMax</a><sub><br/>Return maximum fullness level of a unit, in seconds</sub> | <sub></sub> | <sub>Integer</sub> |
| 14492 | <a id="UnitInHouse">UnitInHouse</a><sub><br/>Returns HouseID in which the Unit is now,<br/>-1 if Unit not found<br/>0 if Unit is not in any house</sub> | <sub>**aUnitID**: Integer;</sub> | <sub>Integer</sub> |
| - | <a id="UnitOwner">UnitOwner</a><sub><br/>See unit owner hand</sub> | <sub>**aUnitID**: Integer;</sub> | <sub>Integer</sub> |
| - | <a id="UnitPositionX">UnitPositionX</a><sub><br/>Get rounded unit position X<br/>-1 if unit does not exist</sub> | <sub>**aUnitID**: Integer;</sub> | <sub>Integer</sub> |
| - | <a id="UnitPositionY">UnitPositionY</a><sub><br/>Get rounded unit position Y<br/>-1 if unit does not exist</sub> | <sub>**aUnitID**: Integer;</sub> | <sub>Integer</sub> |
| 12430 | <a id="UnitsAt">UnitsAt</a><sub><br/>Return UIDs of the units within requested coordinates<br/>Units inside houses do not count<br/>For convenience, bounds can exceed map coordinates without generating an error</sub> | <sub>**aX1**: Integer; <br/> **aY1**: Integer; <br/> **aX2**: Integer; <br/> **aY2**: Integer;</sub> | <sub>TKMIntegerArray</sub> |
| - | <a id="UnitType">UnitType</a><sub><br/>See unit type</sub> | <sub>**aUnitID**: Integer;</sub> | <sub>TKMUnitType</sub> |
| 15658 | <a id="UnitTypeName">UnitTypeName</a><sub><br/>Returns unit type name as used in the game engine<br/>Intended to be used for debug purposes</sub> | <sub>**aUnitType**: TKMUnitType;</sub> | <sub>string</sub> |
| 15658 | <a id="WareTypeName">WareTypeName</a><sub><br/>Returns ware type name as used in the game engine<br/>Intended to be used for debug purposes</sub> | <sub>**aWareType**: TKMWareType;</sub> | <sub>string</sub> |
