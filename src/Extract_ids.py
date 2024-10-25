# extract_ids.py
import os
import re

# Construct input and output file paths using os.path.join
script_dir = os.path.dirname(os.path.abspath(__file__))
input_file = os.path.join(script_dir, 'temp', 'temp.txt')  # Input file path
output_file = os.path.join(script_dir, 'temp', 'output_ids.txt')  # Output file path

def extract_ids(input_file, output_file):
    # Regular expression pattern to match the Id in "name.name" format
    id_pattern = re.compile(r'\b[\w\.-]+\.[\w\.-]+\b')

    with open(input_file, 'r') as infile, open(output_file, 'w') as outfile:
        data_section_started = False
        
        for line in infile:
            # Skip until we find the separator
            if '---' in line:
                data_section_started = True
                continue
            
            if not data_section_started:
                continue  # Skip lines until data section starts

            # Skip empty lines or lines with "upgrades available"
            line = line.strip()
            if not line or "upgrades available" in line:
                continue
            
            # Find the first "name.name" pattern in the line
            match = id_pattern.search(line)
            if match:
                id_part = match.group(0)
                outfile.write(id_part + '\n')

    print(f"IDs extracted to {output_file}")

if __name__ == "__main__":
    extract_ids(input_file, output_file)
