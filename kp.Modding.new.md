### Modding types

Description of moddable types used in Knights Province.

***

* <a href="#TKMHUDAvatarSetup">HUD Avatar setup</a>
* <a href="#TKMMapObjectAnimationSpec">List of map object animations</a>
* <a href="#TKMMapObjectStateSpec">List of map object states</a>
* <a href="#TKMMapObjectHUDSpec">Map object HUD</a>
* <a href="#TKMMapObjectSpec">Map objects</a>
* <a href="#TKMDecalSpec">Terrain decal</a>

<br/>

### <a id="TKMHUDAvatarSetup">HUD Avatar setup</a>
HUD setup specifies how the object is going to be shown on the avatar when selected.<br/>Relevant even if the object itself is not selectable - it could be used in MapEd palettes.<br/>Defined by 6 floating-point numbers `"1;2;3;4;5;6"`:<br/>1 - camera distance from the object;<br/>2 - camera height above the ground;<br/>3 - camera target height on the object;<br/>4 - object offset X;<br/>5 - object offset Y;<br/>6 - object heading angle in Euler degrees (0 .. 360).


### <a id="TKMMapObjectAnimationSpec">List of map object animations</a>
List of animations between states. To make an idle animation for some state, set both states to one value.

XML layout example:
```xml
<Anims>
  <anim StateFrom="value" StateTo="value" AnimFile="value" Duration="value" EngName="value"/>
  ...
</Anims>
```

| Attribute name | Type | Required / Default | Description |
| -------------- |:----:|:------------------:| ----------- |
| StateFrom | Integer | **Required** | Source state. |
| StateTo | Integer | **Required** | Destination state. |
| AnimFile | String | **Required** | Animation file name. |
| Duration | Integer | **Required** | Duration of the animation. |
| EngName | String | **Required** | EngName (unused?). |

### <a id="TKMMapObjectStateSpec">List of map object states</a>
List of object states. Maximum of 4 states is allowed.

XML layout example:
```xml
<States>
  <state TileBlock="value" VertBlock="value" EngName="value"/>
  ...
</States>
```

| Attribute name | Type | Required / Default | Description |
| -------------- |:----:|:------------------:| ----------- |
| TileBlock | String | **Required** | Override value for the matching placement |
| VertBlock | String | **Required** | Override value for the matching placement |
| EngName | String | **Required** | Identifier of this state |

### <a id="TKMMapObjectHUDSpec">Map object HUD</a>
Settings for map object HUD.

XML layout example:
```xml
<HUD AvatarSetup="value"/>
```

| Attribute name | Type | Required / Default | Description |
| -------------- |:----:|:------------------:| ----------- |
| AvatarSetup | <a href="#TKMHUDAvatarSetup">TKMHUDAvatarSetup</a> <sub>[attribute]</sub> | `"-"` | Default values are `"6.0;3.0;1.5;0.0;0.0;145.0"`. |

### <a id="TKMMapObjectSpec">Map objects</a>
Objects that can be placed on terrain.

XML layout example:
```xml
<?xml version="1.0" encoding="UTF-8"?>
<Root>
  <Objects>
    <object EngName="value" CanPlaceInMapEd="value" Placement="value" Multiple="value" GrowTarget="value"
      GrowTime="value" Sway="value" ScaleVariation="value" Foliage="value" FoliageScale="value"
      TileBlock="value" VertBlock="value" Removable="value" Selectable="value" ColorMinimap="value"
      AllowedHumiditySet="value" Flags="value">
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

| Attribute name | Type | Required / Default | Description |
| -------------- |:----:|:------------------:| ----------- |
| EngName | String | **Required** | Unique identifier of the map object. |
| CanPlaceInMapEd | Boolean | `"True"` | If the map object can be placed in the Map Editor.<br/>Some objects require special handling and should be not placeable (e.g. grain, orchards, coalpiles). |
| Placement | String | **Required** | Placement of the object - tile or vertice.<br/>- `"csTile"`, object will be placed on tiles;<br/>- `"csVertice"`, object will be placed on vertices between tiles. |
| Multiple | Integer | `"1"` | How many instances of the object are placed at once (1, 2, 36). |
| GrowTarget | String | `""` | What will this object grow into (EngName). Used for trees. |
| GrowTime | Integer | `"0"` | How long in game ticks will it tage to grow. |
| Sway | Float | `"0.0"` | How much does the object sway in the wind (0.0 .. 1.0). |
| ScaleVariation | Float | `"0.0"` | How much do object instances scale in size. |
| Foliage | Boolean | `"False"` | Is this object a foliage model (trees, bushes). |
| FoliageScale | Float | `"1.0"` | Foliage scale. |
| TileBlock | String | **Required** | When object Placement is "csTile" this is a type of tile blocking this object does:<br/>`"none"`, nothing is blocked (default state);<br/>`"houses"`, house-building is blocked;<br/>`"roads"`, road-building is blocked;<br/>`"everything"`, everything (walking) is blocked. |
| VertBlock | String | **Required** | When object Placement is "csVertice" this is a type of vertice blocking this object does:<br/>`"none"`, blocks nothing (default state);<br/>`"walkFightBuild"`, blocks walking/fighting/building over (small rocks, trees). But still can lay roads and fields around it;<br/>`"roadsFields"`, blocks roads/fields as well (e.g. big columns). |
| Removable | String | `""` | How hard is it to remove this object from terrain.<br/>One of the following values:<br/>`"easy"` - object can be removed without a problem in process of building on top of it;<br/>`"hard"` - object can be removed by a Builder on request;<br/>`"nonRemovable"` - object is not removable at all. |
| Selectable | Boolean | `"False"` | Is object selectable. |
| ColorMinimap | Cardinal | **Required** | Color of the object ion the minimap. |
| AllowedHumiditySet | String | `""` | Terrain humidity suitable for this decal (e.g. ore decals can be placed only on rock). Use "" for all. |
| Flags | String | `""` | Set of flags for the object:<br/>`"repelTrees"` - woodcutter will not plant new trees around this object;<br/>`"treeSapling"` - object is a tree sapling;<br/>`"treeCuttable"` - object is a cuttable tree;<br/>`"treeStump"`  - object is a stump of a tree. Woodcutter will prefer planting new trees on its place. |
| HUD | <a href="#TKMMapObjectHUDSpec">TKMMapObjectHUDSpec</a> <sub>[object]</sub> | `"-"` | HUD setup of the object. |
| Anims | <a href="#TKMMapObjectAnimationSpec">TKMMapObjectAnimationSpec</a> <sub>[object]</sub> | `"-"` | List of animations for the object. |
| States | <a href="#TKMMapObjectStateSpec">TKMMapObjectStateSpec</a> <sub>[object]</sub> | `"-"` | List of states in which this object can be. |

### <a id="TKMDecalSpec">Terrain decal</a>
Decals that can be placed onto terrain tiles.

XML layout example:
```xml
<?xml version="1.0" encoding="UTF-8"?>
<Root>
  <Decals>
    <decal EngName="value" AllowedHumiditySet="value" IsPassable="value" IsBuildable="value" MinimapColor="value"
      ReplaceTile="value" GoldDeposit="value" IronDeposit="value" StoneDeposit="value" Selectable="value"
      ModelHeight="value" AvatarSetup="value">
      </decal>
    ...
  </Decals>
</Root>
```

| Attribute name | Type | Required / Default | Description |
| -------------- |:----:|:------------------:| ----------- |
| EngName | String | **Required** | Unique identifier of the decal. |
| AllowedHumiditySet | String | `""` | Terrain humidity suitable for this decal (e.g. ore decals can be placed only on rock). Use "" for all. |
| IsPassable | Boolean | **Required** | Wherever this decal can be walk over by units. |
| IsBuildable | Boolean | **Required** | Wherever roads and houses can be built on top of this decal. |
| MinimapColor | Cardinal | `"0"` | Color of the decal on the minimap. Use 0 for none. |
| ReplaceTile | Boolean | `"False"` | Wherever this decal replaces terrain on the tile. |
| GoldDeposit | Integer | `"0"` | Amount of gold this ore decal contains. Up to 255. Use on your own risk. |
| IronDeposit | Integer | `"0"` | Amount of iron this ore decal contains. Up to 255. Use on your own risk. |
| StoneDeposit | Integer | `"0"` | Amount of stone this ore decal contains. Up to 255. Use on your own risk. |
| Selectable | Boolean | `"False"` | Can be select to see its info in the HUD. |
| ModelHeight | Float | `"0.0"` | Height of the model for HitTest. Can be set slightly lower than the actual model for better match.<br/>Not needed if the object is not selectable. |
| AvatarSetup | <a href="#TKMHUDAvatarSetup">TKMHUDAvatarSetup</a> <sub>[attribute]</sub> | `"-"` | HUD avatar setup of the decal.<br/>Default values are "3.8;1.4;0.5;0;0;145" |

