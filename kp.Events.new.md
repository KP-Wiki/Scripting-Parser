### Events

Events are written in a form `procedure EVENT_NAME(EVENT_PARAMETERS);` like so:
```pascal
    procedure OnHouseBuilt(aHouseID: Integer);
    begin
      // code
    end;
```

Version column description:  
<sub>"-" Means this event was added from the start.</sub>  
<sub>"5678" Means this event was introduced in revision 5678.</sub>  
<sub>"-5678" Means this event was removed in revision 5678.</sub>


***

* <a href="#OnCampaignMenu">OnCampaignMenu</a>
* <a href="#OnGroupBeforeDied">OnGroupBeforeDied</a>
* <a href="#OnGroupDied">OnGroupDied</a>
* <a href="#OnHouseBuilt">OnHouseBuilt</a>
* <a href="#OnHouseDamaged">OnHouseDamaged</a>
* <a href="#OnHouseDestroyed">OnHouseDestroyed</a>
* <a href="#OnHousePlanPlaced">OnHousePlanPlaced</a>
* <a href="#OnMapObjectClick">OnMapObjectClick</a>
* <a href="#OnMissionStart">OnMissionStart</a>
* <a href="#OnPlayerDefeated">OnPlayerDefeated</a>
* <a href="#OnPlayerVictory">OnPlayerVictory</a>
* <a href="#OnScriptButtonClick">OnScriptButtonClick</a>
* <a href="#OnScriptMarkerClick">OnScriptMarkerClick</a>
* <a href="#OnTerrainTrigger">OnTerrainTrigger</a>
* <a href="#OnTick">OnTick</a>
* <a href="#OnUnitBeforeDied">OnUnitBeforeDied</a>
* <a href="#OnUnitDied">OnUnitDied</a>
* <a href="#OnUnitGiven">OnUnitGiven</a>
* <a href="#OnUnitOwnerChanged">OnUnitOwnerChanged</a>
* <a href="#OnUnitOwnerChanging">OnUnitOwnerChanging</a>
* <a href="#OnUnitTrained">OnUnitTrained</a>
* <a href="#OnUnitWagonEnteredHouse">OnUnitWagonEnteredHouse</a>
* <a href="#OnUnitWoundedByHouse">OnUnitWoundedByHouse</a>
* <a href="#OnUnitWoundedByUnit">OnUnitWoundedByUnit</a>
* <a href="#OnWarriorEquipped">OnWarriorEquipped</a>
<br />

| Ver<br/>sion | Event description | Parameters<br/>and types |
| ------- | ------------------------------------ | -------------- |
| 8250 | <a id="OnCampaignMenu">OnCampaignMenu</a><sub><br/>A campaign menu has been opened. Campaign-only action!</sub> | <sub></sub> |
| 10626 | <a id="OnGroupBeforeDied">OnGroupBeforeDied</a><sub><br/>Group will cease to exist in a moment (last current member will die). The process is irreversible<br/>Most of the group properties can still be accessed<br/>Note that groups can be rearranged, split and joined. Single warrior is a group too.</sub> | <sub>**aGroup**: Integer;</sub> |
| 10626 | <a id="OnGroupDied">OnGroupDied</a><sub><br/>Group has ceased to exist (all current members have died). The process is irreversible<br/>Most of the group properties can no longer be accessed<br/>Note that groups can be rearranged, split and joined. Single warrior is a group too.</sub> | <sub>**aGroup**: Integer;</sub> |
| - | <a id="OnHouseBuilt">OnHouseBuilt</a><sub><br/>A house has finished construction</sub> | <sub>**aHouse**: Integer;</sub> |
| 7820 | <a id="OnHouseDamaged">OnHouseDamaged</a><sub><br/>A house got damaged</sub> | <sub>**aHouse**: Integer; <br/> **aAttacker**: Integer; // _UID of the attacked, can be a house, a unit or noone (e.g. if damage was applied from script)_</sub> |
| - | <a id="OnHouseDestroyed">OnHouseDestroyed</a><sub><br/>Occurs right before house gets destroyed</sub> | <sub>**aHouse**: Integer; <br/> **aDestroyerIndex**: Integer;</sub> |
| - | <a id="OnHousePlanPlaced">OnHousePlanPlaced</a><sub><br/>HouseFace added in r10532</sub> | <sub>**aPlayer**: Integer; <br/> **aX, aY**: Word; <br/> **aType**: TKMHouseType; <br/> **aFace**: TKMHouseFace; // _house facing direction_</sub> |
| 14230 | <a id="OnMapObjectClick">OnMapObjectClick</a><sub></sub> | <sub>**aPlayer**: Integer; // _player who clicked the object_ <br/> **aX, aY**: Word; <br/> **aCoord**: Byte; <br/> **aEngName**: AnsiString; // _object name as it was when it was clicked (note, due to multiplayer lag it could have been different than right now)_</sub> |
| - | <a id="OnMissionStart">OnMissionStart</a><sub><br/>Happens right before OnTick(1)</sub> | <sub></sub> |
| - | <a id="OnPlayerDefeated">OnPlayerDefeated</a><sub><br/>Happens when player gets defeated</sub> | <sub>**aPlayer**: Integer;</sub> |
| - | <a id="OnPlayerVictory">OnPlayerVictory</a><sub><br/>Event is fired right before victory gets registered.<br/>It's a good time to set the mission highscore or passing campaign data</sub> | <sub>**aPlayer**: Integer;</sub> |
| 7996 | <a id="OnScriptButtonClick">OnScriptButtonClick</a><sub><br/>Occurs when player clicks on a button in the message.<br/>Note that click events may come in late and/or repeated.</sub> | <sub>**aPlayer**: Integer; // _Player who clicked the button_ <br/> **aTag**: Integer; // _Tag of the button_</sub> |
| 12950 | <a id="OnScriptMarkerClick">OnScriptMarkerClick</a><sub><br/>Occurs when player clicks on an interaction marker<br/>Note that click events may come in late and/or repeated.</sub> | <sub>**aPlayer**: Integer; // _Player who clicked the marker_ <br/> **aMarkerId**: Integer;</sub> |
| 5102 | <a id="OnTerrainTrigger">OnTerrainTrigger</a><sub><br/>Happens when a unit enters terrain trigger area (or gets spawned in to it, or exits a house)</sub> | <sub>**aTriggerId**: Integer; <br/> **aUnit**: Integer; <br/> **aX, aY**: Word;</sub> |
| - | <a id="OnTick">OnTick</a><sub><br/>Happens right after OnMissionStart<br/>First tick is '1'</sub> | <sub>**aTick**: Integer;</sub> |
| 10626 | <a id="OnUnitBeforeDied">OnUnitBeforeDied</a><sub><br/>Unit will cease to exist in a moment. The process is irreversible<br/>Most of the unit properties can still be accessed</sub> | <sub>**aUnit**: Integer; <br/> **aKillerOwner**: Integer;</sub> |
| - | <a id="OnUnitDied">OnUnitDied</a><sub><br/>Unit has died. The process is irreversible<br/>Most of unit properties can no longer be accessed</sub> | <sub>**aUnit**: Integer; <br/> **aKillerOwner**: Integer;</sub> |
| 7023 | <a id="OnUnitGiven">OnUnitGiven</a><sub></sub> | <sub>**aUnit**: Integer;</sub> |
| 10630 | <a id="OnUnitOwnerChanged">OnUnitOwnerChanged</a><sub><br/>Occurs after a unit changes owner.<br/>When a unit changes its owner it actually get silently killed and a new unit gets spawned for a new owner in its place.</sub> | <sub>**aOldUnit**: Integer; // _UID of the unit that was killed (since it is already dead, it can't be used in any States or Actions)._ <br/> **aNewUnit**: Integer; // _UID of the new unit that was spawned (-1 if it failed)_</sub> |
| 14474 | <a id="OnUnitOwnerChanging">OnUnitOwnerChanging</a><sub><br/>Occurs right before unit changes owner.<br/>When a unit changes its owner it actually get silently killed and a new unit gets spawned for a new owner in its place.</sub> | <sub>**aUnit**: Integer; // _UID of the unit that will be silently killed (since it is doomed, it must not be used in any Actions)._ <br/> **aNewOwner**: Integer; // _Player who will get the new identical unit_</sub> |
| - | <a id="OnUnitTrained">OnUnitTrained</a><sub></sub> | <sub>**aUnit**: Integer;</sub> |
| 12050 | <a id="OnUnitWagonEnteredHouse">OnUnitWagonEnteredHouse</a><sub><br/>Occurs when wagon has successfully entered a house. Right before wares get transferred and the wagon is gone</sub> | <sub>**aUnit**: Integer; <br/> **aHouse**: Integer;</sub> |
| 4349 | <a id="OnUnitWoundedByHouse">OnUnitWoundedByHouse</a><sub><br/>A unit was attacked by an enemy house (surely a Tower)</sub> | <sub>**aUnit**: Integer; <br/> **aAttackerHouse**: Integer;</sub> |
| 4349 | <a id="OnUnitWoundedByUnit">OnUnitWoundedByUnit</a><sub><br/>A unit was attacked by an enemy unit</sub> | <sub>**aUnit**: Integer; <br/> **aAttackerUnit**: Integer;</sub> |
| - | <a id="OnWarriorEquipped">OnWarriorEquipped</a><sub></sub> | <sub>**aUnit**: Integer; <br/> **aGroup**: Integer;</sub> |
