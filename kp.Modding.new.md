## Modding types

Description of moddable types used in Knights Province.

***

### Conventions 

* [Count (cardinality)](#Cardinality)
* [Types](#Types)

### Root types

* [Map objects](#TKMResMapObjects)
* [Terrain decals](#TKMResTerrainDecals)


---

### <a id="Count (cardinality)">Cardinality</a>

Count (aka cardinality) means how many times an attribute or a node needs or must be present.

| Count<br>(cardinality) | Meaning |
|:----------------------:|---------|
| `1` | Required in the XML. If missing, loading fails. |
| `0..1` | Optional. If omitted, the engine uses that default value. |
| `0..x` | Optional; may appear up to x times. |
| `0..N` | Optional; may appear any number of times. |
| `1..N` | Required; must appear at least once. |


### <a id="Types">Types</a>

| Type | Meaning |
|:----:|---------|
| `Boolean` | Must be `True` or `False`. |
| `Cardinal` | Hexadecimal color value written as `$AABBGGRR`. E.g. `$FF0080FF` will be orange. |
| `Float` | Floating-point value. Make sure to use `.` for delimiter of the fractional part. Delimiter is optional. E.g. `5.0` or `11`. |
| `Integer` | Numeric value. E.g. `3` or `217`. |
| `String` | Text string, usually without spaces. E.g. `stone` or `palm_tree`. |
| `String (enum)` | String value that must match one of the provided values. |
| `String (enum set)` | Comma delimited string values that must match one of the provided values. E.g. `sand,rock,snow`.|

---

### <a id="TKMResMapObjects">Map objects</a>

Objects that can be placed on terrain.

Minimal XML structure:
```xml
<?xml version="1.0" encoding="UTF-8"?>
<Root>
  <Objects>
    <object EngName="value" Placement="value" TileBlock="value" VertBlock="value" ColorMinimap="value">
      <HUD />
    </object>
    ...
  </Objects>
</Root>
```

<details>
<summary>Full XML structure:</summary>

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
</details>

| Parent | Count | Name | Type | Default | Description |
| ------ |:-----------:|:----:|:----:|:-------:| ----------- |
|  | 1 | Objects | Node |  | Objects that can be placed on terrain. |
| Objects | 1..N | object | Node |  | Object that can be placed on terrain. |
| Objects.object | 1 | EngName | String |  | Unique identifier of the map object. |
| Objects.object | 0..1 | CanPlaceInMapEd | Boolean | `"True"` | Whether the map object can be placed in the Map Editor.<br>Some objects require special handling and should not be placeable under normal circumstances (e.g. grain, orchards, coalpiles). |
| Objects.object | 1 | Placement | String<br>(enum) |  | Placement of the object - tile or vertice.<br>Coordinate system:<br> - `"csTile"` - object will be placed on tiles;<br> - `"csVertice"` - object will be placed on a vertex between tiles. |
| Objects.object | 0..1 | Multiple | Integer | `"1"` | How many instances of the object are placed at once (1, 2, 36). |
| Objects.object | 0..1 | GrowTarget | String | `""` | What will this object grow into (EngName). Used for trees. Leave empty or omit if not needed. |
| Objects.object | 0..1 | GrowTime | Integer | `"0"` | Time, in game ticks, required for the object to grow. |
| Objects.object | 0..1 | Sway | Float | `"0.0"` | How much does the object sway in the wind (0.0 .. 1.0). |
| Objects.object | 0..1 | ScaleVariation | Float | `"0.0"` | Amount of random scale variation applied to object instances. |
| Objects.object | 0..1 | Foliage | Boolean | `"False"` | Is this object a foliage model (trees, bushes). |
| Objects.object | 0..1 | FoliageScale | Float | `"1.0"` | Foliage scale. |
| Objects.object | 1 | TileBlock | String<br>(enum) |  | When object Placement is "csTile" this is a type of tile blocking this object does:<br> - `"none"` - nothing is blocked (default state);<br> - `"houses"` - house-building is blocked;<br> - `"roads"` - road-building is blocked;<br> - `"everything"` - everything (walking) is blocked. |
| Objects.object | 1 | VertBlock | String<br>(enum) |  | When object Placement is "csVertice" this is a type of vertex blocking this object does:<br> - `"none"` - blocks nothing (default state);<br> - `"walkFightBuild"` - blocks walking/fighting/building over the vertex (e.g. trees).<br> - `"roadsFields"` - blocks roads/fields as well (e.g. big columns). |
| Objects.object | 0..1 | Removable | String<br>(enum) | `""` | How hard is it to remove this object from terrain.<br> - `"easy"` - can be removed without a problem in process of building on top of it;<br> - `"hard"` - can be removed by a Builder on request;<br> - `"nonremovable"` - not removable at all. |
| Objects.object | 0..1 | Selectable | Boolean | `"False"` | Whether object is selectable. |
| Objects.object | 1 | ColorMinimap | Cardinal |  | Color of the object on the minimap. |
| Objects.object | 0..1 | AllowedHumiditySet | String<br>(enum set) | `""` | Terrain humidity suitable for this map object (e.g. ore decals can be placed only on rock). Several values can be listed via a comma. Use `""` for all.<br>Terrain surface humidity ranges from dry rock to wet snow.<br>Comma-separated set of allowed terrain humidity values. An empty value means all humidity types are allowed.<br> - `"none"` - None (not used)<br> - `"rock"` - Rocky terrain<br> - `"sand"` - Sandy terrain<br> - `"savanna"` - Savanna terrain<br> - `"grass"` - Grassy terrain<br> - `"dirt"` - Dirty terrain<br> - `"swamp"` - Swampy terrain<br> - `"snow"` - Snowy terrain |
| Objects.object | 0..1 | Flags | String<br>(enum set) | `""` | Set of flags for the object. Multiple values can be listed via a comma:<br> - `"repelTrees"` - Woodcutter will not plant new trees around this object.<br> - `"treeSapling"` - Object is a tree sapling.<br> - `"treeCuttable"` - Object is a cuttable tree<br> - `"treeStump"` - Object is a stump of a tree. Woodcutter will prefer planting new trees on its place. |
| Objects.object | 1 | HUD | Node |  | Settings for map object HUD. |
| Objects.object.HUD | 0..1 | AvatarSetup | String6 | `"6.0;3.0;1.5;0;0;145"` | <br>Specifies how the object is going to be shown on the avatar when selected.<br>Relevant even if the object itself is not selectable - it could be used in MapEd palettes.<br>Defined by 6 floating-point numbers:<br> - camera distance from the object<br> - camera height above the ground<br> - camera target height on the object<br> - object offset X<br> - object offset Y<br> - object heading angle in Euler degrees (0 .. 360) |
| Objects.object | 0..1 | Anims | Node |  | List of animations. |
| Objects.object.Anims | 0..N | anim | Node |  | Animation between states. To make an idle animation for some state, set both states to one value. |
| Objects.object.Anims.anim | 1 | StateFrom | Integer |  | Source state. |
| Objects.object.Anims.anim | 1 | StateTo | Integer |  | Destination state. |
| Objects.object.Anims.anim | 1 | AnimFile | String |  | Animation file name. |
| Objects.object.Anims.anim | 1 | Duration | Integer |  | Duration of the animation. |
| Objects.object.Anims.anim | 1 | EngName | String |  | EngName (unused?). |
| Objects.object | 0..1 | States | Node |  | List of states in which this object can be. Maximum of 4 states is allowed. |
| Objects.object.States | 0..4 | state | Node |  | Map object state properties. |
| Objects.object.States.state | 1 | TileBlock | String<br>(enum) |  | Override value for the matching placement<br> - `"none"` - nothing is blocked (default state);<br> - `"houses"` - house-building is blocked;<br> - `"roads"` - road-building is blocked;<br> - `"everything"` - everything (walking) is blocked. |
| Objects.object.States.state | 1 | VertBlock | String<br>(enum) |  | Override value for the matching placement<br> - `"none"` - blocks nothing (default state);<br> - `"walkFightBuild"` - blocks walking/fighting/building over the vertex (e.g. trees).<br> - `"roadsFields"` - blocks roads/fields as well (e.g. big columns). |
| Objects.object.States.state | 1 | EngName | String |  | Identifier of this state |


---
### <a id="TKMResTerrainDecals">Terrain decals</a>

Decals that can be placed onto terrain tiles.

Minimal XML structure:
```xml
<?xml version="1.0" encoding="UTF-8"?>
<Root>
  <Decals>
    <decal EngName="value" IsPassable="value" IsBuildable="value"/>
    ...
  </Decals>
</Root>
```

<details>
<summary>Full XML structure:</summary>

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
</details>

| Parent | Count | Name | Type | Default | Description |
| ------ |:-----------:|:----:|:----:|:-------:| ----------- |
|  | 1 | Decals | Node |  | Decals that can be placed onto terrain tiles. |
| Decals | 1..N | decal | Node |  | Decal that can be placed onto terrain tiles. |
| Decals.decal | 1 | EngName | String |  | Unique identifier of the decal. |
| Decals.decal | 0..1 | AllowedHumiditySet | String<br>(enum set) | `""` | Terrain humidity suitable for this decal (e.g. ore decals can be placed only on rock). Use "" for all.<br>Terrain surface humidity ranges from dry rock to wet snow.<br>Comma-separated set of allowed terrain humidity values. An empty value means all humidity types are allowed.<br> - `"none"` - None (not used)<br> - `"rock"` - Rocky terrain<br> - `"sand"` - Sandy terrain<br> - `"savanna"` - Savanna terrain<br> - `"grass"` - Grassy terrain<br> - `"dirt"` - Dirty terrain<br> - `"swamp"` - Swampy terrain<br> - `"snow"` - Snowy terrain |
| Decals.decal | 1 | IsPassable | Boolean |  | Whether this decal can be walked over by units. |
| Decals.decal | 1 | IsBuildable | Boolean |  | Whether roads and houses can be built on top of this decal. |
| Decals.decal | 0..1 | MinimapColor | Cardinal | `"$00000000"` | Color of the decal on the minimap. |
| Decals.decal | 0..1 | ReplaceTile | Boolean | `"False"` | Whether the decal replaces the underlying terrain tile. |
| Decals.decal | 0..1 | GoldDeposit | Integer | `"0"` | Amount of gold this ore decal contains. Valid range is 0..255. |
| Decals.decal | 0..1 | IronDeposit | Integer | `"0"` | Amount of iron this ore decal contains. Valid range is 0..255. |
| Decals.decal | 0..1 | StoneDeposit | Integer | `"0"` | Amount of stone this ore decal contains. Valid range is 0..255. |
| Decals.decal | 0..1 | Selectable | Boolean | `"False"` | Whether the decal can be selected to show its information in the HUD. |
| Decals.decal | 0..1 | ModelHeight | Float | `"0.0"` | Height of the model for HitTest. Can be set slightly lower than the actual model for better match.<br>Not needed if the object is not selectable. |
| Decals.decal | 0..1 | AvatarSetup | String6 | `"3.8;1.4;0.5;0;0;145"` | <br>Specifies how the object is going to be shown on the avatar when selected.<br>Relevant even if the object itself is not selectable - it could be used in MapEd palettes.<br>Defined by 6 floating-point numbers:<br> - camera distance from the object<br> - camera height above the ground<br> - camera target height on the object<br> - object offset X<br> - object offset Y<br> - object heading angle in Euler degrees (0 .. 360) |


---

