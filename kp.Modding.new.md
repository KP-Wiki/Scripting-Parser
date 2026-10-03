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
    <object EngName="value" CanPlaceInMapEd="value" Placement="value" Multiple="value" GrowTarget="value"
    GrowTime="value" Sway="value" ScaleVariation="value" Foliage="value" FoliageScale="value" TileBlock="value"
    VertBlock="value" Removable="value" Selectable="value" ColorMinimap="value" AllowedHumiditySet="value"
    Flags="value">
      <HUD AvatarSetup="value"/>
      <Anims>
        <anim StateFrom="value" StateTo="value" AnimFile="value" Duration="value" EngName="value"/>
        ...
      </Anims>
      <States>
        <state TileBlock="value" VertBlock="value" EngName="value"/>
        ...
      </States>
    </object>
    ...
  </Objects>
</Root>
```
| Structure | A/N | Attribute name | Type | Default | Description |
| --------- |:---:|:--------------:|:----:|:-------:| ----------- |
|  | node | Objects * |  |  | Objects that can be placed on terrain. |
| Objects | node | object * |  |  | Object that can be placed on terrain. |
| Objects.object | attr | EngName * | String |  | Unique identifier of the map object. |
| Objects.object | attr | CanPlaceInMapEd  | Boolean | `"True"` | Whether the map object can be placed in the Map Editor.<br>Some objects require special handling and should not be placeable under normal circumstances (e.g. grain, orchards, coalpiles). |
| Objects.object | attr | Placement * | Enum |  | Placement of the object - tile or vertice.<br>* `"csTile"`, object will be placed on tiles;<br>* `"csVertice"`, object will be placed on a vertex between tiles. |
| Objects.object | attr | Multiple  | Integer | `"1"` | How many instances of the object are placed at once (1, 2, 36). |
| Objects.object | attr | GrowTarget  | String | `""` | What will this object grow into (EngName). Used for trees. |
| Objects.object | attr | GrowTime  | Integer | `"0"` | Time, in game ticks, required for the object to grow. |
| Objects.object | attr | Sway  | Float | `"0.0"` | How much does the object sway in the wind (0.0 .. 1.0). |
| Objects.object | attr | ScaleVariation  | Float | `"0.0"` | Amount of random scale variation applied to object instances. |
| Objects.object | attr | Foliage  | Boolean | `"False"` | Is this object a foliage model (trees, bushes). |
| Objects.object | attr | FoliageScale  | Float | `"1.0"` | Foliage scale. |
| Objects.object | attr | TileBlock * | Enum |  | When object Placement is "csTile" this is a type of tile blocking this object does:<br>* `"none"` - nothing is blocked (default state);<br>* `"houses"` - house-building is blocked;<br>* `"roads"` - road-building is blocked;<br>* `"everything"` - everything (walking) is blocked. |
| Objects.object | attr | VertBlock * | Enum |  | When object Placement is "csVertice" this is a type of vertex blocking this object does:<br>* `"none"` - blocks nothing (default state);<br>* `"walkFightBuild"` - blocks walking/fighting/building over the vertex (e.g. trees).<br>* `"roadsFields"` - blocks roads/fields as well (e.g. big columns). |
| Objects.object | attr | Removable  | Enum | `""` | How hard is it to remove this object from terrain.<br>One of the following values:<br>* `"easy"` - object can be removed without a problem in process of building on top of it;<br>* `"hard"` - object can be removed by a Builder on request;<br>* `"nonRemovable"` - object is not removable at all. |
| Objects.object | attr | Selectable  | Boolean | `"False"` | Whether object selectable. |
| Objects.object | attr | ColorMinimap * | Cardinal |  | Color of the object ion the minimap. |
| Objects.object | attr | AllowedHumiditySet  | Enum set | `""` | Terrain humidity suitable for this map object (e.g. ore decals can be placed only on rock). Several values can be listed via a comma. Use `""` for all. |
| Objects.object | attr | Flags  | Enum set | `""` | Set of flags for the object. Multiple values can be listed via a comma:<br>* `"repelTrees"` - woodcutter will not plant new trees around this object;<br>* `"treeSapling"` - object is a tree sapling;<br>* `"treeCuttable"` - object is a cuttable tree;<br>* `"treeStump"`  - object is a stump of a tree. Woodcutter will prefer planting new trees on its place. |
| Objects.object | node | HUD  |  |  | Settings for map object HUD. |
| Objects.object.HUD | attr | AvatarSetup  | String6 | `"6"` | Default values are `"6.0;3.0;1.5;0.0;0.0;145.0"`.<br>Specifies how the object is going to be shown on the avatar when selected.<br>Relevant even if the object itself is not selectable - it could be used in MapEd palettes.<br>Defined by 6 floating-point numbers:<br> - camera distance from the object<br> - camera height above the ground<br> - camera target height on the object<br> - object offset X<br> - object offset Y<br> - object heading angle in Euler degrees (0 .. 360) |
| Objects.object | node | Anims  |  |  | List of animations. |
| Objects.object.Anims | node | anim  |  |  | Animation between states. To make an idle animation for some state, set both states to one value. |
| Objects.object.Anims.anim | attr | StateFrom * | Integer |  | Source state. |
| Objects.object.Anims.anim | attr | StateTo * | Integer |  | Destination state. |
| Objects.object.Anims.anim | attr | AnimFile * | String |  | Animation file name. |
| Objects.object.Anims.anim | attr | Duration * | Integer |  | Duration of the animation. |
| Objects.object.Anims.anim | attr | EngName * | String |  | EngName (unused?). |
| Objects.object | node | States  |  |  | List of states in which this object can be. Maximum of 4 states is allowed. |
| Objects.object.States | node | state  |  |  | Map object state properties. |
| Objects.object.States.state | attr | TileBlock * | Enum |  | Override value for the matching placement |
| Objects.object.States.state | attr | VertBlock * | Enum |  | Override value for the matching placement |
| Objects.object.States.state | attr | EngName * | String |  | Identifier of this state |

\* - _Required_


---
### <a id="TKMResTerrainDecals">Terrain decals</a>

Decals that can be placed onto terrain tiles.

XML layout example:
```xml
<?xml version="1.0" encoding="UTF-8"?>
<Root>
  <Decals>
    <decal EngName="value" AllowedHumiditySet="value" IsPassable="value" IsBuildable="value"
    MinimapColor="value" ReplaceTile="value" GoldDeposit="value" IronDeposit="value" StoneDeposit="value"
    Selectable="value" ModelHeight="value" AvatarSetup="value"/>
    ...
  </Decals>
</Root>
```
| Structure | A/N | Attribute name | Type | Default | Description |
| --------- |:---:|:--------------:|:----:|:-------:| ----------- |
|  | node | Decals * |  |  | Decals that can be placed onto terrain tiles. |
| Decals | node | decal * |  |  | Decal that can be placed onto terrain tiles. |
| Decals.decal | attr | EngName * | String |  | Unique identifier of the decal. |
| Decals.decal | attr | AllowedHumiditySet  | String (set of enum) | `""` | Terrain humidity suitable for this decal (e.g. ore decals can be placed only on rock). Use "" for all.<br>Terrain surface humidity ranges from dry rock to wet snow.<br>Several values could be listed separated by `,`.<br> * `"none"` - None (not used)<br> * `"rock"` - Rocky terrain<br> * `"sand"` - Sandy terrain<br> * `"savanna"` - Savanna terrain<br> * `"grass"` - Grassy terrain<br> * `"dirt"` - Dirty terrain<br> * `"swamp"` - Swampy terrain<br> * `"snow"` - Snowy terrain |
| Decals.decal | attr | IsPassable * | Boolean |  | Wherever this decal can be walk over by units. |
| Decals.decal | attr | IsBuildable * | Boolean |  | Wherever roads and houses can be built on top of this decal. |
| Decals.decal | attr | MinimapColor  | Cardinal | `"0"` | Color of the decal on the minimap. Use 0 for none. |
| Decals.decal | attr | ReplaceTile  | Boolean | `"False"` | Whether the decal replaces the underlying terrain tile. |
| Decals.decal | attr | GoldDeposit  | Integer | `"0"` | Amount of gold this ore decal contains. Up to 255. Use on your own risk. |
| Decals.decal | attr | IronDeposit  | Integer | `"0"` | Amount of iron this ore decal contains. Up to 255. Use on your own risk. |
| Decals.decal | attr | StoneDeposit  | Integer | `"0"` | Amount of stone this ore decal contains. Up to 255. Use on your own risk. |
| Decals.decal | attr | Selectable  | Boolean | `"False"` | Can be select to see its info in the HUD. |
| Decals.decal | attr | ModelHeight  | Float | `"0.0"` | Height of the model for HitTest. Can be set slightly lower than the actual model for better match.<br>Not needed if the object is not selectable. |
| Decals.decal | attr | AvatarSetup * | String6 |  | Default values are "3.8;1.4;0.5;0;0;145"<br>Specifies how the object is going to be shown on the avatar when selected.<br>Relevant even if the object itself is not selectable - it could be used in MapEd palettes.<br>Defined by 6 floating-point numbers:<br> - camera distance from the object<br> - camera height above the ground<br> - camera target height on the object<br> - object offset X<br> - object offset Y<br> - object heading angle in Euler degrees (0 .. 360) |

\* - _Required_


---

