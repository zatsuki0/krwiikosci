import re
from mkdocs.utils import get_relative_url

CLASS_LINKS = {
    "Dungeon": "dungeon/index.md",
    "DungeonData": "dungeon/dungeon_data.md",
    "DungeonNode": "dungeon/dungeon_node.md",
    "DungeonGenerator": "dungeon/dungeon_generator.md",
    "DungeonCell": "dungeon/dungeon_cell.md",
    "Player": "player/index.md",
    "PlayerData": "player/player_data.md",
    "PlayerCharacter": "player/player_character.md",
}

def on_page_content(html, page, config, files):
    for name, target in CLASS_LINKS.items():
        target_file = files.get_file_from_path(target)
        if target_file is None:
            continue  # target page doesn't exist, skip silently (or log a warning)

        url = get_relative_url(target_file.url, page.file.url)
        pattern = rf'(<span class="n">){name}(</span>)'
        html = re.sub(pattern, rf'\1<a href="{url}">{name}</a>\2', html)
    return html
