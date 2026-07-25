# <span class=class>DungeonGenerator</span>
RefCounted class responsible for procedurally generating dungeon layouts using the Wave Function Collapse(WFC) algorithm and validating generated results.

## Class variables
<div class="variable_table">

  <div class="variable_header">
    <span>Variable</span>
    <span>Type</span>
    <span>Description</span>
  </div>

  <div class="variable_line">
    <span>dungeon_width</span>
    <span>int</span>
    <span>Defines the horizontal size of the generated dungeon.</span>
  </div>

  <div class="variable_line">
    <span>dungeon_height</span>
    <span>int</span>
    <span>Defines the vertical size of the generated dungeon.</span>
  </div>

  <div class="variable_line">
    <span>starting_cell_cords</span>
    <span>Vector2i</span>
    <span>Stores the coordinates of the dungeon starting cell.</span>
  </div>

  <div class="variable_line">
    <span>min_room_count</span>
    <span>int</span>
    <span>Defines the minimum number of non-wall cells required for a valid dungeon.</span>
  </div>

  <div class="variable_line">
    <span>max_room_count</span>
    <span>int</span>
    <span>Defines the maximum number of non-wall cells allowed for a valid dungeon.</span>
  </div>

  <div class="variable_line">
    <span>distance_to_boss</span>
    <span>int</span>
    <span>Defines the minimum required distance between the starting cell and boss room.</span>
  </div>

  <div class="variable_line">
    <span>possible_cell_rescs</span>
    <span>Array[Resource]</span>
    <span>Contains all possible tile resources that can be used during generation.</span>
  </div>

  <div class="variable_line">
    <span>cell_database</span>
    <span>Resource</span>
    <span>Stores the database containing categorized dungeon tile resources.</span>
  </div>

  <div class="variable_line">
    <span>basic_starting_cell_resc</span>
    <span>Resource</span>
    <span>Stores the default resource used for the dungeon starting cell.</span>
  </div>

  <div class="variable_line">
    <span>wall_resc</span>
    <span>Resource</span>
    <span>Stores the resource used for wall and border cells.</span>
  </div>

  <div class="variable_line">
    <span>possible_boss_rescs</span>
    <span>Array[Resource]</span>
    <span>Contains possible tile resources that can be assigned to the boss room.</span>
  </div>

  <div class="variable_line">
    <span>starting_cell</span>
    <span>DungeonCell</span>
    <span>Stores the predefined starting dungeon cell.</span>
  </div>

  <div class="variable_line">
    <span>wall_cell</span>
    <span>DungeonCell</span>
    <span>Stores the predefined wall border cell.</span>
  </div>

  <div class="variable_line">
    <span>boss_cell</span>
    <span>DungeonCell</span>
    <span>Stores the predefined boss room cell.</span>
  </div>

  <div class="variable_line">
    <span>mutex</span>
    <span>Mutex</span>
    <span>Provides thread synchronization when generating dungeons in parallel.</span>
  </div>

  <div class="variable_line">
    <span>result_dungeon</span>
    <span>DungeonData</span>
    <span>Stores the first successfully generated dungeon.</span>
  </div>

  <div class="variable_line">
    <span>threads</span>
    <span>Array[Thread]</span>
    <span>Stores the worker threads used for parallel dungeon generation.</span>
  </div>

</div>

## Functions

<div class="box">
```gdscript
func _init(width: int, height: int, starting_cell_cords: Vector2i, starting_cell_resource: Resource, min_room_count: int, max_room_count: int, distance_to_boss: int):
```

Initializes the dungeon generator with generation parameters and creates predefined starting, wall, and boss cells.
</div>

<div class="box">
```gdscript
func generate() -> DungeonData:
```

Starts the dungeon generation process using multiple threads and returns the first valid generated dungeon.
</div>

<div class="box">
```gdscript
func generate_dungeon_thread():
```
Runs an independent dungeon generation attempt in a separate thread until a valid dungeon is created.
</div>

<div class="box">
```gdscript
func create_grid(data: DungeonData):
```

Initializes the dungeon grid, places predefined cells, and creates the outer wall border.
</div>

<div class="box">
```gdscript
func generate_dungeon(data: DungeonData):
```

Runs the Wave Function Collapse generation process and removes disconnected cells after generation.
</div>

<div class="box">
```gdscript
func update_entropies(data: DungeonData):
```

Updates the entropy values of all cells based on neighboring cells and available tile resources.
</div>

<div class="box">
```gdscript
func collapse_lowest_entropy_cell(data: DungeonData):
```

Finds the cell with the lowest entropy and collapses it into a selected tile resource.
</div>

<div class="box">
```gdscript
func check_dungeon(data: DungeonData) -> bool:
```

Validates the generated dungeon by checking room count, boss placement, and boss distance requirements.
</div>

<div class="box">
```gdscript
func load_resources(path: String):
```

Loads all tile resources from the specified directory and returns them as an array.
</div>
