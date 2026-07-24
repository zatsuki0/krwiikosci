import re

CLASS_LINKS = {
    "DungeonData": "Dungeon/DungeonData.md",
}

def on_page_content(html, page, config, files):
    for name, target in CLASS_LINKS.items():
        pattern = rf'(<span class="n">){name}(</span>)'
        url = page.file.url  # for computing relative path
        html = re.sub(pattern, rf'\1<a href="{target}">{name}</a>\2', html)
    return html
