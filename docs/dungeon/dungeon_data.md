# <span class=class>DungeonData</span>
Resource class responsible for storing and managing the generated dungeon grid data.

## Class variables
<div class="variable_table">

  <div class="variable_header">
    <span>Variable</span>
    <span>Type</span>
    <span>Description</span>
  </div>

  <div class="variable_line">
    <span>width</span>
    <span>int</span>
    <span>Defines the horizontal size of the dungeon grid.</span>
  </div>

  <div class="variable_line">
    <span>height</span>
    <span>int</span>
    <span>Defines the vertical size of the dungeon grid.</span>
  </div>

  <div class="variable_line">
    <span>grid</span>
    <span>Dictionary</span>
    <span>Stores dungeon cells using their Vector2i coordinates as keys.</span>
  </div>

  <div class="variable_line">
    <span>cords_of_starting_cell</span>
    <span>Vector2i</span>
    <span>Stores the coordinates of the initial dungeon starting cell.</span>
  </div>

  <div class="variable_line">
    <span>wall_resc</span>
    <span>Resource</span>
    <span>Stores the resource reference used to identify wall cells.</span>
  </div>

</div>

## Functions

<div class="box">
```gdscript
func print_grid(mode: String, border: bool = false):
```
</div>

<div class="box">
```gdscript
func insert_static_cell(cell: DungeonCell, cords: Vector2i):
```
Inserts a predefined dungeon cell into the grid and marks it as already collapsed.
</div>

<div class="box">
```gdscript
func get_cell(cords: Vector2i) -> DungeonCell:
```
Returns the dungeon cell located at the specified coordinates.
</div>

<div class="box">
```gdscript
func get_neighbors(cords: Vector2i) -> Dictionary:
```
Returns a dictionary containing neighboring cells in the four cardinal directions.
</div>

<div class="box">
```gdscript
func grid_has_flag(flag_name) -> bool:
```
Checks whether any cell in the grid contains the specified flag.
</div>

<div class="box">
```gdscript
func count_non_wall_cells() -> int:
```
Counts and returns the number of cells that do not contain a wall resource.
</div>
