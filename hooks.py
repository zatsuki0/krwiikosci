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
            continue

        url = get_relative_url(target_file.url, page.file.url)

        # Do not replace text already inside an HTML tag
        parts = re.split(r"(<[^>]+>)", html)

        for i, part in enumerate(parts):
            # Skip HTML tags themselves
            if part.startswith("<"):
                continue

            pattern = rf"\b{re.escape(name)}\b"

            parts[i] = re.sub(
                pattern,
                rf'<a href="{url}">{name}</a>',
                part
            )

        html = "".join(parts)

    return html
