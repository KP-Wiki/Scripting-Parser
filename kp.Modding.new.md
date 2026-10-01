## Modding types

Description of moddable types used in Knights Province.

***

### Root types

* [Map objects](#TKMResMapObjects)
* [Terrain decals](#TKMResTerrainDecals)


-----

### <a id="TKMResMapObjects">Map objects</a>

Objects that can be placed on terrain.

XML layout example:
```xml
<?xml version="1.0" encoding="UTF-8"?>
<Root>
  <Objects>
    <object EngName="value" CanPlaceInMapEd="value" Placement="value" Multiple="value" GrowTarget="value" GrowTime="value"
    Sway="value" ScaleVariation="value" Foliage="value" FoliageScale="value" TileBlock="value" VertBlock="value"
    Removable="value" Selectable="value" ColorMinimap="value" AllowedHumiditySet="value" Flags="value"
    Anims="value" States="value">
      <HUD AvatarSetup="value"/>
      <anim StateFrom="value" StateTo="value" AnimFile="value" Duration="value" EngName="value"/>
      <state TileBlock="value" VertBlock="value" EngName="value"/>
    <object/>
  <Objects/>
</Root>
```
| Structure | A/N | Attribute name | Type | Required / Default | Description |
| --------- |:---:|:--------------:|:----:|:------------------:| ----------- |
| Root | node | Objects | TKMResMapObjects |  | Objects that can be placed on terrain. |
| Root.Objects | node | object | TKMMapObjectSpec |  | Objects that can be placed on terrain. |
| Root.Objects.object | attr | EngName | String | **Required** | Unique identifier of the map object. |
| Root.Objects.object | attr | CanPlaceInMapEd | Boolean | `"True"` | Whether the map object can be placed in the Map Editor.<br>Some objects require special handling and should not be placeable under normal circumstances (e.g. grain, orchards, coalpiles). |
| Root.Objects.object | attr | Placement | Enum | **Required** | Placement of the object - tile or vertice.<br>* `"csTile"`, object will be placed on tiles;<br>* `"csVertice"`, object will be placed on a vertex between tiles. |
| Root.Objects.object | attr | Multiple | Integer | `"1"` | How many instances of the object are placed at once (1, 2, 36). |
| Root.Objects.object | attr | GrowTarget | String | `""` | What will this object grow into (EngName). Used for trees. |
| Root.Objects.object | attr | GrowTime | Integer | `"0"` | Time, in game ticks, required for the object to grow. |
| Root.Objects.object | attr | Sway | Float | `"0.0"` | How much does the object sway in the wind (0.0 .. 1.0). |
| Root.Objects.object | attr | ScaleVariation | Float | `"0.0"` | Amount of random scale variation applied to object instances. |
| Root.Objects.object | attr | Foliage | Boolean | `"False"` | Is this object a foliage model (trees, bushes). |
| Root.Objects.object | attr | FoliageScale | Float | `"1.0"` | Foliage scale. |
| Root.Objects.object | attr | TileBlock | Enum | **Required** | When object Placement is "csTile" this is a type of tile blocking this object does:<br>* `"none"` - nothing is blocked (default state);<br>* `"houses"` - house-building is blocked;<br>* `"roads"` - road-building is blocked;<br>* `"everything"` - everything (walking) is blocked. |
| Root.Objects.object | attr | VertBlock | Enum | **Required** | When object Placement is "csVertice" this is a type of vertex blocking this object does:<br>* `"none"` - blocks nothing (default state);<br>* `"walkFightBuild"` - blocks walking/fighting/building over the vertex (e.g. trees).<br>* `"roadsFields"` - blocks roads/fields as well (e.g. big columns). |
| Root.Objects.object | attr | Removable | Enum | `""` | How hard is it to remove this object from terrain.<br>One of the following values:<br>* `"easy"` - object can be removed without a problem in process of building on top of it;<br>* `"hard"` - object can be removed by a Builder on request;<br>* `"nonRemovable"` - object is not removable at all. |
| Root.Objects.object | attr | Selectable | Boolean | `"False"` | Whether object selectable. |
| Root.Objects.object | attr | ColorMinimap | Cardinal | **Required** | Color of the object ion the minimap. |
| Root.Objects.object | attr | AllowedHumiditySet | Enum set | `""` | Terrain humidity suitable for this map object (e.g. ore decals can be placed only on rock). Several values can be listed via a comma. Use `""` for all. |
| Root.Objects.object | attr | Flags | Enum set | `""` | Set of flags for the object. Multiple values can be listed via a comma:<br>* `"repelTrees"` - woodcutter will not plant new trees around this object;<br>* `"treeSapling"` - object is a tree sapling;<br>* `"treeCuttable"` - object is a cuttable tree;<br>* `"treeStump"`  - object is a stump of a tree. Woodcutter will prefer planting new trees on its place. |
| Root.Objects.object | attr | Anims | = aNode.Find | `"'Anims'"` | NodeName: Anims |
| Root.Objects.object | attr | States | = aNode.Find | `"'States'"` | List of states in which this object can be. |
| Root.Objects.object | node | HUD | TKMMapObjectHUDSpec |  | Settings for map object HUD. |
| Root.Objects.object.HUD | attr | AvatarSetup | String6 | `"6"` | Specifies how the object is going to be shown on the avatar when selected.<br>Relevant even if the object itself is not selectable - it could be used in MapEd palettes.<br>Defined by 6 floating-point numbers:<br> - camera distance from the object<br> - camera height above the ground<br> - camera target height on the object<br> - object offset X<br> - object offset Y<br> - object heading angle in Euler degrees (0 .. 360)<br>Default values are `"6.0;3.0;1.5;0.0;0.0;145.0"`. |
| Root.Objects.object | node | anim | TKMMapObjectAnimationSpec |  | List of animations between states. To make an idle animation for some state, set both states to one value. |
| Root.Objects.object.anim | attr | StateFrom | Integer | **Required** | Source state. |
| Root.Objects.object.anim | attr | StateTo | Integer | **Required** | Destination state. |
| Root.Objects.object.anim | attr | AnimFile | String | **Required** | Animation file name. |
| Root.Objects.object.anim | attr | Duration | Integer | **Required** | Duration of the animation. |
| Root.Objects.object.anim | attr | EngName | String | **Required** | EngName (unused?). |
| Root.Objects.object | node | state | TKMMapObjectStateSpec |  | List of object states. Maximum of 4 states is allowed. |
| Root.Objects.object.state | attr | TileBlock | Enum | **Required** | Override value for the matching placement |
| Root.Objects.object.state | attr | VertBlock | Enum | **Required** | Override value for the matching placement |
| Root.Objects.object.state | attr | EngName | String | **Required** | Identifier of this state |

### <a id="TKMResTerrainDecals">Terrain decals</a>

Decals that can be placed onto terrain tiles.

XML layout example:
```xml
<?xml version="1.0" encoding="UTF-8"?>
<Root>
  <Decals>
    <decal EngName="value" AllowedHumiditySet="value" IsPassable="value" IsBuildable="value" MinimapColor="value"
    ReplaceTile="value" GoldDeposit="value" IronDeposit="value" StoneDeposit="value" Selectable="value"
    ModelHeight="value" AvatarSetup="value"/>
  <Decals/>
</Root>
```
| Structure | A/N | Attribute name | Type | Required / Default | Description |
| --------- |:---:|:--------------:|:----:|:------------------:| ----------- |
| Root | node | Decals | TKMResTerrainDecals |  | Decals that can be placed onto terrain tiles. |
| Root.Decals | node | decal | TKMDecalSpec |  | Decals that can be placed onto terrain tiles. |
| Root.Decals.decal | attr | EngName | String | **Required** | Unique identifier of the decal. |
| Root.Decals.decal | attr | AllowedHumiditySet | Enum set | `""` | Terrain humidity suitable for this decal (e.g. ore decals can be placed only on rock). Use "" for all. |
| Root.Decals.decal | attr | IsPassable | Boolean | **Required** | Wherever this decal can be walk over by units. |
| Root.Decals.decal | attr | IsBuildable | Boolean | **Required** | Wherever roads and houses can be built on top of this decal. |
| Root.Decals.decal | attr | MinimapColor | Cardinal | `"0"` | Color of the decal on the minimap. Use 0 for none. |
| Root.Decals.decal | attr | ReplaceTile | Boolean | `"False"` | Whether the decal replaces the underlying terrain tile. |
| Root.Decals.decal | attr | GoldDeposit | Integer | `"0"` | Amount of gold this ore decal contains. Up to 255. Use on your own risk. |
| Root.Decals.decal | attr | IronDeposit | Integer | `"0"` | Amount of iron this ore decal contains. Up to 255. Use on your own risk. |
| Root.Decals.decal | attr | StoneDeposit | Integer | `"0"` | Amount of stone this ore decal contains. Up to 255. Use on your own risk. |
| Root.Decals.decal | attr | Selectable | Boolean | `"False"` | Can be select to see its info in the HUD. |
| Root.Decals.decal | attr | ModelHeight | Float | `"0.0"` | Height of the model for HitTest. Can be set slightly lower than the actual model for better match.<br>Not needed if the object is not selectable. |
| Root.Decals.decal | attr | AvatarSetup | String6 | **Required** | Specifies how the object is going to be shown on the avatar when selected.<br>Relevant even if the object itself is not selectable - it could be used in MapEd palettes.<br>Defined by 6 floating-point numbers:<br> - camera distance from the object<br> - camera height above the ground<br> - camera target height on the object<br> - object offset X<br> - object offset Y<br> - object heading angle in Euler degrees (0 .. 360)<br>Default values are "3.8;1.4;0.5;0;0;145" |



0. :TKMHUDAvatarSetup -> 
0.  - _array6

1. anim:TKMMapObjectAnimationSpec -> 
1.  - StateFrom
1.  - StateTo
1.  - AnimFile
1.  - Duration
1.  - EngName

2. HUD:TKMMapObjectHUDSpec -> 
2.  - AvatarSetup

3. state:TKMMapObjectStateSpec -> 
3.  - TileBlock
3.  - VertBlock
3.  - EngName

4. object:TKMMapObjectSpec -> 
4.  - EngName
4.  - CanPlaceInMapEd
4.  - Placement
4.  - Multiple
4.  - GrowTarget
4.  - GrowTime
4.  - Sway
4.  - ScaleVariation
4.  - Foliage
4.  - FoliageScale
4.  - TileBlock
4.  - VertBlock
4.  - Removable
4.  - Selectable
4.  - ColorMinimap
4.  - AllowedHumiditySet
4.  - Flags
4.  - Anims
4.  - States
4.  HUD:TKMMapObjectHUDSpec -> 
4.   - AvatarSetup
4.  anim:TKMMapObjectAnimationSpec -> 
4.   - StateFrom
4.   - StateTo
4.   - AnimFile
4.   - Duration
4.   - EngName
4.  state:TKMMapObjectStateSpec -> 
4.   - TileBlock
4.   - VertBlock
4.   - EngName

5. Objects:TKMResMapObjects -> 
5.  object:TKMMapObjectSpec -> 
5.   - EngName
5.   - CanPlaceInMapEd
5.   - Placement
5.   - Multiple
5.   - GrowTarget
5.   - GrowTime
5.   - Sway
5.   - ScaleVariation
5.   - Foliage
5.   - FoliageScale
5.   - TileBlock
5.   - VertBlock
5.   - Removable
5.   - Selectable
5.   - ColorMinimap
5.   - AllowedHumiditySet
5.   - Flags
5.   - Anims
5.   - States
5.   HUD:TKMMapObjectHUDSpec -> 
5.    - AvatarSetup
5.   anim:TKMMapObjectAnimationSpec -> 
5.    - StateFrom
5.    - StateTo
5.    - AnimFile
5.    - Duration
5.    - EngName
5.   state:TKMMapObjectStateSpec -> 
5.    - TileBlock
5.    - VertBlock
5.    - EngName

6. decal:TKMDecalSpec -> 
6.  - EngName
6.  - AllowedHumiditySet
6.  - IsPassable
6.  - IsBuildable
6.  - MinimapColor
6.  - ReplaceTile
6.  - GoldDeposit
6.  - IronDeposit
6.  - StoneDeposit
6.  - Selectable
6.  - ModelHeight
6.  - AvatarSetup

7. Decals:TKMResTerrainDecals -> 
7.  decal:TKMDecalSpec -> 
7.   - EngName
7.   - AllowedHumiditySet
7.   - IsPassable
7.   - IsBuildable
7.   - MinimapColor
7.   - ReplaceTile
7.   - GoldDeposit
7.   - IronDeposit
7.   - StoneDeposit
7.   - Selectable
7.   - ModelHeight
7.   - AvatarSetup

