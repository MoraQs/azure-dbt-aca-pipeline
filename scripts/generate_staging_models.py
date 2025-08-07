import os
import json

BASE_DIR = os.path.abspath(os.path.join(os.path.dirname(__file__), ".."))
MODELS_DIR = os.path.join(BASE_DIR, "models", "staging")
SOURCE_MANIFEST = os.path.join(BASE_DIR, "sources_manifest.json")

with open(SOURCE_MANIFEST, "r") as f:
    entries = json.load(f)

sources_by_domain = {}

for entry in entries:
    domain = entry["domain"]
    table = entry["table"]
    domain_path = os.path.join(MODELS_DIR, domain)
    os.makedirs(domain_path, exist_ok=True)

    # Generate stg_<table>.sql
    sql_path = os.path.join(domain_path, f"stg_{table}.sql")
    with open(sql_path, "w") as f:
        f.write(f"""{{{{ config(materialized='view') }}}}

-- staging model for {table}
select *
from {{{{ source('bronze', '{table}') }}}}
""")

    # Prepare for sources.yml
    if domain not in sources_by_domain:
        sources_by_domain[domain] = []
    sources_by_domain[domain].append(table)

# Generate sources.yml per domain
for domain, tables in sources_by_domain.items():
    sources_yml_path = os.path.join(MODELS_DIR, domain, "sources.yml")
    with open(sources_yml_path, "w") as f:
        f.write("version: 2\n\n")
        f.write("sources:\n")
        f.write("  - name: raw\n")
        f.write("    tables:\n")
        for table in tables:
            f.write(f"      - name: {table}\n")

print(f"✅ Generated staging models and sources.yml for {len(entries)} tables.")