####States

| Ver<br/>sion | State description | Parameters<br/>and types | Returns |
| ------- | ------------------------------------ | -------------- | ------- |
| 7969 | EntityType<sub><br/>Get the entity type by its UID (0 - unknown or none, 1 - Unit, 2 - House, 3 - UnitGroup, 4 - Stockpile)</sub> | <sub>**aEntityID**: Integer;</sub> | <sub>Integer</sub> |
| - | FogRevealed<sub><br/>See if tile is revealed (known or live)</sub> | <sub>**aPlayer**: Integer; <br/> **aX**: Word; <br/> **aY**: Word;</sub> | <sub>Boolean</sub> |
| - | GameTime<sub><br/>Deprecated. Please use the time provided by OnTick event</sub> | <sub></sub> | <sub>Cardinal</sub> |
| - | GroupAt<sub><br/>Return UID of a group at requested coordinates</sub> | <sub>**aX**: Word; <br/> **aY**: Word;</sub> | <sub>Integer</sub> |
| - | GroupColumnCount<sub></sub> | <sub>**aGroupID**: Integer;</sub> | <sub>Integer</sub> |
| - | GroupDead<sub><br/>See if the group is dead (all members are dead)</sub> | <sub>**aGroupID**: Integer;</sub> | <sub>Boolean</sub> |
| 5632 | GroupIsIdle<sub><br/>See if the group is idle (ready to take orders)</sub> | <sub>**aGroupID**: Integer;</sub> | <sub>Boolean</sub> |
| - | GroupMember<sub><br/>Get N-th group member</sub> | <sub>**aGroupID**: Integer; <br/> **aMemberIndex**: Integer;</sub> | <sub>Integer</sub> |
| - | GroupMemberCount<sub><br/>Returns how many member there are in this group</sub> | <sub>**aGroupID**: Integer;</sub> | <sub>Integer</sub> |
| - | GroupOwner<sub><br/>Returns to which Hand this group belongs</sub> | <sub>**aGroupID**: Integer;</sub> | <sub>Integer</sub> |
| - | HouseAt<sub><br/>Get the house at coordinates</sub> | <sub>**aX**: Word; <br/> **aY**: Word;</sub> | <sub>Integer</sub> |
| - | HouseDamage<sub><br/>Check house damage</sub> | <sub>**aHouseID**: Integer;</sub> | <sub>Integer</sub> |
| -7015 | HouseDeliveryBlocked<sub><br/>Use HouseWareBlock instead</sub> | <sub>**aHouseID**: Integer; <br/> **aWareType**: TKMWareType;</sub> | <sub>Boolean</sub> |
| - | HouseDestroyed<sub></sub> | <sub>**aHouseID**: Integer;</sub> | <sub>Boolean</sub> |
| -6102 | HouseHasOccupant<sub><br/>Replaced with HouseHasWorker</sub> | <sub>**aHouseID**: Integer;</sub> | <sub></sub> |
| 6102 | HouseHasWorker<sub><br/>Check if the house has a worker assigned to it</sub> | <sub>**aHouseID**: Integer;</sub> | <sub>Boolean</sub> |
| - | HouseIsComplete<sub><br/>Check if house is complete</sub> | <sub>**aHouseID**: Integer;</sub> | <sub>Boolean</sub> |
| - | HouseOwner<sub></sub> | <sub>**aHouseID**: Integer;</sub> | <sub>Integer</sub> |
| - | HousePositionX<sub></sub> | <sub>**aHouseID**: Integer;</sub> | <sub>Integer</sub> |
| - | HousePositionY<sub></sub> | <sub>**aHouseID**: Integer;</sub> | <sub>Integer</sub> |
| - | HouseRepair<sub><br/>Check if house repair is enabled</sub> | <sub>**aHouseID**: Integer;</sub> | <sub>Boolean</sub> |
| 4820 | HouseTrainQueuePeek<sub><br/>Get the unit type in the houses queue (School/Fort/Barracks)</sub> | <sub>**aHouseID**: Integer; <br/> **QueueIndex**: Integer;</sub> | <sub>TKMUnitType</sub> |
| - | HouseType<sub></sub> | <sub>**aHouseID**: Integer;</sub> | <sub>TKMHouseType</sub> |
| 7021 | HouseWareBlock<sub></sub> | <sub>**aHouseID**: Integer; <br/> **aWareType**: TKMWareType;</sub> | <sub>Integer</sub> |
| - | HouseWareInside<sub></sub> | <sub>**aHouseID**: Integer; <br/> **aWareType**: TKMWareType;</sub> | <sub>Integer</sub> |
| - | HouseWeaponsOrdered<sub></sub> | <sub>**aHouseID**: Integer; <br/> **aWareType**: TKMWareType;</sub> | <sub>Integer</sub> |
| - | HouseWoodcutterChopOnly<sub></sub> | <sub>**aHouseID**: Integer;</sub> | <sub>Boolean</sub> |
| - | IsFieldAt<sub><br/>Check if there is a field owned by player at coordinates</sub> | <sub>**aPlayer**: Integer; //_Player - player to whom field must belong. -1 stands for any player_ <br/> **aX**: Word; <br/> **aY**: Word;</sub> | <sub>Boolean</sub> |
| - | IsOrchardAt<sub><br/>Check if there is a orchard owned by player at coordinates</sub> | <sub>**aPlayer**: Integer; //_Player - player to whom orchard must belong. -1 stands for any player_ <br/> **aX**: Word; <br/> **aY**: Word;</sub> | <sub>Boolean</sub> |
| - | IsRoadAt<sub><br/>Check if there is a road owned by player at coordinates</sub> | <sub>**aPlayer**: Integer; //_Player - player to whom road must belong. -1 stands for any player_ <br/> **aX**: Word; <br/> **aY**: Word;</sub> | <sub>Boolean</sub> |
| - | PeaceTime<sub><br/>Get the peacetime (in game ticks)</sub> | <sub></sub> | <sub>Cardinal</sub> |
| - | PlayerAllianceCheck<sub></sub> | <sub>**aPlayer1**: Integer; <br/> **aPlayer2**: Integer;</sub> | <sub>Boolean</sub> |
| - | PlayerColorText<sub><br/>Get the string with color code of the player</sub> | <sub>**aPlayer**: Integer;</sub> | <sub>UnicodeString</sub> |
| - | PlayerDefeated<sub></sub> | <sub>**aPlayer**: Integer;</sub> | <sub>Boolean</sub> |
| - | PlayerEnabled<sub><br/>Check if hand is enabled (chosen to be played by anyone on mission start)</sub> | <sub>**aPlayer**: Integer;</sub> | <sub>Boolean</sub> |
| - | PlayerGetAllGroups<sub><br/>Get list of all players groups</sub> | <sub>**aPlayer**: Integer;</sub> | <sub>array of Integer</sub> |
| - | PlayerGetAllHouses<sub></sub> | <sub>**aPlayer**: Integer;</sub> | <sub>array of Integer</sub> |
| - | PlayerGetAllUnits<sub></sub> | <sub>**aPlayer**: Integer;</sub> | <sub>array of Integer</sub> |
| - | PlayerHouseCanBuild<sub><br/>Check if Player can build certain house type</sub> | <sub>**aPlayer**: Integer; <br/> **aHouseType**: TKMHouseType;</sub> | <sub>Boolean</sub> |
| - | PlayerName<sub><br/>Get the players name</sub> | <sub>**aPlayer**: Integer;</sub> | <sub>UnicodeString</sub> |
| - | PlayerVictorious<sub></sub> | <sub>**aPlayer**: Integer;</sub> | <sub>Boolean</sub> |
| - | PlayerWareDistribution<sub></sub> | <sub>**aPlayer**: Integer; <br/> **aWareType**: TKMWareType; <br/> **aHouseType**: TKMHouseType;</sub> | <sub>Byte</sub> |
| - | StatArmyCount<sub></sub> | <sub>**aPlayer**: Integer;</sub> | <sub>Integer</sub> |
| - | StatCitizenCount<sub></sub> | <sub>**aPlayer**: Integer;</sub> | <sub>Integer</sub> |
| - | StatHouseTypeCount<sub></sub> | <sub>**aPlayer**: Integer; <br/> **aHouseType**: TKMHouseType;</sub> | <sub>Integer</sub> |
| - | StatPlayerCount<sub><br/>See how many enabled players there are in the mission (chosen to be played by anyone on mission start)</sub> | <sub></sub> | <sub>Integer</sub> |
| - | StatUnitCount<sub><br/>See how many units player has alive</sub> | <sub>**aPlayer**: Integer;</sub> | <sub>Integer</sub> |
| - | StatUnitKilledCount<sub><br/>See how many units player has killed</sub> | <sub>**aPlayer**: Integer; <br/> **aUnitType**: TKMUnitType;</sub> | <sub>Integer</sub> |
| - | StatUnitLostCount<sub><br/>See how many units player has lost</sub> | <sub>**aPlayer**: Integer; <br/> **aUnitType**: TKMUnitType;</sub> | <sub>Integer</sub> |
| - | StatUnitTypeCount<sub><br/>See how many units of certain type player has alive</sub> | <sub>**aPlayer**: Integer; <br/> **aUnitType**: TKMUnitType;</sub> | <sub>Integer</sub> |
| 5606 | StatWaresBalance<sub><br/>See how many wares player has at the moment</sub> | <sub>**aPlayer**: Integer; <br/> **aWareType**: TKMWareType;</sub> | <sub>Integer</sub> |
| 5606 | StatWaresProduced<sub><br/>See how many wares were produced by the player</sub> | <sub>**aPlayer**: Integer; <br/> **aWareType**: TKMWareType;</sub> | <sub>Integer</sub> |
| -6683 | SysRandom<sub><br/>Moved to Utils.Random</sub> | <sub></sub> | <sub>Single</sub> |
| -6683 | SysRandomI<sub><br/>Moved to Utils.RandomI</sub> | <sub>**aMax**: Integer;</sub> | <sub>Integer</sub> |
| - | UnitAt<sub><br/>Return UID of the unit on requested coordinates</sub> | <sub>**aX**: Word; <br/> **aY**: Word;</sub> | <sub>Integer</sub> |
| - | UnitCarryCount<sub><br/>See how many wares that unit is carrying</sub> | <sub>**aUnitID**: Integer; <br/> **aWareType**: TKMWareType;</sub> | <sub>Integer</sub> |
| - | UnitCarryType<sub><br/>See ware type that unit is carrying</sub> | <sub>**aUnitID**: Integer;</sub> | <sub>TKMWareType</sub> |
| - | UnitDead<sub><br/>Check if unit is dead</sub> | <sub>**aUnitID**: Integer;</sub> | <sub>Boolean</sub> |
| - | UnitDirection<sub><br/>See unit facing direction (0 .. 7)<br/>-1 if direction is uninitialized</sub> | <sub>**aUnitID**: Integer;</sub> | <sub>Integer</sub> |
| 4829 | UnitGroup<sub><br/>Return UID of a group to which requested Unit belongs</sub> | <sub>**aUnitID**: Integer;</sub> | <sub>Integer</sub> |
| 6692 | UnitHunger<sub><br/>See unit hunger condition in seconds remaining till death<br/>Result within 0 and 2700 (45min)</sub> | <sub>**aUnitID**: Integer;</sub> | <sub>Integer</sub> |
| 6692 | UnitHungerLow<sub><br/>Return fullness level of a unit when it becomes hungry, in seconds</sub> | <sub></sub> | <sub>Integer</sub> |
| 6692 | UnitHungerMax<sub><br/>Return maximum fullness level of a unit, in seconds</sub> | <sub></sub> | <sub>Integer</sub> |
| - | UnitOwner<sub><br/>See unit owner hand</sub> | <sub>**aUnitID**: Integer;</sub> | <sub>Integer</sub> |
| - | UnitPositionX<sub><br/>Get rounded unit position X</sub> | <sub>**aUnitID**: Integer;</sub> | <sub>Integer</sub> |
| - | UnitPositionY<sub><br/>Get rounded unit position Y</sub> | <sub>**aUnitID**: Integer;</sub> | <sub>Integer</sub> |
| - | UnitType<sub><br/>See unit type</sub> | <sub>**aUnitID**: Integer;</sub> | <sub>TKMUnitType</sub> |
