import json
from pathlib import Path

BASE_DIR = Path(__file__).resolve().parent.parent
PROJECT_DIR = BASE_DIR / "adventureworks"
MODELS_DIR = PROJECT_DIR / "models" / "staging"
SOURCE_MANIFEST = BASE_DIR / "sources_manifest.json"

with SOURCE_MANIFEST.open("r") as f:
    entries = sorted(json.load(f), key=lambda x: (x["domain"], x["table"]))

sources_by_domain = {}

for entry in entries:
    domain = entry["domain"]
    table = entry["table"]
    domain_path = MODELS_DIR / domain
    domain_path.mkdir(parents=True, exist_ok=True)

    sql_file = domain_path / f"stg_{table}.sql"
    sql_file.write_text(f"""{{{{ config(materialized='view') }}}}

-- staging model for {table}
select *
from {{{{ source('bronze', '{table}') }}}}
""")

    sources_by_domain.setdefault(domain, []).append(table)

for domain, tables in sources_by_domain.items():
    yml_path = MODELS_DIR / domain / "sources.yml"
    lines = [
        "version: 2\n",
        "sources:\n",
        "  - name: bronze\n",
        "    tables:\n"
    ]
    for table in tables:
        lines.append(f"      - name: {table}\n")
    yml_path.write_text("".join(lines))

print(f"✅ Generated {len(entries)} staging models and sources.yml files inside adventureworks/models/staging/")
