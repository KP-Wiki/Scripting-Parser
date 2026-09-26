### Modding types

Description of moddable types used in Knights Province.

***

* <a href="#Map object">Map object</a>
* <a href="#Terrain decal">Terrain decal</a>

<br/>

### <a id="Map object">Map object</a>

| Field name | Field type | Required | Description |
| ---------- | ---------- | -------- | ----------- |
| EngName | String | Required | Objects that can be placed on terrain.<br/>Unique identifier of the map object. |
| CanPlaceInMapEd | Boolean | True) | If the map object can be placed in the Map Editor.<br/>Some objects require special handling and should be not placeable (e.g. grain, orchards, coalpiles). |
| Placement | String | Required | Placement of the object - tile or vertice.<br/>- csTile<br/>- csVertice |
| Multiple | Integer | 1) | How many instances of the object are placed at once (1, 2, 36). |
| GrowTarget | String | '') | What will this object grow into. Used for trees. |
| GrowTime | Integer | 0) | How long in game ticks will it tage to grow. |
| Sway | Float | 0) | How much does the object sway in the wind (0.0 .. 1.0). |
| ScaleVariation | Float | 0) | How much do object instances scale in size. |
| Foliage | Boolean | False) | Is this object a foliage model (trees, bushes). |
| FoliageScale | Float | 1.0) | Foliage scale. |
| AvatarSetup |  | Required | HUD configuration.<br/>Still needed even if the decal itself is not selectable - it is used in MapEd palettes.<br/>- camera distance<br/>- camera height<br/>- camera target height<br/>- model offset X<br/>- model offset Y<br/>- model heading angle<br/>Default values are "6.0;3.0;1.5;0;0;145" |
| Removable | String | Required | Is object removable. |
| Selectable | Boolean | False) | Is object selectable. |
| ColorMinimap | Cardinal | Required | Color of the object ion the minimap. |
| AllowedHumiditySet | String | Required | Terrain humidity suitable for this decal (e.g. ore decals can be placed only on rock). Use "" for all. |
| Flags | String | Required | Set of flags for the object:<br/>- repelTrees - woodcutter will not plant new trees around this object.<br/>- treeSapling - object is a tree sapling.<br/>- treeCuttable - object is a cuttable tree.<br/>- treeStump  - object is a stump of a tree. Woodcutter will prefer planting new trees on its place. |

### <a id="Terrain decal">Terrain decal</a>

| Field name | Field type | Required | Description |
| ---------- | ---------- | -------- | ----------- |
| EngName | String | Required | Declas that can be placed onto terrain tiles.<br/>Unique identifier of the decal. |
| AllowedHumiditySet | String | '')) | Terrain humidity suitable for this decal (e.g. ore decals can be placed only on rock). Use "" for all. |
| IsPassable | Boolean | Required | Wherever this decal can be walk over by units. |
| IsBuildable | Boolean | Required | Wherever roads and houses can be built on top of this decal. |
| MinimapColor | Cardinal | 0)) | Color of the decal on the minimap. Use 0 for none. |
| ReplaceTile | Boolean | False) | Wherever this decal replaces terrain on the tile. |
| GoldDeposit | Integer | 0) | Amount of gold this ore decal contains. Up to 255. Use on your own risk. |
| IronDeposit | Integer | 0) | Amount of iron this ore decal contains. Up to 255. Use on your own risk. |
| StoneDeposit | Integer | 0) | Amount of stone this ore decal contains. Up to 255. Use on your own risk. |
| Selectable | Boolean | False) | Can be select to see its info in the HUD. |
| ModelHeight | Float | 0.0) | Height of the model for HitTest. Can be set slightly lower than the actual model for better match.<br/>Not needed if the object is not selectable. |
| AvatarSetup |  | Required | HUD avatar setup.<br/>Still needed even if the decal itself is not selectable - it is used in MapEd palettes.<br/>Default values are "3.8;1.4;0.5;0;0;145" |

