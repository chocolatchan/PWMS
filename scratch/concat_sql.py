import os
import glob

migrations_dir = 'database/migrations'
seed_files = ['database/seed_inbound.sql', 'database/seed_outbound.sql']

migration_files = sorted(glob.glob(os.path.join(migrations_dir, '*.sql')))
all_files = migration_files + seed_files

output_path = '/home/chocolat/.gemini/antigravity/brain/d38e7d05-a0ae-4529-b564-e47b5408b98f/artifacts/all_database_scripts.md'
os.makedirs(os.path.dirname(output_path), exist_ok=True)

with open(output_path, 'w') as out_f:
    out_f.write('# All Database Migrations and Seeds\n\n')
    for fpath in all_files:
        if os.path.exists(fpath):
            with open(fpath, 'r') as in_f:
                content = in_f.read()
            out_f.write(f'## `{os.path.basename(fpath)}`\n\n')
            out_f.write('```sql\n')
            out_f.write(content)
            if not content.endswith('\n'):
                out_f.write('\n')
            out_f.write('```\n\n')
print(f"Successfully generated {output_path}")
