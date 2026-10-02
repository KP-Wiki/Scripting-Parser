unit KM_DocumenterTypes;
interface


type
  TKMParsingGame = (pgKaMRemake, pgKnightsProvince);
  TKMScriptingArea = (paActions, paEvents, paStates, paUtils, paTypes);

  // Set of paths required for one job
  TKMDocumenterPathSet = record
  public
    SourceInput: string;    // Supports wildcards
    WikiTemplate: string;
    WikiOutput: string;
    SourceOutput1: string;
    SourceOutput2: string;
  end;

const
  GAME_INFO: array [TKMParsingGame] of record Ext, Name: string; end = (
    (Ext: 'kmr'; Name: 'KaM Remake'),
    (Ext: 'kp';  Name: 'Knights Province')
  );

  LOG_MESSAGE_NAME: array [TKMParsingGame] of string = (
    'LogParamWarn',   // KMR
    'LogParamWarning' // KP
  );

  // Denotes specification details for scripting domains (Events, States, Actions, Types, Utils)
  SCRIPTING_AREA_SPEC: array [TKMScriptingArea] of record
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

  // We need to annotate modding regions to avoid clashing with Type declarations
  DOC_TAG_AREA_MODDING_SPECIFICATION = '//*Area-Modding-Specification*//';

  // Modding types documentation tags
  DOC_TAG_MODDING_TYPE_IS_ROOT      = '//* Type-IsRoot:';       // Root type
  DOC_TAG_MODDING_TYPE_NAME         = '//* Type-Name:';         // Type name when it is impractical to parse
  DOC_TAG_MODDING_TYPE_NODENAME     = '//* Type-NodeName:';     // Next line will contain xml node name
  DOC_TAG_MODDING_TYPE_CAPTION      = '//* Type-Caption:';      // Caption name
  DOC_TAG_MODDING_TYPE_DESCRIPTION  = '//* Type-Description:';  // Description
  DOC_TAG_MODDING_TYPE_SPECIALTY    = '//* Type-Specialty:';    // Special

  DOC_TAG_MODDING_NODE_IS_REQUIRED  = '//* Node-IsRequired:';   // Node is required
  DOC_TAG_MODDING_REFERENCE_NODE    = '//* Reference-Node:';    // Reference to another type
  DOC_TAG_MODDING_REFERENCE_ATTR    = '//* Reference-Attr:';    // Reference to another type
  DOC_TAG_MODDING_LIST = '//* ListForNextNode:';     // Reference to another type


type
  TKMModdingTypeSpecialty = (
    mtsNormal,
    mtsSemicolonDelimitedArray,
    mtsList
  );

const
  MODDING_TYPE_SPECIALTY_NAME: array [TKMModdingTypeSpecialty] of string = (
    '',
    'SemicolonDelimitedArray',
    'List'
  );


implementation


end.
