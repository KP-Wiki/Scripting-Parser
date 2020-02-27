####Events

| Ver<br/>sion | Event Description | Parameters<br/>and types |
| ------- | ------------------------------------ | -------------- |
| 8250 | OnCampaignMenu<sub><br/>A campaign menu has been opened. Campaign-only action!</sub> | <sub></sub> |
| - | OnHouseBuilt<sub><br/>A house has finished construction</sub> | <sub>**aHouse**: Integer;</sub> |
| 7820 | OnHouseDamaged<sub><br/>A house got damaged</sub> | <sub>**aHouse**: Integer; <br/> **aAttacker**: Integer; //_Attacker - UID of the attacked, can be a house, a unit or noone (e.g. if damage was applied from script)_</sub> |
| - | OnHouseDestroyed<sub></sub> | <sub>**aHouse**: Integer; <br/> **aDestroyerIndex**: Integer;</sub> |
| - | OnHousePlanPlaced<sub></sub> | <sub>**aPlayer**: Integer; <br/> **aX**: Word; <br/> **aY**: Word; <br/> **aType**: TKMHouseType;</sub> |
| - | OnMissionStart<sub><br/>Happens right before OnTick(1);</sub> | <sub></sub> |
| - | OnPlayerDefeated<sub><br/>Happens when player gets defeated</sub> | <sub>**aPlayer**: Integer;</sub> |
| - | OnPlayerVictory<sub><br/>Happens when player gets victory</sub> | <sub>**aPlayer**: Integer;</sub> |
| 7996 | OnScriptButtonClick<sub><br/>Occurs when player clicks on a button in the message.<br/>Note that click events may come in late and/or repeated.</sub> | <sub>**aPlayer**: Integer; //_Player who clicked the button_ <br/> **aTag**: Integer; //_Tag of the button_</sub> |
| 5102 | OnTerrainTrigger<sub><br/>Happens when a unit enters terrain trigger area (or gets spawned in to it, or exits a house)</sub> | <sub>**aTriggerId**: Integer; <br/> **aUnit**: Integer; <br/> **aX**: Word; <br/> **aY**: Word;</sub> |
| - | OnTick<sub><br/>Happens right after OnMissionStart;<br/>First tick is '1'</sub> | <sub>**aTick**: Integer;</sub> |
| - | OnUnitDied<sub></sub> | <sub>**aUnit**: Integer; <br/> **aKillerOwner**: Integer;</sub> |
| 7023 | OnUnitGiven<sub></sub> | <sub>**aUnit**: Integer;</sub> |
| - | OnUnitTrained<sub></sub> | <sub>**aUnit**: Integer;</sub> |
| 4349 | OnUnitWoundedByHouse<sub><br/>A unit was attacked by an enemy house (surely a Tower)</sub> | <sub>**aUnit**: Integer; <br/> **aAttackerHouse**: Integer;</sub> |
| 4349 | OnUnitWoundedByUnit<sub><br/>A unit was attacked by an enemy unit</sub> | <sub>**aUnit**: Integer; <br/> **aAttackerUnit**: Integer;</sub> |
| - | OnWarriorEquipped<sub></sub> | <sub>**aUnit**: Integer; <br/> **aGroup**: Integer;</sub> |
