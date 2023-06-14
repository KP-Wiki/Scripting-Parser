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
* <a href="#FogRevealed">FogRevealed</a>
* <a href="#GamePeaceTime">GamePeaceTime</a>
* <a href="#GroupAt">GroupAt</a>
* <a href="#GroupColumnCount">GroupColumnCount</a>
* <a href="#GroupDead">GroupDead</a>
* <a href="#GroupIsIdle">GroupIsIdle</a>
* <a href="#GroupMember">GroupMember</a>
* <a href="#GroupMemberCount">GroupMemberCount</a>
* <a href="#GroupOwner">GroupOwner</a>
* <a href="#HouseAt">HouseAt</a>
* <a href="#HouseDamage">HouseDamage</a>
* <a href="#HouseDeliveryBlocked">HouseDeliveryBlocked</a>
* <a href="#HouseDestroyed">HouseDestroyed</a>
* <a href="#HouseHasOccupant">HouseHasOccupant</a>
* <a href="#HouseHasWorker">HouseHasWorker</a>
* <a href="#HouseIsComplete">HouseIsComplete</a>
* <a href="#HouseOwner">HouseOwner</a>
* <a href="#HousePositionX">HousePositionX</a>
* <a href="#HousePositionY">HousePositionY</a>
* <a href="#HouseRepair">HouseRepair</a>
* <a href="#HouseSheepyardHasPasture">HouseSheepyardHasPasture</a>
* <a href="#HouseTrainQueuePeek">HouseTrainQueuePeek</a>
* <a href="#HouseType">HouseType</a>
* <a href="#HouseWareBlock">HouseWareBlock</a>
* <a href="#HouseWareInside">HouseWareInside</a>
* <a href="#HouseWaresBlock">HouseWaresBlock</a>
* <a href="#HouseWeaponsOrdered">HouseWeaponsOrdered</a>
* <a href="#HouseWoodcutterChopOnly">HouseWoodcutterChopOnly</a>
* <a href="#IsFieldAt">IsFieldAt</a>
* <a href="#IsOrchardAt">IsOrchardAt</a>
* <a href="#IsRoadAt">IsRoadAt</a>
* <a href="#PlayerAllianceCheck">PlayerAllianceCheck</a>
* <a href="#PlayerColorText">PlayerColorText</a>
* <a href="#PlayerDefeated">PlayerDefeated</a>
* <a href="#PlayerEnabled">PlayerEnabled</a>
* <a href="#PlayerFogRevealed">PlayerFogRevealed</a>
* <a href="#PlayerGetAllGroups">PlayerGetAllGroups</a>
* <a href="#PlayerGetAllHouses">PlayerGetAllHouses</a>
* <a href="#PlayerGetAllRoads">PlayerGetAllRoads</a>
* <a href="#PlayerGetAllUnits">PlayerGetAllUnits</a>
* <a href="#PlayerGetHouses">PlayerGetHouses</a>
* <a href="#PlayerHouseBlocked">PlayerHouseBlocked</a>
* <a href="#PlayerHouseCanBuild">PlayerHouseCanBuild</a>
* <a href="#PlayerHouseGranted">PlayerHouseGranted</a>
* <a href="#PlayerIsNeutral">PlayerIsNeutral</a>
* <a href="#PlayerName">PlayerName</a>
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
* <a href="#SysRandom">SysRandom</a>
* <a href="#SysRandomI">SysRandomI</a>
* <a href="#UnitAt">UnitAt</a>
* <a href="#UnitCarryCount">UnitCarryCount</a>
* <a href="#UnitCarryType">UnitCarryType</a>
* <a href="#UnitDead">UnitDead</a>
* <a href="#UnitDirection">UnitDirection</a>
* <a href="#UnitGroup">UnitGroup</a>
* <a href="#UnitHunger">UnitHunger</a>
* <a href="#UnitHungerLow">UnitHungerLow</a>
* <a href="#UnitHungerMax">UnitHungerMax</a>
* <a href="#UnitOwner">UnitOwner</a>
* <a href="#UnitPositionX">UnitPositionX</a>
* <a href="#UnitPositionY">UnitPositionY</a>
* <a href="#UnitType">UnitType</a>
<br />

| Ver<br/>sion | State description | Parameters<br/>and types | Returns |
| ------- | ------------------------------------ | -------------- | ------- |
| 8721 | <a id="CampaignMissionCount">CampaignMissionCount</a><sub><br/>Get total number of missions in the current campaign. Campaign-only action!</sub> | <sub></sub> | <sub>Integer</sub> |
| 8723 | <a id="CampaignMissionWon">CampaignMissionWon</a><sub><br/>See if the mission was won. Campaign-only action!</sub> | <sub>**aMission**: Integer; // _mission index to check_</sub> | <sub>Boolean</sub> |
| 7969 | <a id="EntityType">EntityType</a><sub><br/>Get the entity type by its UID (0 - unknown or none, 1 - Unit, 2 - House, 3 - UnitGroup, 4 - Stockpile)</sub> | <sub>**aEntityID**: Integer;</sub> | <sub>Integer</sub> |
| -8743 | <a id="FogRevealed">FogRevealed</a><br/>&#x274C;`Removed`<br/><sub>*Method was removed, use <a href="#PlayerFogRevealed">PlayerFogRevealed</a> instead*</sub><sub></sub> | <sub>**aPlayer**: Integer; <br/> **aX, aY**: Word;</sub> | <sub>Boolean</sub> |
| - | <a id="GamePeaceTime">GamePeaceTime</a><sub><br/>Get the peacetime duration (in game ticks)</sub> | <sub></sub> | <sub>Cardinal</sub> |
| - | <a id="GroupAt">GroupAt</a><sub><br/>Return UID of a group at requested coordinates</sub> | <sub>**aX, aY**: Word;</sub> | <sub>Integer</sub> |
| - | <a id="GroupColumnCount">GroupColumnCount</a><sub></sub> | <sub>**aGroupID**: Integer;</sub> | <sub>Integer</sub> |
| - | <a id="GroupDead">GroupDead</a><sub><br/>See if the group is dead (all members are dead)</sub> | <sub>**aGroupID**: Integer;</sub> | <sub>Boolean</sub> |
| 5632 | <a id="GroupIsIdle">GroupIsIdle</a><sub><br/>See if the group is idle (ready to take orders)</sub> | <sub>**aGroupID**: Integer;</sub> | <sub>Boolean</sub> |
| - | <a id="GroupMember">GroupMember</a><sub><br/>Get N-th group member</sub> | <sub>**aGroupID**: Integer; <br/> **aMemberIndex**: Integer;</sub> | <sub>Integer</sub> |
| - | <a id="GroupMemberCount">GroupMemberCount</a><sub><br/>Returns how many member there are in this group</sub> | <sub>**aGroupID**: Integer;</sub> | <sub>Integer</sub> |
| - | <a id="GroupOwner">GroupOwner</a><sub><br/>Returns to which Hand this group belongs</sub> | <sub>**aGroupID**: Integer;</sub> | <sub>Integer</sub> |
| - | <a id="HouseAt">HouseAt</a><sub><br/>Get the house at coordinates</sub> | <sub>**aX, aY**: Word;</sub> | <sub>Integer</sub> |
| - | <a id="HouseDamage">HouseDamage</a><sub><br/>Check house damage<br/>-1 if house does not exist</sub> | <sub>**aHouseID**: Integer;</sub> | <sub>Integer</sub> |
| -7015 | <a id="HouseDeliveryBlocked">HouseDeliveryBlocked</a><br/>&#x274C;`Removed`<br/><sub>*Method was removed, use <a href="#HouseWareBlock">HouseWareBlock</a> instead*</sub><sub></sub> | <sub>**aHouseID**: Integer; <br/> **aWareType**: TKMWareType;</sub> | <sub>Boolean</sub> |
| - | <a id="HouseDestroyed">HouseDestroyed</a><sub></sub> | <sub>**aHouseID**: Integer;</sub> | <sub>Boolean</sub> |
| -6102 | <a id="HouseHasOccupant">HouseHasOccupant</a><br/>&#x274C;`Removed`<br/><sub>*Method was removed, use <a href="#HouseHasWorker">HouseHasWorker</a> instead*</sub><sub></sub> | <sub>**aHouseID**: Integer;</sub> | <sub></sub> |
| 6102 | <a id="HouseHasWorker">HouseHasWorker</a><sub><br/>Check if the house has a worker assigned to it</sub> | <sub>**aHouseID**: Integer;</sub> | <sub>Boolean</sub> |
| - | <a id="HouseIsComplete">HouseIsComplete</a><sub><br/>Check if house is complete</sub> | <sub>**aHouseID**: Integer;</sub> | <sub>Boolean</sub> |
| - | <a id="HouseOwner">HouseOwner</a><sub><br/>See to which player the house belongs</sub> | <sub>**aHouseID**: Integer;</sub> | <sub>Integer</sub> |
| - | <a id="HousePositionX">HousePositionX</a><sub><br/>-1 if house does not exist</sub> | <sub>**aHouseID**: Integer;</sub> | <sub>Integer</sub> |
| - | <a id="HousePositionY">HousePositionY</a><sub><br/>-1 if house does not exist</sub> | <sub>**aHouseID**: Integer;</sub> | <sub>Integer</sub> |
| - | <a id="HouseRepair">HouseRepair</a><sub><br/>Check if house repair is enabled</sub> | <sub>**aHouseID**: Integer;</sub> | <sub>Boolean</sub> |
| 13134 | <a id="HouseSheepyardHasPasture">HouseSheepyardHasPasture</a><sub><br/>Check if the sheepyard has a pasture built (fenced area by the back door)</sub> | <sub>**aHouseID**: Integer;</sub> | <sub>Boolean</sub> |
| 4820 | <a id="HouseTrainQueuePeek">HouseTrainQueuePeek</a><sub><br/>Get the unit type in the houses training queue (School/Fort/Barracks)</sub> | <sub>**aHouseID**: Integer; <br/> **QueueIndex**: Integer;</sub> | <sub>TKMUnitType</sub> |
| - | <a id="HouseType">HouseType</a><sub><br/>Get the house type</sub> | <sub>**aHouseID**: Integer;</sub> | <sub>TKMHouseType</sub> |
| 7021 | <a id="HouseWareBlock">HouseWareBlock</a><sub><br/>Lookup spacious house ware delivery policy. Works only for spacious houses (Camp, Fort, Store, Barracks)</sub> | <sub>**aHouseID**: Integer; <br/> **aWareType**: TKMWareType;</sub> | <sub>Integer // 0 - allow, 1 - block, 2 - evacuate</sub> |
| - | <a id="HouseWareInside">HouseWareInside</a><sub><br/>-1 if house does not exist or ware can not be in that house</sub> | <sub>**aHouseID**: Integer; <br/> **aWareType**: TKMWareType;</sub> | <sub>Integer</sub> |
| 10399 | <a id="HouseWaresBlock">HouseWaresBlock</a><sub><br/>Lookup common ware delivery policy. Works only for common houses</sub> | <sub>**aHouseID**: Integer;</sub> | <sub>Integer // 0 - allow, 1 - block</sub> |
| - | <a id="HouseWeaponsOrdered">HouseWeaponsOrdered</a><sub><br/>Get the amount of weapons ordered in the house</sub> | <sub>**aHouseID**: Integer; <br/> **aWareType**: TKMWareType;</sub> | <sub>Integer</sub> |
| - | <a id="HouseWoodcutterChopOnly">HouseWoodcutterChopOnly</a><sub></sub> | <sub>**aHouseID**: Integer;</sub> | <sub>Boolean</sub> |
| - | <a id="IsFieldAt">IsFieldAt</a><sub><br/>Check if there is a field owned by player at coordinates</sub> | <sub>**aPlayer**: Integer; // _player to whom field must belong. -1 stands for any player_ <br/> **aX, aY**: Word;</sub> | <sub>Boolean</sub> |
| - | <a id="IsOrchardAt">IsOrchardAt</a><sub><br/>Check if there is a orchard owned by player at coordinates</sub> | <sub>**aPlayer**: Integer; // _player to whom orchard must belong. -1 stands for any player_ <br/> **aX, aY**: Word;</sub> | <sub>Boolean</sub> |
| - | <a id="IsRoadAt">IsRoadAt</a><sub><br/>Check if there is a road owned by player at coordinates</sub> | <sub>**aPlayer**: Integer; // _player to whom road must belong. -1 stands for any player_ <br/> **aX, aY**: Word;</sub> | <sub>Boolean</sub> |
| - | <a id="PlayerAllianceCheck">PlayerAllianceCheck</a><sub><br/>Checking alliances with Neutral will always return True (despite some animals being agressive)</sub> | <sub>**aPlayer1**: Integer; <br/> **aPlayer2**: Integer;</sub> | <sub>Boolean</sub> |
| - | <a id="PlayerColorText">PlayerColorText</a><sub><br/>Get the string with color code of the player (adjusted brighter for text display)</sub> | <sub>**aPlayer**: Integer;</sub> | <sub>string</sub> |
| - | <a id="PlayerDefeated">PlayerDefeated</a><sub></sub> | <sub>**aPlayer**: Integer;</sub> | <sub>Boolean</sub> |
| - | <a id="PlayerEnabled">PlayerEnabled</a><sub><br/>Check if hand is enabled (chosen to be played by anyone on mission start)</sub> | <sub>**aPlayer**: Integer;</sub> | <sub>Boolean</sub> |
| 8743 | <a id="PlayerFogRevealed">PlayerFogRevealed</a><sub><br/>See if tile is revealed to the player (known or live)</sub> | <sub>**aPlayer**: Integer; <br/> **aX, aY**: Word;</sub> | <sub>Boolean</sub> |
| - | <a id="PlayerGetAllGroups">PlayerGetAllGroups</a><sub><br/>Get list of all players groups</sub> | <sub>**aPlayer**: Integer;</sub> | <sub>TKMIntegerArray</sub> |
| - | <a id="PlayerGetAllHouses">PlayerGetAllHouses</a><sub><br/>Return all players houses that are not destroyed</sub> | <sub>**aPlayer**: Integer;</sub> | <sub>TKMIntegerArray</sub> |
| - | <a id="PlayerGetAllRoads">PlayerGetAllRoads</a><sub><br/>Get list of all players roads</sub> | <sub>**aPlayer**: Integer; // _player to whom roads must belong. 0..N-1_</sub> | <sub>TKMPointArray</sub> |
| - | <a id="PlayerGetAllUnits">PlayerGetAllUnits</a><sub><br/>Return all players units that are not dead and not in training</sub> | <sub>**aPlayer**: Integer;</sub> | <sub>TKMIntegerArray</sub> |
| 12942 | <a id="PlayerGetHouses">PlayerGetHouses</a><sub><br/>Return all players houses of certain type that are not destroyed</sub> | <sub>**aPlayer**: Integer; <br/> **aHouseType**: TKMHouseType; // _house type to return. htAny for all houses_ <br/> **aOnlyCompleted**: Boolean; // _return only completed houses_</sub> | <sub>TKMIntegerArray</sub> |
| 10697 | <a id="PlayerHouseBlocked">PlayerHouseBlocked</a><sub><br/>Check if Player has the house type explicitly blocked from being built</sub> | <sub>**aPlayer**: Integer; <br/> **aHouseType**: TKMHouseType;</sub> | <sub>Boolean</sub> |
| - | <a id="PlayerHouseCanBuild">PlayerHouseCanBuild</a><sub><br/>Check if Player can build certain house type</sub> | <sub>**aPlayer**: Integer; <br/> **aHouseType**: TKMHouseType;</sub> | <sub>Boolean</sub> |
| 10697 | <a id="PlayerHouseGranted">PlayerHouseGranted</a><sub><br/>Check if Player has the house explicitly granted (allowed to be built<br/>If house is both granted and blocked - it will be blocked</sub> | <sub>**aPlayer**: Integer; <br/> **aHouseType**: TKMHouseType;</sub> | <sub>Boolean</sub> |
| 10470 | <a id="PlayerIsNeutral">PlayerIsNeutral</a><sub><br/>Check if the player is neutral (animals)</sub> | <sub>**aPlayer**: Integer;</sub> | <sub>Boolean</sub> |
| - | <a id="PlayerName">PlayerName</a><sub><br/>Get the players full name</sub> | <sub>**aPlayer**: Integer;</sub> | <sub>string</sub> |
| - | <a id="PlayerVictorious">PlayerVictorious</a><sub></sub> | <sub>**aPlayer**: Integer;</sub> | <sub>Boolean</sub> |
| - | <a id="PlayerWareDistribution">PlayerWareDistribution</a><sub></sub> | <sub>**aPlayer**: Integer; <br/> **aWareType**: TKMWareType; <br/> **aHouseType**: TKMHouseType;</sub> | <sub>Byte</sub> |
| - | <a id="StatArmyCount">StatArmyCount</a><sub></sub> | <sub>**aPlayer**: Integer;</sub> | <sub>Integer</sub> |
| - | <a id="StatCitizenCount">StatCitizenCount</a><sub></sub> | <sub>**aPlayer**: Integer;</sub> | <sub>Integer</sub> |
| - | <a id="StatHouseTypeCount">StatHouseTypeCount</a><sub><br/>Return number of completed houses of specified type</sub> | <sub>**aPlayer**: Integer; <br/> **aHouseType**: TKMHouseType;</sub> | <sub>Integer</sub> |
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
| - | <a id="UnitAt">UnitAt</a><sub><br/>Return UID of the unit on requested coordinates</sub> | <sub>**aX, aY**: Word;</sub> | <sub>Integer</sub> |
| - | <a id="UnitCarryCount">UnitCarryCount</a><sub><br/>See how many wares that unit is carrying</sub> | <sub>**aUnitID**: Integer; <br/> **aWareType**: TKMWareType;</sub> | <sub>Integer</sub> |
| - | <a id="UnitCarryType">UnitCarryType</a><sub><br/>See ware type that unit is carrying</sub> | <sub>**aUnitID**: Integer;</sub> | <sub>TKMWareType</sub> |
| - | <a id="UnitDead">UnitDead</a><sub><br/>Check if unit is dead</sub> | <sub>**aUnitID**: Integer;</sub> | <sub>Boolean</sub> |
| - | <a id="UnitDirection">UnitDirection</a><sub><br/>See unit facing direction (0 .. 7)<br/>-1 if direction is uninitialized</sub> | <sub>**aUnitID**: Integer;</sub> | <sub>Integer</sub> |
| 4829 | <a id="UnitGroup">UnitGroup</a><sub><br/>Return UID of a group to which requested Unit belongs</sub> | <sub>**aUnitID**: Integer;</sub> | <sub>Integer</sub> |
| 6692 | <a id="UnitHunger">UnitHunger</a><sub><br/>See unit hunger condition in seconds remaining till death<br/>Result within 0 and 2700 (45min)</sub> | <sub>**aUnitID**: Integer;</sub> | <sub>Integer</sub> |
| 6692 | <a id="UnitHungerLow">UnitHungerLow</a><sub><br/>Return fullness level of a unit when it becomes hungry, in seconds</sub> | <sub></sub> | <sub>Integer</sub> |
| 6692 | <a id="UnitHungerMax">UnitHungerMax</a><sub><br/>Return maximum fullness level of a unit, in seconds</sub> | <sub></sub> | <sub>Integer</sub> |
| - | <a id="UnitOwner">UnitOwner</a><sub><br/>See unit owner hand</sub> | <sub>**aUnitID**: Integer;</sub> | <sub>Integer</sub> |
| - | <a id="UnitPositionX">UnitPositionX</a><sub><br/>Get rounded unit position X<br/>-1 if unit does not exist</sub> | <sub>**aUnitID**: Integer;</sub> | <sub>Integer</sub> |
| - | <a id="UnitPositionY">UnitPositionY</a><sub><br/>Get rounded unit position Y<br/>-1 if unit does not exist</sub> | <sub>**aUnitID**: Integer;</sub> | <sub>Integer</sub> |
| - | <a id="UnitType">UnitType</a><sub><br/>See unit type</sub> | <sub>**aUnitID**: Integer;</sub> | <sub>TKMUnitType</sub> |
