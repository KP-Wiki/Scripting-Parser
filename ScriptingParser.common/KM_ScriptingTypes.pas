unit KM_ScriptingTypes;
interface


type
  TKMParsingArea = (paActions, paEvents, paStates, paUtils);
  TKMParsingGame = (pgKaMRemake, pgKnightsProvince);


const
  AREA_SHORT: array [TKMParsingArea] of string = ('Actions', 'Events', 'States', 'Utils');
  GAME_EXT: array [TKMParsingGame] of string = ('kmr', 'kp');
  AREA_NEED_RETURN: array [TKMParsingArea] of Boolean = (True, False, True, True);


implementation


end.
