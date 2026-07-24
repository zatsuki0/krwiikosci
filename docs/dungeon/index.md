# <span class=class>Dungeon</span>

```mermaid
graph TD
  n1@{ shape: "circle", label: "Dungeon" }
  n1 --- n5["DungeonData"]
  n1 --- n2["DungeonNode"]
  n1 --- n3["DungeonGenerator"]
  n5 --- n4["DungeonCell"]

  click n5 "/dungeon/dungeon_data/" "Go to DungeonData docs"
  click n3 "/dungeon/dungeon_generator/" "Go to DungeonGenerator docs"
  click n2 "/dungeon/dungeon_node/" "Go to DungeonNode docs"
  click n4 "/dungeon/dungeon_cell/" "Go to DungeonCell docs"
```

### Functions
```gdscript
func generate():

```

```gdscript
func get_cell(pos: Vector2i) -> DungeonCell:

```

```gdscript
func get_neighbors(pos: Vector2i):

```

```gdscript
func print_grid(mode: String, border: bool = false):

```

```gdscript
func count_non_wall_cells() -> int:

```
