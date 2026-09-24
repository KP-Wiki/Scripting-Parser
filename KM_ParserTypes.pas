unit KM_ParserTypes;
interface


type
  TKMParsingGame = (pgKaMRemake, pgKnightsProvince);
  TKMParsingArea = (paActions, paEvents, paStates, paUtils, paTypes);


const
  GAME_INFO: array [TKMParsingGame] of record Ext, Name: string; end = (
    (Ext: 'kmr'; Name: 'KaM Remake'),
    (Ext: 'kp';  Name: 'Knights Province')
  );

  // Denotes regions where Events, States, Actions, Types, Utils are located
  AREA_INFO: array [TKMParsingArea] of record
    Name: string;  // Name of the area. Used in the logs and for reference md-s in this repo
    CheckTag: string;   // Tag used for the Check region
    RegTag: string;     // Tag used for the Register region
    NeedsReturn: Boolean;
  end = (
    (Name: 'Actions'; CheckTag: '//*Actions-Check*//'; RegTag:'//*Actions-Reg*//'; NeedsReturn: True),
    (Name: 'Events';  CheckTag: '//*Events-Check*//';  RegTag:'//*Events-Reg*//';  NeedsReturn: False),
    (Name: 'States';  CheckTag: '//*States-Check*//';  RegTag:'//*States-Reg*//';  NeedsReturn: True),
    (Name: 'Utils';   CheckTag: '//*Utils-Check*//';   RegTag:'//*Utils-Reg*//';   NeedsReturn: True),
    (Name: 'Types';   CheckTag: '//*Types-Check*//';   RegTag:'//*Types-Reg*//';   NeedsReturn: False)
  );


implementation


end.
