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

  AREA_INFO: array [TKMParsingArea] of record Short, CheckTag, RegTag: string; NeedsReturn: Boolean; end = (
    (Short: 'Actions'; CheckTag: '//*Actions-Check*//'; RegTag:'//*Actions-Reg*//'; NeedsReturn: True),
    (Short: 'Events';  CheckTag: '//*Events-Check*//';  RegTag:'';                  NeedsReturn: False),
    (Short: 'States';  CheckTag: '//*States-Check*//';  RegTag:'//*States-Reg*//';  NeedsReturn: True),
    (Short: 'Utils';   CheckTag: '//*Utils-Check*//';   RegTag:'//*Utils-Reg*//';   NeedsReturn: True),
    (Short: 'Types';   CheckTag: '//*Types-Check*//';   RegTag:'//*Types-Reg*//';   NeedsReturn: False)
  );


implementation


end.
