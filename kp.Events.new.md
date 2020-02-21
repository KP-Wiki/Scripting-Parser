####Events

| Ver<br>sion | Event Description | Parameters<br>and types |
| ------- | ------------------------------------ | -------------- |
| 8250 | OnCampaignMenu<br><sub> A campaign menu has been opened. Campaign-only action!</sub> | <sub></sub> |
| - | OnHouseBuilt<br><sub> A house has finished construction</sub> | <sub>**aHouse**: Integer;</sub> |
| 7820 | OnHouseDamaged<br><sub> A house got damaged</sub> | <sub>**aHouse**: Integer; <br> **aAttacker**: Integer; //_Attacker - UID of the attacked, can be a house, a unit or noone (e.g. if damage was applied from script)_</sub> |
| - | OnHouseDestroyed<br><sub></sub> | <sub>**aHouse**: Integer; <br> **aDestroyerIndex**: Integer;</sub> |
| - | OnHousePlanPlaced<br><sub></sub> | <sub>**aPlayer**: Integer; <br> **aX**: Word; <br> **aY**: Word; <br> **aType**: TKMHouseType;</sub> |
| - | OnMissionStart<br><sub> Happens right before OnTick(1);</sub> | <sub></sub> |
| - | OnPlayerDefeated<br><sub> Happens when player gets defeated</sub> | <sub>**aPlayer**: Integer;</sub> |
| - | OnPlayerVictory<br><sub> Happens when player gets victory</sub> | <sub>**aPlayer**: Integer;</sub> |
| 7996 | OnScriptButtonClick<br><sub> Occurs when player clicks on a button in the message. Note that click events may come in late and/or repeated.</sub> | <sub>**aPlayer**: Integer; //_Player who clicked the button_ <br> **aTag**: Integer; //_Tag of the button_</sub> |
| 5102 | OnTerrainTrigger<br><sub> Happens when a unit enters terrain trigger area (or gets spawned in to it, or exits a house)</sub> | <sub>**aTriggerId**: Integer; <br> **aUnit**: Integer; <br> **aX**: Word; <br> **aY**: Word;</sub> |
| - | OnTick<br><sub> Happens right after OnMissionStart; First tick is '1'</sub> | <sub>**aTick**: Integer;</sub> |
| - | OnUnitDied<br><sub></sub> | <sub>**aUnit**: Integer; <br> **aKillerOwner**: Integer;</sub> |
| 7023 | OnUnitGiven<br><sub></sub> | <sub>**aUnit**: Integer;</sub> |
| - | OnUnitTrained<br><sub></sub> | <sub>**aUnit**: Integer;</sub> |
| 4349 | OnUnitWoundedByHouse<br><sub> A unit was attacked by an enemy house (surely a Tower)</sub> | <sub>**aUnit**: Integer; <br> **aAttackerHouse**: Integer;</sub> |
| 4349 | OnUnitWoundedByUnit<br><sub> A unit was attacked by an enemy unit</sub> | <sub>**aUnit**: Integer; <br> **aAttackerUnit**: Integer;</sub> |
| - | OnWarriorEquipped<br><sub></sub> | <sub>**aUnit**: Integer; <br> **aGroup**: Integer;</sub> |
