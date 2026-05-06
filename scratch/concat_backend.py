import os

backend_dir = 'backend/src'
cargo_toml = 'backend/Cargo.toml'
output_path = '/home/chocolat/.gemini/antigravity/brain/d38e7d05-a0ae-4529-b564-e47b5408b98f/artifacts/all_backend_code.md'

os.makedirs(os.path.dirname(output_path), exist_ok=True)

with open(output_path, 'w') as out_f:
    out_f.write('# All Backend Code\n\n')
    
    # Write Cargo.toml
    if os.path.exists(cargo_toml):
        with open(cargo_toml, 'r') as in_f:
            content = in_f.read()
        out_f.write(f'## `{cargo_toml}`\n\n')
        out_f.write('```toml\n')
        out_f.write(content)
        if not content.endswith('\n'):
            out_f.write('\n')
        out_f.write('```\n\n')
    
    # Write all rust files
    for root, dirs, files in os.walk(backend_dir):
        for file in sorted(files):
            if file.endswith('.rs'):
                fpath = os.path.join(root, file)
                with open(fpath, 'r') as in_f:
                    content = in_f.read()
                out_f.write(f'## `{fpath}`\n\n')
                out_f.write('```rust\n')
                out_f.write(content)
                if not content.endswith('\n'):
                    out_f.write('\n')
                out_f.write('```\n\n')

print(f"Successfully generated {output_path}")
