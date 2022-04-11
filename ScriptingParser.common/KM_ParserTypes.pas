unit KM_ParserTypes;
interface


type
  TKMParsingGame = (pgKaMRemake, pgKnightsProvince);
  TKMParsingArea = (paActions, paEvents, paStates, paUtils, paTypes);


const
  GAME_EXT: array [TKMParsingGame] of string = ('kmr', 'kp');
  AREA_SHORT: array [TKMParsingArea] of string = ('Actions', 'Events', 'States', 'Utils', 'Types');
  AREA_NEED_RETURN: array [TKMParsingArea] of Boolean = (True, False, True, True, False);
  AREA_TITLE: array [TKMParsingArea] of string = ('Action', 'Event', 'State', 'Utility function<br/>', 'Types');
  AREA_TAG: array [TKMParsingArea] of string = ('//*Actions*//', 'Event', 'State', 'Utility function<br/>', 'Types');


implementation


end.
