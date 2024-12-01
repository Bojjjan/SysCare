import os
import re


def extract_ids(input_file, output_file):
    # Regular expression pattern to match the Id in "name.name" format
    id_pattern = re.compile(r'\b[\w\.-]+\.[\w\.-]+\b')
    matches_found = False
    output_lines = []

    with open(input_file, 'r') as infile:
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

                id_found = match.group(0)

                # Check if the ID contains "Microsoft.Edge"
                if "lol" not in id_found:
                    matches_found = True
                    output_lines.append(id_found + '\n')

            
    if matches_found:
        with open(output_file, 'w') as outfile:
            outfile.writelines(output_lines)
        print(f"")
    else:
        print("No additional updates available")

if __name__ == "__main__":
    script_dir = os.path.dirname(os.path.abspath(__file__))
    input_file = os.path.join(script_dir, 'temp', 'temp.txt')
    output_file = os.path.join(script_dir, 'temp', 'output_ids.txt')

    extract_ids(input_file, output_file)
