#### Events

Events are written in a form **procedure EVENT_NAME(EVENT_PARAMETERS);** like so:
```pascal
    procedure OnHouseBuilt(aHouseID: Integer);
    begin
      // code
    end;
```

#### Custom event handlers
Sometimes we want to make it possible to handle some event in the different procedures. It could be usefull, when we want to make script, which could be easily included into some other script with minimum efforts, as much simple as possible. 

Let's say in our includable script we want to do some stuff, when house is built, then we must have `OnHouseBuild` procedure. But then there could be an error, if main script (where our script is included) will have same `OnHouseBuild` procedure. 
That is why we want to have some other procedure, that will be invoked in our script. That could be archived with custom directive `{$EVENT}`
```pascal
    {$EVENT event_name:event_handler_procedure_name}
```
where
* **event_name** - name of the event, made with `evt` prefix, f.e. `evtHouseBuilt`
* **event_handler_procedure_name** - name of the procedure, which will be invoked on that event

For example:
```pascal
    {$EVENT evtHouseBuilt:MyCustomOnHouseBuilt}

    procedure MyCustomOnHouseBuilt(aHouseID: Integer);
    begin
      // code
    end;
```

When event happens all event handlers are invoked one after another. Default event handler (f.e. `OnHouseBuilt`) is always invoked first. Other custom event handlers invoked in order of declaration by `{$EVENT}` directive.

***

Other scripts functions:
* [Actions](https://github.com/reyandme/kam_remake/wiki/Actions-(Mission-Script-Dynamic))
* [States](https://github.com/reyandme/kam_remake/wiki/States-(Mission-Script-Dynamic))
* [Utils](https://github.com/reyandme/kam_remake/wiki/Utils-(Mission-Script-Dynamic))

Dynamic scripts usefull info:
* [Tutorial](https://github.com/reyandme/kam_remake/wiki/Tutorial-(Mission-Script-Dynamic))
* [Types](https://github.com/reyandme/kam_remake/wiki/Types-(Mission-Script-Dynamic))
* [Lookup Tables](https://github.com/reyandme/kam_remake/wiki/Lookup-Tables-(Mission-Script-Dynamic))
* [Advanced Features](https://github.com/reyandme/kam_remake/wiki/Advanced-Features-(Mission-Script-Dynamic))
* [Custom Console Commands](https://github.com/reyandme/kam_remake/wiki/Custom-Console-Commands-(Mission-Script-Dynamic))


***

* <a href="#OnBeacon">OnBeacon</a>
* <a href="#OnFieldBuilt">OnFieldBuilt</a>
* <a href="#OnGameSpeedChanged">OnGameSpeedChanged</a>
* <a href="#OnGroupBeforeOrderSplit">OnGroupBeforeOrderSplit</a>
* <a href="#OnGroupHungry">OnGroupHungry</a>
* <a href="#OnGroupOrderAttackHouse">OnGroupOrderAttackHouse</a>
* <a href="#OnGroupOrderAttackUnit">OnGroupOrderAttackUnit</a>
* <a href="#OnGroupOrderLink">OnGroupOrderLink</a>
* <a href="#OnGroupOrderMove">OnGroupOrderMove</a>
* <a href="#OnGroupOrderSplit">OnGroupOrderSplit</a>
* <a href="#OnHouseAfterDestroyed">OnHouseAfterDestroyed</a>
* <a href="#OnHouseAfterDestroyedEx">OnHouseAfterDestroyedEx</a>
* <a href="#OnHouseBuilt">OnHouseBuilt</a>
* <a href="#OnHouseDamaged">OnHouseDamaged</a>
* <a href="#OnHouseDeliveryModeChanged">OnHouseDeliveryModeChanged</a>
* <a href="#OnHouseDestroyed">OnHouseDestroyed</a>
* <a href="#OnHouseFlagPointChanged">OnHouseFlagPointChanged</a>
* <a href="#OnHousePlanDigged">OnHousePlanDigged</a>
* <a href="#OnHousePlanPlaced">OnHousePlanPlaced</a>
* <a href="#OnHousePlanPlacedEx">OnHousePlanPlacedEx</a>
* <a href="#OnHousePlanRemoved">OnHousePlanRemoved</a>
* <a href="#OnHousePlanRemovedEx">OnHousePlanRemovedEx</a>
* <a href="#OnHouseRepaired">OnHouseRepaired</a>
* <a href="#OnHouseWareCountChanged">OnHouseWareCountChanged</a>
* <a href="#OnMarketTrade">OnMarketTrade</a>
* <a href="#OnMarketTradeEx">OnMarketTradeEx</a>
* <a href="#OnMissionStart">OnMissionStart</a>
* <a href="#OnPeacetimeEnd">OnPeacetimeEnd</a>
* <a href="#OnPlanFieldPlaced">OnPlanFieldPlaced</a>
* <a href="#OnPlanFieldRemoved">OnPlanFieldRemoved</a>
* <a href="#OnPlanRoadDigged">OnPlanRoadDigged</a>
* <a href="#OnPlanRoadPlaced">OnPlanRoadPlaced</a>
* <a href="#OnPlanRoadRemoved">OnPlanRoadRemoved</a>
* <a href="#OnPlanWinefieldDigged">OnPlanWinefieldDigged</a>
* <a href="#OnPlanWinefieldPlaced">OnPlanWinefieldPlaced</a>
* <a href="#OnPlanWinefieldRemoved">OnPlanWinefieldRemoved</a>
* <a href="#OnPlayerDefeated">OnPlayerDefeated</a>
* <a href="#OnPlayerVictory">OnPlayerVictory</a>
* <a href="#OnRoadBuilt">OnRoadBuilt</a>
* <a href="#OnTick">OnTick</a>
* <a href="#OnUnitAfterDied">OnUnitAfterDied</a>
* <a href="#OnUnitAfterDiedEx">OnUnitAfterDiedEx</a>
* <a href="#OnUnitAttacked">OnUnitAttacked</a>
* <a href="#OnUnitDied">OnUnitDied</a>
* <a href="#OnUnitDismissed">OnUnitDismissed</a>
* <a href="#OnUnitTrained">OnUnitTrained</a>
* <a href="#OnUnitWounded">OnUnitWounded</a>
* <a href="#OnWareProduced">OnWareProduced</a>
* <a href="#OnWarriorEquipped">OnWarriorEquipped</a>
* <a href="#OnWarriorWalked">OnWarriorWalked</a>
* <a href="#OnWinefieldBuilt">OnWinefieldBuilt</a>
* <a href="#OnWoodcuttersModeChanged">OnWoodcuttersModeChanged</a>
<br />

| Ver<br/>sion | Event description | Parameters<br/>and types |
| ------- | ------------------------------------ | -------------- |
| 6570 | <a id="OnBeacon">OnBeacon</a><sub><br/>Occurs when a player places a beacon on the map.</sub> | <sub>**aPlayer**: Integer; <br/> **aX, aY**: Integer;</sub> |
| 7000+ | <a id="OnFieldBuilt">OnFieldBuilt</a><sub><br/>Occurs when player built a field.</sub> | <sub>**aPlayer**: Integer; <br/> **aX, aY**: Integer;</sub> |
| 11000 | <a id="OnGameSpeedChanged">OnGameSpeedChanged</a><sub><br/>Occurs when game speed was changed</sub> | <sub>**aSpeed**: Single;</sub> |
| 11200 | <a id="OnGroupBeforeOrderSplit">OnGroupBeforeOrderSplit</a><sub><br/>Occurs right before the group gets order to split.<br/>Split parameters could be altered by script and returned to the game to be used there</sub> | <sub>**aGroup**: Integer; // _group ID, which got split order_ <br/> **var aNewType**: TKMUnitType; // _new group leader unit type_ <br/> **var aNewCnt**: Integer; // _new group members count_ <br/> **var aMixed**: Boolean; // _is new group can have the only unit type or it can have any unit type from original group_</sub> |
| 6220 | <a id="OnGroupHungry">OnGroupHungry</a><sub><br/>Occurs when the player would be shown a message about a group being hungry<br/>(when they first get hungry, then every 4 minutes after that if there are still hungry group members).<br/>Occurs regardless of whether the group has hunger messages enabled or not.</sub> | <sub>**aGroup**: Integer;</sub> |
| 7000+ | <a id="OnGroupOrderAttackHouse">OnGroupOrderAttackHouse</a><sub><br/>Occurs when the group gets order to attack house</sub> | <sub>**aGroup**: Integer; // _attackers group ID_ <br/> **aHouse**: Integer; // _target house ID_</sub> |
| 7000+ | <a id="OnGroupOrderAttackUnit">OnGroupOrderAttackUnit</a><sub><br/>Occurs when the group gets order to attack unit</sub> | <sub>**aGroup**: Integer; // _attackers group ID_ <br/> **aUnit**: Integer; // _target unit ID_</sub> |
| 7000+ | <a id="OnGroupOrderLink">OnGroupOrderLink</a><sub><br/>Occurs when the group1 gets order to link to group2</sub> | <sub>**aGroup1**: Integer; // _link group ID_ <br/> **aGroup2**: Integer; // _link target group ID_</sub> |
| 7000+ | <a id="OnGroupOrderMove">OnGroupOrderMove</a><sub><br/>Occurs when the group gets order to move to some point<br/>aX, aY: Point coordinates</sub> | <sub>**aGroup**: Integer; // _group ID_ <br/> **aX, aY**: Integer; <br/> **aDir**: TKMDirection;</sub> |
| 7000+ | <a id="OnGroupOrderSplit">OnGroupOrderSplit</a><sub><br/>Occurs when the group gets order to split</sub> | <sub>**aGroup**: Integer; // _group ID_ <br/> **aNewGroup**: Integer; // _splitted group ID_</sub> |
| 6114 | <a id="OnHouseAfterDestroyed">OnHouseAfterDestroyed</a><sub><br/>Occurs after a house is destroyed and has been completely removed from the game,<br/>meaning the area it previously occupied can be used.<br/>If you need more information about the house use the OnHouseDestroyed event.<br/>aHouseType as Integer from Lookup table</sub> | <sub>**aHouseType**: Integer; <br/> **aOwner**: Integer; <br/> **aX, aY**: Integer;</sub> |
| 14000 | <a id="OnHouseAfterDestroyedEx">OnHouseAfterDestroyedEx</a><sub><br/>Occurs after a house is destroyed and has been completely removed from the game,<br/>meaning the area it previously occupied can be used.<br/>If you need more information about the house use the OnHouseDestroyed event.</sub> | <sub>**aHouseType**: TKMHouseType; // _as TKMHouseType_ <br/> **aOwner**: Integer; <br/> **aX, aY**: Integer;</sub> |
| 5057 | <a id="OnHouseBuilt">OnHouseBuilt</a><sub><br/>Occurs when player has built a house.</sub> | <sub>**aHouse**: Integer;</sub> |
| 5882 | <a id="OnHouseDamaged">OnHouseDamaged</a><sub><br/>Occurs when a house gets damaged (e.g. by the enemy soldier).<br/>Attacker is -1 the house was damaged some other way, such as from Actions.HouseAddDamage.</sub> | <sub>**aHouse**: Integer; <br/> **aAttacker**: Integer;</sub> |
| 15250 | <a id="OnHouseDeliveryModeChanged">OnHouseDeliveryModeChanged</a><sub><br/>Occurs when a house delivery mode changed.</sub> | <sub>**aHouse**: Integer; <br/> **aOldMode**: TKMDeliveryMode; <br/> **aNewMode**: TKMDeliveryMode;</sub> |
| 5407 | <a id="OnHouseDestroyed">OnHouseDestroyed</a><sub><br/>Occurs when a house is destroyed.<br/>If DestroyerIndex is -1 the house was destroyed some other way, such as from Actions.HouseDestroy.<br/>If DestroyerIndex is the same as the house owner (States.HouseOwner), the house was demolished by the player who owns it.<br/>Otherwise it was destroyed by an enemy.<br/>Called just before the house is destroyed so HouseID is usable only during this event, and the area occupied by the house is still unusable.</sub> | <sub>**aHouse**: Integer; <br/> **aDestroyerIndex**: Integer; // _Index of player who destroyed it_</sub> |
| 15250 | <a id="OnHouseFlagPointChanged">OnHouseFlagPointChanged</a><sub><br/>aOldX, aOldY - Coordinates of the previous FlagPoint position<br/>aNewX, aNewY - Coordinates of the new FlagPoint position<br/>Occurs when a house flag point position is changed</sub> | <sub>**aHouse**: Integer; <br/> **aOldX**: Integer; <br/> **aOldY**: Integer; <br/> **aNewX**: Integer; <br/> **aNewY**: Integer;</sub> |
| 7000+ | <a id="OnHousePlanDigged">OnHousePlanDigged</a><sub><br/>Occurs when house plan is digged.</sub> | <sub>**aHouse**: Integer;</sub> |
| 5871 | <a id="OnHousePlanPlaced">OnHousePlanPlaced</a><sub><br/>Occurs when player has placed a house plan.</sub> | <sub>**aPlayer**: Integer; <br/> **aX, aY**: Integer; <br/> **aHouseType**: Integer; // _as Integer from Lookup table_</sub> |
| 14000 | <a id="OnHousePlanPlacedEx">OnHousePlanPlacedEx</a><sub><br/>Occurs when player has placed a house plan.</sub> | <sub>**aPlayer**: Integer; <br/> **aX, aY**: Integer; <br/> **aHouseType**: TKMHouseType; // _as TKMHouseType_</sub> |
| 6298 | <a id="OnHousePlanRemoved">OnHousePlanRemoved</a><sub><br/>Occurs when player has removed a house plan.</sub> | <sub>**aPlayer**: Integer; <br/> **aX, aY**: Integer; <br/> **aHouseType**: Integer; // _as Integer from Lookup table_</sub> |
| 14000 | <a id="OnHousePlanRemovedEx">OnHousePlanRemovedEx</a><sub><br/>Occurs when player has removed a house plan.</sub> | <sub>**aPlayer**: Integer; <br/> **aX, aY**: Integer; <br/> **aHouseType**: TKMHouseType; // _as TKMHouseType_</sub> |
| 13700 | <a id="OnHouseRepaired">OnHouseRepaired</a><sub><br/>Occurs when a house gets repaired.<br/>The event gets fired for each repair action</sub> | <sub>**aHouse**: Integer; // _House ID_ <br/> **aRepairAmount**: Integer; // _how much house was repaired_ <br/> **aDamage**: Integer; // _house damage after repairement_</sub> |
| 10750 | <a id="OnHouseWareCountChanged">OnHouseWareCountChanged</a><sub><br/>Occurs when ware count is changed in house</sub> | <sub>**aHouse**: Integer; <br/> **aWare**: TKMWareType; <br/> **aCnt**: Integer; // _current ware count in house (after change)_ <br/> **aChangeCnt**: Integer; // _ware change count. if aChangeCnt > 0 count increased, if aChangeCnt < 0 count decreased_</sub> |
| 6216 | <a id="OnMarketTrade">OnMarketTrade</a><sub><br/>Occurs when a trade happens in a market (at the moment when resources are exchanged by serfs).</sub> | <sub>**aMarket**: Integer; <br/> **aFrom**: Integer; // _as Integer from Lookup table_ <br/> **aTo**: Integer; // _as Integer from Lookup table_</sub> |
| 14000 | <a id="OnMarketTradeEx">OnMarketTradeEx</a><sub><br/>Occurs when a trade happens in a market (at the moment when resources are exchanged by serfs).</sub> | <sub>**aMarket**: Integer; <br/> **aFrom**: TKMWareType; // _as TKMWareType_ <br/> **aTo**: TKMWareType; // _as TKMWareType_</sub> |
| 5057 | <a id="OnMissionStart">OnMissionStart</a><sub><br/>Occurs immediately after the mission is loaded.</sub> | <sub></sub> |
| 11000 | <a id="OnPeacetimeEnd">OnPeacetimeEnd</a><sub><br/>Occurs immediately after the end of peacetime</sub> | <sub></sub> |
| 5964 | <a id="OnPlanFieldPlaced">OnPlanFieldPlaced</a><sub><br/>Occurs when player has placed a field plan.</sub> | <sub>**aPlayer**: Integer; <br/> **aX, aY**: Integer;</sub> |
| 6301 | <a id="OnPlanFieldRemoved">OnPlanFieldRemoved</a><sub><br/>Occurs when player has removed a field plan.</sub> | <sub>**aPlayer**: Integer; <br/> **aX, aY**: Integer;</sub> |
| 7000+ | <a id="OnPlanRoadDigged">OnPlanRoadDigged</a><sub><br/>Occurs when road plan is digged.</sub> | <sub>**aPlayer**: Integer; <br/> **aX, aY**: Integer;</sub> |
| 5964 | <a id="OnPlanRoadPlaced">OnPlanRoadPlaced</a><sub><br/>Occurs when player has placed a road plan.</sub> | <sub>**aPlayer**: Integer; <br/> **aX, aY**: Integer;</sub> |
| 6301 | <a id="OnPlanRoadRemoved">OnPlanRoadRemoved</a><sub><br/>Occurs when player has removed a road plan.</sub> | <sub>**aPlayer**: Integer; <br/> **aX, aY**: Integer;</sub> |
| 7000+ | <a id="OnPlanWinefieldDigged">OnPlanWinefieldDigged</a><sub><br/>Occurs when winefield is digged</sub> | <sub>**aPlayer**: Integer; <br/> **aX, aY**: Integer;</sub> |
| 5964 | <a id="OnPlanWinefieldPlaced">OnPlanWinefieldPlaced</a><sub><br/>Occurs when player has placed a wine field plan.</sub> | <sub>**aPlayer**: Integer; <br/> **aX, aY**: Integer;</sub> |
| 6301 | <a id="OnPlanWinefieldRemoved">OnPlanWinefieldRemoved</a><sub><br/>Occurs when player has removed a wine field plan.</sub> | <sub>**aPlayer**: Integer; <br/> **aX, aY**: Integer;</sub> |
| 5057 | <a id="OnPlayerDefeated">OnPlayerDefeated</a><sub><br/>Occurs when certain player has been defeated.<br/>Defeat conditions are checked separately by Player AI.</sub> | <sub>**aPlayer**: Integer;</sub> |
| 5057 | <a id="OnPlayerVictory">OnPlayerVictory</a><sub><br/>Occurs when certain player is declared victorious.<br/>Victory conditions are checked separately by Player AI.</sub> | <sub>**aPlayer**: Integer;</sub> |
| 7000+ | <a id="OnRoadBuilt">OnRoadBuilt</a><sub><br/>Occurs when player built a road.</sub> | <sub>**aPlayer**: Integer; <br/> **aX, aY**: Integer;</sub> |
| 5057 | <a id="OnTick">OnTick</a><sub><br/>Occurs every game logic update.</sub> | <sub></sub> |
| 6114 | <a id="OnUnitAfterDied">OnUnitAfterDied</a><sub><br/>Occurs after a unit has died and has been completely removed from the game, meaning the tile it previously occupied can be used.<br/>If you need more information about the unit use the OnUnitDied event.<br/>Note: Because units have a death animation there is a delay of several ticks between OnUnitDied and OnUnitAfterDied.</sub> | <sub>**aUnitType**: Integer; // _as Integer from Lookup table_ <br/> **aOwner**: Integer; <br/> **aX, aY**: Integer;</sub> |
| 14000 | <a id="OnUnitAfterDiedEx">OnUnitAfterDiedEx</a><sub><br/>Occurs after a unit has died and has been completely removed from the game, meaning the tile it previously occupied can be used.<br/>If you need more information about the unit use the OnUnitDied event.<br/>Note: Because units have a death animation there is a delay of several ticks between OnUnitDied and OnUnitAfterDied.</sub> | <sub>**aUnitType**: TKMUnitType; // _as TKMUnitType_ <br/> **aOwner**: Integer; <br/> **aX, aY**: Integer;</sub> |
| 6587 | <a id="OnUnitAttacked">OnUnitAttacked</a><sub><br/>Happens when a unit is attacked (shot at by archers, hit in melee, or shot by a tower).<br/>Attacker can be a warrior, recruit in tower or unknown (-1).<br/>This event will occur very frequently during battles.</sub> | <sub>**aUnit**: Integer; <br/> **aAttacker**: Integer; // _Unit who attacked the unit_</sub> |
| 5407 | <a id="OnUnitDied">OnUnitDied</a><sub><br/>Occurs when a unit dies. If KillerIndex is -1 the unit died from another cause such as hunger or Actions.UnitKill.<br/>Called just before the unit is killed so UnitID is usable only during this event,<br/>and the tile occupied by the unit is still taken.</sub> | <sub>**aUnit**: Integer; <br/> **aKillerOwner**: Integer; // _Index of player who killed it_</sub> |
| 15250 | <a id="OnUnitDismissed">OnUnitDismissed</a><sub><br/>Occurs when a unit is dissmised.<br/>Called just before the unit is dissmised so UnitID is usable only during this event,<br/>and the tile occupied by the unit is still taken.</sub> | <sub>**aUnit**: Integer;</sub> |
| 5057 | <a id="OnUnitTrained">OnUnitTrained</a><sub><br/>Occurs when player trains a unit.</sub> | <sub>**aUnit**: Integer;</sub> |
| 5884 | <a id="OnUnitWounded">OnUnitWounded</a><sub><br/>Happens when unit is wounded.<br/>Attacker can be a warrior, recruit in tower or unknown (-1).</sub> | <sub>**aUnit**: Integer; <br/> **aAttacker**: Integer; // _Unit who attacked the unit_</sub> |
| 14000 | <a id="OnWareProduced">OnWareProduced</a><sub><br/>Occurs when resource is produced for specified house.</sub> | <sub>**aHouse**: Integer; <br/> **aWareType**: TKMWareType; <br/> **aCount**: Integer;</sub> |
| 5057 | <a id="OnWarriorEquipped">OnWarriorEquipped</a><sub><br/>Occurs when player equips a warrior.</sub> | <sub>**aUnit**: Integer; <br/> **aGroup**: Integer;</sub> |
| 7000+ | <a id="OnWarriorWalked">OnWarriorWalked</a><sub><br/>Occurs when warrior walk</sub> | <sub>**aUnit**: Integer; <br/> **aToX**: Integer; <br/> **aToY**: Integer;</sub> |
| 7000+ | <a id="OnWinefieldBuilt">OnWinefieldBuilt</a><sub><br/>Occurs when player built a winefield.</sub> | <sub>**aPlayer**: Integer; <br/> **aX, aY**: Integer;</sub> |
| 15250 | <a id="OnWoodcuttersModeChanged">OnWoodcuttersModeChanged</a><sub><br/>Occurs when woodcutters mode changed.</sub> | <sub>**aHouse**: Integer; <br/> **aOldMode**: TKMWoodcutterMode; <br/> **aNewMode**: TKMWoodcutterMode;</sub> |
