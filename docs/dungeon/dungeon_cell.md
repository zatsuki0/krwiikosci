# <span class=class>DungeonCell</span>
Node class representing a single dungeon grid cell. Stores possible tile resources, manages Wave Function Collapse(WFC) entropy calculation, and handles tile selection during dungeon generation.

## Class variables
<div class="variable_table">

  <div class="variable_header">
    <span>Variable</span>
    <span>Type</span>
    <span>Description</span>
  </div>

  <div class="variable_line">
    <span>collapsed</span>
    <span>bool</span>
    <span>Indicates whether the cell has already been assigned a final tile resource.</span>
  </div>

  <div class="variable_line">
    <span>collapsable_resources</span>
    <span>Array[Resource]</span>
    <span>Stores all tile resources that satisfy the current cell constraints.</span>
  </div>

  <div class="variable_line">
    <span>entropy</span>
    <span>int</span>
    <span>Represents the number of possible tile resources available for the cell.</span>
  </div>

  <div class="variable_line">
    <span>resc</span>
    <span>Resource</span>
    <span>Stores the currently assigned tile resource after the cell has collapsed.</span>
  </div>

  <div class="variable_line">
    <span>debug_log</span>
    <span>String</span>
    <span>Stores debug information generated during entropy calculation and cell collapse.</span>
  </div>

  <div class="variable_line">
    <span>position</span>
    <span>Vector2i</span>
    <span>Stores the grid coordinates of the cell.</span>
  </div>

  <div class="variable_line">
    <span>Flag</span>
    <span>Enum</span>
    <span>Defines special cell states such as starting point, boss room, border, or special rooms.</span>
  </div>

  <div class="variable_line">
    <span>flag</span>
    <span>Flag</span>
    <span>Stores the special purpose assigned to the cell.</span>
  </div>

</div>

## Functions

<div class="box">
```gdscript
func update_entropy(neighbors: Dictionary, all_possible_resources: Array[Resource], cords: Vector2i):
```

Calculates valid tile resources for the cell based on neighboring cell constraints and updates the cell entropy value.
</div>

<div class="box">
```gdscript
func collapse():
```

Selects a tile resource from the available options using weighted randomness and permanently assigns it to the cell.
</div>

<div class="box">
```gdscript
func weighted_random(options: Array):
```

Selects and returns a random resource from an array based on the weight value assigned to each resource.
</div>

<div class="box">
```gdscript
func is_fully_walled():
```

Checks whether the assigned tile resource has walls on all four sides.
</div>
