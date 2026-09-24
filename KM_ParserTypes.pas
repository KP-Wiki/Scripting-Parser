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
    Name: string;         // Name of the area. Used in the logs and for reference md-s in this repo
    CheckTag: string;     // Tag used for the Check region
    RegTag: string;       // Tag used for the Register region
    NeedsReturn: Boolean; // Wherever wiki needs return type column for this area (Actions, States, Utils)
  end = (
    (Name: 'Actions'; CheckTag: '//*Area-Actions-Check*//'; RegTag:'//*Area-Actions-Reg*//'; NeedsReturn: True),
    (Name: 'Events';  CheckTag: '//*Area-Events-Check*//';  RegTag:'//*Area-Events-Reg*//';  NeedsReturn: False),
    (Name: 'States';  CheckTag: '//*Area-States-Check*//';  RegTag:'//*Area-States-Reg*//';  NeedsReturn: True),
    (Name: 'Utils';   CheckTag: '//*Area-Utils-Check*//';   RegTag:'//*Area-Utils-Reg*//';   NeedsReturn: True),
    (Name: 'Types';   CheckTag: '//*Area-Types-Check*//';   RegTag:'//*Area-Types-Reg*//';   NeedsReturn: False)
  );


  // Long comments may contain whole paragraphs, hence //* has to stay without a whitespace
  DOC_TAG = '//*';
  DOC_TAG_VERSION = '//* Version:';
  DOC_TAG_STATUS = '//* Status:';
  DOC_TAG_STATUS_DEPRECATED = 'Deprecated';
  DOC_TAG_STATUS_CHANGED = 'Changed';
  DOC_TAG_STATUS_REMOVED = 'Removed';
  DOC_TAG_REPLACEMENT = '//* Replacement:';
  DOC_TAG_RESULT = '//* Result:';

  DOC_TAG_AREA = '//*Area';


implementation


end.
